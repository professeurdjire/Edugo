import 'package:flutter/material.dart';

class MotPasseOublieA extends StatelessWidget {
  const MotPasseOublieA({super.key});

  @override
  Widget build(BuildContext context) {
    // Définition des couleurs utilisées sur l'écran
    final Color primaryPurple = const Color(0xFFA885D8); // Violet principal cohérent
    final Color lightPurple = const Color(0xFFF3EDFC);
    final Color iconColor = const Color(0xFF7042C9);

    // NOUVELLES COULEURS POUR CORRESPONDRE À L'INSCRIPTION
    final Color _borderColor = const Color(0xFFD1C4E9); // Bordure douce violette
    final Color _fillColor = const Color(0xFFF5F5F5);   // Fond gris clair
    final String _fontFamily = 'Roboto'; // Police par défaut

    return Scaffold(
      backgroundColor: Colors.white,
      // Barre supérieure (AppBar)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
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
        centerTitle: false,
      ),

      // Corps principal de l'écran
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Section de l'icône (cadenas)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: lightPurple,
                  shape: BoxShape.circle,
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

            // Titre et description
            const Text(
              'Réinitialiser votre mot de passe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Veuillez entrer votre adresse e-mail pour recevoir un code de vérification.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 40),

            // Label du champ d'e-mail
            const Text(
              'Adresse Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),

            // Champ de saisie pour l'adresse e-mail - STYLE MODIFIÉ
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
              decoration: InputDecoration(
                hintText: 'Entrer votre email',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: _fillColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.email_outlined,
                    color: Color(0xFFA582E5), // Violet cohérent
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1C4E9),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1C4E9),
                    width: 1.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD1C4E9),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Bouton d'envoi du lien de réinitialisation
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  print('Bouton "Envoyer le lien" pressé');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Coins arrondis à 12px
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Envoyer le lien de réinitialisation',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
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