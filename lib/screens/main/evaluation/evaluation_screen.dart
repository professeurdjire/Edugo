import 'package:flutter/material.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_possible.dart';

class EvaluationScreen extends StatefulWidget {
  final String title;
  final String type; // QUIZ, EXERCICE, CHALLENGE
  final List<Question> questions;
  final int totalTime; // in seconds, 0 for no time limit
  
  const EvaluationScreen({
    Key? key,
    required this.title,
    required this.type,
    required this.questions,
    this.totalTime = 0,
  }) : super(key: key);

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  int _currentQuestionIndex = 0;
  int _timeRemaining = 0;
  late PageController _pageController;
  Map<int, List<int>> _selectedAnswers = {}; // questionId -> list of selected responseIds
  bool _isSubmitted = false;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timeRemaining = widget.totalTime;
    
    // Start timer if there's a time limit
    if (widget.totalTime > 0) {
      _startTimer();
    }
  }
  
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timeRemaining > 0 && !_isSubmitted) {
        setState(() {
          _timeRemaining--;
        });
        _startTimer();
      } else if (_timeRemaining == 0 && !_isSubmitted) {
        // Time's up, auto-submit
        _submitEvaluation();
      }
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
  
  void _submitEvaluation() {
    setState(() {
      _isSubmitted = true;
    });
    
    // Here you would typically call the appropriate service to submit the answers
    // For now, we'll just show a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Évaluation terminée'),
          content: const Text('Vos réponses ont été soumises avec succès.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFA885D8),
        foregroundColor: Colors.white,
        actions: [
          if (widget.totalTime > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _timeRemaining < 60 ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.questions.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA885D8)),
          ),
          
          // Question counter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Question ${_currentQuestionIndex + 1}/${widget.questions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Questions pager
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.questions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentQuestionIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final Question question = widget.questions[index];
                return _buildQuestionCard(question);
              },
            ),
          ),
          
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex > 0 
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA885D8),
                  ),
                  child: const Text('Précédent'),
                ),
                ElevatedButton(
                  onPressed: _currentQuestionIndex < widget.questions.length - 1 
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : _isSubmitted 
                          ? null 
                          : _submitEvaluation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA885D8),
                  ),
                  child: _currentQuestionIndex < widget.questions.length - 1 
                      ? const Text('Suivant') 
                      : const Text('Soumettre'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestionCard(Question question) {
    final bool isMultipleChoice = question.type?.libelleType == 'QCM';
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.enonce ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Points: ${question.points}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choisissez votre réponse:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: question.reponsesPossibles?.length ?? 0,
                  itemBuilder: (context, index) {
                    final ReponsePossible response = question.reponsesPossibles![index];
                    return _buildAnswerOption(
                      response, 
                      question.id!, 
                      isMultipleChoice
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnswerOption(ReponsePossible response, int questionId, bool isMultipleChoice) {
    final bool isSelected = _isAnswerSelected(questionId, response.id!);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: isSelected ? const Color(0xFFA885D8).withOpacity(0.2) : null,
      child: ListTile(
        title: Text(response.libelleReponse ?? ''),
        leading: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSelected ? const Color(0xFFA885D8) : Colors.grey,
        ),
        onTap: () {
          _selectAnswer(questionId, response.id!, isMultipleChoice);
        },
      ),
    );
  }
}