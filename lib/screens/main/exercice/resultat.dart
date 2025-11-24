import 'package:flutter/material.dart';
// Importe ExerciseMatiereListScreen (pour le bouton "Terminer")
import 'package:edugo/screens/main/exercice/exercice2.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_possible.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000);
const Color _shadowColor = Color(0xFFEEEEEE);
const Color _colorCheck = Color(0xFF32C832);
const Color _colorError = Color(0xFFE57373);
const Color _colorValidBackground = Color(0xFFE8F5E9);
const Color _colorInvalidBackground = Color(0xFFFBE8E8);
const Color _colorScoreBackground = Color(0xFFECEFF1);
const Color _colorScoreText = Color(0xFF5A4493);
const String _fontFamily = 'Roboto';

class ResultatScreen extends StatefulWidget {
  final SubmitResultResponse? result;
  final List<Question>? questions;
  final Map<int, dynamic>? selectedAnswers;
  final int? eleveId; // Pour rafraîchir les points
  
  // Propriétés de compatibilité pour l'ancien format
  final int? totalQuestions;
  final int? answeredCorrectly;
  final int? pointsGained;
  final dynamic results; // Peut être null maintenant

  const ResultatScreen({
    super.key,
    this.result,
    this.questions,
    this.selectedAnswers,
    this.eleveId,
    // Ancien format (pour compatibilité)
    this.totalQuestions,
    this.answeredCorrectly,
    this.pointsGained,
    this.results,
  });

  @override
  State<ResultatScreen> createState() => _ResultatScreenState();
}

class _ResultatScreenState extends State<ResultatScreen> {
  final EleveService _eleveService = EleveService();
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  
  @override
  void initState() {
    super.initState();
    // Recharger les points après avoir affiché le résultat
    _refreshPoints();
  }
  
  Future<void> _refreshPoints() async {
    final eleveId = widget.eleveId ?? _authService.currentUserId;
    if (eleveId != null) {
      try {
        final points = await _eleveService.getElevePoints(eleveId);
        // Mettre à jour le profil dans AuthService
        final eleve = await _eleveService.getEleveProfile(eleveId);
        if (eleve != null) {
          _authService.setCurrentEleve(eleve);
        }
      } catch (e) {
        print('Error refreshing points: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Utiliser le nouveau format si disponible, sinon l'ancien
    final result = widget.result;
    final questions = widget.questions;
    final selectedAnswers = widget.selectedAnswers;
    
    final int totalQuestions = result?.details.length ?? widget.totalQuestions ?? 0;
    final int answeredCorrectly = result?.details.where((d) => d.correct == true).length ?? widget.answeredCorrectly ?? 0;
    final int pointsGained = result?.score ?? widget.pointsGained ?? 0;
    
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: _buildCustomAppBar(context, primaryColor),
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
            if (result != null && questions != null && selectedAnswers != null)
              ...result.details.asMap().entries.map((entry) {
                final index = entry.key;
                final detail = entry.value;
                
                // Trouver la question correspondante
                final question = questions.firstWhere(
                  (q) => q.id == detail.questionId,
                  orElse: () => Question((b) => b..id = detail.questionId),
                );
                final selectedAnswer = selectedAnswers[detail.questionId];
                
                // Trouver les bonnes réponses
                final correctAnswers = question.reponsesPossibles
                    ?.where((r) => r.estCorrecte == true)
                    .toList() ?? [];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _QuestionDetailNew(
                    index: index + 1,
                    question: question,
                    selectedAnswer: selectedAnswer,
                    correctAnswers: correctAnswers,
                    isCorrect: detail.correct,
                    points: detail.points,
                  ),
                );
              }).toList()
            else if (widget.results != null && widget.results is List && widget.results.isNotEmpty)
              // Ancien format (pour compatibilité)
              ...widget.results.asMap().entries.map((entry) {
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
      },
    );
  }

  // --- WIDGET APPBAR PERSONNALISÉE ---
  Widget _buildCustomAppBar(BuildContext context, Color primaryColor) {
    return Container(
      color: primaryColor,
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
                    icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
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
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return ElevatedButton(
          onPressed: () {
            // Retourne à la Liste des Exercices (enlève ResultatScreen et QuizScreen)
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ >= 2;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
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
      },
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

// --- 2. DÉTAIL D'UNE QUESTION (Nouveau format avec SubmitResultResponse) ---
class _QuestionDetailNew extends StatelessWidget {
  final int index;
  final Question question;
  final dynamic selectedAnswer;
  final List<ReponsePossible> correctAnswers;
  final bool isCorrect;
  final int points;

  const _QuestionDetailNew({
    required this.index,
    required this.question,
    required this.selectedAnswer,
    required this.correctAnswers,
    required this.isCorrect,
    required this.points,
  });
  
  String _formatAnswer(dynamic answer) {
    if (answer == null) return 'Aucune réponse';
    
    if (answer is List<int>) {
      // QCM: afficher les libellés des réponses sélectionnées
      if (question.reponsesPossibles != null) {
        final selectedLabels = answer.map((id) {
          final reponse = question.reponsesPossibles!.firstWhere(
            (r) => r.id == id,
            orElse: () => ReponsePossible((b) => b..id = id),
          );
          return reponse.libelleReponse ?? 'Réponse $id';
        }).join(', ');
        return selectedLabels;
      }
      return answer.join(', ');
    } else if (answer is int) {
      // QCU/VRAI_FAUX: afficher le libellé de la réponse sélectionnée
      if (question.reponsesPossibles != null) {
        final reponse = question.reponsesPossibles!.firstWhere(
          (r) => r.id == answer,
          orElse: () => ReponsePossible((b) => b..id = answer),
        );
        return reponse.libelleReponse ?? 'Réponse $answer';
      }
      return 'Réponse $answer';
    } else if (answer is String) {
      return answer;
    } else if (answer is Map<int, int>) {
      // Appariement: afficher les correspondances
      return answer.entries.map((e) => '${e.key} → ${e.value}').join(', ');
    }
    
    return answer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec icône et points
        Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? _colorCheck : _colorError,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Question $index : ${question.enonce ?? "Sans énoncé"}',
                style: const TextStyle(
                  color: _colorBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCorrect ? _colorCheck.withOpacity(0.1) : _colorError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$points pts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? _colorCheck : _colorError,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Réponse de l'élève
        if (selectedAnswer != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _AnswerCard(
              text: 'Votre réponse : ${_formatAnswer(selectedAnswer)}',
              isCorrect: false,
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: _AnswerCard(
              text: 'Vous n\'avez pas répondu à cette question',
              isCorrect: false,
            ),
          ),

        // Bonnes réponses (si la question est ratée)
        if (!isCorrect && correctAnswers.isNotEmpty)
          _AnswerCard(
            text: 'Bonne réponse : ${correctAnswers.map((r) => r.libelleReponse ?? '').join(', ')}',
            isCorrect: true,
          ),
      ],
    );
  }
}

// --- 2. DÉTAIL D'UNE QUESTION (Ancien format pour compatibilité) ---
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