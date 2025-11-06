import 'package:flutter/material.dart';

// Vous pouvez nommer ce fichier 'password_reset_success_screen.dart'

class SuccesReenitialisation extends StatelessWidget {
  const SuccesReenitialisation({super.key});

  // Placeholder colors for a close visual match
  final Color primaryPurple = const Color(0xFFA885D8);
  final Color lightPurple = const Color(0xFFF3EDFC);
  final Color checkMarkColor = const Color(0xFF9B7DE4); // Checkmark color matches the button/circle border

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      // Pas d'AppBar pour un écran de succès plein écran, mais j'utilise un widget pour centrer.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Icon section (centered in a Stack)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: lightPurple, // Light background circle
                    shape: BoxShape.circle,
                    // Optional: Add a subtle border to match the image's shading
                    // border: Border.all(color: primaryPurple.withOpacity(0.3), width: 1),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check, // The checkmark icon
                      size: 100,
                      color: checkMarkColor,
                    ),
                  ),
                ),
              ),

              // Title
              const Text(
                'Mot de passe réinitialiser',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'Votre mot de passe a été réinitialiser avec succès. Vous pouvez maintenant vous connecter avec votre nouveau mot de passe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 80),

              // Button: Se connecter maintenant
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Implémenter la navigation vers l'écran de connexion ici
                    print('Se connecter maintenant button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple, // Background color from the image
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Se connecter maintenant',
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
      ),
    );
  }
}