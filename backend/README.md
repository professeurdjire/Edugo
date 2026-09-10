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
| `JWT_SECRET` | aléatoire par démarrage | **À définir en production** (sinon les sessions ne survivent pas aux redémarrages) |

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
| POST    | `/auth/mot-de-passe`      | `{ancien, nouveau}` (Bearer)| `{token}`         |
| POST    | `/auth/logout`            | — (Bearer)                  | 204               |
| PUT     | `/eleves/moi`             | champs de l'élève (Bearer)  | `{eleve}`         |
| POST    | `/suggestions`            | `{message}` (Bearer)        | 204               |
| GET     | `/sante`                  | —                           | `{ok: true}`      |

Les erreurs renvoient `{message}` en français ; le client les affiche
telles quelles.

## Sécurité

- Mots de passe hachés bcrypt ; comparaison factice pour les emails
  inconnus au login (durée de traitement égalisée).
- Chaque élève porte une **version de session** : changer de mot de
  passe ou se déconnecter l'incrémente, ce qui invalide immédiatement
  tous les jetons émis auparavant. Le changement de mot de passe renvoie
  un jeton neuf (`{token}`) que le client stocke.
- Les routes d'authentification non authentifiées sont **limitées en
  débit** (30 requêtes / 15 min par IP par défaut).
- Sans `JWT_SECRET`, un secret aléatoire est généré à chaque démarrage
  (jamais de secret codé en dur).

## Limites connues

- La réinitialisation par e-mail génère et stocke un code à 6 chiffres
  (table `reinitialisations`, expiration 30 min) mais **ne l'envoie
  pas** — aucun service d'e-mail n'est branché et le code n'est jamais
  journalisé. À compléter avec un envoi réel et l'endpoint de
  consommation du code quand l'app supportera les liens profonds.

## Tests

```bash
npm test             # 13 tests d'intégration (base en mémoire)
```
