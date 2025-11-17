import 'package:flutter/material.dart';
// Importation du QuizScreen (exercice3.dart)
import 'package:edugo/screens/main/exercice/exercice3.dart';
import 'package:edugo/services/exercice_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleAppbar = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _colorEasyTag = Color(0xFFC0D99D);
const Color _colorMediumTag = Color(0xFFB1A0D6);
const Color _colorHardTag = Color(0xFFD6A0A0);
const Color _colorProgressEasy = Color(0xFF8DC63F);
const Color _colorProgressMedium = Color(0xFF5D3BA5);
const Color _colorProgressHard = Color(0xFFE4712F);
const Color _colorCheck = Color(0xFF32C832);
const String _fontFamily = 'Roboto';
const Color _shadowColor = Color(0xFFEEEEEE);

// -------------------------------------------------------------------
// --- STRUCTURE DE DONNÉES ---
// -------------------------------------------------------------------

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

// ===================================================================
// ÉCRAN 2 : LISTE DES EXERCICES PAR MATIÈRE
// ===================================================================

class ExerciseMatiereListScreen extends StatefulWidget {
  final String matiere;

  const ExerciseMatiereListScreen({super.key, required this.matiere});

  @override
  State<ExerciseMatiereListScreen> createState() => _ExerciseMatiereListScreenState();
}

class _ExerciseMatiereListScreenState extends State<ExerciseMatiereListScreen> {
  final ExerciceService _exerciceService = ExerciceService();
  final AuthService _authService = AuthService();
  
  BuiltList<ExerciceResponse>? _exercices;
  bool _isLoading = true;
  int? _currentEleveId;

  @override
  void initState() {
    super.initState();
    _currentEleveId = _authService.currentUserId;
    _loadExercices();
  }

  Future<void> _loadExercices() async {
    if (_currentEleveId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load exercises by subject
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  _buildExerciseList(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: _colorBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.matiere,
                        style: const TextStyle(
                          color: _colorBlack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- LISTE DES EXERCICES ---
  Widget _buildExerciseList(BuildContext context) {
    List<ExerciseData> exercises = [];
    List<ExerciceResponse> filteredExercises = [];
    
    if (_exercices != null) {
      // Filter exercises by subject
      filteredExercises = _exercices!.where((exercice) => exercice.matiereNom == widget.matiere).toList();
      
      // Convert real data to display format
      exercises = filteredExercises.map((exercice) {
        return ExerciseData(
          title: exercice.titre ?? 'Exercice sans titre',
          subtitle: exercice.matiereNom ?? 'Aucune matière',
          questions: 0, // We don't have question count in ExerciceResponse
          level: _getDifficultyLevel(exercice.niveauDifficulte ?? 1),
          progress: 0.0, // We don't have progress data in the current model
        );
      }).toList();
    } else {
      // Fallback to simulated data
      exercises = [
        ExerciseData(title: 'Exercice 1', subtitle: 'Algèbre de base', questions: 10, level: 'Facile', progress: 1.0),
        ExerciseData(title: 'Exercice 2', subtitle: 'Géométrie des triangles', questions: 16, level: 'Moyen', progress: 0.75),
        ExerciseData(title: 'Exercice 3', subtitle: 'Calcul mentale et fractions', questions: 12, level: 'Difficile', progress: 0.20),
        ExerciseData(title: 'Exercice 4', subtitle: 'Problèmes de logique', questions: 13, level: 'Facile', progress: 0.0),
        ExerciseData(title: 'Exercice 5', subtitle: 'Introduction aux équations', questions: 12, level: 'Moyen', progress: 0.60),
        ExerciseData(title: 'Exercice 6', subtitle: 'Équations complexes', questions: 15, level: 'Difficile', progress: 0.0),
      ];
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final item = exercises[index];
        final exerciceId = _exercices != null ? filteredExercises[index].id ?? 0 : index + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0, left: 20, right: 20),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(exerciseTitle: item.title, exerciseId: exerciceId),
                ),
              );
            },
            child: _ExerciseListItem( // L'erreur de portée est maintenant résolue
              data: item,
            ),
          ),
        );
      },
    );
  }
  
  String _getDifficultyLevel(int niveau) {
    switch (niveau) {
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
}

// -------------------------------------------------------------------
// --- COMPOSANTS AJOUTÉS (pour résoudre l'erreur de portée) ---
// -------------------------------------------------------------------

// --- COMPOSANT DE LA BALISE DE DIFFICULTÉ ---
class _DifficultyTag extends StatelessWidget {
  final String level;
  final Color color;

  const _DifficultyTag({required this.level, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        level,
        style: const TextStyle(
          color: _colorBlack,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
      ),
    );
  }
}

// --- COMPOSANT DE L'ÉLÉMENT DE LISTE D'EXERCICE ---
class _ExerciseListItem extends StatelessWidget {
  final ExerciseData data;

  const _ExerciseListItem({required this.data});

  Color _getLevelTagColor(String level) {
    switch (level) {
      case 'Facile':
        return _colorEasyTag;
      case 'Moyen':
        return _colorMediumTag;
      case 'Difficile':
        return _colorHardTag;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getProgressColor(String level) {
    switch (level) {
      case 'Facile':
        return _colorProgressEasy;
      case 'Moyen':
        return _colorProgressMedium;
      case 'Difficile':
        return _colorProgressHard;
      default:
        return _colorProgressMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color levelTagColor = _getLevelTagColor(data.level);
    final Color progressColor = _getProgressColor(data.level);
    final bool isCompleted = data.progress >= 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et icône de validation / Progression
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: _colorBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
              if (!isCompleted)
                SizedBox(
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(
                      value: data.progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      minHeight: 5,
                    ),
                  ),
                ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: _colorCheck, size: 24),
            ],
          ),
          const SizedBox(height: 5),

          // Sous-titre de l'exercice
          Text(
            data.subtitle,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 15,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 10),

          // Niveau + nombre de questions
          Row(
            children: [
              _DifficultyTag(level: data.level, color: levelTagColor),
              const SizedBox(width: 8),
              const Icon(Icons.circle, size: 5, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                '${data.questions} questions',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: _fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}