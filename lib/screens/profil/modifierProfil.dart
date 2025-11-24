import 'package:flutter/material.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/schoolService.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/models/eleveProfileData.dart';
import 'package:edugo/models/eleve.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Contrôleurs
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Services
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  final SchoolService _schoolService = SchoolService();

  // Contrôleurs pour les champs de texte
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Données pour les dropdowns
  List<Map<String, dynamic>> _niveaux = [];
  List<Map<String, dynamic>> _classes = [];
  String? _selectedNiveauId;
  String? _selectedClasseId;
  String? _selectedNiveauText;
  String? _selectedClasseText;

  // Avatar
  String? _selectedAvatar;
  final List<String> _avatars = [
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/personas/png?seed=personas${index + 1}'),
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/adventurer/png?seed=adventurer${index + 1}'),
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/avataaars/png?seed=avataaars${index + 1}'),
    ...List.generate(24, (index) => 'https://api.dicebear.com/6.x/micah/png?seed=micah${index + 1}'),
  ];

  // États
  bool _isLoading = true;
  bool _isSaving = false;
  bool _loadingNiveaux = false;
  bool _loadingClasses = false;

  // Données du profil utilisateur
  EleveProfileData? _userProfile;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
    _initializeData();
  }

  void _onPageChanged() {
    int next = _pageController.page!.round();
    if (_currentPage != next) {
      setState(() {
        _currentPage = next;
      });
    }
  }

  Future<void> _initializeData() async {
    try {
      // Charger les données du profil via AuthService
      _userProfile = await _authService.getCurrentUserProfile();

      if (_userProfile != null) {
        await _loadUserData();
      }

      // Charger les niveaux
      await _loadNiveaux();
    } catch (e) {
      print('Erreur initialisation: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    if (_userProfile == null) return;

    setState(() {
      _nomController.text = _userProfile!.nom;
      _prenomController.text = _userProfile!.prenom;
      _telephoneController.text = _userProfile!.telephone ?? '';
      _villeController.text = _userProfile!.ville ?? '';
      _emailController.text = _userProfile!.email;
      _selectedAvatar = _userProfile!.photoProfil;

      // Pré-sélectionner le niveau et la classe si disponibles
      if (_userProfile!.niveauId != null) {
        _selectedNiveauId = _userProfile!.niveauId.toString();
        _selectedNiveauText = _userProfile!.niveauNom;
        _loadClasses(_userProfile!.niveauId!);
      }
      if (_userProfile!.classeId != null) {
        _selectedClasseId = _userProfile!.classeId.toString();
        _selectedClasseText = _userProfile!.classeNom;
      }
    });
  }

  Future<void> _loadNiveaux() async {
    setState(() {
      _loadingNiveaux = true;
    });

    try {
      final niveaux = await _schoolService.getNiveaux();
      setState(() {
        _niveaux = niveaux;

        // Si l'utilisateur a déjà un niveau, s'assurer qu'il est dans la liste
        if (_selectedNiveauId != null) {
          final niveau = _niveaux.firstWhere(
            (n) => n['id'].toString() == _selectedNiveauId,
            orElse: () => {},
          );
          if (niveau.isEmpty) {
            // Si le niveau n'est pas trouvé, réinitialiser
            _selectedNiveauId = null;
            _selectedNiveauText = null;
          }
        }
      });
    } catch (e) {
      print('Erreur chargement niveaux: $e');
    } finally {
      setState(() {
        _loadingNiveaux = false;
      });
    }
  }

  Future<void> _loadClasses(int? niveauId) async {
    if (niveauId == null) return;

    setState(() {
      _loadingClasses = true;
      _classes = [];
      _selectedClasseId = null;
      _selectedClasseText = null;
    });

    try {
      final classes = await _schoolService.getClasses(niveauId);
      setState(() {
        _classes = classes;

        // Si l'utilisateur a déjà une classe, s'assurer qu'elle est dans la liste
        if (_selectedClasseId != null) {
          final classe = _classes.firstWhere(
            (c) => c['id'].toString() == _selectedClasseId,
            orElse: () => {},
          );
          if (classe.isEmpty) {
            // Si la classe n'est pas trouvée, réinitialiser
            _selectedClasseId = null;
            _selectedClasseText = null;
          }
        }
      });
    } catch (e) {
      print('Erreur chargement classes: $e');
    } finally {
      setState(() {
        _loadingClasses = false;
      });
    }
  }

  void _onNiveauChanged(String? niveauId) {
    if (niveauId == null) return;

    setState(() {
      _selectedNiveauId = niveauId;

      // Trouver le texte du niveau sélectionné
      final niveau = _niveaux.firstWhere(
        (n) => n['id'].toString() == niveauId,
        orElse: () => {},
      );
      _selectedNiveauText = niveau['nom'];

      // Recharger les classes pour ce niveau
      _loadClasses(int.tryParse(niveauId));
    });
  }

  void _onClasseChanged(String? classeId) {
    if (classeId == null) return;

    setState(() {
      _selectedClasseId = classeId;

      // Trouver le texte de la classe sélectionnée
      final classe = _classes.firstWhere(
        (c) => c['id'].toString() == classeId,
        orElse: () => {},
      );
      _selectedClasseText = classe['nom'];
    });
  }

  void _showAvatarPicker(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choisissez un avatar',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sélectionnez un avatar qui vous représente',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Grille d'avatars avec défilement vertical
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _avatars.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedAvatar == _avatars[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatar = _avatars[index];
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(color: primaryColor, width: 3)
                                : Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
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
                                  color: primaryColor.withOpacity(0.1),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: primaryColor,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Erreur chargement avatar $index: $error');
                                return Container(
                                  color: primaryColor.withOpacity(0.1),
                                  child: Icon(Icons.person, color: primaryColor, size: 20),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final currentEleve = _authService.currentEleve;
      if (currentEleve == null) return;

      // Ici vous devrez adapter selon votre API
      // Créer les données de mise à jour
      final updateData = {
        'nom': _nomController.text.isNotEmpty ? _nomController.text : _userProfile?.nom,
        'prenom': _prenomController.text.isNotEmpty ? _prenomController.text : _userProfile?.prenom,
        'telephone': _telephoneController.text.isNotEmpty ? _telephoneController.text : _userProfile?.telephone,
        'ville': _villeController.text.isNotEmpty ? _villeController.text : _userProfile?.ville,
        'email': _emailController.text.isNotEmpty ? _emailController.text : _userProfile?.email,
        'photoProfil': _selectedAvatar,
        'niveauId': _selectedNiveauId != null ? int.tryParse(_selectedNiveauId!) : _userProfile?.niveauId,
        'classeId': _selectedClasseId != null ? int.tryParse(_selectedClasseId!) : _userProfile?.classeId,
      };

      // Appeler le service de mise à jour
      // NOTE: Vous devrez créer cette méthode dans EleveService
      final eleveService = EleveService();
      final result = await eleveService.updateEleveProfile(currentEleve.id!, updateData);

      if (result != null) {
        // Recharger les données utilisateur
        await _authService.getCurrentUserProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profil mis à jour avec succès'),
              backgroundColor: _themeService.currentPrimaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      } else {
        throw Exception('Échec de la mise à jour');
      }
    } catch (e) {
      print('Erreur lors de la sauvegarde: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _villeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        final Color borderColor = primaryColor.withOpacity(0.3);
        final Color fillColor = const Color(0xFFF5F5F5);
        const String fontFamily = 'Roboto';
        const Color appBarColor = Color(0xFFFFFFFF);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Modifier Votre profil',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: fontFamily,
              ),
            ),
            centerTitle: true,
          ),

          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        children: [
                          _buildPage1(context, primaryColor, borderColor, fillColor, fontFamily),
                          _buildPage2(context, primaryColor, borderColor, fillColor, fontFamily),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (index) => _buildDot(index, primaryColor)),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildProfileHeader(Color primaryColor) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          GestureDetector(
            onTap: () => _showAvatarPicker(context, primaryColor),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFF5F5F5),
              backgroundImage: _selectedAvatar != null
                  ? NetworkImage(_selectedAvatar!)
                  : null,
              child: _selectedAvatar == null
                  ? const Icon(Icons.person, size: 60, color: Color(0xFF969696))
                  : null,
            ),
          ),
          GestureDetector(
            onTap: () => _showAvatarPicker(context, primaryColor),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Les méthodes _buildPage1, _buildPage2, _buildTextField, etc. restent identiques
  // ... (gardez tout le reste du code des méthodes de construction d'UI)

  Widget _buildPage1(BuildContext context, Color primaryColor, Color borderColor, Color fillColor, String fontFamily) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeader(primaryColor),
          const SizedBox(height: 30),

          const Text('Nom', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nomController,
            hint: 'Entrer votre nom',
            borderColor: borderColor,
            fillColor: fillColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 25),

          const Text('Prenom', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _prenomController,
            hint: 'Entrer votre prenom',
            borderColor: borderColor,
            fillColor: fillColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 25),

          const Text('Téléphone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _telephoneController,
            hint: 'Votre numéro de téléphone',
            keyboardType: TextInputType.phone,
            borderColor: borderColor,
            fillColor: fillColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 25),

          const Text('Ville', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _villeController,
            hint: 'Entrez votre ville',
            borderColor: borderColor,
            fillColor: fillColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 40),

          const SizedBox(height: 50 + 16 + 50),
        ],
      ),
    );
  }

  Widget _buildPage2(BuildContext context, Color primaryColor, Color borderColor, Color fillColor, String fontFamily) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeader(primaryColor),
          const SizedBox(height: 30),

          const Text('Adresse Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'Entrer votre email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            borderColor: borderColor,
            fillColor: fillColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 25),

          const Text('Niveau', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
          const SizedBox(height: 8),
          _buildNiveauDropdown(primaryColor, borderColor, fillColor, fontFamily),
          const SizedBox(height: 25),

          const Text('Classe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
          const SizedBox(height: 8),
          _buildClasseDropdown(primaryColor, borderColor, fillColor, fontFamily),
          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Annuler',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  primaryColor: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  label: _isSaving ? 'Enregistrement...' : 'Enregistrer',
                  isPrimary: true,
                  onPressed: _isSaving ? null : _saveProfile,
                  primaryColor: primaryColor,
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
    IconData? icon,
    required Color borderColor,
    required Color fillColor,
    required Color primaryColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: borderColor,
        width: 1.0,
      ),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        border: borderStyle,
      ),
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  Widget _buildNiveauDropdown(Color primaryColor, Color borderColor, Color fillColor, String fontFamily) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedNiveauId,
              hint: _loadingNiveaux
                  ? const Text('Chargement des niveaux...', style: TextStyle(color: Colors.grey))
                  : const Text('Choisir votre niveau d\'étude', style: TextStyle(color: Colors.grey)),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: primaryColor),
              style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Roboto'),
              items: _niveaux.map((niveau) {
                return DropdownMenuItem<String>(
                  value: niveau['id'].toString(),
                  child: Text(niveau['nom'] ?? 'Niveau inconnu'),
                );
              }).toList(),
              onChanged: _onNiveauChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClasseDropdown(Color primaryColor, Color borderColor, Color fillColor, String fontFamily) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedClasseId,
              hint: _loadingClasses
                  ? const Text('Chargement des classes...', style: TextStyle(color: Colors.grey))
                  : _selectedNiveauId == null
                      ? const Text('Choisissez d\'abord un niveau', style: TextStyle(color: Colors.grey))
                      : const Text('Choisir votre classe', style: TextStyle(color: Colors.grey)),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: primaryColor),
              style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Roboto'),
              items: _classes.map((classe) {
                return DropdownMenuItem<String>(
                  value: classe['id'].toString(),
                  child: Text(classe['nom'] ?? 'Classe inconnue'),
                );
              }).toList(),
              onChanged: _selectedNiveauId == null ? null : _onClasseChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isPrimary,
    required VoidCallback? onPressed,
    required Color primaryColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: isPrimary ? primaryColor : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary ? BorderSide.none : BorderSide(color: primaryColor.withOpacity(0.5), width: 1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isPrimary ? Colors.white : Colors.black87,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildDot(int index, Color primaryColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? primaryColor : Colors.grey.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}