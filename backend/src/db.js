import Database from 'better-sqlite3';

/**
 * Ouvre (ou crée) la base SQLite et son schéma.
 * @param {string} fichier Chemin du fichier, ou ':memory:' pour les tests.
 */
export function ouvrirBase(fichier) {
  const db = new Database(fichier);
  db.pragma('journal_mode = WAL');
  db.pragma('foreign_keys = ON');

  db.exec(`
    CREATE TABLE IF NOT EXISTS eleves (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nom TEXT NOT NULL DEFAULT '',
      prenom TEXT NOT NULL DEFAULT '',
      telephone TEXT NOT NULL DEFAULT '',
      ville TEXT NOT NULL DEFAULT '',
      email TEXT NOT NULL UNIQUE COLLATE NOCASE,
      niveau_scolaire TEXT NOT NULL DEFAULT '',
      classe TEXT NOT NULL DEFAULT '',
      avatar TEXT,
      mot_de_passe_hash TEXT NOT NULL,
      version_session INTEGER NOT NULL DEFAULT 0,
      cree_le TEXT NOT NULL DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS suggestions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      eleve_id INTEGER NOT NULL REFERENCES eleves(id),
      message TEXT NOT NULL,
      cree_le TEXT NOT NULL DEFAULT (datetime('now'))
    );

    CREATE TABLE IF NOT EXISTS reinitialisations (
      email TEXT NOT NULL COLLATE NOCASE,
      code TEXT NOT NULL,
      expire_le TEXT NOT NULL
    );
  `);

  // Migration pour les bases créées avant l'ajout de version_session.
  const colonnes = db.prepare("PRAGMA table_info(eleves)").all();
  if (!colonnes.some((c) => c.name === 'version_session')) {
    db.exec(
      'ALTER TABLE eleves ADD COLUMN version_session INTEGER NOT NULL DEFAULT 0');
  }

  return db;
}

/** Représentation JSON d'un élève, alignée sur le modèle Flutter (Eleve). */
export function eleveVersJson(ligne) {
  return {
    nom: ligne.nom,
    prenom: ligne.prenom,
    telephone: ligne.telephone,
    ville: ligne.ville,
    email: ligne.email,
    niveauScolaire: ligne.niveau_scolaire,
    classe: ligne.classe,
    ...(ligne.avatar ? { avatar: ligne.avatar } : {}),
  };
}
