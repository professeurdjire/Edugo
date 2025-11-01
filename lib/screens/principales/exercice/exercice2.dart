import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFF673AB7); // Un violet plus foncé pour l'AppBar et le fond
const Color _purpleAppbar = Color(0xFFA885D8); // Le violet clair de l'AppBar
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorEasyTag = Color(0xFFC0D99D); // Vert clair pour Facile
const Color _colorMediumTag = Color(0xFFB1A0D6); // Violet moyen pour Moyen
const Color _colorHardTag = Color(0xFFD6A0A0); // Rouge clair pour Difficile
const Color _colorProgressEasy = Color(0xFF8DC63F); // Progression Facile (vert clair)
const Color _colorProgressMedium = Color(0xFF5D3BA5); // Progression Moyen (violet foncé)
const Color _colorProgressHard = Color(0xFFE4712F); // Progression Difficile (orange)
const Color _colorCheck = Color(0xFF32C832); // Vert pour icône de validation
const String _fontFamily = 'Roboto'; // Police principale
const Color _shadowColor = Color(0xFFEEEEEE); // Couleur de l'ombre de la carte

// --- STRUCTURE DE DONNÉES ---
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

class ExerciseMatiereListScreen extends StatelessWidget {
  final String matiere;

  const ExerciseMatiereListScreen({super.key, required this.matiere});

  @override
  Widget build(BuildContext context) {
    // Changement : Utilisation d'un Container pour le dégradé de couleur en haut
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // AppBar personnalisée
          _buildCustomAppBar(context),

          // Corps principal
          Expanded(
            child: SingleChildScrollView(
              // Suppression du padding horizontal ici, il est dans l'item
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  // Liste des exercices
                  _buildExerciseList(context),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET APPBAR PERSONNALISÉE (Mise à jour) ---
  Widget _buildCustomAppBar(BuildContext context) {
    // Changement : Couleur de fond pour correspondre à l'image (violet)
    return Container(
      color: Colors.white, // Couleur de fond de l'AppBar
      child: SafeArea(
        bottom: false, // Laissez l'ombre se répandre en bas
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 0, right: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  // Icône de retour (changement de couleur en blanc)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Changement : Centrer le texte et le mettre en blanc
                  Expanded(
                    child: Center(
                      child: Text(
                        matiere,
                        style: const TextStyle(
                          color: Colors.white, // Couleur blanche pour le texte
                          fontSize: 24, // Taille légèrement plus grande
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Pour aligner le titre au centre
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- LISTE DES EXERCICES (Mise à jour avec la nouvelle structure) ---
  Widget _buildExerciseList(BuildContext context) {
    final List<ExerciseData> exercises = [
      ExerciseData(title: 'Exercice 1', subtitle: 'Algèbre de base', questions: 10, level: 'Facile', progress: 1.0),
      ExerciseData(title: 'Exercice 2', subtitle: 'Géométrie des triangles', questions: 16, level: 'Moyen', progress: 0.75),
      ExerciseData(title: 'Exercice 3', subtitle: 'Calcul mentale et fractions', questions: 12, level: 'Difficile', progress: 0.20),
      ExerciseData(title: 'Exercice 4', subtitle: 'Problèmes de logique', questions: 13, level: 'Facile', progress: 0.0),
      ExerciseData(title: 'Exercice 5', subtitle: 'Introduction aux équations', questions: 12, level: 'Moyen', progress: 0.60),
      ExerciseData(title: 'Exercice 6', subtitle: 'Introduction aux équations', questions: 15, level: 'Difficile', progress: 0.0), // Changement du sous-titre de l'exercice 6 pour correspondre à l'image
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final item = exercises[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0, left: 20, right: 20),
          child: InkWell(
            // La carte elle-même est le bouton, InkWell ajoute l'effet visuel au clic
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              // Action de navigation
            },
            child: _ExerciseListItem(
              data: item, // Passe l'objet de données complètes
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------------
// --- COMPOSANTS DE LISTE ---
// -------------------------------------------------------------------

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

  // Fonction pour obtenir la couleur de la barre de progression
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
        borderRadius: BorderRadius.circular(15), // Coins plus arrondis
        border: Border.all(color: Colors.grey.shade100, width: 1), // Léger contour
        boxShadow: [
          BoxShadow(
            color: _shadowColor, // Ombre très claire et subtile
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et icône de validation
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
              // Barre de progression à droite du titre (si non complété)
              if (!isCompleted)
                SizedBox(
                  width: 50, // Longueur de la barre de progression
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
              // Icône de validation (si complété)
              if (isCompleted)
                const Icon(Icons.check_circle, color: _colorCheck, size: 24),
            ],
          ),
          const SizedBox(height: 5),

          // Sous-titre de l'exercice (Algèbre de base)
          Text(
            data.subtitle,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 15, // Plus grand que l'original
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