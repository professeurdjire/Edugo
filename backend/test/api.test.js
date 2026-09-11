import assert from 'node:assert/strict';
import { after, before, test } from 'node:test';

import { creerApplication } from '../src/server.js';

let serveur;
let base;

const corps = {
  nom: 'Haïdara',
  prenom: 'Haoua',
  telephone: '70000000',
  ville: 'Bamako',
  email: 'haoua@example.com',
  niveauScolaire: 'Primaire',
  classe: 'CM2',
  avatar: 'assets/images/avatar1.png',
  motDePasse: 'secret123',
};

let jeton;

// Codes de réinitialisation « envoyés » (capturés au lieu d'un vrai SMTP).
const codesEnvoyes = [];

before(async () => {
  const app = creerApplication({
    fichierBase: ':memory:',
    secretJeton: 'test',
    limiteAuth: { max: 1000, fenetreMs: 60000 },
    envoyerCodeReinitialisation: async (email, code) => {
      codesEnvoyes.push({ email, code });
    },
  });
  await new Promise((resolve) => {
    serveur = app.listen(0, resolve);
  });
  base = `http://127.0.0.1:${serveur.address().port}`;
});

after(() => {
  serveur.close();
});

const poster = (chemin, donnees, jetonAuth, baseUrl = base) =>
  fetch(baseUrl + chemin, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(jetonAuth ? { Authorization: `Bearer ${jetonAuth}` } : {}),
    },
    body: JSON.stringify(donnees),
  });

test('la santé répond ok', async () => {
  const rep = await fetch(`${base}/sante`);
  assert.equal(rep.status, 200);
  assert.deepEqual(await rep.json(), { ok: true });
});

test("l'inscription crée un compte et renvoie jeton + élève", async () => {
  const rep = await poster('/auth/register', corps);
  assert.equal(rep.status, 201);
  const json = await rep.json();
  assert.ok(json.token.length > 20);
  assert.equal(json.eleve.email, corps.email);
  assert.equal(json.eleve.niveauScolaire, 'Primaire');
  assert.equal(json.eleve.avatar, corps.avatar);
  jeton = json.token;
});

test("l'inscription refuse un email déjà utilisé", async () => {
  const rep = await poster('/auth/register', corps);
  assert.equal(rep.status, 409);
});

test("l'inscription refuse un mot de passe trop court", async () => {
  const rep = await poster('/auth/register',
    { ...corps, email: 'autre@example.com', motDePasse: '123' });
  assert.equal(rep.status, 400);
});

test('la connexion réussit avec les bons identifiants', async () => {
  const rep = await poster('/auth/login',
    { email: corps.email, motDePasse: corps.motDePasse });
  assert.equal(rep.status, 200);
  const json = await rep.json();
  assert.equal(json.eleve.prenom, 'Haoua');
});

test('la connexion refuse un mauvais mot de passe et un email inconnu', async () => {
  const mauvais = await poster('/auth/login',
    { email: corps.email, motDePasse: 'mauvais' });
  assert.equal(mauvais.status, 401);
  assert.equal((await mauvais.json()).message,
    'Email ou mot de passe incorrect.');

  const inconnu = await poster('/auth/login',
    { email: 'inconnu@example.com', motDePasse: 'nimporte' });
  assert.equal(inconnu.status, 401);
});

test('la demande de réinitialisation répond 204, email connu ou non', async () => {
  assert.equal((await poster('/auth/mot-de-passe/oubli',
    { email: corps.email })).status, 204);
  assert.equal((await poster('/auth/mot-de-passe/oubli',
    { email: 'inconnu@example.com' })).status, 204);

  // Le code n'est envoyé qu'au compte existant, jamais à un inconnu.
  assert.equal(codesEnvoyes.length, 1);
  assert.equal(codesEnvoyes[0].email, corps.email);
  assert.match(codesEnvoyes[0].code, /^\d{6}$/);
});

test('les routes protégées exigent un jeton', async () => {
  assert.equal((await poster('/suggestions', { message: 'coucou' })).status, 401);
});

test('le changement de mot de passe invalide l\'ancien jeton', async () => {
  const ancienJeton = jeton;

  const mauvais = await poster('/auth/mot-de-passe',
    { ancien: 'mauvais', nouveau: 'nouveau123' }, jeton);
  assert.equal(mauvais.status, 400);

  const bon = await poster('/auth/mot-de-passe',
    { ancien: corps.motDePasse, nouveau: 'nouveau123' }, jeton);
  assert.equal(bon.status, 200);
  const json = await bon.json();
  assert.ok(json.token.length > 20);
  jeton = json.token;

  // Le jeton d'avant le changement doit être refusé...
  const avecAncien = await poster('/suggestions',
    { message: 'test' }, ancienJeton);
  assert.equal(avecAncien.status, 401);

  // ... et le nouveau mot de passe doit permettre de se reconnecter.
  const reconnexion = await poster('/auth/login',
    { email: corps.email, motDePasse: 'nouveau123' });
  assert.equal(reconnexion.status, 200);
});

test('la mise à jour du profil renvoie l\'élève modifié', async () => {
  const rep = await fetch(`${base}/eleves/moi`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${jeton}`,
    },
    body: JSON.stringify({ ville: 'Ségou', avatar: 'assets/images/avatar3.png' }),
  });
  assert.equal(rep.status, 200);
  const json = await rep.json();
  assert.equal(json.eleve.ville, 'Ségou');
  assert.equal(json.eleve.avatar, 'assets/images/avatar3.png');
  assert.equal(json.eleve.nom, corps.nom);
});

test('une suggestion authentifiée est acceptée', async () => {
  const vide = await poster('/suggestions', { message: '   ' }, jeton);
  assert.equal(vide.status, 400);

  const rep = await poster('/suggestions',
    { message: 'Ajouter plus de livres !' }, jeton);
  assert.equal(rep.status, 204);
});

test('la déconnexion invalide le jeton', async () => {
  const rep = await poster('/auth/logout', {}, jeton);
  assert.equal(rep.status, 204);

  const apres = await poster('/suggestions', { message: 'test' }, jeton);
  assert.equal(apres.status, 401);
});

test('le code reçu par e-mail réinitialise le mot de passe', async () => {
  // Nouveau code (le mot de passe courant est « nouveau123 » à ce stade).
  assert.equal((await poster('/auth/mot-de-passe/oubli',
    { email: corps.email })).status, 204);
  const { code } = codesEnvoyes[codesEnvoyes.length - 1];

  // Mauvais code, ou mot de passe trop court : refusés.
  const mauvaisCode = await poster('/auth/mot-de-passe/reinitialiser',
    { email: corps.email, code: '000000', nouveau: 'reinit123' });
  assert.equal(mauvaisCode.status, 400);
  assert.equal((await mauvaisCode.json()).message, 'Code invalide ou expiré.');
  assert.equal((await poster('/auth/mot-de-passe/reinitialiser',
    { email: corps.email, code, nouveau: '123' })).status, 400);

  // Bon code : 204, puis connexion avec le nouveau mot de passe.
  assert.equal((await poster('/auth/mot-de-passe/reinitialiser',
    { email: corps.email, code, nouveau: 'reinit123' })).status, 204);
  const reconnexion = await poster('/auth/login',
    { email: corps.email, motDePasse: 'reinit123' });
  assert.equal(reconnexion.status, 200);

  // Le code est à usage unique.
  assert.equal((await poster('/auth/mot-de-passe/reinitialiser',
    { email: corps.email, code, nouveau: 'autre1234' })).status, 400);
});

test('le catalogue de livres est protégé, filtrable et recherché', async () => {
  // Sans jeton : refusé.
  assert.equal((await fetch(`${base}/livres`)).status, 401);

  // Reconnexion (le mot de passe courant est « reinit123 » à ce stade).
  const connexion = await poster('/auth/login',
    { email: corps.email, motDePasse: 'reinit123' });
  const jetonLivres = (await connexion.json()).token;
  const lire = async (chemin) => {
    const rep = await fetch(base + chemin,
      { headers: { Authorization: `Bearer ${jetonLivres}` } });
    assert.equal(rep.status, 200);
    return (await rep.json()).livres;
  };

  const tous = await lire('/livres');
  assert.ok(tous.length >= 6);
  assert.ok(tous.every((l) => l.titre && l.niveauScolaire));

  const primaire = await lire('/livres?niveau=Primaire');
  assert.ok(primaire.length > 0);
  assert.ok(primaire.every((l) => l.niveauScolaire === 'Primaire'));

  const recherche = await lire('/livres?q=apn%C3%A9e');
  assert.equal(recherche.length, 1);
  assert.equal(recherche[0].titre, 'En apnée');

  assert.equal((await lire('/livres?q=introuvable-xyz')).length, 0);
});

test('les routes d\'authentification sont limitées en débit', async () => {
  const appLimitee = creerApplication({
    fichierBase: ':memory:',
    secretJeton: 'test',
    limiteAuth: { max: 3, fenetreMs: 60000 },
  });
  const serveurLimite = await new Promise((resolve) => {
    const s = appLimitee.listen(0, () => resolve(s));
  });
  const baseLimitee = `http://127.0.0.1:${serveurLimite.address().port}`;

  try {
    for (let i = 0; i < 3; i += 1) {
      const rep = await poster('/auth/login',
        { email: 'x@example.com', motDePasse: 'x' }, null, baseLimitee);
      assert.equal(rep.status, 401);
    }
    const bloquee = await poster('/auth/login',
      { email: 'x@example.com', motDePasse: 'x' }, null, baseLimitee);
    assert.equal(bloquee.status, 429);
    assert.equal((await bloquee.json()).message,
      'Trop de tentatives, réessayez plus tard.');
  } finally {
    serveurLimite.close();
  }
});
