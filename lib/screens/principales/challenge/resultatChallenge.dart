import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/challenge/classement.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _colorScoreBackground = Color(0xFFFFF7E3);
const Color _colorTimeBackground = Color(0xFFF0F8FF);
const Color _colorCorrectBackground = Color(0xFFE8F5E9);
const Color _colorIncorrectBackground = Color(0xFFFBE4E4);
const Color _colorSuccess = Color(0xFF32C832);
const Color _colorFailure = Color(0xFFFF4500);
const Color _colorOrange = Color(0xFFFF9800);
const String _fontFamily = 'Roboto';

// --- Modèle pour une question ---
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

// --- Écran principal des résultats ---
class ChallengeResultScreen extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final String timeTaken;
  final double scorePercentage;

  // Correction simulée
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildPerformanceSummary(),
                  const SizedBox(height: 25),
                  _buildViewLeaderboardButton(context),
                  const SizedBox(height: 25),
                  _buildReviewList(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: scorePercentage,
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
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExerciseScreen()),
                    );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Affichage du classement (simulé)')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
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
}

// -------------------------------------------------------------------
// --- WIDGETS INDÉPENDANTS (déplacés hors de la classe) ---
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
      width: MediaQuery.of(context).size.width / 3.8,
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
    final Color itemColor =
        item.isCorrect ? _colorCorrectBackground : _colorIncorrectBackground;
    final IconData icon =
        item.isCorrect ? Icons.check_circle : Icons.cancel;
    final Color iconColor =
        item.isCorrect ? _colorSuccess : _colorFailure;

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
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question $questionNumber : ${item.questionText}',
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
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
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
