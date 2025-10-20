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
  final Color primaryPurple = const Color(0xFFA885D8);
  final Color lightPurple = const Color(0xFFF3EDFC);
  final Color iconColor = const Color(0xFF7042C9);
  final Color inputFillColor = const Color(0xFFF8F8F8); // fond clair pour les champs

  // Fonction de construction des champs de mot de passe
  Widget _buildPasswordField({
    required String hintText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextField(
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onVisibilityToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryPurple, width: 1.5),
        ),
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
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hintText: '......',
              isVisible: _isNewPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 30),

            // Champ : Confirmer le mot de passe
            const Text(
              'Confirmer le mot de passe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hintText: '......',
              isVisible: _isConfirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 70),

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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Réinitialiser mot de passe',
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
