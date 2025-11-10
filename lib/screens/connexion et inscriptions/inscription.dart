import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/mainScreen.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/schoolService.dart'; // Service pour récupérer niveaux et classes

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

// ------------------ STEP 1 ------------------
class RegistrationStep1 extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final _firstNameController = TextEditingController(text: firstName);
    final _lastNameController = TextEditingController(text: lastName);
    final _phoneController = TextEditingController(text: phone);
    final _cityController = TextEditingController(text: city);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(label: 'Nom', hint: 'Entrer votre nom', controller: _firstNameController, onChanged: onFirstNameChanged),
          const SizedBox(height: 25),
          _buildInputField(label: 'Prénom', hint: 'Entrer votre prénom', controller: _lastNameController, onChanged: onLastNameChanged),
          const SizedBox(height: 25),
          _buildInputField(label: 'Téléphone', hint: 'Votre numéro', keyboardType: TextInputType.phone, controller: _phoneController, onChanged: onPhoneChanged),
          const SizedBox(height: 25),
          _buildInputField(label: 'Ville', hint: 'Votre ville', controller: _cityController, onChanged: onCityChanged),
          const SizedBox(height: 60),
          _buildNextButton(text: 'Suivant', onPressed: onNext),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ------------------ STEP 2 ------------------
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

  List<Map<String, dynamic>> niveaux = [];
  List<Map<String, dynamic>> classes = [];

  int? selectedNiveau;
  int? selectedClasse;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);

    _loadNiveaux();
  }

  Future<void> _loadNiveaux() async {
    niveaux = await SchoolService().getNiveaux();
    setState(() {});
  }

  Future<void> _loadClasses(int niveauId) async {
    classes = await SchoolService().getClasses(niveauId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(label: 'Email', hint: 'Entrer votre email', controller: _emailController, onChanged: widget.onEmailChanged, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 25),
          _buildInputField(label: 'Mot de passe', hint: 'Entrer votre mot de passe', isPassword: true, controller: _passwordController, onChanged: widget.onPasswordChanged),
          const SizedBox(height: 25),
          DropdownButtonFormField<int>(
            value: selectedNiveau,
            hint: const Text('Sélectionnez le niveau scolaire'),
            items: niveaux.map((niv) => DropdownMenuItem<int>(value: niv['id'], child: Text(niv['nom']))).toList(),
            onChanged: (val) {
              selectedNiveau = val;
              widget.onSchoolLevelChanged(val);
              _loadClasses(val!);
            },
          ),
          const SizedBox(height: 25),
          DropdownButtonFormField<int>(
            value: selectedClasse,
            hint: const Text('Sélectionnez la classe'),
            items: classes.map((cls) => DropdownMenuItem<int>(value: cls['id'], child: Text(cls['nom']))).toList(),
            onChanged: (val) {
              selectedClasse = val;
              widget.onClassChanged(val);
            },
          ),
          const SizedBox(height: 60),
          _buildNextButton(text: 'Suivant', onPressed: widget.onNext),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ------------------ STEP 3 (Avatar + Inscription) ------------------
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

  // Liste dynamique de 100 avatars via Pravatar
  late final List<String> _avatarUrls = List.generate(100, (index) => 'https://i.pravatar.cc/150?img=${index + 1}');

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
        motDePasse: widget.userPassword,
        nom: widget.userLastName,
        prenom: widget.userFirstName,
        ville: widget.ville,
        classeId: widget.classeId!,
        telephone: int.parse(widget.telephone),
        niveauId: widget.niveauId!,
      );

      if (response != null && response.token != null) {
        _authService.setAuthToken(response.token!);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
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
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Choisissez un avatar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        if (_errorMessage != null)
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _avatarUrls.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatarIndex = index),
                child: Container(
                  decoration: BoxDecoration(
                    border: _selectedAvatarIndex == index ? Border.all(color: _purpleMain, width: 3) : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_avatarUrls[index], fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
        _buildNextButton(text: _isLoading ? 'Inscription...' : 'S\'inscrire', onPressed: _isLoading ? () {} : _registerUser),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ------------------ WIDGETS UTILITAIRES ------------------
Widget _buildInputField({
  required String label,
  required String hint,
  bool isPassword = false,
  TextEditingController? controller,
  Function(String)? onChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: _purpleLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ],
  );
}

Widget _buildNextButton({required String text, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: _purpleMain, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    ),
  );
}
