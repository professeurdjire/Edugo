import 'package:flutter/material.dart';

// Vous pouvez nommer ce fichier 'nouveauMotDePasse.dart'

class NouveauMotPasse extends StatefulWidget {
  const NouveauMotPasse({super.key});

  @override
  State<NouveauMotPasse> createState() => _NouveauMotPasseState();
}

class _NouveauMotPasseState extends State<NouveauMotPasse> {
  // Variables d'état pour masquer/afficher les mots de passe
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Placeholder colors pour correspondre au design
  final Color primaryPurple = const Color(0xFFA885D8); // Violet cohérent
  final Color lightPurple = const Color(0xFFF3EDFC);
  final Color iconColor = const Color(0xFF7042C9);

  // NOUVELLES COULEURS POUR CORRESPONDRE À L'INSCRIPTION
  final Color _borderColor = const Color(0xFFD1C4E9); // Bordure douce violette
  final Color _fillColor = const Color(0xFFF5F5F5);   // Fond gris clair
  final String _fontFamily = 'Roboto'; // Police par défaut

  // Fonction de construction des champs de mot de passe - STYLE MODIFIÉ
  Widget _buildPasswordField({
    required String hintText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFD1C4E9),
        width: 1.0,
      ),
    );

    return TextField(
      obscureText: !isVisible,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'Roboto',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: _fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFFA582E5), // Violet cohérent avec l'inscription
          ),
          onPressed: onVisibilityToggle,
        ),
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
        border: borderStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Nouveau mot de passe',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      // Corps de la page
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Icône du cadenas
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

            // Champ : Nouveau mot de passe
            const Text(
              'Nouveau mot de passe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hintText: 'Entrer votre nouveau mot de passe',
              isVisible: _isNewPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 25),

            // Champ : Confirmer le mot de passe
            const Text(
              'Confirmer le mot de passe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hintText: 'Confirmer votre nouveau mot de passe',
              isVisible: _isConfirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 40),

            // Bouton : Réinitialiser mot de passe
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  print('Réinitialiser mot de passe button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Coins arrondis à 12px
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Réinitialiser mot de passe',
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