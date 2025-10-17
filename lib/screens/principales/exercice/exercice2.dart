import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorEasy = Color(0xFFC0D99D);  // Vert clair pour Facile
const Color _colorMedium = Color(0xFFB1A0D6); // Violet moyen pour Moyen
const Color _colorHard = Color(0xFFD6A0A0);  // Rouge clair pour Difficile
const Color _colorProgress = Color(0xFF5A4493); // Couleur foncée pour la progression
const Color _colorCheck = Color(0xFF32C832);  // Vert pour icône de validation
const String _fontFamily = 'Roboto'; // Police principale

class ExerciseMatiereListScreen extends StatelessWidget {
  final String matiere;

  // Le constructeur prend la matière en paramètre, ex: ExerciseMatiereListScreen(matiere: 'Mathématiques')
  const ExerciseMatiereListScreen({super.key, required this.matiere});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // La barre de navigation inférieure est fixe
      bottomNavigationBar: _buildBottomNavBar(),

      body: Column(
        children: [
          // 1. App Bar personnalisé (avec barre de statut et titre dynamique)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // 3. Liste des Exercices
                  _buildExerciseList(),
                  
                  const SizedBox(height: 80), // Espace final pour la barre de navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            // Barre de Statut (simulée)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20 : 20', style: TextStyle(color: _colorBlack, fontSize: 15, fontWeight: FontWeight.w700)),
                Icon(Icons.circle, color: _colorBlack, size: 10),
                Row(
                  children: [
                    Icon(Icons.wifi, color: _colorBlack, size: 20),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, color: _colorBlack, size: 20),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Titre de la page (dynamique)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      matiere, // Affiche "Mathématiques"
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), 
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    // Données d'exercices simulées (basées sur l'image)
    final List<Map<String, dynamic>> exercises = [
      {'title': 'Exercice 1', 'subtitle': 'Algèbre de base', 'questions': 10, 'level': 'Facile', 'progress': 1.0}, // Terminé
      {'title': 'Exercice 2', 'subtitle': 'Géométrie des triangles', 'questions': 16, 'level': 'Moyen', 'progress': 0.75},
      {'title': 'Exercice 3', 'subtitle': 'Calcul mentale et fractions', 'questions': 12, 'level': 'Difficile', 'progress': 0.20},
      {'title': 'Exercice 4', 'subtitle': 'Problèmes de logique', 'questions': 13, 'level': 'Facile', 'progress': 0.0},
      {'title': 'Exercice 5', 'subtitle': 'Introduction aux équations', 'questions': 12, 'level': 'Moyen', 'progress': 0.60},
      {'title': 'Exercice 6', 'subtitle': 'Introduction aux équations', 'questions': 15, 'level': 'Difficile', 'progress': 0.0},
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final item = exercises[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _ExerciseListItem(
            title: item['title']!,
            subtitle: item['subtitle']!,
            questions: item['questions']!,
            level: item['level']!,
            progress: item['progress']!,
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    // Le code du BottomNavigationBar
    return Container(
      height: 70, 
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(icon: Icons.home, label: 'Accueil'),
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque'),
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge'),
          _NavBarItem(icon: Icons.checklist, label: 'Exercice', isSelected: true), // Exercice est actif
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
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
  final String title;
  final String subtitle;
  final int questions;
  final String level;
  final double progress; // 0.0 à 1.0

  const _ExerciseListItem({
    required this.title,
    required this.subtitle,
    required this.questions,
    required this.level,
    required this.progress,
  });

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Facile':
        return _colorEasy;
      case 'Moyen':
        return _colorMedium;
      case 'Difficile':
        return _colorHard;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color levelColor = _getLevelColor(level);
    final bool isCompleted = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _colorBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: _colorCheck, size: 24),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              _DifficultyTag(level: level, color: levelColor),
              const SizedBox(width: 8),
              const Icon(Icons.circle, size: 5, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                '$questions questions',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: _fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_colorProgress),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavBarItem({required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? _purpleMain : _colorBlack,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? _purpleMain : _colorBlack,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}