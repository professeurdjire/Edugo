import 'package:flutter/material.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_possible.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/reponse_eleve.dart';
import 'package:edugo/services/quiz_service.dart';
import 'package:edugo/screens/main/quiz/quiz_result_screen.dart';

class TakeQuizScreen extends StatefulWidget {
  final int quizId;
  final int eleveId;
  
  const TakeQuizScreen({
    Key? key,
    required this.quizId,
    required this.eleveId,
  }) : super(key: key);

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  final QuizService _quizService = QuizService();
  Quiz? _quiz;
  bool _isLoading = true;
  Map<int, List<int>> _selectedAnswers = {}; // questionId -> list of selected responseIds
  bool _isSubmitted = false;
  
  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }
  
  Future<void> _loadQuiz() async {
    try {
      final quiz = await _quizService.getQuizById(widget.quizId);
      if (mounted) {
        setState(() {
          _quiz = quiz;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement du quiz: $e')),
        );
      }
    }
  }
  
  void _selectAnswer(int questionId, int responseId, bool isMultipleChoice) {
    if (_isSubmitted) return;
    
    setState(() {
      if (isMultipleChoice) {
        // For multiple choice, we can select multiple answers
        if (_selectedAnswers.containsKey(questionId)) {
          if (_selectedAnswers[questionId]!.contains(responseId)) {
            // Remove if already selected
            _selectedAnswers[questionId]!.remove(responseId);
          } else {
            // Add if not selected
            _selectedAnswers[questionId]!.add(responseId);
          }
        } else {
          // First selection for this question
          _selectedAnswers[questionId] = [responseId];
        }
      } else {
        // For single choice, only one answer can be selected
        _selectedAnswers[questionId] = [responseId];
      }
    });
  }
  
  bool _isAnswerSelected(int questionId, int responseId) {
    return _selectedAnswers.containsKey(questionId) && 
           _selectedAnswers[questionId]!.contains(responseId);
  }
  
  void _submitQuiz() async {
    if (_quiz == null) return;
    
    setState(() {
      _isSubmitted = true;
    });
    
    // Prepare the submission request
    final List<ReponseEleve> reponses = [];
    
    for (var entry in _selectedAnswers.entries) {
      final questionId = entry.key;
      final responseIds = entry.value;
      
      // Create a string response from the selected IDs
      final responseText = responseIds.join(',');
      
      final question = Question((b) => b..id = questionId);
      reponses.add(
        ReponseEleve((b) => b
          ..question.replace(question)
          ..reponse = responseText
        )
      );
    }
    
    final submitRequest = SubmitRequest((b) => b
      ..eleveId = widget.eleveId
      ..reponses.replace(reponses)
    );
    
    try {
      final result = await _quizService.submitQuizAnswers(widget.quizId, submitRequest);
      
      if (result != null && mounted) {
        // Navigate to results screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(
              result: result,
              title: 'Quiz ${_quiz?.id ?? ''}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la soumission du quiz: $e')),
        );
        setState(() {
          _isSubmitted = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz ${_quiz?.id ?? ''}'),
        backgroundColor: const Color(0xFFA885D8),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quiz == null
              ? const Center(child: Text('Impossible de charger le quiz'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quiz description
                        // Quiz description would go here if available
                        const SizedBox(height: 20),
                        
                        // Questions
                        ..._quiz!.questionsQuiz?.map((question) {
                              final isMultipleChoice = question.type?.libelleType == 'QCM';
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        question.enonce ?? '',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 12),
                                      ...question.reponsesPossibles?.map((reponse) {
                                            return Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: _isAnswerSelected(question.id!, reponse.id!) 
                                                      ? const Color(0xFFA885D8) 
                                                      : Colors.grey,
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: RadioListTile<int>(
                                                title: Text(reponse.libelleReponse ?? ''),
                                                value: reponse.id!,
                                                groupValue: _selectedAnswers.containsKey(question.id!) 
                                                    ? (_selectedAnswers[question.id!]!.length == 1 
                                                        ? _selectedAnswers[question.id!]![0] 
                                                        : null)
                                                    : null,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    _selectAnswer(question.id!, value, isMultipleChoice);
                                                  }
                                                },
                                                toggleable: isMultipleChoice,
                                              ),
                                            );
                                          }).toList() ?? [],
                                    ],
                                  ),
                                ),
                              );
                            }).toList() ?? [],
                        
                        const SizedBox(height: 20),
                        
                        // Submit button
                        Center(
                          child: ElevatedButton(
                            onPressed: _isSubmitted ? null : _submitQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA885D8),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _isSubmitted
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text('Soumission...', style: TextStyle(color: Colors.white)),
                                    ],
                                  )
                                : const Text(
                                    'Soumettre le quiz',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
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