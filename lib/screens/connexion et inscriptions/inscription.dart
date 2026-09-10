import 'package:edugo/core/widgets/widgets.dart';
import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/screens/main_navigation.dart';
import 'package:flutter/material.dart';

class RegistrationStepperScreen extends StatefulWidget {
  const RegistrationStepperScreen({super.key});

  @override
  State<RegistrationStepperScreen> createState() =>
      _RegistrationStepperScreenState();
}

class _RegistrationStepperScreenState extends State<RegistrationStepperScreen> {
  int _currentStep = 0;
  late final PageController _pageController;

  // Clés de formulaire par étape pour valider avant de passer à la suivante
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();

  // Étape 1 : informations personnelles
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();

  // Étape 2 : détails du compte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _classeController = TextEditingController();
  String? _niveauScolaire;
  bool _obscurePassword = true;

  // Étape 3 : avatar
  int? _selectedAvatarIndex;

  static const List<String> _niveaux = ['Primaire', 'Secondaire'];

  static const List<String> _avatars = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _villeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _classeController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep() {
    if (_currentStep == 0 && !_step1FormKey.currentState!.validate()) return;
    if (_currentStep == 1 && !_step2FormKey.currentState!.validate()) return;
    if (_currentStep < 2) _goToStep(_currentStep + 1);
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  void _submitRegistration() {
    if (_selectedAvatarIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez choisir un avatar pour continuer'),
          backgroundColor: AppConst.purpleDark,
        ),
      );
      return;
    }
    final Eleve eleve = Eleve(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      telephone: _telephoneController.text.trim(),
      ville: _villeController.text.trim(),
      email: _emailController.text.trim(),
      niveauScolaire: _niveauScolaire ?? '',
      classe: _classeController.text.trim(),
      avatar: _avatars[_selectedAvatarIndex!],
    );
    // TODO: envoyer `eleve` (et le mot de passe) à l'API d'inscription
    // (voir issue #3), puis naviguer seulement après une réponse valide.
    debugPrint('Inscription prête à envoyer : ${eleve.toJson()}');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: AppConst.textDark),
          onPressed: _previousStep,
        ),
        title: const Text(
          'Inscription',
          style: TextStyle(
            color: AppConst.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 90,
              fit: BoxFit.contain,
            ),
            _buildStepIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // Indicateur de progression (1 — 2 — 3)
  // ----------------------------------------------------
  Widget _buildStepIndicator() {
    const Color inactiveColor = Color(0xFFE8E8E8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Row(
        children: List.generate(3, (index) {
          final bool isCompleted = index < _currentStep;
          final bool isCurrent = index == _currentStep;
          final bool isActive = isCompleted || isCurrent;

          final Widget circle = AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? AppConst.purpleButton : inactiveColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : AppConst.textGrey,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConst.fontFamily,
                    ),
                  ),
          );

          if (index == 2) return circle;
          return Expanded(
            child: Row(
              children: [
                circle,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      decoration: BoxDecoration(
                        color: isCompleted ? AppConst.purpleButton : inactiveColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
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

  // ----------------------------------------------------
  // Étape 1 : Informations personnelles
  // ----------------------------------------------------
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Form(
        key: _step1FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Nom de l\'enfant',
              hint: 'Entrez le nom',
              controller: _nomController,
              prefixIcon: Icons.person_outline_rounded,
              validator: (v) => _requiredValidator(v, 'le nom'),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Prénom de l\'enfant',
              hint: 'Entrez le prénom',
              controller: _prenomController,
              prefixIcon: Icons.person_outline_rounded,
              validator: (v) => _requiredValidator(v, 'le prénom'),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Téléphone',
              hint: 'Votre numéro de téléphone',
              controller: _telephoneController,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Ville',
              hint: 'Précisez votre ville',
              controller: _villeController,
              prefixIcon: Icons.location_city_outlined,
              validator: (v) => _requiredValidator(v, 'la ville'),
            ),
            const SizedBox(height: 40),
            AppPrimaryButton(text: 'Suivant', onPressed: _nextStep),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // Étape 2 : Détails du compte
  // ----------------------------------------------------
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Form(
        key: _step2FormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Adresse Email',
              hint: 'Entrez votre email',
              controller: _emailController,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Mot De Passe',
              hint: 'Entrez votre mot de passe',
              controller: _passwordController,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              validator: _validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppConst.textGrey,
                  size: 22,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            const SizedBox(height: 20),
            const AppFieldLabel('Niveau Scolaire de l\'enfant'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _niveauScolaire,
              items: _niveaux
                  .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                  .toList(),
              onChanged: (value) => setState(() => _niveauScolaire = value),
              validator: (value) =>
                  value == null ? 'Veuillez choisir un niveau' : null,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: AppConst.textGrey),
              style: const TextStyle(
                fontFamily: AppConst.fontFamily,
                fontSize: 16,
                color: AppConst.textDark,
              ),
              decoration: appInputDecoration(
                hint: 'Choisir le niveau d\'étude',
                prefixIcon: Icons.school_outlined,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Classe actuelle de l\'enfant',
              hint: 'Précisez la classe',
              controller: _classeController,
              prefixIcon: Icons.class_outlined,
              validator: (v) => _requiredValidator(v, 'la classe'),
            ),
            const SizedBox(height: 40),
            AppPrimaryButton(text: 'Suivant', onPressed: _nextStep),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // Étape 3 : Choix de l'avatar
  // ----------------------------------------------------
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choisissez Votre Avatar',
            style: TextStyle(
              color: AppConst.textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppConst.fontFamily,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.75,
              ),
              itemCount: _avatars.length,
              itemBuilder: (context, index) {
                final bool isSelected = _selectedAvatarIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAvatarIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: AppConst.purpleButton, width: 4.0)
                          : Border.all(color: Colors.transparent, width: 4.0),
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
          AppPrimaryButton(text: 'S\'inscrire', onPressed: _submitRegistration),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // Widgets et validateurs communs
  // ----------------------------------------------------
  String? _requiredValidator(String? value, String champ) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer $champ';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer le numéro de téléphone';
    }
    final String digits = value.replaceAll(RegExp(r'[\s\-\+]'), '');
    if (digits.length < 8 || !RegExp(r'^\d+$').hasMatch(digits)) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer votre adresse email';
    }
    final RegExp emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Adresse email invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }



  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(
            fontFamily: AppConst.fontFamily,
            fontSize: 16,
            color: AppConst.textDark,
          ),
          decoration: appInputDecoration(
            hint: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

}
