import 'package:flutter/material.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:edugo/services/question_service.dart';
import 'package:edugo/services/submission_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/widgets/dynamic_question_widget.dart';
import 'package:edugo/screens/main/quiz/quiz_result_screen.dart';
import 'package:built_collection/built_collection.dart';

class TakeChallengeScreen extends StatefulWidget {
  final int challengeId;
  final int eleveId;
  final String? challengeTitle;
  
  const TakeChallengeScreen({
    Key? key,
    required this.challengeId,
    required this.eleveId,
    this.challengeTitle,
  }) : super(key: key);

  @override
  State<TakeChallengeScreen> createState() => _TakeChallengeScreenState();
}

class _TakeChallengeScreenState extends State<TakeChallengeScreen> {
  final ChallengeService _challengeService = ChallengeService();
  final QuestionService _questionService = QuestionService();
  final SubmissionService _submissionService = SubmissionService();
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  
  Challenge? _challenge;
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
    _loadChallenge();
  }
  
  Future<void> _loadChallenge() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Charger le challenge pour avoir les infos (titre, etc.)
      final challenge = await _challengeService.getChallengeById(widget.challengeId);
      
      // Charger les questions depuis le nouvel endpoint
      final questions = await _questionService.getQuestionsByChallenge(widget.challengeId);
      
      if (mounted) {
        setState(() {
          _challenge = challenge;
          _questions = questions ?? BuiltList<Question>();
          _isLoading = false;
          
          print('[TakeChallengeScreen] Loaded ${_questions.length} questions for challenge ${widget.challengeId}');
          if (_questions.isNotEmpty) {
            print('[TakeChallengeScreen] First question: id=${_questions.first.id}, enonce=${_questions.first.enonce}, type=${_questions.first.type?.libelleType}');
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
      print('Error loading challenge: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement du challenge: $e')),
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

  void _submitChallenge() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune question disponible pour ce challenge.'),
          backgroundColor: Colors.orange,
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
      final result = await _submissionService.submitChallenge(
        challengeId: widget.challengeId,
        eleveId: widget.eleveId,
        selectedAnswers: _selectedAnswers,
        questions: _questions.toList(),
      );
      
      if (result != null && mounted) {
        // Navigate to results screen with questions and answers
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(
              result: result,
              title: _challenge?.titre ?? widget.challengeTitle ?? 'Challenge',
              questions: _questions.toList(),
              selectedAnswers: _selectedAnswers,
            ),
          ),
        ).then((_) {
          // Rafraîchir la page d'accueil quand on revient
          // pour mettre à jour les points affichés
          if (mounted) {
            print('[TakeChallengeScreen] User returned from QuizResultScreen, refreshing home screen points...');
            // Importer HomeScreen pour utiliser la méthode refresh
            // Note: On doit utiliser un callback ou un ValueNotifier pour rafraîchir
            // Pour l'instant, on laisse QuizResultScreen rafraîchir les points dans AuthService
            // La page d'accueil devrait se rafraîchir automatiquement via MainScreen
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la soumission: $e')),
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
              _challenge?.titre ?? widget.challengeTitle ?? 'Challenge',
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
          ? const Center(child: CircularProgressIndicator())
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
                        _challenge?.titre ?? widget.challengeTitle ?? 'Challenge',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progression bar
                      _buildProgressionBar(primaryColor),
                      const SizedBox(height: 20),
                      
                      // Challenge description
                      if (_challenge?.description != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA885D8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _challenge!.description!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Questions avec widget dynamique
                      ..._questions.map((question) {
                        return DynamicQuestionWidget(
                          question: question,
                          onAnswerChanged: _onAnswerChanged,
                          selectedAnswers: _selectedAnswers,
                          isReadOnly: _isSubmitted,
                          primaryColor: primaryColor,
                        );
                      }).toList(),
                      
                      const SizedBox(height: 20),
                      
                      // Submit button
                      Center(
                        child: ElevatedButton(
                          onPressed: _answeredQuestionCount == _totalQuestionCount && !_isSubmitted
                              ? _submitChallenge
                              : null,
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
                                  'Soumettre le challenge',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade300,
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
          ),
        ),
      ],
    );
  }
}

