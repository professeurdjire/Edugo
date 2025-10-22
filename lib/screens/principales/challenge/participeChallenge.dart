import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

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

// ---------------------------------------------------
// COULEURS ET CONSTANTES HARMONISÉES
// ---------------------------------------------------
class AppColors {
  static const Color primaryPurple = Color(0xFFA885D8);
  static const Color lightPurple = Color(0xFFE1BEE7);
  static const Color veryLightPurple = Color(0xFFF3E5F5);
  static const Color lightGrey = Color(0xFFE0E0E0);
}

// ---------------------------------------------------
// WIDGET PRINCIPAL
// ---------------------------------------------------
class ChallengeParticipeScreen extends StatelessWidget {
  const ChallengeParticipeScreen({super.key});

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
            const TimeProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Progression', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 8),
            ProgressIndicator(
              current: 5,
              total: 10,
              label: '5/10 questions répondues',
            ),
            const SizedBox(height: 30),
            const TrueFalseQuestionCard(
              questionIndex: 1,
              totalQuestions: 10,
              questionText: 'La somme de 2 et 3 font 5 ?',
            ),
            const SizedBox(height: 20),
            MultipleChoiceQuestionCard(
              questionIndex: 2,
              totalQuestions: 10,
              questionText: 'La somme de 2 et 3 font ?',
              options: ['4', '5', '10', '6'],
              currentValue: '5',
            ),
            const SizedBox(height: 20),
            const Text('6/10 questions', style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 20),
            MatchingQuestionCard(
              questionIndex: 3,
              totalQuestions: 10,
              questionText: 'Faites correspondre les pays à leurs capitales',
              leftOptions: ['France', 'Japon', 'Mali'],
              bottomOptions: ['Paris', 'Tokyo', 'Bamako'],
            ),
            const SizedBox(height: 20),
            TextEntryQuestionCard(
              questionIndex: 4,
              totalQuestions: 10,
              questionText: 'Quel est le résultat de 7 * 8 ?',
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
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

// ---------------------------------------------------
// WIDGETS COMMUNS
// ---------------------------------------------------
class TimeProgressIndicator extends StatelessWidget {
  const TimeProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Temps restant', style: TextStyle(fontSize: 16, color: Colors.black54)),
            Text('04 : 32', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.75,
            backgroundColor: AppColors.lightPurple,
            color: Colors.green,
            minHeight: 8,
          ),
        ),

      ],
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final String label;

  const ProgressIndicator({super.key, required this.current, required this.total, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          LinearProgressIndicator(
            value: current / total,
            backgroundColor: AppColors.lightPurple,
            color: AppColors.primaryPurple,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }
}

// ---------------------------------------------------
// QUESTION CARD DE BASE
// ---------------------------------------------------
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
      elevation: cardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Question $questionIndex/$totalQuestions', style: const TextStyle(fontSize: 14, color: AppColors.primaryPurple, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(questionText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// 1. TRUE/FALSE
// ---------------------------------------------------
class TrueFalseQuestionCard extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;

  const TrueFalseQuestionCard({super.key, required this.questionIndex, required this.totalQuestions, required this.questionText});

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: questionIndex,
      totalQuestions: totalQuestions,
      questionText: questionText,
      child: Row(
        children: [
          Expanded(child: TrueFalseButton(text: 'True', isSelected: true, onTap: () {})),
          const SizedBox(width: 15),
          Expanded(child: TrueFalseButton(text: 'False', isSelected: false, onTap: () {})),
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

// ---------------------------------------------------
// 2. MULTIPLE CHOICE
// ---------------------------------------------------
class MultipleChoiceQuestionCard extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final List<String> options;
  final String? currentValue;

  const MultipleChoiceQuestionCard({super.key, required this.questionIndex, required this.totalQuestions, required this.questionText, required this.options, this.currentValue});

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: questionIndex,
      totalQuestions: totalQuestions,
      questionText: questionText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.map((option) {
          return RadioListTile<String>(
            title: Text(option, style: const TextStyle(fontSize: 16)),
            value: option,
            groupValue: currentValue,
            onChanged: (String? value) {},
            activeColor: AppColors.primaryPurple,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------
// 3. MATCHING QUESTION
// ---------------------------------------------------
class MatchingQuestionCard extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;
  final List<String> leftOptions;
  final List<String> bottomOptions;

  const MatchingQuestionCard({
    super.key,
    required this.questionIndex,
    required this.totalQuestions,
    required this.questionText,
    required this.leftOptions,
    required this.bottomOptions,
  });

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: questionIndex,
      totalQuestions: totalQuestions,
      questionText: questionText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonnes des pays (gauche)
              Expanded(
                child: Column(
                  children: leftOptions
                      .map((text) => Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.veryLightPurple,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ))
                      .toList(),
                ),
              ),
              const SizedBox(width: 10),
              // Colonnes des zones de réponse (droite)
              Expanded(
                child: Column(
                  children: leftOptions
                      .map((text) => DottedBorder(
                    color: AppColors.primaryPurple,
                    dashPattern: const [5, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Cliquez sur la réponse', style: TextStyle(fontSize: 14, color: AppColors.primaryPurple)),
                    ),
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Chips des réponses possibles (en bas)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: bottomOptions
                .map((text) => Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black)),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}


class MatchingOptionButton extends StatelessWidget {
  final String text;
  final bool isLeft;
  final Color textColor;
  final bool useDotted;

  const MatchingOptionButton({super.key, required this.text, required this.isLeft, this.textColor = Colors.black, this.useDotted = false});

  @override
  Widget build(BuildContext context) {
    if (useDotted) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: DottedBorder(
          color: AppColors.lightGrey,
          strokeWidth: 1.5,
          dashPattern: const [5, 3],
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.white,
            child: Text(text, style: TextStyle(fontSize: 14, color: textColor)),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isLeft ? AppColors.veryLightPurple : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLeft ? Colors.transparent : AppColors.lightGrey,
              width: 1.5,
            ),
          ),
          child: Text(text, style: TextStyle(fontSize: 14, color: textColor)),
        ),
      );
    }
  }
}

// ---------------------------------------------------
// WIDGET MatchingBottomChip
// ---------------------------------------------------
class MatchingBottomChip extends StatelessWidget {
  final String text;
  const MatchingBottomChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: AppColors.primaryPurple,
    );
  }
}

// ---------------------------------------------------
// 4. TEXT ENTRY QUESTION
// ---------------------------------------------------
class TextEntryQuestionCard extends StatelessWidget {
  final int questionIndex;
  final int totalQuestions;
  final String questionText;

  const TextEntryQuestionCard({super.key, required this.questionIndex, required this.totalQuestions, required this.questionText});

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      questionIndex: questionIndex,
      totalQuestions: totalQuestions,
      questionText: questionText,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: 'Votre réponse',
        ),
      ),
    );
  }
}
