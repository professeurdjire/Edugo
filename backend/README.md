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

## Déploiement

L'API est fournie avec un `Dockerfile` et un `docker-compose.yml`.
Deux impératifs en production :

1. **`JWT_SECRET` doit être défini** (sinon un secret aléatoire est
   généré à chaque démarrage et toutes les sessions sont invalidées) :
   générez-le une fois avec `openssl rand -hex 32` et conservez-le.
2. **`/data` doit être un volume persistant** : la base SQLite y vit
   (`DB_FILE=/data/edugo.db` par défaut dans l'image) ; sans volume,
   les comptes disparaissent à chaque redéploiement.

### Sur un serveur (VPS) avec Docker

```bash
cd backend
echo "JWT_SECRET=$(openssl rand -hex 32)" > .env
docker compose up -d --build
curl http://localhost:3000/sante        # {"ok":true}
```

Le port 3000 n'est publié que sur la boucle locale (`127.0.0.1`) : l'API
n'est pas joignable en HTTP clair depuis Internet. Placez un reverse
proxy HTTPS sur l'hôte (Caddy, Nginx + certbot…) devant
`127.0.0.1:3000` — l'application mobile doit parler à l'API **en HTTPS**.

### Sur un hébergeur de conteneurs (Render, Railway, Fly.io…)

- Racine du service : `backend/` (l'hébergeur détecte le `Dockerfile`).
- Variables : `JWT_SECRET` (obligatoire) ; `PORT` est fourni par
  l'hébergeur et l'API le respecte.
- Attachez un **disque persistant** monté sur `/data`. SQLite impose
  **une seule instance** (pas de mise à l'échelle horizontale) — pour
  plusieurs instances, il faudra migrer vers un serveur de base de
  données.

### Côté application Flutter

Une fois l'API en ligne, compilez l'application avec l'URL réelle :

```bash
flutter build apk --dart-define=EDUGO_DEMO=false \
                  --dart-define=EDUGO_API_URL=https://votre-api.example
```

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
