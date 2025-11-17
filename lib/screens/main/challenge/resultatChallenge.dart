import 'package:flutter/material.dart';
import 'package:edugo/screens/main/challenge/classement.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _colorWhite = Color(0xFFFFFFFF);
const Color _colorBackground = Color(0xFFF8F9FA);
const Color _colorScoreBackground = Color(0xFFFFF7E3);
const Color _colorTimeBackground = Color(0xFFF0F8FF);
const Color _colorCorrectBackground = Color(0xFFE8F5E9);
const Color _colorIncorrectBackground = Color(0xFFFBE4E4);
const Color _colorSuccess = Color(0xFF32C832);
const Color _colorFailure = Color(0xFFFF4500);
const Color _colorOrange = Color(0xFFFF9800);
const Color _colorGold = Color(0xFFFFD700);
const String _fontFamily = 'Roboto';

class ChallengeResultScreen extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final String timeTaken;
  final double scorePercentage;

  final List<ReviewQuestion> reviewItems = [
    ReviewQuestion(
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswer: 'Votre Réponse : 5',
      correctAnswer: 'Bonne Réponse : 5',
      isCorrect: true,
    ),
    ReviewQuestion(
      questionText: 'La somme de 10 et 5 font 15 ?',
      userAnswer: 'Votre Réponse : 12',
      correctAnswer: 'Bonne Réponse : 15',
      isCorrect: false,
    ),
    ReviewQuestion(
      questionText: 'La somme de 6 et 4 font 10 ?',
      userAnswer: 'Votre Réponse : 10',
      correctAnswer: 'Bonne Réponse : 10',
      isCorrect: true,
    ),
  ];

  ChallengeResultScreen({
    super.key,
    this.score = 150,
    this.correctAnswers = 8,
    this.totalQuestions = 10,
    this.timeTaken = '5m 32s',
    this.scorePercentage = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorBackground,
      body: Column(
        children: [
          // Header avec le score principal
          _buildHeaderSection(),

          // Contenu principal avec défilement
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  // Résumé de performance
                  _buildPerformanceSummary(),
                  const SizedBox(height: 25),

                  // Bouton classement
                  _buildViewLeaderboardButton(context),
                  const SizedBox(height: 25),

                  // Liste des révisions
                  _buildReviewSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_purpleMain.withOpacity(0.9), _purpleMain],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Félicitations !',
            style: TextStyle(
              color: _colorWhite,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Vous avez terminé le challenge',
            style: TextStyle(
              color: _colorWhite.withOpacity(0.9),
              fontSize: 16,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: _colorWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'SCORE FINAL',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$score Points',
                  style: const TextStyle(
                    color: _purpleMain,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _colorWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Résumé de Performance',
            style: TextStyle(
              color: _colorBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 15),

          // Barre de progression
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: scorePercentage,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      scorePercentage >= 0.7 ? _colorSuccess :
                      scorePercentage >= 0.5 ? _colorOrange : _colorFailure
                    ),
                    minHeight: 12,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                '${(scorePercentage * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _colorBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Cartes de statistiques
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.emoji_events,
                  color: _colorScoreBackground,
                  text: '$score\nScore',
                  iconColor: _colorGold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.check_circle,
                  color: _colorCorrectBackground,
                  text: '$correctAnswers/$totalQuestions\nBonnes réponses',
                  iconColor: _colorSuccess,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.timer,
                  color: _colorTimeBackground,
                  text: '$timeTaken\nTemps',
                  iconColor: _purpleMain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewLeaderboardButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => ChallengeRankingScreen(hasBadge: true)),
         );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorOrange,
          foregroundColor: _colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 3,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard, size: 20),
            SizedBox(width: 8),
            Text(
              'Voir Classement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détail des Réponses',
          style: TextStyle(
            color: _colorBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 15),
        ...reviewItems.asMap().entries.map((entry) {
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
      ],
    );
  }
}

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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.3,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: itemColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _colorWhite, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question $questionNumber',
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.questionText,
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.userAnswer,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: _colorSuccess.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _colorSuccess.withOpacity(0.3)),
            ),
            child: Text(
              item.correctAnswer,
              style: const TextStyle(
                color: _colorSuccess,
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