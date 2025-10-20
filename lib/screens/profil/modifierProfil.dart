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
  // Couleur de fond des champs de texte
  static const Color _inputFillColor = Color(0xFFF5F5F5);
  // Nouvelle couleur de bordure (Orange: #FF9800)
  static const Color _borderColor = Color(0xFFD1C4E9);

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
          const Text('Nom', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Entrer votre nom',
            icon: null,
          ),
          const SizedBox(height: 20),

          // Champ Prenom
          const Text('Prenom', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Entrer votre prenom',
            icon: null,
          ),
          const SizedBox(height: 20),

          // Champ Téléphone
          const Text('Téléphone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Votre numéro de téléphone',
            icon: null,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // Champ Ville
          const Text('Ville', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          const Text('Adresse Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Entrer votre email',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Champ Niveau
          const Text('Niveau', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildDropdownField(),
          const SizedBox(height: 20),

          // Champ Classe
          const Text('Classe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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


  Widget _buildTextField({
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Définition de la bordure commune
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: _borderColor, // Couleur orange
        width: 1.0,           // Épaisseur de 1
      ),
    );

    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),

        // Ajout du fond et du padding
        filled: true,
        fillColor: _inputFillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        // Applique la bordure à l'état normal
        enabledBorder: borderStyle,

        // Applique la bordure à l'état de focus (pour la cohérence, on garde la même couleur)
        focusedBorder: borderStyle,

        // Applique la bordure par défaut (fallback)
        border: borderStyle,

        suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      ),
    );
  }

  Widget _buildDropdownField() {
    // Définition de la bordure pour le Dropdown (pour la cohérence)
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: _borderColor, // Couleur orange
        width: 1.0,           // Épaisseur de 1
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: _inputFillColor,
        borderRadius: BorderRadius.circular(12),
        // Ajout de la bordure autour du Container pour le Dropdown
        border: Border.all(color: _borderColor, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedNiveau,
          hint: const Text('Choisir votre niveau d\'etude', style: TextStyle(color: Colors.grey)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          style: const TextStyle(fontSize: 16, color: Colors.black),
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