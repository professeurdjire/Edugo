import 'package:flutter/material.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_possible.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/reponse_eleve.dart';
import 'package:edugo/services/quiz_service.dart';
import 'package:edugo/services/question_service.dart';
import 'package:edugo/services/submission_service.dart';
import 'package:edugo/screens/main/quiz/quiz_result_screen.dart';
import 'package:edugo/widgets/dynamic_question_widget.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:built_collection/built_collection.dart';

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
  final QuestionService _questionService = QuestionService();
  final SubmissionService _submissionService = SubmissionService();
  final ThemeService _themeService = ThemeService();
  Quiz? _quiz;
  BuiltList<Question> _questions = BuiltList<Question>();
  bool _isLoading = true;
  // Supporte tous les types de réponses:
  // - QCM: List<int> (liste des IDs de réponses sélectionnées)
  // - Vrai/Faux: int (ID de la réponse sélectionnée)
  // - Réponse courte: String (texte de la réponse)
  // - Appariement: Map<int, int> (leftItemId -> rightItemId)
  Map<int, dynamic> _selectedAnswers = {};
  bool _isSubmitted = false;
  
  @override
  void initState() {
    super.initState();
    _loadQuizAndQuestions();
  }
  
  Future<void> _loadQuizAndQuestions() async {
    try {
      // Charger le quiz pour avoir les infos (titre, etc.)
      final quiz = await _quizService.getQuizById(widget.quizId);
      
      // Charger les questions depuis le nouvel endpoint
      final questions = await _questionService.getQuestionsByQuiz(widget.quizId);
      
      if (mounted) {
        setState(() {
          _quiz = quiz;
          _questions = questions ?? BuiltList<Question>();
          _isLoading = false;
          
          print('[TakeQuizScreen] Loaded ${_questions.length} questions for quiz ${widget.quizId}');
          if (_questions.isNotEmpty) {
            print('[TakeQuizScreen] First question: id=${_questions.first.id}, enonce=${_questions.first.enonce}, type=${_questions.first.type?.libelleType}');
          }
          
          // Initialiser les réponses vides pour toutes les questions
          if (_questions.isNotEmpty) {
            _selectedAnswers = Map.fromIterable(
              _questions,
              key: (q) => (q as Question).id!,
              value: (_) => null,
            );
          }
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
  
  void _onAnswerChanged(int questionId, dynamic answer) {
    if (_isSubmitted) return;
    
    setState(() {
      _selectedAnswers[questionId] = answer;
    });
  }
  
  void _submitQuiz() async {
    if (_questions.isEmpty) return;
    
    // Valider les réponses avant soumission
    final questionsList = _questions.toList();
    if (!_submissionService.validateAnswers(
      questions: questionsList,
      selectedAnswers: _selectedAnswers,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez répondre à toutes les questions avant de soumettre.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    setState(() {
      _isSubmitted = true;
    });
    
    try {
      final result = await _submissionService.submitQuiz(
        quizId: widget.quizId,
        eleveId: widget.eleveId,
        selectedAnswers: _selectedAnswers,
        questions: questionsList,
      );
      
      if (result != null && mounted) {
        // Navigate to results screen with questions and answers
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(
              result: result,
              title: 'Quiz ${_quiz?.id ?? ''}',
              questions: questionsList,
              selectedAnswers: _selectedAnswers,
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la soumission du quiz. Veuillez réessayer.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isSubmitted = false;
          });
        }
      }
    } catch (e) {
      print('[TakeQuizScreen] Error submitting quiz: $e');
      if (mounted) {
        String errorMessage = 'Erreur lors de la soumission du quiz';
        if (e is Exception) {
          final errorString = e.toString();
          if (errorString.contains('Accès refusé') || errorString.contains('403')) {
            errorMessage = 'Accès refusé. Veuillez vous reconnecter et réessayer.';
          } else if (errorString.contains('Session expirée') || errorString.contains('401')) {
            errorMessage = 'Session expirée. Veuillez vous reconnecter.';
          } else if (errorString.contains('Format de données')) {
            errorMessage = 'Format de données invalide. Vérifiez vos réponses.';
          } else {
            // Extraire le message d'erreur sans le préfixe "Exception: "
            errorMessage = errorString.replaceFirst('Exception: ', '');
          }
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        setState(() {
          _isSubmitted = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Quiz ${_quiz?.id ?? ''}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)))
              : _questions.isEmpty
                  ? const Center(child: Text('Aucune question disponible pour ce quiz'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quiz description
                            // Quiz description would go here if available
                            const SizedBox(height: 20),
                            
                            // Questions avec widget dynamique
                            ..._questions.map((question) {
                                  print('[TakeQuizScreen] Rendering question ID: ${question.id}, enonce: ${question.enonce}');
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: DynamicQuestionWidget(
                                      question: question,
                                      onAnswerChanged: _onAnswerChanged,
                                      selectedAnswers: _selectedAnswers,
                                      isReadOnly: _isSubmitted,
                                      primaryColor: primaryColor,
                                    ),
                                  );
                                }).toList(),
                            
                            const SizedBox(height: 20),
                            
                            // Submit button
                            Center(
                              child: ElevatedButton(
                                onPressed: _isSubmitted ? null : _submitQuiz,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
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
      },
    );
  }
}