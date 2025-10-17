import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorGreen = Color(0xFF32C832); // Vert pour complété
const Color _colorOrange = Color(0xFFFF9800); // Orange pour un nouveau quiz
const String _fontFamily = 'Roboto'; // Police principale

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // La barre de navigation inférieure est fixe
      bottomNavigationBar: _buildBottomNavBar(),

      body: Column(
        children: [
          // 1. App Bar personnalisé (avec barre de statut et titre)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 3. Section Quiz disponibles
                  _buildAvailableQuizzesSection(),
                  
                  const SizedBox(height: 30),
                  
                  // 4. Section Historique des exercices
                  _buildExerciseHistorySection(),
                  
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

            // Titre de la page
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Exercices & Quiz',
                      style: TextStyle(
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

  Widget _buildAvailableQuizzesSection() {
    const List<Map<String, dynamic>> availableQuizzes = [
      {'title': 'Quiz sur les nombres premiers', 'duration': '10 min', 'questions': 15, 'level': 'Primaire', 'isNew': true},
      {'title': 'Conjugaison des verbes du 3e groupe', 'duration': '5 min', 'questions': 10, 'level': 'Secondaire', 'isNew': false},
      {'title': 'Quiz : L\'histoire du Mali', 'duration': '15 min', 'questions': 20, 'level': 'Secondaire', 'isNew': true},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz à Faire',
          style: TextStyle(
            color: _colorBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 15),
        
        ...availableQuizzes.map((quiz) => Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _QuizCard(
            title: quiz['title']!,
            duration: quiz['duration']!,
            questions: quiz['questions']!,
            level: quiz['level']!,
            isNew: quiz['isNew']!,
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildExerciseHistorySection() {
    const List<Map<String, dynamic>> history = [
      {'title': 'Quiz sur le livre Harry Potter', 'date': 'Il y a 2 jours', 'score': '15/20', 'isSuccess': true},
      {'title': 'Quiz de Mathématiques Basiques', 'date': 'Il y a 4 jours', 'score': '7/20', 'isSuccess': false},
      {'title': 'Quiz d\'Histoire Générale', 'date': 'Il y a 1 semaine', 'score': '18/20', 'isSuccess': true},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historique des Exercices',
          style: TextStyle(
            color: _colorBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 15),

        ...history.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: _HistoryItem(
            title: item['title']!,
            date: item['date']!,
            score: item['score']!,
            isSuccess: item['isSuccess']!,
          ),
        )).toList(),
      ],
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

class _QuizCard extends StatelessWidget {
  final String title;
  final String duration;
  final int questions;
  final String level;
  final bool isNew;

  const _QuizCard({
    required this.title,
    required this.duration,
    required this.questions,
    required this.level,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône et indicateur 'Nouveau'
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _purpleMain.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.question_answer, color: _purpleMain),
              ),
              if (isNew)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Nouveau',
                    style: TextStyle(color: _colorOrange, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 15),

          // Détails du Quiz
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 4),
                Text(
                  '$questions questions • $duration • $level',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
          
          // Bouton Démarrer
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _purpleMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            ),
            child: const Text(
              'Démarrer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String score;
  final bool isSuccess;

  const _HistoryItem({
    required this.title,
    required this.date,
    required this.score,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        children: [
          // Icône de statut
          Icon(
            isSuccess ? Icons.check_circle : Icons.cancel,
            color: isSuccess ? _colorGreen : Colors.red,
            size: 24,
          ),
          const SizedBox(width: 15),

          // Détails de l'exercice
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: _fontFamily,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
          
          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isSuccess ? _colorGreen.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score,
              style: TextStyle(
                color: isSuccess ? _colorGreen : Colors.red,
                fontWeight: FontWeight.bold,
              ),
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