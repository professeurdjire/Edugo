import 'package:edugo/core/widgets/widgets.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/services/api/api.dart';
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

  Eleve? _eleve;
  String? _avatar;
  bool _isSaving = false;

  // Mêmes avatars que l'inscription
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
    _pageController.addListener(() {
      final int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });
    _loadProfile();
  }

  /// Préremplit le formulaire avec le profil stocké localement.
  Future<void> _loadProfile() async {
    final Eleve? eleve = await AuthService.instance.currentEleve();
    if (eleve == null || !mounted) return;
    setState(() {
      _eleve = eleve;
      _avatar = eleve.avatar;
      _nomController.text = eleve.nom;
      _prenomController.text = eleve.prenom;
      _telephoneController.text = eleve.telephone;
      _villeController.text = eleve.ville;
      _emailController.text = eleve.email;
      _classeController.text = eleve.classe;
      _selectedNiveau =
          _niveaux.contains(eleve.niveauScolaire) ? eleve.niveauScolaire : null;
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

  Future<void> _handleSave() async {
    if (_isSaving) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final Eleve updated = Eleve(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      telephone: _telephoneController.text.trim(),
      ville: _villeController.text.trim(),
      email: _emailController.text.trim(),
      niveauScolaire: _selectedNiveau ?? '',
      classe: _classeController.text.trim(),
      avatar: _avatar ?? _eleve?.avatar,
    );

    setState(() => _isSaving = true);
    try {
      // En mode démo, la mise à jour est enregistrée localement.
      await AuthService.instance.updateProfile(updated);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (!mounted) return;
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
      child: GestureDetector(
        onTap: _pickAvatar,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppConst.purpleInputFill,
              backgroundImage:
                  AssetImage(_avatar ?? 'assets/images/avatar1.png'),
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
      ),
    );
  }

  /// Feuille de sélection d'avatar (mêmes choix qu'à l'inscription).
  void _pickAvatar() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choisissez votre avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConst.textDark,
                  fontFamily: AppConst.fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
                children: _avatars.map((path) {
                  final bool isSelected = path == _avatar;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _avatar = path);
                      Navigator.pop(sheetContext);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppConst.purpleButton
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.asset(path, fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
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

          const AppFieldLabel('Nom'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nomController,
            hint: 'Entrez votre nom',
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),

          const AppFieldLabel('Prénom'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _prenomController,
            hint: 'Entrez votre prénom',
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),

          const AppFieldLabel('Téléphone'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _telephoneController,
            hint: 'Votre numéro de téléphone',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: _optionalPhoneValidator,
          ),
          const SizedBox(height: 20),

          const AppFieldLabel('Ville'),
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

          const AppFieldLabel('Adresse Email'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'Entrez votre email',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: _optionalEmailValidator,
          ),
          const SizedBox(height: 20),

          const AppFieldLabel('Niveau'),
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
            decoration: appInputDecoration(
              hint: 'Choisir le niveau d\'étude',
              prefixIcon: Icons.school_outlined,
            ),
          ),
          const SizedBox(height: 20),

          const AppFieldLabel('Classe'),
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
      decoration: appInputDecoration(hint: hint, prefixIcon: prefixIcon),
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
