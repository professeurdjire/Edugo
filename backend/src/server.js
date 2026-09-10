import bcrypt from 'bcryptjs';
import cors from 'cors';
import crypto from 'node:crypto';
import express from 'express';
import jwt from 'jsonwebtoken';

import { eleveVersJson, ouvrirBase } from './db.js';

const DUREE_JETON = '30d';
const DUREE_CODE_REINIT_MIN = 30;
const TOURS_BCRYPT = 10;

// Haché factice comparé pour les comptes inconnus, afin que la durée de
// traitement du login ne révèle pas quels emails sont enregistrés.
const HASH_FACTICE = bcrypt.hashSync('mot-de-passe-factice', TOURS_BCRYPT);

/**
 * Limiteur de débit en mémoire pour les routes d'authentification non
 * authentifiées : au plus `max` requêtes par adresse IP par fenêtre.
 */
function creerLimiteur({ max, fenetreMs }) {
  const journaux = new Map();
  return function limiter(req, res, next) {
    const maintenant = Date.now();
    const cle = req.ip ?? 'inconnu';
    const recents =
      (journaux.get(cle) ?? []).filter((t) => maintenant - t < fenetreMs);
    if (recents.length >= max) {
      journaux.set(cle, recents);
      return res.status(429).json({
        message: 'Trop de tentatives, réessayez plus tard.',
      });
    }
    recents.push(maintenant);
    journaux.set(cle, recents);
    return next();
  };
}

/**
 * Construit l'application Express de l'API EDUGO.
 * Les routes, champs et messages sont alignés sur le client Flutter
 * (lib/services/api/api.dart — AuthService).
 *
 * `limiteAuth` ({max, fenetreMs}) règle le limiteur de débit des routes
 * d'authentification (30 requêtes / 15 min par IP par défaut).
 */
export function creerApplication({ fichierBase, secretJeton, limiteAuth }) {
  const db = ouvrirBase(fichierBase);
  const app = express();
  app.use(cors());
  app.use(express.json());

  const limiter = creerLimiteur({
    max: limiteAuth?.max ?? 30,
    fenetreMs: limiteAuth?.fenetreMs ?? 15 * 60000,
  });

  const chercherParEmail = db.prepare(
    'SELECT * FROM eleves WHERE email = ?');
  const chercherParId = db.prepare('SELECT * FROM eleves WHERE id = ?');
  const incrementerVersion = db.prepare(
    'UPDATE eleves SET version_session = version_session + 1 WHERE id = ?');

  const signerJeton = (eleve) =>
    jwt.sign({ sub: eleve.id, v: eleve.version_session }, secretJeton,
      { expiresIn: DUREE_JETON });

  /**
   * Middleware : exige un jeton Bearer valide dont la version de session
   * correspond à celle en base (les jetons émis avant un changement de
   * mot de passe ou une déconnexion sont ainsi invalidés).
   */
  function exigerSession(req, res, next) {
    const enTete = req.headers.authorization ?? '';
    const jeton = enTete.startsWith('Bearer ') ? enTete.slice(7) : null;
    if (!jeton) {
      return res.status(401).json({ message: 'Session expirée, reconnectez-vous.' });
    }
    try {
      const charge = jwt.verify(jeton, secretJeton);
      const eleve = chercherParId.get(charge.sub);
      if (!eleve || charge.v !== eleve.version_session) {
        throw new Error('session invalide');
      }
      req.eleve = eleve;
      return next();
    } catch {
      return res.status(401).json({ message: 'Session expirée, reconnectez-vous.' });
    }
  }

  app.get('/sante', (req, res) => {
    res.json({ ok: true });
  });

  // POST /auth/register {eleve..., motDePasse} -> {token, eleve}
  app.post('/auth/register', limiter, async (req, res) => {
    const {
      nom = '', prenom = '', telephone = '', ville = '',
      email, niveauScolaire = '', classe = '', avatar = null, motDePasse,
    } = req.body ?? {};

    if (typeof email !== 'string' || !email.includes('@')) {
      return res.status(400).json({ message: 'Adresse email invalide.' });
    }
    if (typeof motDePasse !== 'string' || motDePasse.length < 6) {
      return res.status(400).json({
        message: 'Le mot de passe doit contenir au moins 6 caractères.',
      });
    }
    if (chercherParEmail.get(email.trim())) {
      return res.status(409).json({
        message: 'Un compte existe déjà avec cet email.',
      });
    }

    const hash = await bcrypt.hash(motDePasse, TOURS_BCRYPT);
    const info = db.prepare(`
      INSERT INTO eleves
        (nom, prenom, telephone, ville, email, niveau_scolaire, classe,
         avatar, mot_de_passe_hash)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `).run(
      String(nom), String(prenom), String(telephone), String(ville),
      email.trim(), String(niveauScolaire), String(classe),
      avatar === null ? null : String(avatar),
      hash,
    );

    const eleve = chercherParId.get(info.lastInsertRowid);
    return res.status(201).json({
      token: signerJeton(eleve),
      eleve: eleveVersJson(eleve),
    });
  });

  // POST /auth/login {email, motDePasse} -> {token, eleve}
  app.post('/auth/login', limiter, async (req, res) => {
    const { email, motDePasse } = req.body ?? {};
    const eleve =
      typeof email === 'string' ? chercherParEmail.get(email.trim()) : null;
    // Compte inconnu : comparaison factice pour égaliser la durée de
    // traitement et ne pas révéler quels emails sont enregistrés.
    const valide = await bcrypt.compare(
      typeof motDePasse === 'string' ? motDePasse : '',
      eleve ? eleve.mot_de_passe_hash : HASH_FACTICE,
    );
    if (!eleve || !valide) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect.' });
    }
    return res.json({ token: signerJeton(eleve), eleve: eleveVersJson(eleve) });
  });

  // POST /auth/mot-de-passe/oubli {email} -> 204
  // Répond toujours 204 pour ne pas révéler quels emails existent.
  app.post('/auth/mot-de-passe/oubli', limiter, (req, res) => {
    const { email } = req.body ?? {};
    if (typeof email === 'string' && chercherParEmail.get(email.trim())) {
      const code = crypto.randomInt(100000, 1000000).toString();
      const expire =
        new Date(Date.now() + DUREE_CODE_REINIT_MIN * 60000).toISOString();
      db.prepare('DELETE FROM reinitialisations WHERE email = ?')
        .run(email.trim());
      db.prepare(
        'INSERT INTO reinitialisations (email, code, expire_le) VALUES (?, ?, ?)')
        .run(email.trim(), code, expire);
      // TODO: envoyer le code par e-mail (service d'envoi à brancher).
      // Le code n'est jamais journalisé : il vit uniquement dans la table
      // reinitialisations, avec une expiration.
      console.log('[EDUGO] Demande de réinitialisation traitée.');
    }
    return res.status(204).end();
  });

  // POST /auth/mot-de-passe {ancien, nouveau} (Bearer) -> {token}
  // Invalide les jetons existants (version de session incrémentée) et
  // renvoie un jeton neuf pour la session courante.
  app.post('/auth/mot-de-passe', exigerSession, async (req, res) => {
    const { ancien, nouveau } = req.body ?? {};
    if (typeof ancien !== 'string' ||
        !(await bcrypt.compare(ancien, req.eleve.mot_de_passe_hash))) {
      return res.status(400).json({ message: 'Ancien mot de passe incorrect.' });
    }
    if (typeof nouveau !== 'string' || nouveau.length < 6) {
      return res.status(400).json({
        message: 'Le mot de passe doit contenir au moins 6 caractères.',
      });
    }
    const hash = await bcrypt.hash(nouveau, TOURS_BCRYPT);
    db.prepare('UPDATE eleves SET mot_de_passe_hash = ? WHERE id = ?')
      .run(hash, req.eleve.id);
    incrementerVersion.run(req.eleve.id);
    const eleve = chercherParId.get(req.eleve.id);
    return res.json({ token: signerJeton(eleve) });
  });

  // POST /auth/logout (Bearer) -> 204
  // Incrémente la version de session : les jetons déjà émis deviennent
  // invalides côté serveur, en plus de la suppression côté client.
  app.post('/auth/logout', exigerSession, (req, res) => {
    incrementerVersion.run(req.eleve.id);
    return res.status(204).end();
  });

  // PUT /eleves/moi {eleve...} (Bearer) -> {eleve}
  app.put('/eleves/moi', exigerSession, (req, res) => {
    const {
      nom, prenom, telephone, ville, email, niveauScolaire, classe, avatar,
    } = req.body ?? {};

    if (typeof email === 'string' && email.trim() !== '' ) {
      if (!email.includes('@')) {
        return res.status(400).json({ message: 'Adresse email invalide.' });
      }
      const existant = chercherParEmail.get(email.trim());
      if (existant && existant.id !== req.eleve.id) {
        return res.status(409).json({
          message: 'Un compte existe déjà avec cet email.',
        });
      }
    }

    const actuel = req.eleve;
    const champ = (valeur, defaut) =>
      typeof valeur === 'string' ? valeur : defaut;

    db.prepare(`
      UPDATE eleves SET
        nom = ?, prenom = ?, telephone = ?, ville = ?,
        email = ?, niveau_scolaire = ?, classe = ?, avatar = ?
      WHERE id = ?
    `).run(
      champ(nom, actuel.nom),
      champ(prenom, actuel.prenom),
      champ(telephone, actuel.telephone),
      champ(ville, actuel.ville),
      typeof email === 'string' && email.trim() !== ''
        ? email.trim() : actuel.email,
      champ(niveauScolaire, actuel.niveau_scolaire),
      champ(classe, actuel.classe),
      typeof avatar === 'string' ? avatar : actuel.avatar,
      actuel.id,
    );

    return res.json({ eleve: eleveVersJson(chercherParId.get(actuel.id)) });
  });

  // POST /suggestions {message} (Bearer) -> 204
  app.post('/suggestions', exigerSession, (req, res) => {
    const { message } = req.body ?? {};
    if (typeof message !== 'string' || message.trim() === '') {
      return res.status(400).json({ message: 'Le message est requis.' });
    }
    db.prepare('INSERT INTO suggestions (eleve_id, message) VALUES (?, ?)')
      .run(req.eleve.id, message.trim());
    return res.status(204).end();
  });

  app.use((req, res) => {
    res.status(404).json({ message: 'Route inconnue.' });
  });

  return app;
}
