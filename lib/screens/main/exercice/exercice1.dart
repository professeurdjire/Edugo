import 'package:flutter/material.dart';
import 'package:edugo/screens/main/exercice/exercice2.dart';
import 'package:edugo/services/exercice_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale
const Color _purpleAppbar = Color(0xFFA885D8); // Violet de la barre d'app
const Color _shadowColor = Color(0xFFE5E5E5); // Gris clair d'ombre
const Color _colorBackground = Color(0xFFF8F9FA);

class MatiereListScreen extends StatefulWidget {
  final int? eleveId;

  const MatiereListScreen({super.key, this.eleveId});

  @override
  State<MatiereListScreen> createState() => _MatiereListScreenState();
}

class _MatiereListScreenState extends State<MatiereListScreen> {
  final ExerciceService _exerciceService = ExerciceService();
  final AuthService _authService = AuthService();
  
  BuiltList<ExerciceResponse>? _exercices;
  bool _isLoading = true;
  int? _currentEleveId;

  @override
  void initState() {
    super.initState();
    _currentEleveId = widget.eleveId ?? _authService.currentUserId;
    _loadExercices();
  }

  Future<void> _loadExercices() async {
    if (_currentEleveId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load available exercises for the student
      final exercices = await _exerciceService.getExercicesDisponibles(_currentEleveId!);
      
      if (mounted) {
        setState(() {
          _exercices = exercices;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading exercises: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Liste des matières à afficher (will be populated from backend data)
  List<String> _getMatieresFromExercices() {
    if (_exercices == null) {
      // Fallback to simulated data
      return [
        'Histoire',
        'Géographie',
        'Mathématique',
        'Français',
        'Physique',
        'Chimie',
        'Education Familiale',
        'Education physique et morale',
      ];
    }
    
    // Extract unique subjects from exercises
    final matieres = <String>{};
    for (final exercice in _exercices!) {
      if (exercice.matiereNom != null) {
        matieres.add(exercice.matiereNom!);
      }
    }
    
    return matieres.toList();
  }

  @override
  Widget build(BuildContext context) {
    final matieres = _getMatieresFromExercices();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Liste des cartes de matière
                  _buildMatiereList(context, matieres),
                ],
              ),
            ),
    );
  }

  // --- WIDGET APPBAR PERSONNALISÉE ---
  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: _purpleAppbar,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 10.0, left: 0, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  // Icône de retour (en noir)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: _colorBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Centrer le titre "Exercices"
                  Expanded(
                    child: Center(
                      child: Text(
                        'Exercices',
                        style: const TextStyle(
                          color: _colorBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Pour équilibrer l'icône de retour
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET LISTE DES MATIÈRES ---
  Widget _buildMatiereList(BuildContext context, List<String> matieres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          // Titre "Matières"
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Matières',
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
            ),
          ),

          // Liste des matières
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: matieres.length,
            itemBuilder: (context, index) {
              final matiere = matieres[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseMatiereListScreen(matiere: matiere),
                      ),
                    );
                  },
                  // Effet de survol avec MouseRegion pour un meilleur contrôle
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _shadowColor.withOpacity(0.8),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            matiere,
                            style: const TextStyle(
                              color: _colorBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: _fontFamily,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}