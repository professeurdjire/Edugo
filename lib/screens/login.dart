import 'package:edugo/screens/inscriptions/inscription.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Couleurs utilisées dans le design
  final Color _purpleLogoAndButton = const Color(0xFFA582E5); // Violet principal (bouton, logo)
  final Color _lightPurpleInput = const Color(0xFFF1EFFE); // Violet très clair (fond des champs)
  final String _fontFamily = 'Roboto'; // Police par défaut

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
            ),
            
            const SizedBox(height: 25),
            
            // 3. Champs de Saisie (Mot de Passe)
            _buildInputField(
              label: 'Mot De Passe',
              hint: '.............',
              isPassword: true,
            ),
            
            const SizedBox(height: 10),
            
            // 4. Lien "Mot de passe oublié?"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
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
            _buildLoginButton(),
            
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
    // Note : Comme l'icône du livre est complexe, nous simulons l'aspect 
    // en utilisant une icône de livre (ou une image si elle est disponible dans assets)
    // Ici, nous utiliserons l'image 'assets/images/edugo_logo.png' 
    // pour être fidèle, en supposant que l'image du livre est un fichier.
    // Pour cet exemple, je fournis une implémentation basée sur une image asset.

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Remplacer avec le chemin de votre image si vous l'avez
        Image.asset(
          'assets/images/logo.png', // Assurez-vous d'ajouter cette image
          height: 120, // Hauteur ajustée pour la proportion
          fit: BoxFit.contain,
          // Nous appliquons la couleur violette au nom, mais l'image du livre doit être dans le asset.
        ),
      ],
    );
  }

  // Widget pour les champs de saisie
  Widget _buildInputField({required String label, required String hint, required bool isPassword}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label du champ
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        
        // Champ de saisie
        Container(
          height: 55, 
          decoration: BoxDecoration(
            color: _lightPurpleInput, // Fond violet très clair
            borderRadius: BorderRadius.circular(10.0), // Coins légèrement arrondis
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              obscureText: isPassword, // Cacher le texte si c'est un mot de passe
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
                border: InputBorder.none, // Retirer la bordure par défaut
                contentPadding: const EdgeInsets.only(bottom: 5) // Ajustement du padding
              ),
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget pour le bouton de connexion
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
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

// ----------------------------------------------------
// CODE D'AFFICHAGE DANS main.dart
// Si vous voulez le tester directement:
// ----------------------------------------------------
/*
void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
*/