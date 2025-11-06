import 'package:edugo/screens/connexion%20et%20inscriptions/inscription.dart';
import 'package:edugo/screens/principales/mainScreen.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/reenitialisationA.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Couleurs utilisées dans le design
  final Color _purpleLogoAndButton = const Color(0xFFA885D8); // Violet principal (bouton, logo)
  final Color _lightPurpleInput = const Color(0xFFF1EFFE); // Violet très clair (fond des champs)
  final String _fontFamily = 'Roboto'; // Police par défaut

  // Nouvelles couleurs pour correspondre au style de l'inscription
  final Color _borderColor = const Color(0xFFD1C4E9); // Bordure douce violette
  final Color _fillColor = const Color(0xFFF5F5F5);   // Fond gris clair

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // La couleur de fond est blanche
      backgroundColor: Colors.white,

      // La barre d'état (20:20, icônes) est gérée par le système,
      // mais nous pouvons la simuler si besoin (comme dans la page précédente),
      // ici nous nous concentrons sur le contenu principal.
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: <Widget>[
            // Espace pour la barre de statut (simulée ici, environ 10% de l'écran)
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),

            // 1. Logo et Nom de l'Application
            _buildLogoSection(context),

            const SizedBox(height: 60),

            // 2. Champs de Saisie (Adresse Email)
            _buildInputField(
              label: 'Adresse Email',
              hint: 'Entré Votre Email',
              isPassword: false,
              suffixIcon: const Icon(Icons.email_outlined, color: Color(0xFFA582E5)),
            ),

            const SizedBox(height: 25),

            // 3. Champs de Saisie (Mot de Passe)
            _buildInputField(
              label: 'Mot De Passe',
              hint: 'Entré Votre Mot de Passe',
              isPassword: true,
              suffixIcon: const Icon(Icons.visibility_outlined, color: Color(0xFFA582E5)),
            ),

            const SizedBox(height: 10),

            // 4. Lien "Mot de passe oublié?"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  MotPasseOublieA()),
                            );
                  // Action pour mot de passe oublié
                  debugPrint('Mot de passe oublié cliqué.');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero, // Retire le padding par défaut
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Mot de passe oublié?',
                  style: TextStyle(
                    color: _purpleLogoAndButton.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 5. Bouton "Se Connecter"
            _buildLoginButton(context),

            const SizedBox(height: 20),

            // 6. Lien "Pas de compte ? Inscrivez Vous"
            TextButton(
              onPressed: () {
                // Action pour inscription
                debugPrint('Inscription cliquée.');
                 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrationStepperScreen()),
            );
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Pas de compte ? Inscrivez Vous',
                style: TextStyle(
                  color: _purpleLogoAndButton.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: _fontFamily,
                  decoration: TextDecoration.underline, // Ajout du soulignement visible sur le PNG
                  decorationColor: _purpleLogoAndButton.withOpacity(0.8),
                ),
              ),
            ),

            // Espace pour la barre de navigation du système (bas de l'écran)
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  // Widget pour la section du logo
  Widget _buildLogoSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Remplacer avec le chemin de votre image si vous l'avez
        Image.asset(
          'assets/images/logo.png', // Assurez-vous d'ajouter cette image
          height: 120, // Hauteur ajustée pour la proportion
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  // Widget pour les champs de saisie - STYLE MODIFIÉ pour correspondre à l'inscription
  Widget _buildInputField({
    required String label,
    required String hint,
    required bool isPassword,
    Widget? suffixIcon
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFD1C4E9),
        width: 1.0,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label du champ
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),

        // Champ de saisie - NOUVEAU STYLE
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffixIcon,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle,
            border: borderStyle,
          ),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Widget pour le bouton de connexion
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MainScreen()),
            );
          // Action de connexion
          debugPrint('Bouton Se Connecter cliqué.');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _purpleLogoAndButton,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Coins arrondis
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'Se Connecter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
      ),
    );
  }
}