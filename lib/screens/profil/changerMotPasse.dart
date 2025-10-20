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
  final Color primaryColor = const Color(0xFF9370DB);
  final Color lightPurpleBackground = const Color(0xFFF5F0FF);

  // --- Variables d’état pour afficher/masquer les mots de passe ---
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hint: '..........................',
              backgroundColor: lightPurpleBackground,
              obscureText: !_oldPasswordVisible,
              onToggleVisibility: () {
                setState(() => _oldPasswordVisible = !_oldPasswordVisible);
              },
              isVisible: _oldPasswordVisible,
            ),

            const SizedBox(height: 20),

            // --- Nouveau mot de passe ---
            const Text(
              'Nouveau mot de passe',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hint: '..........................',
              backgroundColor: lightPurpleBackground,
              obscureText: !_newPasswordVisible,
              onToggleVisibility: () {
                setState(() => _newPasswordVisible = !_newPasswordVisible);
              },
              isVisible: _newPasswordVisible,
            ),

            const SizedBox(height: 20),

            // --- Confirmer le mot de passe ---
            const Text(
              'Confirmer le mot de passe',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              hint: '..........................',
              backgroundColor: lightPurpleBackground,
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
                elevation: 3,
              ),
              child: const Text(
                'Changer le mot de passe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget réutilisable pour champ mot de passe ---
  Widget _buildPasswordField({
    required String hint,
    required Color backgroundColor,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required bool isVisible,
  }) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(fontSize: 18, letterSpacing: 3),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 2),
        filled: true,
        fillColor: backgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9370DB), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}
