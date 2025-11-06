import 'package:flutter/material.dart';

// Classe principale de l'écran (un StatefulWidget car l'état peut changer)
class MotPasseOublieB extends StatefulWidget {
  const MotPasseOublieB({super.key});

  @override
  State<MotPasseOublieB> createState() => _MotPasseOublieBState();
}

// Classe qui gère l'état et le comportement de l'écran
class _MotPasseOublieBState extends State<MotPasseOublieB> {
  // Variable booléenne qui indique si le message de succès doit être affiché
  bool _emailSentSuccessfully = false;

  // Définition des couleurs principales utilisées dans le design
  final Color primaryPurple = const Color(0xFFA885D8); // Violet principal cohérent
  final Color lightPurple = const Color(0xFFF3EDFC);
  final Color iconColor = const Color(0xFF7042C9);
  final Color successGreen = const Color(0xFFE6FAE7);
  final Color successIconTextGreen = const Color(0xFF1E8C23);

  // NOUVELLES COULEURS POUR CORRESPONDRE À L'INSCRIPTION
  final Color _borderColor = const Color(0xFFD1C4E9); // Bordure douce violette
  final Color _fillColor = const Color(0xFFF5F5F5);   // Fond gris clair
  final String _fontFamily = 'Roboto'; // Police par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Un lien pour réinitialiser votre mot de passe a été envoyé. Pensez à vérifier votre dossier de spams',
                            style: TextStyle(
                              fontSize: 14,
                              color: successIconTextGreen,
                              height: 1.4,
                              fontFamily: 'Roboto',
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

            // ---------- Titre principal ----------
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

            // ---------- Texte d'instructions ----------
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

            // ---------- Champ de saisie pour l'adresse email - STYLE MODIFIÉ ----------
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

            // ---------- Bouton principal ----------
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _emailSentSuccessfully = true;
                  });
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