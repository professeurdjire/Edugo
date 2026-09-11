import crypto from 'node:crypto';

import { creerEnvoyeurCode } from './mailer.js';
import { creerApplication } from './server.js';

const port = Number(process.env.PORT ?? 3000);
const fichierBase = process.env.DB_FILE ?? 'edugo.db';

// Jamais de secret codé en dur : sans JWT_SECRET, un secret aléatoire est
// généré pour cette exécution (les sessions ne survivent alors pas à un
// redémarrage). Définissez JWT_SECRET avant toute mise en production.
let secretJeton = process.env.JWT_SECRET;
if (!secretJeton) {
  secretJeton = crypto.randomBytes(32).toString('hex');
  console.warn(
    '[EDUGO] JWT_SECRET non défini : secret aléatoire généré pour cette ' +
    'exécution (les sessions seront invalidées au prochain redémarrage). ' +
    'Définissez JWT_SECRET en production.');
}

const envoyerCodeReinitialisation = creerEnvoyeurCode();
if (!envoyerCodeReinitialisation) {
  console.warn(
    '[EDUGO] SMTP non configuré (SMTP_HOST absent) : les codes de ' +
    'réinitialisation sont stockés mais aucun e-mail ne part. Définissez ' +
    'SMTP_HOST/SMTP_USER/SMTP_PASS/SMTP_FROM en production.');
}

const app = creerApplication({
  fichierBase, secretJeton, envoyerCodeReinitialisation,
});

app.listen(port, () => {
  console.log(`[EDUGO] API démarrée sur http://localhost:${port} (base: ${fichierBase})`);
});
