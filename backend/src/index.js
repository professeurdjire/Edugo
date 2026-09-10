import { creerApplication } from './server.js';

const port = Number(process.env.PORT ?? 3000);
const fichierBase = process.env.DB_FILE ?? 'edugo.db';
const secretJeton = process.env.JWT_SECRET ?? 'edugo-dev-secret';

if (!process.env.JWT_SECRET) {
  console.warn(
    '[EDUGO] JWT_SECRET non défini : secret de développement utilisé. ' +
    'Définissez JWT_SECRET avant toute mise en production.');
}

const app = creerApplication({ fichierBase, secretJeton });

app.listen(port, () => {
  console.log(`[EDUGO] API démarrée sur http://localhost:${port} (base: ${fichierBase})`);
});
