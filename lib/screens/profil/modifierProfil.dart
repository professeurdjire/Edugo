import 'package:edugo/core/constants/constant.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _classeController = TextEditingController();

  // Mêmes niveaux que l'inscription
  static const List<String> _niveaux = ['Primaire', 'Secondaire'];
  String? _selectedNiveau;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _villeController.dispose();
    _emailController.dispose();
    _classeController.dispose();
    super.dispose();
  }

  String? _optionalEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final RegExp emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Adresse email invalide';
    }
    return null;
  }

  String? _optionalPhoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final String digits = value.replaceAll(RegExp(r'[\s\-\+]'), '');
    if (digits.length < 8 || !RegExp(r'^\d+$').hasMatch(digits)) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  void _handleSave() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    // TODO: enregistrer les modifications via l'API (voir issue #3)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mis à jour'),
        backgroundColor: AppConst.purpleDark,
      ),
    );
    Navigator.pop(context);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Modifier votre profil',
          style: TextStyle(
            color: AppConst.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _buildPage1(),
                  _buildPage2(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) => _buildDot(index)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppConst.purpleInputFill,
            backgroundImage: AssetImage('assets/images/avatar1.png'),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              color: AppConst.purpleButton,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // PAGE 1 : Nom, Prénom, Téléphone, Ville
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeader(),
          const SizedBox(height: 30),

          _buildLabel('Nom'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nomController,
            hint: 'Entrez votre nom',
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),

          _buildLabel('Prénom'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _prenomController,
            hint: 'Entrez votre prénom',
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),

          _buildLabel('Téléphone'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _telephoneController,
            hint: 'Votre numéro de téléphone',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: _optionalPhoneValidator,
          ),
          const SizedBox(height: 20),

          _buildLabel('Ville'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _villeController,
            hint: 'Entrez votre ville',
            prefixIcon: Icons.location_city_outlined,
          ),
          const SizedBox(height: 40),

          // Espace pour aligner la hauteur avec la page 2 qui a des boutons
          const SizedBox(height: 50 + 16 + 50),
        ],
      ),
    );
  }

  // PAGE 2 : Email, Niveau, Classe + boutons d'action
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeader(),
          const SizedBox(height: 30),

          _buildLabel('Adresse Email'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'Entrez votre email',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: _optionalEmailValidator,
          ),
          const SizedBox(height: 20),

          _buildLabel('Niveau'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedNiveau,
            items: _niveaux
                .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                .toList(),
            onChanged: (value) => setState(() => _selectedNiveau = value),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppConst.textGrey),
            style: const TextStyle(
              fontFamily: AppConst.fontFamily,
              fontSize: 16,
              color: AppConst.textDark,
            ),
            decoration: _inputDecoration(
              hint: 'Choisir le niveau d\'étude',
              prefixIcon: Icons.school_outlined,
            ),
          ),
          const SizedBox(height: 20),

          _buildLabel('Classe'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _classeController,
            hint: 'Précisez votre classe',
            prefixIcon: Icons.class_outlined,
          ),
          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Annuler',
                  isPrimary: false,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  label: 'Enregistrer',
                  isPrimary: true,
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppConst.textDark,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: AppConst.fontFamily,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppConst.textGrey,
        fontSize: 15,
        fontFamily: AppConst.fontFamily,
      ),
      prefixIcon: Icon(prefixIcon, color: AppConst.purpleButton, size: 22),
      filled: true,
      fillColor: AppConst.purpleInputFill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppConst.purpleButton, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: AppConst.fontFamily,
        fontSize: 16,
        color: AppConst.textDark,
      ),
      decoration: _inputDecoration(hint: hint, prefixIcon: prefixIcon),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: isPrimary ? AppConst.purpleButton : Colors.white,
        foregroundColor: isPrimary ? Colors.white : AppConst.textDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: AppConst.textGrey, width: 1),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: AppConst.fontFamily,
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppConst.purpleButton
            : AppConst.textGrey.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}
