import 'package:flutter/material.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_possible.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:built_collection/built_collection.dart';

class QuizResultScreen extends StatefulWidget {
  final SubmitResultResponse result;
  final String title;
  final List<Question>? questions;
  final Map<int, dynamic>? selectedAnswers;
  
  const QuizResultScreen({
    Key? key,
    required this.result,
    required this.title,
    this.questions,
    this.selectedAnswers,
  }) : super(key: key);
  
  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  final EleveService _eleveService = EleveService();
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  
  @override
  void initState() {
    super.initState();
    // Recharger les points après avoir affiché le résultat
    _refreshPoints();
  }
  
  Future<void> _refreshPoints() async {
    final eleveId = widget.result.eleveId;
    if (eleveId != null) {
      try {
        final points = await _eleveService.getElevePoints(eleveId);
        // Mettre à jour le profil dans AuthService
        final eleve = await _eleveService.getEleveProfile(eleveId);
        if (eleve != null) {
          _authService.setCurrentEleve(eleve);
        }
      } catch (e) {
        print('Error refreshing points: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scorePercentage = widget.result.totalPoints > 0 
        ? (widget.result.score / widget.result.totalPoints) * 100 
        : 0.0;
    final bool isPassed = scorePercentage >= 50; // Assuming 50% is the pass mark
    
    // Les points gagnés correspondent au score du quiz
    // ⚠️ IMPORTANT: Les points ont déjà été ajoutés par SubmissionService
    final int pointsGagnes = widget.result.score;
    
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
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
                    '${widget.result.score}/${widget.result.totalPoints} points',
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
                  if (pointsGagnes > 0)
                    Text(
                      '+$pointsGagnes points gagnés !',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 5),
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
                itemCount: widget.result.details.length,
                itemBuilder: (context, index) {
                  final detail = widget.result.details[index];
                  // Trouver la question correspondante
                  final question = widget.questions?.firstWhere(
                    (q) => q.id == detail.questionId,
                    orElse: () => Question((b) => b..id = detail.questionId),
                  );
                  final selectedAnswer = widget.selectedAnswers?[detail.questionId];
                  return _buildResultItem(detail, question, selectedAnswer);
                },
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildResultItem(DetailResultat detail, Question? question, dynamic selectedAnswer) {
    // Trouver les bonnes réponses
    final correctAnswers = question?.reponsesPossibles
        ?.where((r) => r.estCorrecte == true)
        .toList() ?? [];
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: detail.correct ? const Color(0xFF32C832) : const Color(0xFFE74C3C),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône et points
            Row(
              children: [
                Icon(
                  detail.correct ? Icons.check_circle : Icons.cancel,
                  color: detail.correct ? const Color(0xFF32C832) : const Color(0xFFE74C3C),
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question?.enonce ?? 'Question ${detail.questionId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: detail.correct ? const Color(0xFF32C832).withOpacity(0.1) : const Color(0xFFE74C3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${detail.points} pts',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: detail.correct ? const Color(0xFF32C832) : const Color(0xFFE74C3C),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Réponse de l'élève
            if (selectedAnswer != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Votre réponse:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatAnswer(selectedAnswer, question),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // Bonnes réponses (si la question est ratée)
            if (!detail.correct && correctAnswers.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF32C832).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF32C832),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Color(0xFF32C832),
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Bonne réponse:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF32C832),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...correctAnswers.map((answer) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: Color(0xFF32C832),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              answer.libelleReponse ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF32C832),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  String _formatAnswer(dynamic answer, Question? question) {
    if (answer == null) return 'Aucune réponse';
    
    if (answer is List<int>) {
      // QCM: afficher les libellés des réponses sélectionnées
      if (question?.reponsesPossibles != null) {
        final selectedLabels = answer.map((id) {
          final reponse = question!.reponsesPossibles!.firstWhere(
            (r) => r.id == id,
            orElse: () => ReponsePossible((b) => b..id = id),
          );
          return reponse.libelleReponse ?? 'Réponse $id';
        }).join(', ');
        return selectedLabels;
      }
      return answer.join(', ');
    } else if (answer is int) {
      // QCU/VRAI_FAUX: afficher le libellé de la réponse sélectionnée
      if (question?.reponsesPossibles != null) {
        final reponse = question!.reponsesPossibles!.firstWhere(
          (r) => r.id == answer,
          orElse: () => ReponsePossible((b) => b..id = answer),
        );
        return reponse.libelleReponse ?? 'Réponse $answer';
      }
      return 'Réponse $answer';
    } else if (answer is String) {
      return answer;
    } else if (answer is Map<int, int>) {
      // Appariement: afficher les correspondances
      return answer.entries.map((e) => '${e.key} → ${e.value}').join(', ');
    }
    
    return answer.toString();
  }
}