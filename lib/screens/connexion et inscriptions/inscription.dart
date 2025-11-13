import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/mainScreen.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/schoolService.dart';

// ------------------ CONSTANTES ------------------
const Color _purpleMain = Color(0xFFA885D8);
const Color _purpleLight = Color(0xFFF1EFFE);
const Color _purpleStepInactive = Color(0xFFE8E8E8);
const String _fontFamily = 'Roboto';

// ------------------ ÉCRAN PRINCIPAL ------------------
class RegistrationStepperScreen extends StatefulWidget {
  const RegistrationStepperScreen({super.key});

  @override
  State<RegistrationStepperScreen> createState() => _RegistrationStepperScreenState();
}

class _RegistrationStepperScreenState extends State<RegistrationStepperScreen> {
  int _currentStep = 0;
  late PageController _pageController;

  // Données collectées
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _city = '';
  String _email = '';
  String _password = '';
  int? _niveauId;
  int? _classeId;

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

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  List<Widget> get _steps => [
        RegistrationStep1(
          onNext: _nextStep,
          onFirstNameChanged: (val) => setState(() => _firstName = val),
          onLastNameChanged: (val) => setState(() => _lastName = val),
          onPhoneChanged: (val) => setState(() => _phone = val),
          onCityChanged: (val) => setState(() => _city = val),
          firstName: _firstName,
          lastName: _lastName,
          phone: _phone,
          city: _city,
        ),
        RegistrationStep2(
          onNext: _nextStep,
          onPrevious: _previousStep,
          onEmailChanged: (val) => setState(() => _email = val),
          onPasswordChanged: (val) => setState(() => _password = val),
          onSchoolLevelChanged: (val) => setState(() => _niveauId = val),
          onClassChanged: (val) => setState(() => _classeId = val),
          email: _email,
          password: _password,
          schoolLevelId: _niveauId,
          classId: _classeId,
        ),
        RegistrationStep3(
          onNext: _nextStep,
          onPrevious: _previousStep,
          userEmail: _email,
          userPassword: _password,
          userFirstName: _firstName,
          userLastName: _lastName,
          ville: _city,
          telephone: _phone,
          classeId: _classeId,
          niveauId: _niveauId,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Image.asset('assets/images/logo.png', height: 120, fit: BoxFit.contain),
          const SizedBox(height: 30),
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _steps,
            ),
          ),
        ],
      ),
    );
  }

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
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isCurrent || isCompleted ? _purpleMain : _purpleStepInactive,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text('${index + 1}', style: TextStyle(color: isCurrent || isCompleted ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                ),
                if (index < 2)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(height: 2, color: isCompleted ? _purpleMain : _purpleStepInactive),
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

// ------------------ STEP 1 CORRIGÉ ------------------
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
  void didUpdateWidget(RegistrationStep1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.firstName != _firstNameController.text) {
      _firstNameController.text = widget.firstName;
    }
    if (widget.lastName != _lastNameController.text) {
      _lastNameController.text = widget.lastName;
    }
    if (widget.phone != _phoneController.text) {
      _phoneController.text = widget.phone;
    }
    if (widget.city != _cityController.text) {
      _cityController.text = widget.city;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            label: 'Nom',
            hint: 'Entrer votre nom',
            controller: _firstNameController,
            onChanged: widget.onFirstNameChanged,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Prénom',
            hint: 'Entrer votre prénom',
            controller: _lastNameController,
            onChanged: widget.onLastNameChanged,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Téléphone',
            hint: 'Votre numéro',
            controller: _phoneController,
            onChanged: widget.onPhoneChanged,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 25),
          _buildInputField(
            label: 'Ville',
            hint: 'Votre ville',
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

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: _purpleLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              fontFamily: _fontFamily,
              color: Colors.grey[600],
            ),
          ),
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// ------------------ STEP 2 COMPLÈTEMENT CORRIGÉ ------------------
class RegistrationStep2 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(int?) onSchoolLevelChanged;
  final Function(int?) onClassChanged;
  final String email;
  final String password;
  final int? schoolLevelId;
  final int? classId;

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
    this.schoolLevelId,
    this.classId,
  });

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  List<Map<String, dynamic>> niveaux = [];
  List<Map<String, dynamic>> classes = [];
  bool _loadingNiveaux = false;
  bool _loadingClasses = false;

  int? selectedNiveau;
  int? selectedClasse;

  late TextEditingController _niveauController;
  late TextEditingController _classeController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    _niveauController = TextEditingController();
    _classeController = TextEditingController();
    _loadNiveaux();
  }

  Future<void> _loadNiveaux() async {
    setState(() => _loadingNiveaux = true);
    try {
      print('🔄 Chargement des niveaux...');
      final result = await SchoolService().getNiveaux();
      print('✅ Niveaux chargés: ${result.length}');
      setState(() {
        niveaux = result;
        _loadingNiveaux = false;
      });
    } catch (e) {
      print('❌ Erreur chargement niveaux: $e');
      setState(() => _loadingNiveaux = false);
    }
  }

  Future<void> _loadClasses(int niveauId) async {
    setState(() => _loadingClasses = true);
    try {
      print('🔄 Chargement des classes pour niveau $niveauId...');
      final result = await SchoolService().getClasses(niveauId);
      print('✅ Classes chargées: ${result.length}');
      setState(() {
        classes = result;
        _loadingClasses = false;
      });
    } catch (e) {
      print('❌ Erreur chargement classes: $e');
      setState(() => _loadingClasses = false);
    }
  }

  Future<void> _showNiveauSelection() async {
    if (_loadingNiveaux) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Poignée du bottom sheet
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _loadingNiveaux
                    ? const Center(child: CircularProgressIndicator())
                    : niveaux.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucun niveau disponible',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: niveaux.length,
                            itemBuilder: (context, index) {
                              final niveau = niveaux[index];
                              return ListTile(
                                title: Text(
                                  niveau['nom']?.toString() ?? 'Niveau sans nom',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedNiveau = niveau['id'];
                                    _niveauController.text = niveau['nom']?.toString() ?? '';
                                    widget.onSchoolLevelChanged(niveau['id']);
                                    selectedClasse = null;
                                    _classeController.clear();
                                    widget.onClassChanged(null);
                                  });
                                  _loadClasses(niveau['id']!);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showClasseSelection() async {
    if (selectedNiveau == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez d\'abord sélectionner un niveau')),
      );
      return;
    }

    if (_loadingClasses) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Poignée du bottom sheet
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _loadingClasses
                    ? const Center(child: CircularProgressIndicator())
                    : classes.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucune classe disponible pour ce niveau',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: classes.length,
                            itemBuilder: (context, index) {
                              final classe = classes[index];
                              return ListTile(
                                title: Text(
                                  classe['nom']?.toString() ?? 'Classe sans nom',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedClasse = classe['id'];
                                    _classeController.text = classe['nom']?.toString() ?? '';
                                    widget.onClassChanged(classe['id']);
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email
          _buildInputField(
            label: 'Adresse Email',
            hint: 'Entrer votre email',
            controller: _emailController,
            onChanged: widget.onEmailChanged,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),

          // Mot de passe
          _buildPasswordField(),
          const SizedBox(height: 25),

          // Niveau scolaire
          _buildDropdownField(
            label: 'Niveau Scolaire de l\'enfant',
            controller: _niveauController,
            hint: 'Choisir votre niveau d\'étude',
            onTap: _showNiveauSelection,
            isLoading: _loadingNiveaux,
          ),
          const SizedBox(height: 25),

          // Classe
          _buildDropdownField(
            label: 'Classe actuelle de l\'enfant',
            controller: _classeController,
            hint: 'Choisissez votre classe',
            onTap: _showClasseSelection,
            isLoading: _loadingClasses,
            isEnabled: selectedNiveau != null,
          ),
          const SizedBox(height: 60),
          _buildNextButton(
            text: 'Suivant',
            onPressed: () {
              if (_emailController.text.isEmpty ||
                  _passwordController.text.isEmpty ||
                  selectedNiveau == null ||
                  selectedClasse == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez remplir tous les champs')),
                );
                return;
              }
              widget.onNext();
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: _purpleLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              fontFamily: _fontFamily,
              color: Colors.grey[600],
            ),
          ),
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mot de passe', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: widget.onPasswordChanged,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'Entrer votre mot de passe',
            filled: true,
            fillColor: _purpleLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            hintStyle: TextStyle(
              fontFamily: _fontFamily,
              color: Colors.grey[600],
            ),
          ),
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required VoidCallback onTap,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: isEnabled ? onTap : null,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isEnabled ? _purpleLight : Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.arrow_drop_down, color: Colors.grey),
            hintStyle: TextStyle(
              fontFamily: _fontFamily,
              color: Colors.grey[600],
            ),
          ),
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            color: isEnabled ? Colors.black : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// ------------------ STEP 3 AVEC AVATARS PNG ET ENVOI DE L'AVATAR ------------------
class RegistrationStep3 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final String userEmail;
  final String userPassword;
  final String userFirstName;
  final String userLastName;
  final String ville;
  final String telephone;
  final int? classeId;
  final int? niveauId;

  const RegistrationStep3({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.userEmail,
    required this.userPassword,
    required this.userFirstName,
    required this.userLastName,
    required this.ville,
    required this.telephone,
    required this.classeId,
    required this.niveauId,
  });

  @override
  State<RegistrationStep3> createState() => _RegistrationStep3State();
}

class _RegistrationStep3State extends State<RegistrationStep3> {
  final AuthService _authService = AuthService();
  int? _selectedAvatarIndex;
  bool _isLoading = false;
  String? _errorMessage;

  // Liste d'avatars en format PNG
  final List<String> _avatars = [
    // Style Personas (24 avatars) - PNG
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/personas/png?seed=personas${index + 1}'),

    // Style Adventurer (24 avatars) - PNG
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/adventurer/png?seed=adventurer${index + 1}'),

    // Style Avataaars (24 avatars) - PNG
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/avataaars/png?seed=avataaars${index + 1}'),

    // Style Micah (24 avatars) - PNG
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/micah/png?seed=micah${index + 1}'),
  ];

  Future<void> _registerUser() async {
    if (_selectedAvatarIndex == null) {
      setState(() => _errorMessage = 'Veuillez sélectionner un avatar');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Récupérer l'URL de l'avatar sélectionné
      final String selectedAvatarUrl = _avatars[_selectedAvatarIndex!];
      print(' Avatar sélectionné: $selectedAvatarUrl');

      final response = await _authService.register(
        email: widget.userEmail,
        motDePasse: widget.userPassword,
        nom: widget.userLastName,
        prenom: widget.userFirstName,
        ville: widget.ville,
        classeId: widget.classeId!,
        telephone: int.parse(widget.telephone),
        niveauId: widget.niveauId!,
        photoProfil: selectedAvatarUrl, // Envoi de l'URL dans photoProfil
      );

      if (response != null && response.token != null) {
        _authService.setAuthToken(response.token!);
        print(' Inscription réussie avec avatar');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen())
        );
      } else {
        setState(() => _errorMessage = 'Erreur lors de l\'inscription. Veuillez réessayer.');
      }
    } catch (e) {
      print(' Erreur inscription: $e');
      setState(() => _errorMessage = 'Une erreur est survenue: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Choisissez un avatar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Sélectionnez un avatar qui vous représente',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Message d'erreur
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          if (_errorMessage != null) const SizedBox(height: 20),

          // Indicateur de sélection
          if (_selectedAvatarIndex != null)
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Avatar ${_selectedAvatarIndex! + 1} sélectionné',
                style: TextStyle(
                  color: _purpleMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Grille d'avatars avec défilement horizontal
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 lignes pour le défilement horizontal
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.0,
              ),
              itemCount: _avatars.length,
              itemBuilder: (_, index) {
                final isSelected = _selectedAvatarIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarIndex = index;
                      _errorMessage = null; // Effacer l'erreur si avatar sélectionné
                    });
                    print('👤 Avatar $index sélectionné: ${_avatars[index]}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: _purpleMain, width: 3)
                          : Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: _purpleMain.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _avatars[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: _purpleLight,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print(' Erreur chargement avatar $index: $error');
                          return Container(
                            color: _purpleLight,
                            child: const Icon(Icons.person, color: _purpleMain, size: 30),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          _buildNextButton(
            text: _isLoading ? 'Inscription en cours...' : 'S\'inscrire',
            onPressed: _isLoading ? null : _registerUser,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ------------------ WIDGETS UTILITAIRES ------------------
Widget _buildNextButton({required String text, VoidCallback? onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _purpleMain,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ),
  );
}