import 'package:flutter/material.dart';
import 'package:edugo/screens/main/bibliotheque/bibliotheque.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorSuccess = Color(0xFF32C832); // Vert pour la bonne réponse
const Color _colorError = Color(0xFFE74C3C); // Rouge pour les erreurs
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair pour les bords non sélectionnés
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une question de quiz
abstract class QuizQuestion {
  final String text;
  final String type; // 'multiple', 'true_false', 'matching'
  bool isAnswered;
  bool isCorrect;

  QuizQuestion({
    required this.text,
    required this.type,
    this.isAnswered = false,
    this.isCorrect = false,
  });

  void checkAnswer();
  void resetAnswer();
}

// Question à choix multiple
class MultipleChoiceQuestion extends QuizQuestion {
  final List<String> options;
  final String correctAnswer;
  int? selectedOptionIndex;

  MultipleChoiceQuestion({
    required String text,
    required this.options,
    required this.correctAnswer,
  }) : super(text: text, type: 'multiple');

  @override
  void checkAnswer() {
    if (selectedOptionIndex != null) {
      isCorrect = options[selectedOptionIndex!] == correctAnswer;
      isAnswered = true;
    }
  }

  @override
  void resetAnswer() {
    selectedOptionIndex = null;
    isAnswered = false;
    isCorrect = false;
  }
}

// Question Vrai/Faux
class TrueFalseQuestion extends QuizQuestion {
  final bool correctAnswer;
  bool? selectedAnswer;

  TrueFalseQuestion({
    required String text,
    required this.correctAnswer,
  }) : super(text: text, type: 'true_false');

  @override
  void checkAnswer() {
    if (selectedAnswer != null) {
      isCorrect = selectedAnswer == correctAnswer;
      isAnswered = true;
    }
  }

  @override
  void resetAnswer() {
    selectedAnswer = null;
    isAnswered = false;
    isCorrect = false;
  }
}

// Question d'appariement
class MatchingQuestion extends QuizQuestion {
  final List<String> leftItems;
  final List<String> rightItems;
  final Map<String, String> correctMatches; // leftItem -> rightItem
  Map<String, String?> userMatches;

  MatchingQuestion({
    required String text,
    required this.leftItems,
    required this.rightItems,
    required this.correctMatches,
  }) : userMatches = { for (var item in leftItems) item : null },
        super(text: text, type: 'matching');

  @override
  void checkAnswer() {
    bool allMatched = userMatches.values.every((match) => match != null);
    if (allMatched) {
      isCorrect = true;
      for (var leftItem in leftItems) {
        if (userMatches[leftItem] != correctMatches[leftItem]) {
          isCorrect = false;
          break;
        }
      }
      isAnswered = true;
    }
  }

  @override
  void resetAnswer() {
    userMatches = { for (var item in leftItems) item : null };
    isAnswered = false;
    isCorrect = false;
  }

  void setMatch(String leftItem, String rightItem) {
    userMatches[leftItem] = rightItem;
    // Vérifier si tous les éléments sont appariés
    bool allMatched = userMatches.values.every((match) => match != null);
    if (allMatched) {
      checkAnswer();
    }
  }

  void clearMatch(String leftItem) {
    userMatches[leftItem] = null;
    isAnswered = false;
    isCorrect = false;
  }
}

class BookQuizScreen extends StatefulWidget {
  final String quizTitle;

  const BookQuizScreen({super.key, this.quizTitle = 'Quiz'});

  @override
  State<BookQuizScreen> createState() => _BookQuizScreenState();
}

class _BookQuizScreenState extends State<BookQuizScreen> {
  // Liste des questions avec différents types
  final List<QuizQuestion> _allQuestions = [
    MultipleChoiceQuestion(
      text: "Qui est l'acteur principal de ce livre ?",
      options: ['Alfred', 'Albert', 'Guyard'],
      correctAnswer: 'Alfred',
    ),
    TrueFalseQuestion(
      text: "Ce livre est un récit ?",
      correctAnswer: true,
    ),
    MatchingQuestion(
      text: "Faites correspondre les pays à leurs capitales",
      leftItems: ['France', 'Japon', 'Mali'],
      rightItems: ['Paris', 'Tokyo', 'Bamako'],
      correctMatches: {
        'France': 'Paris',
        'Japon': 'Tokyo',
        'Mali': 'Bamako',
      },
    ),
    MultipleChoiceQuestion(
      text: "En quelle année l'histoire débute-t-elle ?",
      options: ['2007', '2021', '2010'],
      correctAnswer: '2021',
    ),
  ];

  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool _showResultsOverlay = false;

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _allQuestions[_currentQuestionIndex];
    final int totalQuestions = _allQuestions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Contenu principal du quiz
          Column(
            children: [
              // 1. App Bar personnalisé
              _buildCustomAppBar(context),

              // 2. Le corps de la page (Défilement)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // 3. Barre de Progression
                      _buildProgressionBar(totalQuestions),

                      const SizedBox(height: 20),

                      // 4. Contenu de la Question
                      _buildQuestionContent(currentQuestion),

                      const SizedBox(height: 30),

                    ],
                  ),
                ),
              ),

              // 5. Bouton Suivant
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: _buildNextButton(context, totalQuestions),
              ),
            ],
          ),

          // Overlay des résultats
          if (_showResultsOverlay)
            _buildResultsOverlay(),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Titre de la page
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.quizTitle,
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

  Widget _buildProgressionBar(int totalQuestions) {
    int answeredQuestions = _allQuestions.where((q) => q.isAnswered).length;
    double progressValue = answeredQuestions / totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // La barre de progression
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: _colorUnselected,
            valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$answeredQuestions/$totalQuestions questions répondues',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent(QuizQuestion currentQuestion) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          // Titre de la question
          Text(
            'Question ${_currentQuestionIndex + 1}/${_allQuestions.length}',
            style: const TextStyle(
              color: _purpleMain,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            currentQuestion.text,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 20),

          // Contenu spécifique selon le type de question
          if (currentQuestion is MultipleChoiceQuestion)
            _buildMultipleChoiceContent(currentQuestion)
          else if (currentQuestion is TrueFalseQuestion)
            _buildTrueFalseContent(currentQuestion)
          else if (currentQuestion is MatchingQuestion)
            _buildMatchingContent(currentQuestion),

          const SizedBox(height: 10),

          // Affichage de la correction (si répondu)
          if (currentQuestion.isAnswered)
            _buildAnswerFeedback(currentQuestion),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceContent(MultipleChoiceQuestion question) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        int optionIndex = entry.key;
        String optionText = entry.value;
        bool isSelected = question.selectedOptionIndex == optionIndex;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: _QuizOption(
            text: optionText,
            isSelected: isSelected,
            isAnswered: question.isAnswered,
            onTap: () {
              if (!question.isAnswered) {
                setState(() {
                  question.selectedOptionIndex = optionIndex;
                  question.checkAnswer();
                });
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalseContent(TrueFalseQuestion question) {
    return Row(
      children: [
        Expanded(
          child: _TrueFalseButton(
            text: 'Vrai',
            isSelected: question.selectedAnswer == true,
            isAnswered: question.isAnswered,
            onTap: () {
              if (!question.isAnswered) {
                setState(() {
                  question.selectedAnswer = true;
                  question.checkAnswer();
                });
              }
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _TrueFalseButton(
            text: 'Faux',
            isSelected: question.selectedAnswer == false,
            isAnswered: question.isAnswered,
            onTap: () {
              if (!question.isAnswered) {
                setState(() {
                  question.selectedAnswer = false;
                  question.checkAnswer();
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchingContent(MatchingQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ligne des éléments de gauche et leurs réponses sélectionnées
        Column(
          children: question.leftItems.asMap().entries.map((entry) {
            int index = entry.key;
            String leftItem = entry.value;
            String? selectedMatch = question.userMatches[leftItem];

            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: [
                  // Élément de gauche
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                        color: _purpleMain.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        leftItem,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Réponse sélectionnée (cliquable pour effacer)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (selectedMatch != null && !question.isAnswered) {
                          setState(() {
                            question.clearMatch(leftItem);
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedMatch != null ? _purpleMain : Colors.grey.shade300,
                            width: selectedMatch != null ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          selectedMatch ?? 'Sélectionnez',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedMatch != null ? _colorBlack : Colors.grey,
                            fontWeight: selectedMatch != null ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Options disponibles en bas
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: question.rightItems.map((rightItem) {
            bool isUsed = question.userMatches.values.contains(rightItem);

            return GestureDetector(
              onTap: isUsed ? null : () {
                // Trouver le premier slot vide
                for (String leftItem in question.leftItems) {
                  if (question.userMatches[leftItem] == null) {
                    setState(() {
                      question.setMatch(leftItem, rightItem);
                    });
                    break;
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: isUsed ? Colors.grey.shade200 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isUsed ? Colors.grey.shade400 : _purpleMain,
                    width: 1,
                  ),
                ),
                child: Text(
                  rightItem,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUsed ? Colors.grey : _colorBlack,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnswerFeedback(QuizQuestion question) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: question.isCorrect ? _colorSuccess.withOpacity(0.1) : _colorError.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: question.isCorrect ? _colorSuccess : _colorError,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            question.isCorrect ? Icons.check_circle : Icons.cancel,
            color: question.isCorrect ? _colorSuccess : _colorError,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.isCorrect ? 'Bonne réponse !' : 'Réponse incorrecte',
                  style: TextStyle(
                    color: question.isCorrect ? _colorSuccess : _colorError,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!question.isCorrect) ...[
                  const SizedBox(height: 4),
                  _buildCorrectAnswerText(question),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswerText(QuizQuestion question) {
    if (question is MultipleChoiceQuestion) {
      return Text(
        'Bonne réponse : ${question.correctAnswer}',
        style: const TextStyle(
          color: _colorBlack,
          fontSize: 14,
        ),
      );
    } else if (question is TrueFalseQuestion) {
      return Text(
        'Bonne réponse : ${question.correctAnswer ? 'Vrai' : 'Faux'}',
        style: const TextStyle(
          color: _colorBlack,
          fontSize: 14,
        ),
      );
    } else if (question is MatchingQuestion) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: question.correctMatches.entries.map((entry) {
          return Text(
            '${entry.key} : ${entry.value}',
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 14,
            ),
          );
        }).toList(),
      );
    }
    return const SizedBox();
  }

  Widget _buildNextButton(BuildContext context, int totalQuestions) {
    final currentQuestion = _allQuestions[_currentQuestionIndex];

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: currentQuestion.isAnswered ? () {
          if (_currentQuestionIndex < totalQuestions - 1) {
            setState(() {
              _currentQuestionIndex++;
            });
          } else {
            // Calculer le score final
            _totalScore = _allQuestions.where((q) => q.isCorrect).length * 30; // 30 points par bonne réponse
            setState(() {
              _showResultsOverlay = true;
            });
          }
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _purpleMain,
          disabledBackgroundColor: _purpleMain.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Text(
          _currentQuestionIndex < totalQuestions - 1 ? 'Suivant' : 'Voir les résultats',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsOverlay() {
    int correctAnswers = _allQuestions.where((q) => q.isCorrect).length;
    int totalQuestions = _allQuestions.length;

    return Container(
      color: Colors.black.withOpacity(0.5), // Fond semi-transparent
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quiz Terminé !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _colorBlack,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Félicitations ! vous avez gagné',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$_totalScore points',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _purpleMain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$correctAnswers/$totalQuestions réponses correctes',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const LibraryScreen()),
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
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _QuizOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final VoidCallback onTap;

  const _QuizOption({
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = isSelected ? _purpleMain : Colors.grey.shade300;
    Color bgColor = isSelected ? _purpleMain.withOpacity(0.1) : Colors.white;

    return InkWell(
      onTap: isAnswered ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: _fontFamily,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _purpleMain : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? _purpleMain : Colors.white,
              ),
              child: isSelected
                ? const Center(child: Icon(Icons.check, size: 12, color: Colors.white))
                : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrueFalseButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final VoidCallback onTap;

  const _TrueFalseButton({
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAnswered ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? _purpleMain.withOpacity(0.2) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _purpleMain : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? _purpleMain : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}