import 'package:flutter/material.dart';
import 'package:edugo/services/exercise_service.dart'; // Use new ExerciseService
import 'package:edugo/models/exercice_response.dart';
import 'package:edugo/screens/main/exercice/exercice3.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorWhite = Color(0xFFFFFFFF); // Fond blanc
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
const Color _colorGrey = Color(0xFF9E9E9E); // Gris
const Color _colorLightGrey = Color(0xFFE0E0E0); // Gris clair
const Color _colorBackground = Color(0xFFF8F9FA); // Background color
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour les données d'exercice
class ExerciseData {
  final String title;
  final String subtitle;
  final int questions;
  final String level;
  final double progress;

  ExerciseData({
    required this.title,
    required this.subtitle,
    required this.questions,
    required this.level,
    required this.progress,
  });
}

class ExerciseMatiereListScreen extends StatefulWidget {
  final int matiereId;
  final String matiereName;
  final int? eleveId;

  const ExerciseMatiereListScreen({
    super.key,
    required this.matiereId,
    required this.matiereName,
    required this.eleveId,
  });

  @override
  State<ExerciseMatiereListScreen> createState() => _ExerciseMatiereListScreenState();
}

class _ExerciseMatiereListScreenState extends State<ExerciseMatiereListScreen> {
  final ExerciseService _exerciceService = ExerciseService(); // Use new ExerciseService
  
  BuiltList<ExerciceResponse>? _exercices;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercices();
  }

  Future<void> _loadExercices() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final exercices = await _exerciceService.getExercicesByMatiere(widget.matiereId);
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
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors du chargement des exercices')),
        );
      }
    }
  }

  String _getDifficultyLevel(int? niveauDifficulte) {
    switch (niveauDifficulte) {
      case 1:
        return 'Facile';
      case 2:
        return 'Moyen';
      case 3:
        return 'Difficile';
      default:
        return 'Inconnu';
    }
  }

  Color _getDifficultyColor(int? niveauDifficulte) {
    switch (niveauDifficulte) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciceList = _exercices?.toList() ?? [];
    
    return Scaffold(
      backgroundColor: _colorBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : exerciceList.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildExerciseList(context, exerciceList),
                    ],
                  ),
                ),
    );
  }

  // --- WIDGET APPBAR PERSONNALISÉE ---
  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: _purpleMain,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: _colorWhite,
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
                  // Centrer le titre avec le nom de la matière
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.matiereName,
                        style: const TextStyle(
                          color: _colorBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                        overflow: TextOverflow.ellipsis,
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

  // --- WIDGET EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun exercice disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Il n\'y a actuellement aucun exercice disponible pour cette matière.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadExercices,
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleMain,
              ),
              child: const Text(
                'Réessayer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET LISTE DES EXERCICES ---
  Widget _buildExerciseList(BuildContext context, List<ExerciceResponse> exercices) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          // Titre "Exercices"
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Exercices',
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
            ),
          ),
          // Liste des exercices
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exercices.length,
            itemBuilder: (context, index) {
              final exercice = exercices[index];
              return _buildExerciseCard(context, exercice);
            },
          ),
        ],
      ),
    );
  }

  // --- WIDGET CARTE D'EXERCICE ---
  Widget _buildExerciseCard(BuildContext context, ExerciceResponse exercice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to exercise detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                exerciseId: exercice.id ?? 0,
                exerciseTitle: exercice.titre ?? 'Exercice sans titre',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and difficulty
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      exercice.titre ?? 'Exercice sans titre',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _colorBlack,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(exercice.niveauDifficulte).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.speed,
                          color: _getDifficultyColor(exercice.niveauDifficulte),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getDifficultyLevel(exercice.niveauDifficulte),
                          style: TextStyle(
                            color: _getDifficultyColor(exercice.niveauDifficulte),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Description
              Text(
                exercice.titre ?? 'Aucune description disponible',
                style: const TextStyle(
                  color: _colorGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              
              // Footer with info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Questions count
                  Row(
                    children: [
                      const Icon(
                        Icons.question_answer,
                        color: _colorGrey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Questions count not available',
                        style: TextStyle(
                          color: _colorGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  // Points
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: _purpleMain,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Points not available',
                        style: TextStyle(
                          color: _purpleMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}