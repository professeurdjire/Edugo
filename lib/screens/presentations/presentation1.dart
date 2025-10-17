import 'package:edugo/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:edugo/core/constants/constant.dart';


// ----------------------------------------------------
// CODE DE LA PAGE D'ACCUEIL (WelcomeScreen)
// ----------------------------------------------------

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Media Query pour obtenir la hauteur de l'écran et dimensionner l'image correctement
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      // La couleur de fond est blanche pour la partie basse
      backgroundColor: Colors.white,
      
      // Utilisation d'un Stack pour potentiellement placer l'illustration
      body: Column(
        children: <Widget>[
          // 1. Zone supérieure (Image et fond violet)
          Container(
            // Hauteur calculée pour s'adapter à la proportion de l'image sur le PNG
            height: screenHeight * 0.5, 
            width: double.infinity,
            color:AppConst.purpleBackground,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // 1.1. L'illustration
                Center(
                  child: Padding(
                    // Ajuster le padding pour centrer et respecter la hauteur de la zone violette
                    padding: const EdgeInsets.only(top: 100.0), 
                    child: Image.asset(
                      // Assurez-vous d'avoir cette image dans votre dossier assets
                      'assets/images/enfantlu.png', 
                      fit: BoxFit.contain,
                      height: screenHeight * 0.35, // Taille ajustée
                    ),
                  ),
                ),
                
                // 1.2. Barre d'état (Heure, WiFi, Batterie) - Simulée pour être fidèle au PNG
                // La barre d'état du PNG (20:20, icônes) n'est pas gérée par Flutter par défaut
                // mais est ici recréée pour une fidélité visuelle maximale.
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Heure
                      Text(
                        '20 : 20',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConst.fontFamily
                        ),
                      ),
                      
                      // Icônes de statut (simulées)
                      const Row(
                        children: [
                          Icon(Icons.wifi, color: Colors.black, size: 16),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full, color: Colors.black, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 1.3. Le "trou" de la caméra avant (simulé)
                const Positioned(
                  top: 16,
                  child: Icon(Icons.circle, color: Colors.black, size: 8),
                ),
              ],
            ),
          ),
          
          // 2. Zone inférieure (Texte et Bouton)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Titre "Bienvenue Sur EDUGO"
                  Text(
                    'Bienvenue Sur EDUGO',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConst.fontFamily,
                      letterSpacing: -0.5, // Pour simuler la police sans-serif compacte de Figma
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Description
                  Text(
                    'Votre bibliothèque digitale pour les élèves du primaire '
                    'et du secondaire. Accédez à des livres électroniques, '
                    'des quiz interactifs et gagnez des récompenses.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black54, // Couleur du texte plus discrète
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: AppConst.fontFamily,
                    ),
                  ),
                  
                  // Espace flexible pour pousser le bouton vers le bas
                  const Spacer(), 
                  
                  // Bouton "Commencer"
                  SizedBox(
                    width: double.infinity,
                    height: 55, // Hauteur ajustée
                    child: ElevatedButton(
                      onPressed: () {
                        // Action à exécuter lors du clic
                        debugPrint('Démarrage de l\'application...');
                         Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConst.purpleBackground,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Bordure arrondie
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Commencer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppConst.fontFamily,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Flèche vers la droite
                          Icon(
                            Icons.arrow_forward,
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.9),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}