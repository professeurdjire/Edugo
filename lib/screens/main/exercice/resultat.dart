import 'package:flutter/material.dart';
// Importe ExerciseMatiereListScreen (pour le bouton "Terminer")
import 'package:edugo/screens/main/exercice/exercice2.dart';
// Importe la classe Question du QuizScreen (exercice3.dart)
import 'package:edugo/screens/main/exercice/exercice3.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleAppbar = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _shadowColor = Color(0xFFEEEEEE);
const Color _colorCheck = Color(0xFF32C832);
const Color _colorError = Color(0xFFE57373);
const Color _colorValidBackground = Color(0xFFE8F5E9);
const Color _colorInvalidBackground = Color(0xFFFBE8E8);
const Color _colorScoreBackground = Color(0xFFECEFF1);
const Color _colorScoreText = Color(0xFF5A4493);
const String _fontFamily = 'Roboto';

// La classe Question est maintenant importée depuis exercice3.dart


class ResultatScreen extends StatelessWidget {
  // Propriétés pour recevoir les données réelles du quiz
  final int totalQuestions;
  final int answeredCorrectly;
  final int pointsGained;
  final List<Question> results; // Le type Question est maintenant unique

  const ResultatScreen({
    super.key,
    required this.totalQuestions,
    required this.answeredCorrectly,
    required this.pointsGained,
    required this.results,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: _buildCustomAppBar(context),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // 1. Carte de Résumé des Scores
            _ScoreSummaryCard(
              answered: answeredCorrectly,
              total: totalQuestions,
              points: pointsGained,
            ),
            const SizedBox(height: 20),

            // 2. Détails des Questions
            ...results.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;

              final String? userAnswerText = question.selectedOptionIndex != null
                  ? question.options[question.selectedOptionIndex!]
                  : null;

              final String correctAnswerText = question.options[question.correctAnswerIndex];

              final bool isCorrect = question.selectedOptionIndex == question.correctAnswerIndex;


              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _QuestionDetail(
                  index: index + 1,
                  questionText: question.text,
                  userAnswer: userAnswerText,
                  correctAnswer: correctAnswerText,
                  isCorrect: isCorrect,
                ),
              );
            }).toList(),

            // 3. Bouton Terminer
            _buildEndButton(context),
            const SizedBox(height: 40),
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: _colorBlack),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Résultats',
                        style: TextStyle(
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

  // --- WIDGET BOUTON TERMINER ---
  Widget _buildEndButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Retourne à la Liste des Exercices (enlève ResultatScreen et QuizScreen)
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ >= 2;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _purpleAppbar,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(
        'Terminer',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- COMPOSANTS ---
// -------------------------------------------------------------------

// --- 1. CARTE DE RÉSUMÉ DES SCORES ---
class _ScoreSummaryCard extends StatelessWidget {
  final int answered;
  final int total;
  final int points;

  const _ScoreSummaryCard({required this.answered, required this.total, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _colorScoreBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ScoreItem(
            // Affiche le score correct / total des questions
            value: '$answered/$total',
            label: 'Répondu',
            color: _colorBlack,
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300), // Séparateur
          _ScoreItem(
            value: '$points pts',
            label: 'Points gagnés',
            color: _colorScoreText, // Texte violet
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _ScoreItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}

// --- 2. DÉTAIL D'UNE QUESTION (Mis à jour pour utiliser les chaînes directement) ---
class _QuestionDetail extends StatelessWidget {
  final int index;
  final String questionText;
  final String? userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  const _QuestionDetail({
    required this.index,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texte de la question
        Text(
          'Question $index : $questionText',
          style: const TextStyle(
            color: _colorBlack,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 10),

        // Carte : Réponse de l'utilisateur (si incorrecte OU non répondue)
        if (!isCorrect && userAnswer != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _AnswerCard(
              text: 'Votre réponse : $userAnswer',
              isCorrect: false,
            ),
          )
        else if (userAnswer == null)
           const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: _AnswerCard(
              text: 'Vous n\'avez pas répondu à cette question',
              isCorrect: false, // Affiché en rouge pour marquer comme non complété
            ),
          ),


        // Carte : Bonne Réponse
        _AnswerCard(
          text: 'Bonne réponse : $correctAnswer',
          isCorrect: true,
        ),
      ],
    );
  }
}

// --- 3. CARTE DE RÉPONSE (Verte ou Rouge) ---
class _AnswerCard extends StatelessWidget {
  final String text;
  final bool isCorrect;

  const _AnswerCard({required this.text, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isCorrect ? _colorValidBackground : _colorInvalidBackground;
    final iconColor = isCorrect ? _colorCheck : _colorError;
    final icon = isCorrect ? Icons.check : Icons.close;
    final textColor = isCorrect ? _colorCheck : _colorError;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(icon, color: iconColor),
        ],
      ),
    );
  }
}