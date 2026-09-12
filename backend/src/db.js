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

    CREATE TABLE IF NOT EXISTS livres (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titre TEXT NOT NULL,
      auteur TEXT NOT NULL DEFAULT '',
      description TEXT NOT NULL DEFAULT '',
      niveau_scolaire TEXT NOT NULL DEFAULT '',
      matiere TEXT NOT NULL DEFAULT '',
      classe TEXT NOT NULL DEFAULT '',
      image TEXT
    );
  `);

  // Migration pour les bases créées avant l'ajout de version_session.
  const colonnes = db.prepare("PRAGMA table_info(eleves)").all();
  if (!colonnes.some((c) => c.name === 'version_session')) {
    db.exec(
      'ALTER TABLE eleves ADD COLUMN version_session INTEGER NOT NULL DEFAULT 0');
  }

  ensemencerLivres(db);

  return db;
}

/** Catalogue initial, inséré uniquement quand la table livres est vide. */
function ensemencerLivres(db) {
  const nombre = db.prepare('SELECT COUNT(*) AS n FROM livres').get().n;
  if (nombre > 0) return;

  const inserer = db.prepare(`
    INSERT INTO livres
      (titre, auteur, description, niveau_scolaire, matiere, classe, image)
    VALUES
      (@titre, @auteur, @description, @niveau, @matiere, @classe, @image)
  `);
  const livres = [
    {
      titre: 'Le jardin invisible',
      auteur: 'C.S. Lewis',
      description: 'Une aventure fantastique au cœur d\'un jardin secret.',
      niveau: 'Primaire', matiere: 'Français', classe: 'CM1',
      image: 'assets/images/book1.png',
    },
    {
      titre: 'Le cœur se souvient',
      auteur: 'C.S. Lewis',
      description: 'Un récit touchant sur la mémoire et l\'amitié.',
      niveau: 'Primaire', matiere: 'Français', classe: 'CM2',
      image: 'assets/images/book1.png',
    },
    {
      titre: 'Libre comme l\'air',
      auteur: 'C.S. Lewis',
      description: 'Le voyage d\'un jeune héros en quête de liberté.',
      niveau: 'Secondaire', matiere: 'Français', classe: '6ème',
      image: 'assets/images/book1.png',
    },
    {
      titre: 'En apnée',
      auteur: 'C.S. Lewis',
      description: 'Plongée dans les profondeurs d\'un océan mystérieux.',
      niveau: 'Secondaire', matiere: 'Sciences', classe: '5ème',
      image: 'assets/images/book1.png',
    },
    {
      titre: 'Les mathématiques amusantes',
      auteur: 'A. Diarra',
      description: 'Découvrir les nombres et la géométrie en s\'amusant.',
      niveau: 'Primaire', matiere: 'Mathématiques', classe: 'CE2',
      image: 'assets/images/book1.png',
    },
    {
      titre: 'Histoire du Mali',
      auteur: 'M. Konaté',
      description: 'Des grands empires à l\'indépendance, l\'histoire du pays.',
      niveau: 'Secondaire', matiere: 'Histoire', classe: '4ème',
      image: 'assets/images/book1.png',
    },
  ];
  const tout = db.transaction(() => {
    for (const livre of livres) inserer.run(livre);
  });
  tout();
}

/** Représentation JSON d'un livre, alignée sur le modèle Flutter (Livre). */
export function livreVersJson(ligne) {
  return {
    id: ligne.id,
    titre: ligne.titre,
    auteur: ligne.auteur,
    description: ligne.description,
    niveauScolaire: ligne.niveau_scolaire,
    matiere: ligne.matiere,
    classe: ligne.classe,
    ...(ligne.image ? { image: ligne.image } : {}),
  };
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
