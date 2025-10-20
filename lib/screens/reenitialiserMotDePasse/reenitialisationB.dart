import 'package:flutter/material.dart';

// Classe principale de l’écran (un StatefulWidget car l’état peut changer)
class MotPasseOublieB extends StatefulWidget {
  const MotPasseOublieB({super.key});

  @override
  State<MotPasseOublieB> createState() => _MotPasseOublieBState();
}

// Classe qui gère l’état et le comportement de l’écran
class _MotPasseOublieBState extends State<MotPasseOublieB> {
  // Variable booléenne qui indique si le message de succès doit être affiché
  bool _emailSentSuccessfully = false;

  // Définition des couleurs principales utilisées dans le design
  final Color primaryPurple = const Color(0xFFA885D8); // Violet principal (bouton et icône)
  final Color lightPurple = const Color(0xFFF3EDFC);   // Fond clair derrière l’icône circulaire
  final Color iconColor = const Color(0xFF7042C9);     // Couleur de l’icône du cadenas
  final Color successGreen = const Color(0xFFE6FAE7);  // Fond vert clair pour le message de succès
  final Color successIconTextGreen = const Color(0xFF1E8C23); // Vert foncé pour le texte et l’icône du message de succès

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold : structure de base d’un écran Flutter (avec AppBar + corps)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Retire l’ombre sous la barre d’app
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Retour à la page précédente
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mot De Passe Oublié',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false, // Aligne le titre à gauche
      ),

      // Corps de la page, défilable si le contenu dépasse l’écran
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les éléments sur toute la largeur
          children: <Widget>[
            // ---------- Message de succès (affiché seulement si _emailSentSuccessfully = true) ----------
            if (_emailSentSuccessfully) ...[
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 30.0),
                decoration: BoxDecoration(
                  color: successGreen,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.lightGreen.shade200, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: successIconTextGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'E-mail envoyé !',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: successIconTextGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Un lien pour réinitialiser votre mot de passe a été envoyé. Pensez à vérifier votre dossier de spams',
                            style: TextStyle(
                              fontSize: 14,
                              color: successIconTextGreen,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // ---------- Fin du message de succès ----------

            // ---------- Icône du cadenas au centre ----------
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: lightPurple,
                  shape: BoxShape.circle, // Cercle pour fond de l’icône
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_reset,
                    size: 70,
                    color: iconColor,
                  ),
                ),
              ),
            ),

            // ---------- Titre principal ----------
            const Text(
              'Réinitialiser votre mot de passe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // ---------- Texte d’instructions ----------
            const Text(
              'Veuillez entrer votre adresse e-mail pour recevoir un code de vérification.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),

            // ---------- Champ de saisie pour l’adresse email ----------
            const Text(
              'Adresse Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              keyboardType: TextInputType.emailAddress, // Clavier adapté aux emails
              decoration: InputDecoration(
                hintText: 'Entrer votre email',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryPurple, width: 2),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.email_outlined,
                    color: Colors.grey.shade400,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 50),

            // ---------- Bouton principal ----------
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Action du bouton : ici, on simule l’envoi de l’email
                  // En vrai, on appellerait une API backend pour envoyer le lien de réinitialisation
                  setState(() {
                    _emailSentSuccessfully = true; // Active l’affichage du message vert
                  });
                  print('Bouton "Envoyer le lien" pressé');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Envoyer le lien de réinitialisation',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
