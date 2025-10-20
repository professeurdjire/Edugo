import 'package:flutter/material.dart';


class MotPasseOublieA extends StatelessWidget {
  const MotPasseOublieA({super.key});

  @override
  Widget build(BuildContext context) {
    //  Définition des couleurs utilisées sur l’écran
    final Color primaryPurple = const Color(0xFFA885D8); // Violet principal (utilisé pour le bouton)
    final Color lightPurple = const Color(0xFFF3EDFC);   // Violet clair (fond du cercle de l’icône)
    final Color iconColor = const Color(0xFF7042C9);     // Couleur du cadenas

    return Scaffold(
      backgroundColor: Colors.white,
      // Barre supérieure (AppBar)
      appBar: AppBar(
        // Fond blanc pour un design épuré
        backgroundColor: Colors.white,
        elevation: 0, // Supprime l’ombre sous la barre
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            // Retour à l’écran précédent
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
        centerTitle: false, // Le titre est aligné à gauche
      ),

      // Corps principal de l’écran
      body: SingleChildScrollView(
        // Permet de scroller si le contenu dépasse la taille de l’écran
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Section de l’icône (cadenas)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: lightPurple, // Cercle violet clair en fond
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_reset, // Icône de réinitialisation du mot de passe
                    size: 70,
                    color: iconColor,
                  ),
                ),
              ),
            ),

            // Titre et description
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
            const Text(
              'Veuillez entrer votre adresse e-mail pour recevoir un code de vérification.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),

            // Label du champ d’e-mail
            const Text(
              'Adresse Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Champ de saisie pour l’adresse e-mail
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Entrer votre email',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                // Style des bordures du champ
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
                // Icône à droite du champ
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.email_outlined,
                    color: Colors.grey.shade400,
                  ),
                ),
                fillColor: Colors.white,
                filled: true, // Fond blanc dans le champ
              ),
            ),
            const SizedBox(height: 50),

            // Bouton d’envoi du lien de réinitialisation
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Action du bouton (à remplacer par un appel API plus tard)
                  print('Bouton "Envoyer le lien" pressé');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple, // Couleur de fond violette
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0, // Pas d’ombre
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
