# API EDUGO

Backend Node.js/Express de l'application EDUGO : authentification des
élèves, profil et suggestions. Base SQLite (fichier local), jetons JWT,
mots de passe hachés avec bcrypt.

## Démarrer

```bash
cd backend
npm install
npm start            # http://localhost:3000
```

Variables d'environnement (toutes optionnelles en développement) :

| Variable     | Défaut            | Rôle                                        |
|--------------|-------------------|---------------------------------------------|
| `PORT`       | `3000`            | Port d'écoute                               |
| `DB_FILE`    | `edugo.db`        | Fichier SQLite (créé automatiquement)       |
| `JWT_SECRET` | secret de dev     | **À définir obligatoirement en production** |

## Brancher l'application Flutter

```bash
flutter run --dart-define=EDUGO_DEMO=false \
            --dart-define=EDUGO_API_URL=http://10.0.2.2:3000
```

(`10.0.2.2` atteint la machine hôte depuis l'émulateur Android ;
sur un appareil physique, utilisez l'adresse IP locale du serveur.)

## Endpoints

Alignés sur le client Flutter (`lib/services/api/api.dart`) :

| Méthode | Route                     | Corps                       | Réponse           |
|---------|---------------------------|-----------------------------|-------------------|
| POST    | `/auth/register`          | élève + `motDePasse`        | `{token, eleve}`  |
| POST    | `/auth/login`             | `{email, motDePasse}`       | `{token, eleve}`  |
| POST    | `/auth/mot-de-passe/oubli`| `{email}`                   | 204               |
| POST    | `/auth/mot-de-passe`      | `{ancien, nouveau}` (Bearer)| 204               |
| POST    | `/auth/logout`            | — (Bearer)                  | 204               |
| PUT     | `/eleves/moi`             | champs de l'élève (Bearer)  | `{eleve}`         |
| POST    | `/suggestions`            | `{message}` (Bearer)        | 204               |
| GET     | `/sante`                  | —                           | `{ok: true}`      |

Les erreurs renvoient `{message}` en français ; le client les affiche
telles quelles.

## Limites connues

- La réinitialisation par e-mail génère et stocke un code à 6 chiffres
  mais **ne l'envoie pas** (aucun service d'e-mail branché) : il est
  journalisé côté serveur. À compléter avec un envoi réel et l'endpoint
  de consommation du code quand l'app supportera les liens profonds.
- Les jetons JWT sont sans état : `/auth/logout` valide la session et
  répond 204, la déconnexion effective étant la suppression du jeton
  côté client.

## Tests

```bash
npm test             # 12 tests d'intégration (base en mémoire)
```
