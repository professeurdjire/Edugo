import 'package:edugo/screens/principales/accueil/accueil.dart';
import 'package:edugo/screens/principales/accueil/accueille.dart';
import 'package:edugo/screens/principales/bibliotheque/bibliotheque.dart';
import 'package:edugo/screens/principales/challenge/challenge.dart';
import 'package:edugo/screens/principales/challenge/classement.dart';
import 'package:edugo/screens/principales/bibliotheque/mesLectures.dart';
import 'package:edugo/screens/principales/accueil/partenaire.dart';
import 'package:flutter/material.dart';

// Constantes de style pour les couleurs
const Color _purpleMain = Color(0xFFA582E5); // Violet principal (logo, bouton, étape active)
const Color _purpleLight = Color(0xFFF1EFFE); // Violet très clair (fond des champs)
const Color _purpleStepInactive = Color(0xFFE8E8E8); // Gris clair pour les étapes inactives
const String _fontFamily = 'Roboto'; // Police par défaut

class RegistrationStepperScreen extends StatefulWidget {
  const RegistrationStepperScreen({super.key});

  @override
  State<RegistrationStepperScreen> createState() => _RegistrationStepperScreenState();
}

class _RegistrationStepperScreenState extends State<RegistrationStepperScreen> {
  int _currentStep = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fonction de navigation pour aller à l'étape suivante
  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Fin du formulaire / Action d'inscription finale
      debugPrint('Inscription Complète !');
    }
  }

  // Fonction de navigation pour revenir à l'étape précédente
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Liste des étapes (Pages)
  List<Widget> get _steps {
    return [
      RegistrationStep1(onNext: _nextStep), // Inscription1.png
      RegistrationStep2(onNext: _nextStep, onPrevious: _previousStep), // Inscription2.png
      RegistrationStep3(onNext: _nextStep, onPrevious: _previousStep), // Inscription3.png
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // En-tête (Logo et Barre de Statut)
          _buildHeader(context),
          
          // Indicateur de Progression (1, 2, 3)
          _buildStepIndicator(),
          
          // Contenu des Pages (Champs/Avatars)
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Désactiver le swipe
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: _steps,
            ),
          ),
        ],
      ),
    );
  }

  // Simule l'en-tête commun (Logo, Barre de Statut)
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        
        // Simulation de la barre de statut (20:20, icônes) - Réutilisé de la page de Connexion
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('20 : 20', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
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
        
        // Logo
        const SizedBox(height: 10),
        Image.asset(
          'assets/images/logo.png', 
          height: 100, 
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Simulateur du Stepper horizontal
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;
          return Expanded(
            child: Row(
              children: [
                // Numéro de l'étape
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isCurrent || isCompleted ? _purpleMain : _purpleStepInactive,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrent || isCompleted ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Ligne de connexion (sauf après le dernier point)
                if (index < 2)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 2,
                        color: isCompleted ? _purpleMain : _purpleStepInactive,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. ÉTAPE 1: Informations Personnelles (Inscription1.png)
// ----------------------------------------------------
class RegistrationStep1 extends StatelessWidget {
  final VoidCallback onNext;
  const RegistrationStep1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(label: 'Nom de l\'enfant', hint: 'Entrer votre nom'),
          const SizedBox(height: 25),
          _buildInputField(label: 'Prenom de l\'enfant', hint: 'Entrer votre prenom'),
          const SizedBox(height: 25),
          _buildInputField(label: 'Téléphone', hint: 'Votre numéro de téléphone', keyboardType: TextInputType.phone),
          const SizedBox(height: 25),
          _buildInputField(label: 'Ville', hint: 'Précisez votre ville'),
          
          const SizedBox(height: 60),
          _buildNextButton(text: 'Suivant', onPressed: onNext),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 3. ÉTAPE 2: Détails du Compte (Inscription2.png)
// ----------------------------------------------------
class RegistrationStep2 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  const RegistrationStep2({super.key, required this.onNext, required this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            label: 'Adresse Email', 
            hint: 'Entrer votre email',
            suffixIcon: const Icon(Icons.email_outlined, color: _purpleMain), // Icône email
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Mot De Passe', 
            hint: 'Entrer votre mot de passe', 
            isPassword: true,
            suffixIcon: const Icon(Icons.visibility_outlined, color: _purpleMain), // Icône œil
          ),
          const SizedBox(height: 25),
          
          // Niveau Scolaire (Simulé par un champ de texte simple pour l'aspect visuel)
          _buildDropdownField(label: 'Niveau Scolaire de l\'enfant', hint: 'Choisir votre niveau d\'etude'),
          const SizedBox(height: 25),
          
          // Classe Actuelle
          _buildInputField(label: 'Classe actuelle de l\'enfant', hint: 'Précisez votre classe'),
          
          const SizedBox(height: 60),
          _buildNextButton(text: 'Suivant', onPressed: onNext),
          
          // Optionnel : Bouton précédent pour plus de flexibilité
          // TextButton(onPressed: onPrevious, child: const Text('Précédent')), 
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 4. ÉTAPE 3: Choix de l'Avatar (Inscription3.png)
// ----------------------------------------------------
class RegistrationStep3 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  const RegistrationStep3({super.key, required this.onNext, required this.onPrevious});

  @override
  State<RegistrationStep3> createState() => _RegistrationStep3State();
}

class _RegistrationStep3State extends State<RegistrationStep3> {
  int? _selectedAvatarIndex;

  // Liste des images d'avatars (Assurez-vous qu'elles sont dans les assets)
  final List<String> _avatars = [
    'assets/images/avatar1.png', // Avatar roux
    'assets/images/avatar2.png', // Avatar asiatique homme
    'assets/images/avatar3.png', // Avatar indienne femme
    'assets/images/avatar4.png', // Avatar homme lunettes
    'assets/images/avatar5.png', // Avatar femme tresse
    'assets/images/avatar6.png', // Avatar homme lunettes jaune
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choisissez Votre Avatar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 25),
          
          // Grille des Avatars
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 avatars par ligne
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.75, // Ajustement pour la forme des avatars
              ),
              itemCount: _avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // Bordure violette pour l'avatar sélectionné
                      border: _selectedAvatarIndex == index
                          ? Border.all(color: _purpleMain, width: 4.0)
                          : null,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        _avatars[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bouton "S'inscrire"
          _buildNextButton(text: 'S\'inscrire', onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  HomeScreen()),
    );
  },),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 5. WIDGETS UTILITAIRES (Communs aux étapes)
// ----------------------------------------------------

// Widget pour les champs de saisie (commun à toutes les pages)
Widget _buildInputField({
  required String label, 
  required String hint, 
  bool isPassword = false, 
  Widget? suffixIcon, 
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 55, 
        decoration: BoxDecoration(
          color: _purpleLight, // Fond violet très clair
          borderRadius: BorderRadius.circular(10.0), 
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextFormField(
            obscureText: isPassword, 
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              border: InputBorder.none, 
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ),
    ],
  );
}

// Widget pour simuler le champ de sélection (Dropdown)
Widget _buildDropdownField({required String label, required String hint}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        height: 55, 
        decoration: BoxDecoration(
          color: _purpleLight, // Fond violet très clair
          borderRadius: BorderRadius.circular(10.0), 
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hint,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              ),
              const Icon(Icons.keyboard_arrow_down, color: _purpleMain),
            ],
          ),
        ),
      ),
    ],
  );
}

// Widget pour le bouton "Suivant" ou "S'inscrire"
Widget _buildNextButton({required String text, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _purpleMain,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), 
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamily,
        ),
      ),
    ),
  );
}

// ----------------------------------------------------
// Point d'entrée pour le test :
// ----------------------------------------------------
/*
void main() {
  // Assurez-vous d'avoir configuré vos assets avant d'exécuter
  runApp(const MaterialApp(
    home: RegistrationStepperScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
*/