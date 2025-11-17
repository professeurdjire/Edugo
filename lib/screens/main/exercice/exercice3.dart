import 'package:flutter/material.dart';
// Correction de l'importation de resultat.dart (suppression du '/')
import 'package:edugo/screens/main/exercice/resultat.dart';
import 'package:edugo/services/exercice_service.dart';
import 'package:edugo/models/exercice_detail_response.dart';
import 'package:edugo/models/question.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une question (Ceci est la définition unique et fait autorité)
class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex; // AJOUTÉ : Index de la bonne réponse
  int? selectedOptionIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    this.selectedOptionIndex,
  });
}

class QuizScreen extends StatefulWidget {
  final String exerciseTitle;
  final int exerciseId; // Add exercise ID to fetch real data

  const QuizScreen({super.key, required this.exerciseTitle, required this.exerciseId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ExerciceService _exerciceService = ExerciceService();
  
  // Liste des questions simulées
  List<Question> _questions = [];
  bool _isLoading = true;
  ExerciceDetailResponse? _exerciseDetails;

  @override
  void initState() {
    super.initState();
    _loadExerciseDetails();
  }

  Future<void> _loadExerciseDetails() async {
    try {
      final details = await _exerciceService.getExerciceDetails(widget.exerciseId);
      
      if (mounted) {
        setState(() {
          _exerciseDetails = details;
          _isLoading = false;
          
          // For now, we'll still use simulated questions since we don't have the full question model
          // In a real implementation, we would parse the actual questions from the exercise details
          _questions = [
            Question(
              text: "Quelle est la valeur de 'x' dans l'équation : 2x+3=12 ?",
              options: ['X=4.5', 'X=3', 'X=5'],
              correctAnswerIndex: 0, // X=4.5
              selectedOptionIndex: null,
            ),
            Question(
              text: "Simplifiez l'expression : 3(x+2)-2x",
              options: ['x+6', '5x+6', 'x-6'],
              correctAnswerIndex: 0, // x+6
              selectedOptionIndex: null,
            ),
            Question(
              text: "La racine carrée de 144 est :",
              options: ['10', '12', '14'],
              correctAnswerIndex: 1, // 12
              selectedOptionIndex: null,
            ),
          ];
        });
      }
    } catch (e) {
      print('Error loading exercise details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  int get _totalQuestionCount => _questions.length;
  int get _answeredQuestionCount => _questions.where((q) => q.selectedOptionIndex != null).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCustomAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildProgressionBar(),
                        const SizedBox(height: 20),
                        _buildQuestionsList(), // Maintenant défini ci-dessous
                        const SizedBox(height: 30),
                        _buildSubmitButton(context),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // --- MISE À JOUR : Ajout de la méthode manquante ---
  Widget _buildQuestionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: _QuestionWidget(
            questionNumber: index + 1,
            question: _questions[index],
            onOptionSelected: (int selectedIndex) {
              setState(() {
                _questions[index].selectedOptionIndex = selectedIndex;
              });
            },
          ),
        );
      },
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE (inchangés) ---

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.exerciseTitle,
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

  Widget _buildProgressionBar() {
    double progressValue = _answeredQuestionCount / _totalQuestionCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progression',
          style: TextStyle(
            color: _colorBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 8),
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
          '$_answeredQuestionCount/$_totalQuestionCount questions répondues',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }

  // --- WIDGET BOUTON SOUMETTRE ---
  Widget _buildSubmitButton(BuildContext context) {
    final bool allAnswered = _answeredQuestionCount == _totalQuestionCount;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: allAnswered
            ? () {
                int correctCount = 0;
                for (var q in _questions) {
                  if (q.selectedOptionIndex == q.correctAnswerIndex) {
                    correctCount++;
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // L'erreur de type est résolue car ResultatScreen importe maintenant Question
                    builder: (context) => ResultatScreen(
                      totalQuestions: _totalQuestionCount,
                      answeredCorrectly: correctCount,
                      pointsGained: correctCount * 10,
                      results: _questions,
                    ),
                  ),
                );
              }
            : null,

        style: ElevatedButton.styleFrom(
          backgroundColor: _purpleMain,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Text(
          'Soumettre l\'exercice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET DE QUESTION (COMPOSANT) ---
// -------------------------------------------------------------------

class _QuestionWidget extends StatelessWidget {
  final int questionNumber;
  final Question question;
  final Function(int) onOptionSelected;

  const _QuestionWidget({
    required this.questionNumber,
    required this.question,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question $questionNumber : ${question.text}',
          style: const TextStyle(
            color: _colorBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 15),

        // Liste des options de réponse
        ...question.options.asMap().entries.map((entry) {
          int optionIndex = entry.key;
          String optionText = entry.value;
          bool isSelected = question.selectedOptionIndex == optionIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: InkWell(
              onTap: () => onOptionSelected(optionIndex),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: isSelected ? _purpleMain.withOpacity(0.05) : Colors.white,
                  border: Border.all(
                    color: isSelected ? _purpleMain : _colorUnselected,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionText,
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                    // Bouton Radio personnalisé (cercle)
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
            ),
          );
        }).toList(),
      ],
    );
  }
}