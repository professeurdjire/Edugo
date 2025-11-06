import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // --- Couleurs principales ---
  final Color primaryColor = const Color(0xFFA885D8); // Violet principal cohérent
  final Color lightPurpleBackground = const Color(0xFFF5F0FF);

  // --- NOUVELLES COULEURS POUR CORRESPONDRE À L'INSCRIPTION ---
  final Color _borderColor = const Color(0xFFD1C4E9); // Bordure douce violette
  final Color _fillColor = const Color(0xFFF5F5F5);   // Fond gris clair
  final String _fontFamily = 'Roboto'; // Police par défaut

  // --- Variables d'état pour afficher/masquer les mots de passe ---
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
          'Changer le mot de passe',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Icône de cadenas
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: lightPurpleBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock,
                  size: 60,
                  color: primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- Ancien mot de passe ---
            const Text(
              'Ancien mot de passe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hint: 'Entrer votre ancien mot de passe',
              obscureText: !_oldPasswordVisible,
              onToggleVisibility: () {
                setState(() => _oldPasswordVisible = !_oldPasswordVisible);
              },
              isVisible: _oldPasswordVisible,
            ),

            const SizedBox(height: 25),

            // --- Nouveau mot de passe ---
            const Text(
              'Nouveau mot de passe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hint: 'Entrer votre nouveau mot de passe',
              obscureText: !_newPasswordVisible,
              onToggleVisibility: () {
                setState(() => _newPasswordVisible = !_newPasswordVisible);
              },
              isVisible: _newPasswordVisible,
            ),

            const SizedBox(height: 25),

            // --- Confirmer le mot de passe ---
            const Text(
              'Confirmer le mot de passe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hint: 'Confirmer votre nouveau mot de passe',
              obscureText: !_confirmPasswordVisible,
              onToggleVisibility: () {
                setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
              },
              isVisible: _confirmPasswordVisible,
            ),

            const SizedBox(height: 40),

            // --- Bouton de validation ---
            ElevatedButton(
              onPressed: () {
                // Logique pour changer le mot de passe
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Changer le mot de passe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget réutilisable pour champ mot de passe - STYLE MODIFIÉ ---
  Widget _buildPasswordField({
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required bool isVisible,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFD1C4E9),
        width: 1.0,
      ),
    );

    return TextField(
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'Roboto',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: _fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFFA582E5), // Violet cohérent avec l'inscription
          ),
          onPressed: onToggleVisibility,
        ),
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
        border: borderStyle,
      ),
    );
  }
}