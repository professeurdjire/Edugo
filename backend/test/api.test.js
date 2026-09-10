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

before(async () => {
  const app = creerApplication({ fichierBase: ':memory:', secretJeton: 'test' });
  await new Promise((resolve) => {
    serveur = app.listen(0, resolve);
  });
  base = `http://127.0.0.1:${serveur.address().port}`;
});

after(() => {
  serveur.close();
});

const poster = (chemin, donnees, jetonAuth) =>
  fetch(base + chemin, {
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

test('la connexion refuse un mauvais mot de passe', async () => {
  const rep = await poster('/auth/login',
    { email: corps.email, motDePasse: 'mauvais' });
  assert.equal(rep.status, 401);
  assert.equal((await rep.json()).message, 'Email ou mot de passe incorrect.');
});

test('la demande de réinitialisation répond 204, email connu ou non', async () => {
  assert.equal((await poster('/auth/mot-de-passe/oubli',
    { email: corps.email })).status, 204);
  assert.equal((await poster('/auth/mot-de-passe/oubli',
    { email: 'inconnu@example.com' })).status, 204);
});

test('les routes protégées exigent un jeton', async () => {
  assert.equal((await poster('/suggestions', { message: 'coucou' })).status, 401);
});

test('le changement de mot de passe vérifie l\'ancien', async () => {
  const mauvais = await poster('/auth/mot-de-passe',
    { ancien: 'mauvais', nouveau: 'nouveau123' }, jeton);
  assert.equal(mauvais.status, 400);

  const bon = await poster('/auth/mot-de-passe',
    { ancien: corps.motDePasse, nouveau: 'nouveau123' }, jeton);
  assert.equal(bon.status, 204);

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

test('la déconnexion authentifiée répond 204', async () => {
  const rep = await poster('/auth/logout', {}, jeton);
  assert.equal(rep.status, 204);
});
