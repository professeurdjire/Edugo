import 'package:flutter/material.dart';
import 'package:edugo/screens/main/exercice/resultat.dart';
import 'package:edugo/screens/main/accueil/accueille.dart';
import 'package:edugo/services/exercise_service.dart';
import 'package:edugo/services/question_service.dart';
import 'package:edugo/services/submission_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/exercice_detail_response.dart';
import 'package:edugo/models/exercice.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:edugo/widgets/dynamic_question_widget.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair
const String _fontFamily = 'Roboto'; // Police principale

class QuizScreen extends StatefulWidget {
  final String exerciseTitle;
  final int exerciseId;
  final int? eleveId; // Ajout de eleveId

  const QuizScreen({
    super.key,
    required this.exerciseTitle,
    required this.exerciseId,
    this.eleveId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  final QuestionService _questionService = QuestionService();
  final SubmissionService _submissionService = SubmissionService();
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  
  Exercice? _exercice; // Exercice complet avec questions
  ExerciceDetailResponse? _exerciseDetails;
  BuiltList<Question> _questions = BuiltList<Question>(); // Questions du backend
  bool _isLoading = true;
  int? _currentEleveId;
  
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
    _currentEleveId = widget.eleveId ?? _authService.currentUserId;
    _loadExercise();
  }

  Future<void> _loadExercise() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Récupérer les questions depuis le nouvel endpoint
      final questions = await _questionService.getQuestionsByExercice(widget.exerciseId);
      
      // Récupérer aussi les détails de l'exercice pour l'affichage
      final details = await _exerciseService.getExerciceById(widget.exerciseId);
      
      if (mounted) {
        setState(() {
          _exerciseDetails = details;
          _questions = questions ?? BuiltList<Question>();
          _isLoading = false;
          
          print('[QuizScreen] Loaded ${_questions.length} questions for exercise ${widget.exerciseId}');
          if (_questions.isNotEmpty) {
            print('[QuizScreen] First question: id=${_questions.first.id}, enonce=${_questions.first.enonce}, type=${_questions.first.type?.libelleType}');
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
      print('Error loading exercise: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement de l\'exercice: $e')),
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

  int get _totalQuestionCount => _questions.length;
  int get _answeredQuestionCount {
    return _questions.where((q) => 
      q.id != null && _selectedAnswers.containsKey(q.id!)
    ).length;
  }

  void _submitExercise() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune question disponible pour cet exercice.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_currentEleveId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur: ID élève non disponible.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Valider les réponses avant soumission
    if (!_submissionService.validateAnswers(
      questions: _questions.toList(),
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
      // Essayer d'abord la soumission avec questions structurées
      SubmitResultResponse? result;
      
      try {
        result = await _submissionService.submitExercise(
          exerciceId: widget.exerciseId,
          eleveId: _currentEleveId!,
          selectedAnswers: _selectedAnswers,
          questions: _questions.toList(),
        );
      } catch (e) {
        print('[QuizScreen] Error submitting exercise: $e');
        // Relancer l'exception pour qu'elle soit gérée par le bloc catch principal
        rethrow;
      }
      
      if (result != null && mounted) {
        // Navigate to results screen with questions and answers
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultatScreen(
              result: result,
              questions: _questions.toList(),
              selectedAnswers: _selectedAnswers,
              eleveId: _currentEleveId, // Pour rafraîchir les points
            ),
          ),
        ).then((_) {
          // Rafraîchir la page d'accueil quand on revient
          // pour mettre à jour les points affichés
          if (mounted) {
            print('[QuizScreen] User returned from ResultatScreen, refreshing home screen points...');
            HomeScreen.refresh(context);
          }
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la soumission. Veuillez réessayer.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isSubmitted = false;
          });
        }
      }
    } catch (e) {
      print('[QuizScreen] Error submitting exercise: $e');
      if (mounted) {
        String errorMessage = 'Erreur lors de la soumission de l\'exercice';
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              _exerciseDetails?.titre ?? widget.exerciseTitle,
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucune question disponible',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _exerciseDetails?.titre ?? widget.exerciseTitle,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _buildProgressionBar(primaryColor),
                          const SizedBox(height: 20),
                          _buildQuestionsList(primaryColor),
                          const SizedBox(height: 30),
                          _buildSubmitButton(context, primaryColor),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildProgressionBar(Color primaryColor) {
    double progressValue = _totalQuestionCount > 0 
        ? _answeredQuestionCount / _totalQuestionCount 
        : 0.0;

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
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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

  Widget _buildQuestionsList(Color primaryColor) {
    if (_questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: _questions.asMap().entries.map((entry) {
        final index = entry.key;
        final question = entry.value;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DynamicQuestionWidget(
            question: question,
            onAnswerChanged: _onAnswerChanged,
            selectedAnswers: _selectedAnswers,
            isReadOnly: _isSubmitted,
            primaryColor: primaryColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton(BuildContext context, Color primaryColor) {
    final bool allAnswered = _answeredQuestionCount == _totalQuestionCount && _totalQuestionCount > 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: allAnswered && !_isSubmitted ? _submitExercise : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: _isSubmitted
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Text(
                    'Soumission...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : const Text(
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
