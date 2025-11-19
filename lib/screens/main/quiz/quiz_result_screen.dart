import 'package:flutter/material.dart';
import 'package:edugo/models/submit_result_response.dart';

class QuizResultScreen extends StatelessWidget {
  final SubmitResultResponse result;
  final String title;
  
  const QuizResultScreen({
    Key? key,
    required this.result,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scorePercentage = (result.score / result.totalPoints) * 100;
    final bool isPassed = scorePercentage >= 50; // Assuming 50% is the pass mark
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFA885D8),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score summary card
            Container(
              decoration: BoxDecoration(
                color: isPassed ? const Color(0xFF32C832) : const Color(0xFFE74C3C),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Résultat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${result.score}/${result.totalPoints} points',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${scorePercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isPassed ? 'Félicitations !' : 'Continuez à réviser',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Detailed results
            const Text(
              'Détails des réponses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            Expanded(
              child: ListView.builder(
                itemCount: result.details.length,
                itemBuilder: (context, index) {
                  final detail = result.details[index];
                  return _buildResultItem(detail);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResultItem(detail) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          detail.correct ? Icons.check_circle : Icons.cancel,
          color: detail.correct ? const Color(0xFF32C832) : const Color(0xFFE74C3C),
          size: 30,
        ),
        title: Text('Question ${detail.questionId}'),
        trailing: Text(
          '${detail.points} pts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: detail.correct ? const Color(0xFF32C832) : const Color(0xFFE74C3C),
          ),
        ),
      ),
    );
  }
}