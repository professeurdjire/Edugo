import nodemailer from 'nodemailer';

/**
 * Construit la fonction d'envoi du code de réinitialisation à partir des
 * variables d'environnement SMTP. Retourne null si SMTP_HOST n'est pas
 * défini : le code est alors seulement stocké en base (comportement de
 * développement, rien n'est envoyé ni journalisé).
 *
 * Variables : SMTP_HOST, SMTP_PORT (587), SMTP_SECURE ('true' pour le
 * port 465), SMTP_USER, SMTP_PASS, SMTP_FROM (expéditeur affiché).
 */
export function creerEnvoyeurCode(env = process.env) {
  const hote = env.SMTP_HOST;
  if (!hote) return null;

  const transport = nodemailer.createTransport({
    host: hote,
    port: Number(env.SMTP_PORT ?? 587),
    secure: env.SMTP_SECURE === 'true',
    auth: env.SMTP_USER
      ? { user: env.SMTP_USER, pass: env.SMTP_PASS }
      : undefined,
  });
  const expediteur = env.SMTP_FROM ?? env.SMTP_USER;

  return async function envoyerCodeReinitialisation(email, code) {
    await transport.sendMail({
      from: expediteur,
      to: email,
      subject: 'EDUGO — Code de réinitialisation du mot de passe',
      text:
        `Bonjour,\n\n` +
        `Votre code de réinitialisation EDUGO est : ${code}\n\n` +
        `Il expire dans 30 minutes. Si vous n'êtes pas à l'origine de ` +
        `cette demande, ignorez cet e-mail : votre mot de passe reste ` +
        `inchangé.\n\n` +
        `L'équipe EDUGO`,
    });
  };
}
