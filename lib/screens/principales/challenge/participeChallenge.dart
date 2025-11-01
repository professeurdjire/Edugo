import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:edugo/screens/principales/challenge/resumeChallenge.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge Demo Combiné',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ChallengeParticipeScreen(),
    );
  }
}

// ---------------------
// COULEURS
// ---------------------
class AppColors {
  static const Color primaryPurple = Color(0xFFA885D8);
  static const Color lightPurple = Color(0xFFE1BEE7);
  static const Color veryLightPurple = Color(0xFFF3E5F5);
  static const Color lightGrey = Color(0xFFE0E0E0);
}

// ---------------------
// SCREEN PRINCIPAL (STATEFUL)
// ---------------------
class ChallengeParticipeScreen extends StatefulWidget {
  const ChallengeParticipeScreen({super.key});

  @override
  State<ChallengeParticipeScreen> createState() => _ChallengeParticipeScreenState();
}

class _ChallengeParticipeScreenState extends State<ChallengeParticipeScreen> {
  // Définit ici combien de questions il y a sur la page.
  // Si tu ajoutes/retire des question cards, mets à jour cette valeur.
  final int totalQuestions = 4;

  // Map questionIndex -> answered (true/false)
  final Map<int, bool> answeredByIndex = {};

  @override
  void initState() {
    super.initState();
    // initialise toutes les questions à non répondues
    for (int i = 1; i <= totalQuestions; i++) {
      answeredByIndex[i] = false;
    }
  }

  void _onAnsweredChanged(int questionIndex, bool isAnswered) {
    setState(() {
      answeredByIndex[questionIndex] = isAnswered;
    });
  }

  int get answeredCount => answeredByIndex.values.where((v) => v).length;
  double get progress => totalQuestions == 0 ? 0.0 : (answeredCount / totalQuestions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Challenge : Défi Mathématiques',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TimeProgressIndicator(), // temps (garde son timer interne)
            const SizedBox(height: 20),
            const Text('Progression', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 8),
            AnimatedProgressIndicator(
              progress: progress,
              answeredCount: answeredCount,
              total: totalQuestions,
              label: '${answeredCount}/${totalQuestions} questions répondues',
            ),
            const SizedBox(height: 30),

            // 1) True/False (index 1)
            TrueFalseQuestionCard(
              questionIndex: 1,
              totalQuestions: totalQuestions,
              questionText: 'La somme de 2 et 3 font 5 ?',
              onAnsweredChanged: (isAnswered) => _onAnsweredChanged(1, isAnswered),
            ),
            const SizedBox(height: 20),

            // 2) Multiple choice (index 2)
            MultipleChoiceQuestionCard(
              questionIndex: 2,
              totalQuestions: totalQuestions,
              questionText: 'La somme de 2 et 3 font ?',
              options: const ['4', '5', '10', '6'],
              onAnsweredChanged: (isAnswered) => _onAnsweredChanged(2, isAnswered),
            ),
            const SizedBox(height: 20),

            // 3) Matching (index 3)
            MatchingQuestionCard(
              questionIndex: 3,
              totalQuestions: totalQuestions,
              questionText: 'Faites correspondre les pays à leurs capitales',
              leftOptions: const ['France', 'Japon', 'Mali'],
              bottomOptions: const ['Paris', 'Tokyo', 'Bamako'],
              onAnsweredChanged: (isAnswered) => _onAnsweredChanged(3, isAnswered),
            ),
            const SizedBox(height: 20),

            // 4) Text entry (index 4)
            TextEntryQuestionCard(
              questionIndex: 4,
              totalQuestions: totalQuestions,
              questionText: 'Quel est le résultat de 7 * 8 ?',
              onAnsweredChanged: (isAnswered) => _onAnsweredChanged(4, isAnswered),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChallengeSummaryScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Suivant', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ---------------------
// TIME INDICATOR (avec bordure)
// ---------------------
class TimeProgressIndicator extends StatefulWidget {
  const TimeProgressIndicator({super.key});

  @override
  State<TimeProgressIndicator> createState() => _TimeProgressIndicatorState();
}

class _TimeProgressIndicatorState extends State<TimeProgressIndicator> with TickerProviderStateMixin {
  double progress = 1.0; // 100%
  int secondsRemaining = 60 * 5; // 5 minutes
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
      if (secondsRemaining > 0) {
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Temps restant', style: TextStyle(fontSize: 16, color: Colors.black54)),
              Text(
                formatTime(secondsRemaining),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------
// AnimatedProgressIndicator (visuel seulement)
// ---------------------
class AnimatedProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 .. 1.0
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated Linear progress (smooth)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.primaryPurple,
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
              Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------
// QuestionCard de base
// ---------------------
class QuestionCard extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final Widget child;
  final double cardElevation;

  const QuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.questionText,
    required this.child,
    this.cardElevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: cardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text('Question $questionIndex/$totalQuestions', style: const TextStyle(fontSize: 14, color: AppColors.primaryPurple, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(questionText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          child,
        ]),
      ),
    );
  }
}

// ---------------------
// True/False (notifie parent avec onAnsweredChanged)
// ---------------------
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
  String? selection; // 'True' / 'False' / null

  void _toggle(String value) {
    setState(() {
      if (selection == value) {
        selection = null; // désélection (mode dynamique)
      } else {
        selection = value;
      }
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
          Expanded(child: TrueFalseButton(text: 'True', isSelected: selection == 'True', onTap: () => _toggle('True'))),
          const SizedBox(width: 15),
          Expanded(child: TrueFalseButton(text: 'False', isSelected: selection == 'False', onTap: () => _toggle('False'))),
        ],
      ),
    );
  }
}

class TrueFalseButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TrueFalseButton({super.key, required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightPurple : AppColors.veryLightPurple,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.transparent, width: 1),
        ),
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primaryPurple : Colors.black54)),
      ),
    );
  }
}

// ---------------------
// Multiple choice (notifie parent)
// ---------------------
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
      if (selectedOption == option) {
        // désélectionne si on tape la même option
        selectedOption = null;
      } else {
        selectedOption = option;
      }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.options.map((option) {
          final bool isSelected = option == selectedOption;
          return GestureDetector(
            onTap: () => _onTapOption(option),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightPurple : AppColors.veryLightPurple,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? AppColors.primaryPurple : Colors.transparent, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? AppColors.primaryPurple : Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(child: Text(option, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primaryPurple : Colors.black))),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------
// Matching question (notifie parent une fois toutes les cases remplies, dynamique si on efface une case)
// ---------------------
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
      } else {
        // si tout est plein, on peut remplacer la dernière ou ignorer — ici on ignore
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // gauche
              Expanded(
                child: Column(
                  children: widget.leftOptions.map((text) {
                    return Column(
                      children: [
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColors.veryLightPurple, borderRadius: BorderRadius.circular(10)),
                          child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        // spacing handled below in map
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              // droite (slots) : cliquable pour effacer
              Expanded(
                child: Column(
                  children: List.generate(widget.leftOptions.length, (index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (selectedAnswers[index] != null) {
                              _clearSlot(index);
                            }
                          },
                          child: DottedBorder(
                            color: AppColors.primaryPurple,
                            dashPattern: const [5, 3],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Text(
                                selectedAnswers[index] ?? 'Cliquez sur la réponse',
                                style: TextStyle(fontSize: 14, color: selectedAnswers[index] != null ? Colors.black : AppColors.primaryPurple),
                              ),
                            ),
                          ),
                        ),
                        if (index != widget.leftOptions.length - 1) const SizedBox(height: 12),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.bottomOptions.map((text) {
            return GestureDetector(
              onTap: () => _selectBottom(text),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
                child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

// ---------------------
// TextEntry (notifie parent selon contenu présent / vide)
// ---------------------
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
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), hintText: 'Votre réponse'),
      ),
    );
  }
}
