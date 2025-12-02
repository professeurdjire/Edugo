import 'package:flutter/material.dart';

/// Widget d'appariement par glisser-déposer amélioré
/// Affiche des cartes à gauche (questions) et des réponses à droite
/// Permet le glisser-déposer ou le clic pour associer les réponses

class DragAndDropMatching extends StatefulWidget {
  final List<String> leftItems;
  final List<String> rightItems;
  final Map<String, String> correctMatches;
  final Function(bool) onMatchComplete;
  final Color primaryColor;

  const DragAndDropMatching({
    Key? key,
    required this.leftItems,
    required this.rightItems,
    required this.correctMatches,
    required this.onMatchComplete,
    this.primaryColor = const Color(0xFF6C63FF),
  }) : super(key: key);

  @override
  _DragAndDropMatchingState createState() => _DragAndDropMatchingState();
}

class _DragAndDropMatchingState extends State<DragAndDropMatching> {
  late List<String?> matchedAnswers;
  late List<String> availableAnswers;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    matchedAnswers = List.filled(widget.leftItems.length, null);
    availableAnswers = List.from(widget.rightItems);
  }

  void _onDragAccept(String answer, int questionIndex) {
    setState(() {
      // Si une réponse était déjà associée à cette question, on la remet dans les réponses disponibles
      if (matchedAnswers[questionIndex] != null) {
        availableAnswers.add(matchedAnswers[questionIndex]!);
      }
      
      // On associe la nouvelle réponse à la question
      matchedAnswers[questionIndex] = answer;
      availableAnswers.remove(answer);
      
      // Vérifier si tout est complété
      isComplete = !matchedAnswers.contains(null);
      widget.onMatchComplete(isComplete);
    });
  }
  
  void _onAnswerTap(String answer) {
    // Trouver le premier slot vide ou le slot actuel de cette réponse
    int? existingIndex;
    for (int i = 0; i < matchedAnswers.length; i++) {
      if (matchedAnswers[i] == answer) {
        existingIndex = i;
        break;
      }
    }
    
    setState(() {
      if (existingIndex != null) {
        // Si la réponse est déjà utilisée, on la retire
        availableAnswers.add(matchedAnswers[existingIndex]!);
        matchedAnswers[existingIndex] = null;
      } else {
        // Sinon, on l'ajoute au premier slot vide
        final firstEmptyIndex = matchedAnswers.indexOf(null);
        if (firstEmptyIndex != -1) {
          matchedAnswers[firstEmptyIndex] = answer;
          availableAnswers.remove(answer);
        }
      }
      
      // Vérifier si tout est complété
      isComplete = !matchedAnswers.contains(null);
      widget.onMatchComplete(isComplete);
    });
  }

  // Méthode pour obtenir une couleur aléatoire pour le style
  Color _getRandomColor(String text) {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
    ];
    final index = text.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Faites glisser ou cliquez sur les réponses pour les associer aux questions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonne des questions (gauche)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.leftItems.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionCard(index);
                  },
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Colonne des réponses (droite)
              Expanded(
                child: _buildAnswerOptions(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int questionIndex) {
    final question = widget.leftItems[questionIndex];
    final matchedAnswer = matchedAnswers[questionIndex];
    final color = _getRandomColor(question);
    
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: matchedAnswer != null 
                ? color.withOpacity(0.3)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: matchedAnswer != null 
                  ? color
                  : Colors.grey.shade300,
              width: matchedAnswer != null ? 2 : 1,
            ),
            boxShadow: [
              if (candidateData.isNotEmpty)
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (matchedAnswer != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    matchedAnswer,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (answer) => _onDragAccept(answer, questionIndex),
    );
  }

  Widget _buildAnswerOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: availableAnswers.map((answer) {
        final color = _getRandomColor(answer);
        
        return Draggable<String>(
          data: answer,
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildAnswerChip(answer, true),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onAnswerTap(answer),
              borderRadius: BorderRadius.circular(20),
              child: _buildAnswerChip(answer, false),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnswerChip(String answer, bool isDragging) {
    final color = _getRandomColor(answer);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDragging ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: isDragging ? 2 : 1.5,
        ),
        boxShadow: [
          if (!isDragging)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Text(
        answer,
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: isDragging ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}
