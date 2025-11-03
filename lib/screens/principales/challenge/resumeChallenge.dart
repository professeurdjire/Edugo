import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/challenge/resultatChallenge.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _colorYellow = Color(0xFFE8981A);
const Color _colorInactiveOption = Color(0xFFF2F2F2);
const String _fontFamily = 'Roboto';

// --- Modèle pour une question ---
class ChallengeQuestion {
  final int id;
  final String questionText;
  final String? userAnswerText;
  final Map<String, String>? matchingAnswers;

  ChallengeQuestion({
    required this.id,
    required this.questionText,
    this.userAnswerText,
    this.matchingAnswers,
  });
}

// --- Écran principal ---
class ChallengeSummaryScreen extends StatelessWidget {
  ChallengeSummaryScreen({super.key});

  // Données de questions simulées
  final List<ChallengeQuestion> _questions = [
    ChallengeQuestion(
      id: 1,
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswerText: 'Réponses : 4',
    ),
    ChallengeQuestion(
      id: 2,
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswerText: 'Réponses : 4',
    ),
    ChallengeQuestion(
      id: 3,
      questionText: 'Correspondre les pays avec leurs capitales',
      matchingAnswers: {
        'France': 'Paris',
        'Mali': 'Ouagadougou',
        'Burkina': 'Bamako',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Contenu principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Titre principal
                  const Center(
                    child: Text(
                      'Résumé du Challenge',
                      style: TextStyle(
                        color: _colorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Liste des questions
                  ..._questions.map((q) => Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: _ChallengeSummaryItem(question: q),
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text(
                        '...................',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bouton Soumettre
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  // --- Bouton Soumettre ---
  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChallengeResultScreen()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Challenge Soumis !')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _purpleMain,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          child: const Text(
            'Soumettre',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET DE CHAQUE QUESTION DU RÉSUMÉ ---
// -------------------------------------------------------------------

class _ChallengeSummaryItem extends StatelessWidget {
  final ChallengeQuestion question;

  const _ChallengeSummaryItem({required this.question});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre + numéro
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: _colorYellow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    question.id.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.questionText,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          if (question.userAnswerText != null)
            _buildSimpleAnswer(question.userAnswerText!),

          if (question.matchingAnswers != null)
            _buildMatchingAnswers(question.matchingAnswers!),
        ],
      ),
    );
  }

  Widget _buildSimpleAnswer(String answerText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: _purpleMain.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        answerText,
        style: const TextStyle(
          color: _purpleMain,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMatchingAnswers(Map<String, String> answers) {
    return Column(
      children: answers.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: _purpleMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                          color: _purpleMain, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: _purpleMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                          color: _purpleMain, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
