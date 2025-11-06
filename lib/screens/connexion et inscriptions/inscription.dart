
import 'package:edugo/screens/principales/accueil/accueille.dart';
import 'package:edugo/screens/principales/bibliotheque/bibliotheque.dart';
import 'package:edugo/screens/principales/challenge/challenge.dart';
import 'package:edugo/screens/principales/challenge/classement.dart';
import 'package:edugo/screens/principales/bibliotheque/mesLectures.dart';
import 'package:edugo/screens/principales/accueil/partenaire.dart';
import 'package:edugo/screens/principales/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/auth_models.dart';

// Constantes de style pour les couleurs
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (logo, bouton, étape active)
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
  
  // User data collected across steps
  String _userFirstName = '';
  String _userLastName = '';
  String _userPhone = '';
  String _userCity = '';
  String _userEmail = '';
  String _userPassword = '';
  String _userSchoolLevel = '';
  String _userClass = '';

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
      RegistrationStep1(
        onNext: _nextStep,
        onFirstNameChanged: (value) => setState(() => _userFirstName = value),
        onLastNameChanged: (value) => setState(() => _userLastName = value),
        onPhoneChanged: (value) => setState(() => _userPhone = value),
        onCityChanged: (value) => setState(() => _userCity = value),
        firstName: _userFirstName,
        lastName: _userLastName,
        phone: _userPhone,
        city: _userCity,
      ), // Inscription1.png
      RegistrationStep2(
        onNext: _nextStep, 
        onPrevious: _previousStep,
        onEmailChanged: (value) => setState(() => _userEmail = value),
        onPasswordChanged: (value) => setState(() => _userPassword = value),
        onSchoolLevelChanged: (value) => setState(() => _userSchoolLevel = value),
        onClassChanged: (value) => setState(() => _userClass = value),
        email: _userEmail,
        password: _userPassword,
        schoolLevel: _userSchoolLevel,
        className: _userClass,
      ), // Inscription2.png
      RegistrationStep3(
        onNext: _nextStep, 
        onPrevious: _previousStep,
        userEmail: _userEmail,
        userPassword: _userPassword,
        userFirstName: _userFirstName,
        userLastName: _userLastName,
      ), // Inscription3.png
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
class RegistrationStep1 extends StatefulWidget {
  final VoidCallback onNext;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onCityChanged;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;
  
  const RegistrationStep1({
    super.key, 
    required this.onNext,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onPhoneChanged,
    required this.onCityChanged,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
  });

  @override
  State<RegistrationStep1> createState() => _RegistrationStep1State();
}

class _RegistrationStep1State extends State<RegistrationStep1> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _phoneController = TextEditingController(text: widget.phone);
    _cityController = TextEditingController(text: widget.city);
  }

  @override
  void didUpdateWidget(covariant RegistrationStep1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstName != widget.firstName) {
      _firstNameController.text = widget.firstName;
    }
    if (oldWidget.lastName != widget.lastName) {
      _lastNameController.text = widget.lastName;
    }
    if (oldWidget.phone != widget.phone) {
      _phoneController.text = widget.phone;
    }
    if (oldWidget.city != widget.city) {
      _cityController.text = widget.city;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            label: 'Nom de l\'enfant', 
            hint: 'Entrer votre nom',
            controller: _firstNameController,
            onChanged: widget.onFirstNameChanged,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Prenom de l\'enfant', 
            hint: 'Entrer votre prenom',
            controller: _lastNameController,
            onChanged: widget.onLastNameChanged,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Téléphone', 
            hint: 'Votre numéro de téléphone', 
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            onChanged: widget.onPhoneChanged,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Ville', 
            hint: 'Précisez votre ville',
            controller: _cityController,
            onChanged: widget.onCityChanged,
          ),
          
          const SizedBox(height: 60),
          _buildNextButton(text: 'Suivant', onPressed: widget.onNext),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// 3. ÉTAPE 2: Détails du Compte (Inscription2.png)
// ----------------------------------------------------
class RegistrationStep2 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onSchoolLevelChanged;
  final Function(String) onClassChanged;
  final String email;
  final String password;
  final String schoolLevel;
  final String className;
  
  const RegistrationStep2({
    super.key, 
    required this.onNext,
    required this.onPrevious,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSchoolLevelChanged,
    required this.onClassChanged,
    required this.email,
    required this.password,
    required this.schoolLevel,
    required this.className,
  });

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _schoolLevelController;
  late TextEditingController _classController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    _schoolLevelController = TextEditingController(text: widget.schoolLevel);
    _classController = TextEditingController(text: widget.className);
  }

  @override
  void didUpdateWidget(covariant RegistrationStep2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.email != widget.email) {
      _emailController.text = widget.email;
    }
    if (oldWidget.password != widget.password) {
      _passwordController.text = widget.password;
    }
    if (oldWidget.schoolLevel != widget.schoolLevel) {
      _schoolLevelController.text = widget.schoolLevel;
    }
    if (oldWidget.className != widget.className) {
      _classController.text = widget.className;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _schoolLevelController.dispose();
    _classController.dispose();
    super.dispose();
  }

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
            controller: _emailController,
            onChanged: widget.onEmailChanged,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Mot De Passe', 
            hint: 'Entrer votre mot de passe', 
            isPassword: true,
            suffixIcon: const Icon(Icons.visibility_outlined, color: _purpleMain), // Icône œil
            controller: _passwordController,
            onChanged: widget.onPasswordChanged,
          ),
          const SizedBox(height: 25),
          
          // Niveau Scolaire (Simulé par un champ de texte simple pour l'aspect visuel)
          _buildInputField(
            label: 'Niveau Scolaire de l\'enfant', 
            hint: 'Choisir votre niveau d\'etude',
            controller: _schoolLevelController,
            onChanged: widget.onSchoolLevelChanged,
          ),
          const SizedBox(height: 25),
          
          // Classe Actuelle
          _buildInputField(
            label: 'Classe actuelle de l\'enfant', 
            hint: 'Précisez votre classe',
            controller: _classController,
            onChanged: widget.onClassChanged,
          ),
          
          const SizedBox(height: 60),
          _buildNextButton(text: 'Suivant', onPressed: widget.onNext),
          
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
  final String userEmail;
  final String userPassword;
  final String userFirstName;
  final String userLastName;
  
  const RegistrationStep3({
    super.key, 
    required this.onNext, 
    required this.onPrevious,
    required this.userEmail,
    required this.userPassword,
    required this.userFirstName,
    required this.userLastName,
  });

  @override
  State<RegistrationStep3> createState() => _RegistrationStep3State();
}

class _RegistrationStep3State extends State<RegistrationStep3> {
  final AuthService _authService = AuthService();
  int? _selectedAvatarIndex;
  bool _isLoading = false;
  String? _errorMessage;

  // Liste des images d'avatars (Assurez-vous qu'elles sont dans les assets)
  final List<String> _avatars = [
    'assets/images/avatar1.png', // Avatar roux
    'assets/images/avatar2.png', // Avatar asiatique homme
    'assets/images/avatar3.png', // Avatar indienne femme
    'assets/images/avatar4.png', // Avatar homme lunettes
    'assets/images/avatar5.png', // Avatar femme tresse
    'assets/images/avatar6.png', // Avatar homme lunettes jaune
  ];



  Future<void> _registerUser() async {
    if (_selectedAvatarIndex == null) {
      setState(() {
        _errorMessage = 'Veuillez sélectionner un avatar';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.register(
        email: widget.userEmail,
        password: widget.userPassword,
        nom: widget.userLastName,
        prenom: widget.userFirstName,
      );

      if (response != null && response.token != null) {
        // Registration successful, save token and navigate to main screen
        _authService.setAuthToken(response.token!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Erreur lors de l\'inscription. Veuillez réessayer.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          
          // Affichage des erreurs
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          
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
          _buildNextButton(
            text: _isLoading ? 'Inscription...' : 'S\'inscrire',
            onPressed: _isLoading ? () {} : () async {
              await _registerUser();
            },
          ),
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
  TextEditingController? controller,
  Function(String)? onChanged,
}) {
  const Color borderColor = Color(0xFFD1C4E9); // Bordure douce violette
  const Color fillColor = Color(0xFFF5F5F5);   // Fond gris clair

  final OutlineInputBorder borderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: borderColor,
      width: 1.0,
    ),
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: suffixIcon,
          enabledBorder: borderStyle,
          focusedBorder: borderStyle,
          border: borderStyle,
        ),
      ),
    ],
  );
}


// Widget pour simuler le champ de sélection (Dropdown)
Widget _buildDropdownField({
  required String label,
  required String hint,
}) {
  const Color borderColor = Color(0xFFD1C4E9);
  const Color fillColor = Color(0xFFF5F5F5);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hint,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
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