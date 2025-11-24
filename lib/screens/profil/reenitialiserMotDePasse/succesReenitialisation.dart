import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

// Vous pouvez nommer ce fichier 'password_reset_success_screen.dart'

class SuccesReenitialisation extends StatelessWidget {
  const SuccesReenitialisation({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService _themeService = ThemeService();
    
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        // Couleurs dynamiques basées sur le thème
        final Color lightPurple = primaryColor.withOpacity(0.1);
        final Color checkMarkColor = primaryColor;

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
                    color: lightPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
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
                    backgroundColor: primaryColor,
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
      },
    );
  }
}