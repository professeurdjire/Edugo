import 'package:flutter/material.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_possible.dart';
import 'package:built_collection/built_collection.dart';

/// Widget dynamique qui s'adapte automatiquement au type de question
class DynamicQuestionWidget extends StatelessWidget {
  final Question question;
  final Function(int questionId, dynamic answer) onAnswerChanged;
  final Map<int, dynamic> selectedAnswers; // questionId -> answer (varie selon le type)
  final bool isReadOnly; // Pour l'affichage des résultats
  final Color primaryColor;

  const DynamicQuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerChanged,
    required this.selectedAnswers,
    this.isReadOnly = false,
    this.primaryColor = const Color(0xFFA885D8),
  }) : super(key: key);

  /// Détermine le type de question à partir de libelleType
  String _getQuestionType() {
    final typeLibelle = question.type?.libelleType?.toUpperCase() ?? '';
    
    // Normaliser les différents formats possibles
    if (typeLibelle.contains('QCM') || 
        typeLibelle.contains('CHOIX MULTIPLE') || 
        typeLibelle.contains('MULTIPLE')) {
      return 'QCM';
    } else if (typeLibelle.contains('VRAI') || 
               typeLibelle.contains('FAUX') || 
               typeLibelle.contains('TRUE') || 
               typeLibelle.contains('FALSE')) {
      return 'VRAI_FAUX';
    } else if (typeLibelle.contains('COURT') || 
               typeLibelle.contains('TEXT') || 
               typeLibelle.contains('LIBRE')) {
      return 'REPONSE_COURTE';
    } else if (typeLibelle.contains('APPARIEMENT') || 
               typeLibelle.contains('MATCHING') || 
               typeLibelle.contains('ASSOCIATION')) {
      return 'APPARIEMENT';
    }
    
    // Par défaut, si on a des réponses possibles, c'est un QCM
    if (question.reponsesPossibles != null && question.reponsesPossibles!.isNotEmpty) {
      // Si seulement 2 réponses et ce sont Vrai/Faux, c'est Vrai/Faux
      if (question.reponsesPossibles!.length == 2) {
        final reponses = question.reponsesPossibles!.map((r) => r.libelleReponse?.toUpperCase() ?? '').toList();
        if (reponses.any((r) => r.contains('VRAI')) && reponses.any((r) => r.contains('FAUX'))) {
          return 'VRAI_FAUX';
        }
      }
      return 'QCM';
    }
    
    return 'REPONSE_COURTE'; // Par défaut
  }

  @override
  Widget build(BuildContext context) {
    final questionType = _getQuestionType();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enoncé de la question
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getTypeLabel(questionType),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.enonce ?? 'Question sans énoncé',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (question.points != null) ...[
              const SizedBox(height: 8),
              Text(
                '${question.points} points',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            
            // Widget spécifique selon le type
            _buildQuestionWidget(questionType),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'QCM':
        return 'Choix Multiple';
      case 'VRAI_FAUX':
        return 'Vrai / Faux';
      case 'REPONSE_COURTE':
        return 'Réponse Courte';
      case 'APPARIEMENT':
        return 'Appariement';
      default:
        return 'Question';
    }
  }

  Widget _buildQuestionWidget(String questionType) {
    switch (questionType) {
      case 'QCM':
        return _buildMultipleChoiceWidget();
      case 'VRAI_FAUX':
        return _buildTrueFalseWidget();
      case 'REPONSE_COURTE':
        return _buildShortAnswerWidget();
      case 'APPARIEMENT':
        return _buildMatchingWidget();
      default:
        return const Text('Type de question non supporté');
    }
  }

  /// Widget pour les questions à choix multiples
  Widget _buildMultipleChoiceWidget() {
    final reponsesList = question.reponsesPossibles;
    if (reponsesList == null || reponsesList.isEmpty) {
      return const Text('Aucune réponse disponible');
    }
    final reponses = reponsesList;
    final selectedIds = selectedAnswers[question.id] as List<int>? ?? [];
    
    return Column(
      children: reponses.map((reponse) {
        final isSelected = selectedIds.contains(reponse.id);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? primaryColor.withOpacity(0.05) : Colors.transparent,
          ),
          child: CheckboxListTile(
            title: Text(
              reponse.libelleReponse ?? '',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            value: isSelected,
            onChanged: isReadOnly
                ? null
                : (bool? value) {
                    if (value != null && reponse.id != null) {
                      final newSelectedIds = List<int>.from(selectedIds);
                      if (value && !newSelectedIds.contains(reponse.id)) {
                        newSelectedIds.add(reponse.id!);
                      } else if (!value && newSelectedIds.contains(reponse.id)) {
                        newSelectedIds.remove(reponse.id);
                      }
                      onAnswerChanged(question.id!, newSelectedIds);
                    }
                  },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: primaryColor,
          ),
        );
      }).toList(),
    );
  }

  /// Widget pour les questions Vrai/Faux
  Widget _buildTrueFalseWidget() {
    final reponsesList = question.reponsesPossibles;
    if (reponsesList == null || reponsesList.isEmpty) {
      return const Text('Aucune réponse disponible');
    }
    final reponses = reponsesList;
    final selectedId = selectedAnswers[question.id] as int?;
    
    // Trouver les réponses Vrai et Faux
    ReponsePossible? vraiReponse;
    ReponsePossible? fauxReponse;
    
    for (var reponse in reponses) {
      final libelle = reponse.libelleReponse?.toUpperCase() ?? '';
      if (libelle.contains('VRAI') || libelle.contains('TRUE')) {
        vraiReponse = reponse;
      } else if (libelle.contains('FAUX') || libelle.contains('FALSE')) {
        fauxReponse = reponse;
      }
    }
    
    // Si on n'a pas trouvé Vrai/Faux, utiliser les deux premières réponses
    if (vraiReponse == null || fauxReponse == null) {
      if (reponses.length >= 2) {
        vraiReponse = reponses[0];
        fauxReponse = reponses[1];
      }
    }
    
    return Row(
      children: [
        Expanded(
          child: _buildTrueFalseOption(
            reponse: vraiReponse,
            label: 'Vrai',
            isSelected: selectedId == vraiReponse?.id,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTrueFalseOption(
            reponse: fauxReponse,
            label: 'Faux',
            isSelected: selectedId == fauxReponse?.id,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseOption({
    required ReponsePossible? reponse,
    required String label,
    required bool isSelected,
    required Color color,
  }) {
    if (reponse == null) return const SizedBox.shrink();
    
    return GestureDetector(
      onTap: isReadOnly ? null : () {
        onAnswerChanged(question.id!, reponse.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? color : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour les réponses courtes
  Widget _buildShortAnswerWidget() {
    final currentAnswer = selectedAnswers[question.id] as String? ?? '';
    
    return TextField(
      enabled: !isReadOnly,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Tapez votre réponse ici...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      controller: TextEditingController(text: currentAnswer)
        ..selection = TextSelection.collapsed(offset: currentAnswer.length),
      onChanged: isReadOnly
          ? null
          : (value) {
              onAnswerChanged(question.id!, value);
            },
    );
  }

  /// Widget pour les questions d'appariement
  Widget _buildMatchingWidget() {
    final reponsesList = question.reponsesPossibles;
    if (reponsesList == null || reponsesList.isEmpty) {
      return const Text('Aucune réponse disponible pour l\'appariement');
    }
    final reponses = reponsesList;
    final matches = selectedAnswers[question.id] as Map<int, int>? ?? {};
    
    // Pour l'appariement, on suppose que les réponses sont organisées en paires
    // ou qu'on a deux listes à faire correspondre
    // Format attendu: Map<leftItemId, rightItemId>
    
    // Diviser les réponses en deux groupes (gauche et droite)
    // Pour simplifier, on prend la moitié pour chaque côté
    final midPoint = (reponses.length / 2).ceil();
    final leftItems = reponses.take(midPoint).toList();
    final rightItems = reponses.skip(midPoint).toList();
    
    return Column(
      children: [
        const Text(
          'Faites correspondre les éléments de gauche avec ceux de droite',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),
        ...leftItems.asMap().entries.map((entry) {
          final index = entry.key;
          final leftItem = entry.value;
          final selectedRightId = matches[leftItem.id];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Élément de gauche
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      leftItem.libelleReponse ?? 'Item ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                const SizedBox(width: 12),
                // Menu déroulant pour la sélection
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedRightId != null ? primaryColor : Colors.grey.shade300,
                        width: selectedRightId != null ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      value: selectedRightId,
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text('Sélectionner...'),
                      items: rightItems.map((rightItem) {
                        return DropdownMenuItem<int>(
                          value: rightItem.id,
                          child: Text(rightItem.libelleReponse ?? ''),
                        );
                      }).toList(),
                      onChanged: isReadOnly
                          ? null
                          : (value) {
                              if (value != null) {
                                final newMatches = Map<int, int>.from(matches);
                                // Retirer l'ancienne correspondance si elle existe
                                newMatches.removeWhere((k, v) => v == value && k != leftItem.id);
                                newMatches[leftItem.id!] = value;
                                onAnswerChanged(question.id!, newMatches);
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

