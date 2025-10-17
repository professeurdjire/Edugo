import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active/bouton)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorScoreBackground = Color(0xFFFFF7E3); // Fond Jaune clair pour le score (comme un badge)
const Color _colorTimeBackground = Color(0xFFF0F8FF); // Fond Bleu clair pour le temps
const Color _colorCorrectBackground = Color(0xFFE8F5E9); // Fond Vert clair pour les bonnes
const Color _colorIncorrectBackground = Color(0xFFFBE4E4); // Fond Rouge clair pour les mauvaises
const Color _colorSuccess = Color(0xFF32C832); // Vert pour la validation
const Color _colorFailure = Color(0xFFFF4500); // Rouge pour la croix
const Color _colorOrange = Color(0xFFFF9800); // Orange pour la barre de score
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une question dans la correction
class ReviewQuestion {
  final String questionText;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  ReviewQuestion({
    required this.questionText, 
    required this.userAnswer, 
    required this.correctAnswer, 
    required this.isCorrect,
  });
}

class ChallengeResultScreen extends StatelessWidget {
  // Données de performance simulées basées sur l'image
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final String timeTaken;
  final double scorePercentage;

  // Correction des questions simulée
  final List<ReviewQuestion> reviewItems = [
    ReviewQuestion(
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswer: 'Votre Reponse : 5',
      correctAnswer: 'Bonne Réponse : 5',
      isCorrect: true,
    ),
    ReviewQuestion(
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswer: 'Votre Reponse : 5',
      correctAnswer: 'Bonne Réponse : 5',
      isCorrect: false,
    ),
    ReviewQuestion(
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswer: 'Votre Reponse : 5',
      correctAnswer: 'Bonne Réponse : 5',
      isCorrect: true,
    ),
  ];

  ChallengeResultScreen({
    super.key, 
    this.score = 150, 
    this.correctAnswers = 8, 
    this.totalQuestions = 10,
    this.timeTaken = '5m 32s',
    this.scorePercentage = 0.8, // 80%
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // La barre de navigation inférieure est fixe
      bottomNavigationBar: _buildBottomNavBar(),

      body: Column(
        children: [
          // 1. App Bar personnalisé (avec barre de statut)
          _buildCustomAppBar(),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 3. Résumé de la performance
                  _buildPerformanceSummary(),
                  
                  const SizedBox(height: 25),
                  
                  // 4. Bouton Voir Classement
                  _buildViewLeaderboardButton(context),
                  
                  const SizedBox(height: 25),

                  // 5. Correction détaillée des questions
                  _buildReviewList(),

                  const SizedBox(height: 80), // Espace final
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar() {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 10),
        child: Column(
          children: [
            // Barre de Statut (simulée)
            Row(
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
            
            // Pas de flèche de retour ou de titre spécifique visible dans l'image
            SizedBox(height: 10), 
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        const Center(
          child: Text(
            'Résumé de votre Performance',
            style: TextStyle(
              color: _colorOrange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
        ),
        const SizedBox(height: 10),
        
        // Barre de Score (Progression)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: scorePercentage, // 0.8 pour 80%
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(_colorOrange),
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${(scorePercentage * 100).toInt()}%',
              style: const TextStyle(
                color: _colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),

        // 3 Cartes d'Information
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryCard(
              icon: Icons.star,
              color: _colorScoreBackground,
              text: '$score Score',
              iconColor: _colorOrange,
            ),
            _SummaryCard(
              icon: Icons.check_circle_outline,
              color: _colorCorrectBackground,
              text: '$correctAnswers/$totalQuestions Bonnes',
              iconColor: _colorSuccess,
            ),
            _SummaryCard(
              icon: Icons.access_time,
              color: _colorTimeBackground,
              text: '$timeTaken temps',
              iconColor: _purpleMain,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewLeaderboardButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Naviguer vers la page de classement (image_ec7abb.png)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Affichage du classement (simulé)')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber, // Jaune (couleur du bouton dans l'image)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, color: _colorBlack),
            SizedBox(width: 8),
            Text(
              'Voir Classement',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    return Column(
      children: reviewItems.asMap().entries.map((entry) {
        int index = entry.key;
        ReviewQuestion item = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _QuestionReviewItem(
            questionNumber: index + 1,
            item: item,
          ),
        );
      }).toList(),
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
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge', isSelected: true), // Challenge est actif
          _NavBarItem(icon: Icons.checklist, label: 'Exercice'),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final Color iconColor;

  const _SummaryCard({
    required this.icon,
    required this.color,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.8, // Taille relative
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionReviewItem extends StatelessWidget {
  final int questionNumber;
  final ReviewQuestion item;

  const _QuestionReviewItem({
    required this.questionNumber,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = item.isCorrect ? _colorCorrectBackground : _colorIncorrectBackground;
    final IconData icon = item.isCorrect ? Icons.check_circle : Icons.cancel;
    final Color iconColor = item.isCorrect ? _colorSuccess : _colorFailure;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: itemColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône de validation/erreur
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Texte de la question
                    Text(
                      'Question $questionNumber : ${item.questionText}',
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Réponse de l'utilisateur
                    Text(
                      item.userAnswer,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10),
          
          // Bonne Réponse (toujours affichée dans la correction)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _colorSuccess,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.correctAnswer,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
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