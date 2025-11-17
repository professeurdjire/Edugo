import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:edugo/screens/main/challenge/resumeChallenge.dart';
import 'package:edugo/services/defi_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/defi_detail_response.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _colorSuccess = Color(0xFF32C832);
const Color _colorError = Color(0xFFE74C3C);
const Color _colorUnselected = Color(0xFFE0E0E0);
const Color _colorLightPurple = Color(0xFFF3E5F5);
const String _fontFamily = 'Roboto';

class ChallengeParticipeScreen extends StatefulWidget {
  final int? defiId;

  const ChallengeParticipeScreen({super.key, this.defiId});

  @override
  State<ChallengeParticipeScreen> createState() => _ChallengeParticipeScreenState();
}

class _ChallengeParticipeScreenState extends State<ChallengeParticipeScreen> {
  final DefiService _defiService = DefiService();
  final AuthService _authService = AuthService();
  
  DefiDetailResponse? _defiDetails;
  bool _isLoading = true;
  int? _currentEleveId;
  
  final Map<int, bool> answeredByIndex = {};
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentEleveId = _authService.currentUserId;
    if (widget.defiId != null && _currentEleveId != null) {
      _loadDefiDetails();
    } else {
      // Initialize with simulated data if no defiId provided
      _initializeSimulatedData();
    }
  }

  Future<void> _loadDefiDetails() async {
    if (widget.defiId == null || _currentEleveId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final details = await _defiService.getDefiById(widget.defiId!);
      
      if (mounted) {
        setState(() {
          _defiDetails = details;
          _isLoading = false;
          
          // For now, we'll still use simulated questions since we don't have the full question model
          // In a real implementation, we would parse the actual questions from the defi details
          _initializeSimulatedData();
        });
      }
    } catch (e) {
      print('Error loading challenge details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _initializeSimulatedData();
        });
      }
    }
  }

  void _initializeSimulatedData() {
    final int totalQuestions = 4;
    for (int i = 0; i < totalQuestions; i++) {
      answeredByIndex[i] = false;
    }
  }

  void _onAnsweredChanged(int questionIndex, bool isAnswered) {
    setState(() {
      answeredByIndex[questionIndex] = isAnswered;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < answeredByIndex.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // All questions answered, navigate to summary
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChallengeSummaryScreen()),
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  int get answeredCount => answeredByIndex.values.where((v) => v).length;
  double get progress => answeredByIndex.length == 0 ? 0.0 : (answeredCount / answeredByIndex.length);

  Widget _buildCurrentQuestion() {
    switch (_currentQuestionIndex) {
      case 0:
        return TrueFalseQuestionCard(
          questionIndex: _currentQuestionIndex + 1,
          totalQuestions: answeredByIndex.length,
          questionText: 'La somme de 2 et 3 font 5 ?',
          onAnsweredChanged: (isAnswered) => _onAnsweredChanged(_currentQuestionIndex, isAnswered),
        );
      case 1:
        return MultipleChoiceQuestionCard(
          questionIndex: _currentQuestionIndex + 1,
          totalQuestions: answeredByIndex.length,
          questionText: 'La somme de 2 et 3 font ?',
          options: const ['4', '5', '10', '6'],
          onAnsweredChanged: (isAnswered) => _onAnsweredChanged(_currentQuestionIndex, isAnswered),
        );
      case 2:
        return MatchingQuestionCard(
          questionIndex: _currentQuestionIndex + 1,
          totalQuestions: answeredByIndex.length,
          questionText: 'Faites correspondre les pays à leurs capitales',
          leftOptions: const ['France', 'Japon', 'Mali'],
          bottomOptions: const ['Paris', 'Tokyo', 'Bamako'],
          onAnsweredChanged: (isAnswered) => _onAnsweredChanged(_currentQuestionIndex, isAnswered),
        );
      case 3:
        return TextEntryQuestionCard(
          questionIndex: _currentQuestionIndex + 1,
          totalQuestions: answeredByIndex.length,
          questionText: 'Quel est le résultat de 7 * 8 ?',
          onAnsweredChanged: (isAnswered) => _onAnsweredChanged(_currentQuestionIndex, isAnswered),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _defiDetails?.titre ?? 'Challenge : Défi Mathématiques',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Timer et progression en haut
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const TimeProgressIndicator(),
                      const SizedBox(height: 20),
                      _buildProgressionBar(answeredByIndex.length),
                    ],
                  ),
                ),

                // Question actuelle au centre
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildCurrentQuestion(),
                  ),
                ),

                // Boutons de navigation en bas
                _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildProgressionBar(int totalQuestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Progression', style: TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 8),
        AnimatedProgressIndicator(
          progress: progress,
          answeredCount: answeredCount,
          total: totalQuestions,
          label: '${answeredCount}/${totalQuestions} questions répondues',
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousQuestion,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _purpleMain,
                  side: const BorderSide(color: _purpleMain),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Précédent'),
              ),
            ),
          if (_currentQuestionIndex > 0) const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: answeredByIndex[_currentQuestionIndex] == true ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleMain,
                disabledBackgroundColor: _purpleMain.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                _currentQuestionIndex == answeredByIndex.length - 1 ? 'Voir le Résumé' : 'Suivant',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- TIME INDICATOR ---
class TimeProgressIndicator extends StatefulWidget {
  const TimeProgressIndicator({super.key});

  @override
  State<TimeProgressIndicator> createState() => _TimeProgressIndicatorState();
}

class _TimeProgressIndicatorState extends State<TimeProgressIndicator> {
  double progress = 1.0;
  int secondsRemaining = 60 * 5;
  late final Duration totalDuration;

  @override
  void initState() {
    super.initState();
    totalDuration = Duration(seconds: secondsRemaining);
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
          progress = secondsRemaining / totalDuration.inSeconds;
        });
        return true;
      }
      return false;
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes : $seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Temps restant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(
                formatTime(secondsRemaining),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _purpleMain),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: progress > 0.3 ? Colors.green : Colors.orange,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// --- ANIMATED PROGRESS INDICATOR ---
class AnimatedProgressIndicator extends StatelessWidget {
  final double progress;
  final int answeredCount;
  final int total;
  final String label;

  const AnimatedProgressIndicator({
    super.key,
    required this.progress,
    required this.answeredCount,
    required this.total,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey.shade200,
                  color: _purpleMain,
                  minHeight: 8,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _purpleMain),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- QUESTION CARD BASE ---
class QuestionCard extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final Widget child;

  const QuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.questionText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question $questionIndex/$totalQuestions',
            style: const TextStyle(
              color: _purpleMain,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// --- TRUE/FALSE QUESTION ---
class TrueFalseQuestionCard extends StatefulWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final ValueChanged<bool> onAnsweredChanged;

  const TrueFalseQuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.questionText,
    required this.onAnsweredChanged,
  });

  @override
  State<TrueFalseQuestionCard> createState() => _TrueFalseQuestionCardState();
}

class _TrueFalseQuestionCardState extends State<TrueFalseQuestionCard> {
  String? selection;

  void _toggle(String value) {
    setState(() {
      selection = selection == value ? null : value;
      widget.onAnsweredChanged(selection != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: widget.questionIndex,
      totalQuestions: widget.totalQuestions,
      questionText: widget.questionText,
      child: Row(
        children: [
          Expanded(
            child: _TrueFalseButton(
              text: 'Vrai',
              isSelected: selection == 'Vrai',
              onTap: () => _toggle('Vrai'),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _TrueFalseButton(
              text: 'Faux',
              isSelected: selection == 'Faux',
              onTap: () => _toggle('Faux'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrueFalseButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TrueFalseButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? _purpleMain.withOpacity(0.2) : _colorLightPurple,
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

// --- MULTIPLE CHOICE QUESTION ---
class MultipleChoiceQuestionCard extends StatefulWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final List<String> options;
  final ValueChanged<bool> onAnsweredChanged;

  const MultipleChoiceQuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.questionText,
    required this.options,
    required this.onAnsweredChanged,
  });

  @override
  State<MultipleChoiceQuestionCard> createState() => _MultipleChoiceQuestionCardState();
}

class _MultipleChoiceQuestionCardState extends State<MultipleChoiceQuestionCard> {
  String? selectedOption;

  void _onTapOption(String option) {
    setState(() {
      selectedOption = selectedOption == option ? null : option;
      widget.onAnsweredChanged(selectedOption != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: widget.questionIndex,
      totalQuestions: widget.totalQuestions,
      questionText: widget.questionText,
      child: Column(
        children: widget.options.map((option) {
          final bool isSelected = option == selectedOption;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _QuizOption(
              text: option,
              isSelected: isSelected,
              onTap: () => _onTapOption(option),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuizOption({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? _purpleMain.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? _purpleMain : Colors.grey.shade300,
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

// --- MATCHING QUESTION ---
class MatchingQuestionCard extends StatefulWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final List<String> leftOptions;
  final List<String> bottomOptions;
  final ValueChanged<bool> onAnsweredChanged;

  const MatchingQuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.questionText,
    required this.leftOptions,
    required this.bottomOptions,
    required this.onAnsweredChanged,
  });

  @override
  State<MatchingQuestionCard> createState() => _MatchingQuestionCardState();
}

class _MatchingQuestionCardState extends State<MatchingQuestionCard> {
  late List<String?> selectedAnswers;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(widget.leftOptions.length, null);
  }

  void _selectBottom(String value) {
    setState(() {
      final firstEmpty = selectedAnswers.indexWhere((e) => e == null);
      if (firstEmpty != -1) {
        selectedAnswers[firstEmpty] = value;
      }
      widget.onAnsweredChanged(!selectedAnswers.contains(null));
    });
  }

  void _clearSlot(int index) {
    setState(() {
      selectedAnswers[index] = null;
      widget.onAnsweredChanged(!selectedAnswers.contains(null));
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: widget.questionIndex,
      totalQuestions: widget.totalQuestions,
      questionText: widget.questionText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: widget.leftOptions.asMap().entries.map((entry) {
              int index = entry.key;
              String leftItem = entry.value;
              String? selectedMatch = selectedAnswers[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: [
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectedMatch != null) {
                            _clearSlot(index);
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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.bottomOptions.map((text) {
              bool isUsed = selectedAnswers.contains(text);
              return GestureDetector(
                onTap: isUsed ? null : () => _selectBottom(text),
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
                    text,
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
      ),
    );
  }
}

// --- TEXT ENTRY QUESTION ---
class TextEntryQuestionCard extends StatefulWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final ValueChanged<bool> onAnsweredChanged;

  const TextEntryQuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.questionText,
    required this.onAnsweredChanged,
  });

  @override
  State<TextEntryQuestionCard> createState() => _TextEntryQuestionCardState();
}

class _TextEntryQuestionCardState extends State<TextEntryQuestionCard> {
  final TextEditingController _ctrl = TextEditingController();
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onChange);
  }

  void _onChange() {
    final hasText = _ctrl.text.trim().isNotEmpty;
    if (hasText != _isAnswered) {
      _isAnswered = hasText;
      widget.onAnsweredChanged(_isAnswered);
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onChange);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: widget.questionIndex,
      totalQuestions: widget.totalQuestions,
      questionText: widget.questionText,
      child: TextField(
        controller: _ctrl,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _purpleMain),
          ),
          hintText: 'Votre réponse',
        ),
      ),
    );
  }
}