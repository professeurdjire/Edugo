import 'package:flutter/material.dart';

// Définition de la classe pour l'écran de modification de profil
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Contrôleur pour gérer la navigation du PageView
  final PageController _pageController = PageController();
  int _currentPage = 0; // Index de la page actuelle

  // Liste des niveaux d'étude pour le Dropdown
  final List<String> _niveaux = ['Lycée', 'Université', 'Primaire', 'Collège'];
  String? _selectedNiveau;

  // Initialisation et écoute des changements de page
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Couleur principale (violet/mauve)
  static const Color _primaryColor = Color(0xFFA885D8);
  // Couleur de fond de l'AppBar
  static const Color _appBarColor = Color(0xFFFFFFFF);

  // NOUVELLES COULEURS POUR CORRESPONDRE À L'INSCRIPTION
  static const Color _borderColor = Color(0xFFD1C4E9); // Bordure douce violette
  static const Color _fillColor = Color(0xFFF5F5F5);   // Fond gris clair
  static const String _fontFamily = 'Roboto'; // Police par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- AppBar (Partie fixe) ---
      appBar: AppBar(
        backgroundColor: _appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Retour à ProfilScreen
          },
        ),
        title: const Text(
          'Modifier Votre profil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // --- Body (Contenu principal avec PageView) ---
      body: Column(
        children: [
          // Section du PageView (Contenu défilant)
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                // PAGE 1 (Index 0): Nom, Prénom, Téléphone, Ville
                _buildPage1(context),

                // PAGE 2 (Index 1): Email, Niveau, Classe + Boutons d'action
                _buildPage2(context),
              ],
            ),
          ),

          // Indicateurs de page (les deux points)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) => _buildDot(index)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets de construction des différentes sections ---

  Widget _buildProfileHeader() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // L'avatar (remplacé par un cercle pour la démonstration)
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color.fromARGB(255, 230, 230, 230),
            child: Icon(Icons.person, size: 60, color: Color.fromARGB(255, 150, 150, 150)),
            // Dans une application réelle, utiliser Image.asset ou NetworkImage
          ),
          // Icône de crayon pour l'édition
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              color: _primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // PAGE 1: Nom, Prénom, Téléphone, Ville
  Widget _buildPage1(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeader(),
          const SizedBox(height: 30),

          // Champ Nom
          const Text('Nom', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Entrer votre nom',
            icon: null,
          ),
          const SizedBox(height: 25),

          // Champ Prenom
          const Text('Prenom', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Entrer votre prenom',
            icon: null,
          ),
          const SizedBox(height: 25),

          // Champ Téléphone
          const Text('Téléphone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Votre numéro de téléphone',
            icon: null,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 25),

          // Champ Ville
          const Text('Ville', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Entrez votre ville',
            icon: null,
          ),
          const SizedBox(height: 40),

          // Espace pour aligner la hauteur avec la Page 2 qui a des boutons.
          const SizedBox(height: 50 + 16 + 50),
        ],
      ),
    );
  }

  // PAGE 2: Email, Niveau, Classe + Boutons d'action
  Widget _buildPage2(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeader(),
          const SizedBox(height: 30),

          // Champ Adresse Email
          const Text('Adresse Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Entrer votre email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),

          // Champ Niveau
          const Text('Niveau', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          _buildDropdownField(),
          const SizedBox(height: 25),

          // Champ Classe
          const Text('Classe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Précisez votre classe',
            icon: null,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 40),

          // Boutons Annuler et Enregistrer
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Annuler',
                  isPrimary: false,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  label: 'Enregistrer',
                  isPrimary: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET CHAMP DE SAISIE - STYLE MODIFIÉ POUR CORRESPONDRE À L'INSCRIPTION
  Widget _buildTextField({
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: _borderColor,
        width: 1.0,
      ),
    );

    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: _fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: icon != null ? Icon(icon, color: _primaryColor) : null,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
        border: borderStyle,
      ),
      style: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  // WIDGET DROPDOWN - STYLE MODIFIÉ POUR CORRESPONDRE À L'INSCRIPTION
  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedNiveau,
              hint: const Text(
                'Choisir votre niveau d\'etude',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: _fontFamily),
              items: _niveaux.map((String niveau) {
                return DropdownMenuItem<String>(
                  value: niveau,
                  child: Text(niveau),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedNiveau = newValue;
                });
              },
            ),
          ),
        ),
      ],
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
        backgroundColor: isPrimary ? _primaryColor : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary ? BorderSide.none : const BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isPrimary ? Colors.white : Colors.black87,
          fontFamily: _fontFamily,
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
        color: _currentPage == index ? _primaryColor : Colors.grey.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}