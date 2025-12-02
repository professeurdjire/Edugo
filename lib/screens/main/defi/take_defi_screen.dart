import 'package:flutter/material.dart';
import 'package:edugo/models/defi_detail_response.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:edugo/services/defi_service.dart';
import 'package:edugo/services/question_service.dart';
import 'package:edugo/services/submission_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/widgets/dynamic_question_widget.dart';
import 'package:edugo/screens/main/quiz/quiz_result_screen.dart';
import 'package:built_collection/built_collection.dart';

class TakeDefiScreen extends StatefulWidget {
  final int defiId;
  final int eleveId;
  final String? defiTitle;
  
  const TakeDefiScreen({
    Key? key,
    required this.defiId,
    required this.eleveId,
    this.defiTitle,
  }) : super(key: key);

  @override
  State<TakeDefiScreen> createState() => _TakeDefiScreenState();
}

class _TakeDefiScreenState extends State<TakeDefiScreen> {
  final DefiService _defiService = DefiService();
  final QuestionService _questionService = QuestionService();
  final SubmissionService _submissionService = SubmissionService();
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  
  DefiDetailResponse? _defi;
  BuiltList<Question> _questions = BuiltList<Question>();
  bool _isLoading = true;
  bool _hasParticipated = false;
  
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
    _loadDefi();
  }
  
  Future<void> _loadDefi() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Charger le défi pour avoir les infos (titre, etc.)
      final defi = await _defiService.getDefiById(widget.defiId);
      
      // Vérifier si l'élève a déjà participé
      final defisParticipes = await _defiService.getDefisParticipes(widget.eleveId);
      if (defisParticipes != null) {
        _hasParticipated = defisParticipes.any((p) => p.defiId == widget.defiId);
      }
      
      // Si l'élève n'a pas encore participé, participer d'abord
      if (!_hasParticipated && defi != null) {
        print('[TakeDefiScreen] Student has not participated yet, participating now...');
        final participation = await _defiService.participerDefi(widget.eleveId, widget.defiId);
        if (participation != null) {
          _hasParticipated = true;
          print('[TakeDefiScreen] Successfully participated in defi ${widget.defiId}');
        }
      }
      
      // Charger les questions depuis l'endpoint
      final questions = await _questionService.getQuestionsByDefi(widget.defiId);
      
      if (mounted) {
        setState(() {
          _defi = defi;
          _questions = questions ?? BuiltList<Question>();
          _isLoading = false;
          
          print('[TakeDefiScreen] Loaded ${_questions.length} questions for defi ${widget.defiId}');
          if (_questions.isNotEmpty) {
            print('[TakeDefiScreen] First question: id=${_questions.first.id}, enonce=${_questions.first.enonce}, type=${_questions.first.type?.libelleType}');
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
      print('Error loading defi: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement du défi: $e')),
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
      q.id != null && _selectedAnswers.containsKey(q.id!) && _selectedAnswers[q.id!] != null
    ).length;
  }

  void _submitDefi() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune question disponible pour ce défi.'),
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
      // Utiliser le même format que pour les challenges
      // Le backend devrait avoir un endpoint similaire pour les défis
      // Pour l'instant, on utilise le même endpoint que les challenges mais avec defiId
      final result = await _submissionService.submitDefi(
        defiId: widget.defiId,
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
              title: _defi?.titre ?? widget.defiTitle ?? 'Défi',
              questions: _questions.toList(),
              selectedAnswers: _selectedAnswers,
            ),
          ),
        ).then((_) {
          // Rafraîchir la page d'accueil quand on revient
          // pour mettre à jour les points affichés
          if (mounted) {
            print('[TakeDefiScreen] User returned from QuizResultScreen, refreshing home screen points...');
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
              _defi?.titre ?? widget.defiTitle ?? 'Défi du jour',
              style: const TextStyle(color: Colors.black12),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black12,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black12),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black12),
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
                            _defi?.titre ?? widget.defiTitle ?? 'Défi',
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
                          
                          // Défi description
                          if (_defi?.ennonce != null) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _defi!.ennonce!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Points du défi
                          if (_defi?.pointDefi != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: primaryColor.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: primaryColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_defi!.pointDefi} points à gagner',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
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
                                  ? _submitDefi
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
                                      'Soumettre le défi',
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

