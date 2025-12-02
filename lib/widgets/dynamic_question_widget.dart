import 'package:flutter/material.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_possible.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/services/question_service.dart';

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

  /// Widget pour les questions d'appariement avec drag and drop
  Widget _buildMatchingWidget() {
    final reponsesList = question.reponsesPossibles;
    if (reponsesList == null || reponsesList.isEmpty) {
      return const Text('Aucune réponse disponible pour l\'appariement');
    }
    final reponses = reponsesList;
    final matches = selectedAnswers[question.id] as Map<int, int>? ?? {};
    
    // Séparer les réponses selon le champ colonne (GAUCHE/DROITE)
    // Utiliser les métadonnées stockées dans QuestionService
    final leftItems = <ReponsePossible>[];
    final rightItems = <ReponsePossible>[];
    
    print('[DynamicQuestionWidget] 🔍 Separating ${reponses.length} responses by colonne...');
    print('[DynamicQuestionWidget] Question ID: ${question.id}, Type: ${question.type?.libelleType}');
    
    for (var reponse in reponses) {
      if (reponse.id != null) {
        final metadata = QuestionService.getMatchingMetadata(reponse.id!);
        final colonne = metadata?['colonne'] as String?;
        final idAssocie = metadata?['idAssocie'] as int?;
        final libelle = reponse.libelleReponse ?? 'Sans libellé';
        
        print('[DynamicQuestionWidget] 📋 Response ID ${reponse.id}: libelle="$libelle"');
        print('[DynamicQuestionWidget]    Metadata: colonne=$colonne, idAssocie=$idAssocie');
        
        if (colonne != null && colonne.toString().isNotEmpty) {
          final colonneUpper = colonne.toString().toUpperCase().trim();
          if (colonneUpper == 'GAUCHE') {
            leftItems.add(reponse);
            print('[DynamicQuestionWidget] ✅ Added to LEFT: "$libelle" (ID: ${reponse.id}, idAssocie: $idAssocie)');
          } else if (colonneUpper == 'DROITE') {
            rightItems.add(reponse);
            print('[DynamicQuestionWidget] ✅ Added to RIGHT: "$libelle" (ID: ${reponse.id}, idAssocie: $idAssocie)');
          } else {
            print('[DynamicQuestionWidget] ⚠️ Unknown colonne value: "$colonne" for "$libelle"');
          }
        } else {
          print('[DynamicQuestionWidget] ⚠️ No colonne metadata for response ${reponse.id}: "$libelle"');
          print('[DynamicQuestionWidget]    Metadata map: $metadata');
        }
      } else {
        print('[DynamicQuestionWidget] ⚠️ Response has no ID: ${reponse.libelleReponse}');
      }
    }
    
    // Si aucune métadonnée de colonne n'est trouvée, utiliser l'ancienne méthode (diviser en deux)
    if (leftItems.isEmpty && rightItems.isEmpty) {
      print('[DynamicQuestionWidget] ⚠️ No colonne metadata found, using fallback: dividing in half');
      final midPoint = (reponses.length / 2).ceil();
      leftItems.addAll(reponses.take(midPoint).toList());
      rightItems.addAll(reponses.skip(midPoint).toList());
      print('[DynamicQuestionWidget] Fallback: ${leftItems.length} left, ${rightItems.length} right');
    } else {
      print('[DynamicQuestionWidget] ✅ Successfully separated: ${leftItems.length} left, ${rightItems.length} right');
      // Afficher le contenu de chaque colonne AVANT mélange
      print('[DynamicQuestionWidget] LEFT items (original order): ${leftItems.map((r) => r.libelleReponse).toList()}');
      print('[DynamicQuestionWidget] RIGHT items (original order): ${rightItems.map((r) => r.libelleReponse).toList()}');
    }
    
    // 🔀 MÉLANGER l'ordre des réponses de droite pour que l'élève doive faire les bonnes associations
    // L'ordre de gauche reste inchangé, mais l'ordre de droite est randomisé
    final shuffledRightItems = List<ReponsePossible>.from(rightItems);
    shuffledRightItems.shuffle();
    print('[DynamicQuestionWidget] 🔀 Shuffled RIGHT items: ${shuffledRightItems.map((r) => r.libelleReponse).toList()}');
    
    return _MatchingDragAndDropWidget(
      leftItems: leftItems,
      rightItems: shuffledRightItems, // Utiliser la version mélangée
      matches: matches,
      onMatchChanged: (newMatches) {
        onAnswerChanged(question.id!, newMatches);
      },
      isReadOnly: isReadOnly,
      primaryColor: primaryColor,
    );
  }
}

/// Widget de drag and drop pour les questions d'appariement
class _MatchingDragAndDropWidget extends StatefulWidget {
  final List<ReponsePossible> leftItems;
  final List<ReponsePossible> rightItems;
  final Map<int, int> matches; // Map<leftItemId, rightItemId>
  final Function(Map<int, int>) onMatchChanged;
  final bool isReadOnly;
  final Color primaryColor;

  const _MatchingDragAndDropWidget({
    required this.leftItems,
    required this.rightItems,
    required this.matches,
    required this.onMatchChanged,
    this.isReadOnly = false,
    this.primaryColor = const Color(0xFFA885D8),
  });

  @override
  State<_MatchingDragAndDropWidget> createState() => _MatchingDragAndDropWidgetState();
}

class _MatchingDragAndDropWidgetState extends State<_MatchingDragAndDropWidget> {
  late Map<int, int> _currentMatches; // Map<leftItemId, rightItemId>
  late List<ReponsePossible> _availableRightItems;

  @override
  void initState() {
    super.initState();
    _currentMatches = Map<int, int>.from(widget.matches);
    _updateAvailableItems();
  }

  void _updateAvailableItems() {
    // Les items de droite disponibles sont ceux qui ne sont pas encore associés
    final usedRightIds = _currentMatches.values.toSet();
    _availableRightItems = widget.rightItems
        .where((item) => !usedRightIds.contains(item.id))
        .toList();
  }

  void _onDragAccept(ReponsePossible rightItem, int leftItemId) {
    if (widget.isReadOnly) return;

    setState(() {
      // Si cette question avait déjà une réponse, on la remet dans les disponibles
      final oldRightId = _currentMatches[leftItemId];
      if (oldRightId != null) {
        final oldItem = widget.rightItems.firstWhere(
          (item) => item.id == oldRightId,
          orElse: () => widget.rightItems.first,
        );
        if (!_availableRightItems.contains(oldItem)) {
          _availableRightItems.add(oldItem);
        }
      }

      // Associer la nouvelle réponse
      _currentMatches[leftItemId] = rightItem.id!;
      _availableRightItems.remove(rightItem);

      // Notifier le changement
      widget.onMatchChanged(Map<int, int>.from(_currentMatches));
    });
  }

  void _onRightItemTap(ReponsePossible rightItem) {
    if (widget.isReadOnly) return;

    // Trouver le premier slot gauche vide ou celui qui a déjà cette réponse
    int? targetLeftId;
    for (var entry in _currentMatches.entries) {
      if (entry.value == rightItem.id) {
        targetLeftId = entry.key;
        break;
      }
    }

    if (targetLeftId == null) {
      // Trouver le premier slot gauche vide
      for (var leftItem in widget.leftItems) {
        if (leftItem.id != null && !_currentMatches.containsKey(leftItem.id)) {
          targetLeftId = leftItem.id;
          break;
        }
      }
    }

    if (targetLeftId != null) {
      _onDragAccept(rightItem, targetLeftId);
    }
  }

  void _onLeftItemClear(int leftItemId) {
    if (widget.isReadOnly) return;

    setState(() {
      final rightId = _currentMatches[leftItemId];
      if (rightId != null) {
        final rightItem = widget.rightItems.firstWhere(
          (item) => item.id == rightId,
          orElse: () => widget.rightItems.first,
        );
        if (!_availableRightItems.contains(rightItem)) {
          _availableRightItems.add(rightItem);
        }
        _currentMatches.remove(leftItemId);
        widget.onMatchChanged(Map<int, int>.from(_currentMatches));
      }
    });
  }

  Color _getColorForItem(String text) {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
      Colors.pink.shade100,
    ];
    final index = text.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instructions minimalistes
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Glissez ou cliquez pour associer',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 450,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonne de gauche - Design moderne et épuré
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête minimaliste
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 16,
                            decoration: BoxDecoration(
                              color: widget.primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Éléments',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Liste des éléments de gauche
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.leftItems.length,
                        itemBuilder: (context, index) {
                          final leftItem = widget.leftItems[index];
                          final leftItemId = leftItem.id;
                          if (leftItemId == null) return const SizedBox.shrink();

                          final matchedRightId = _currentMatches[leftItemId];
                          final matchedRightItem = matchedRightId != null
                              ? widget.rightItems.firstWhere(
                                  (item) => item.id == matchedRightId,
                                  orElse: () => widget.rightItems.first,
                                )
                              : null;

                          final color = _getColorForItem(leftItem.libelleReponse ?? '');

                          return DragTarget<ReponsePossible>(
                            builder: (context, candidateData, rejectedData) {
                              final isHovered = candidateData.isNotEmpty;
                              final isMatched = matchedRightItem != null;
                              
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: isMatched
                                      ? widget.primaryColor.withOpacity(0.08)
                                      : isHovered
                                          ? widget.primaryColor.withOpacity(0.05)
                                          : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isMatched
                                        ? widget.primaryColor.withOpacity(0.4)
                                        : isHovered
                                            ? widget.primaryColor.withOpacity(0.6)
                                            : Colors.grey.shade200,
                                    width: isMatched || isHovered ? 1.5 : 1,
                                  ),
                                  boxShadow: isHovered
                                      ? [
                                          BoxShadow(
                                            color: widget.primaryColor.withOpacity(0.15),
                                            blurRadius: 12,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : isMatched
                                          ? [
                                              BoxShadow(
                                                color: widget.primaryColor.withOpacity(0.1),
                                                blurRadius: 8,
                                                spreadRadius: 0,
                                                offset: const Offset(0, 1),
                                              ),
                                            ]
                                          : null,
                                ),
                                child: Row(
                                  children: [
                                    // Indicateur de statut
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      width: 4,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isMatched
                                            ? widget.primaryColor
                                            : isHovered
                                                ? widget.primaryColor.withOpacity(0.5)
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Texte
                                    Expanded(
                                      child: Text(
                                        leftItem.libelleReponse ?? 'Item ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: isMatched ? FontWeight.w600 : FontWeight.w500,
                                          color: isMatched
                                              ? widget.primaryColor.withOpacity(0.9)
                                              : Colors.grey.shade800,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    // Icône de confirmation
                                    if (isMatched) ...[
                                      AnimatedScale(
                                        scale: 1.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: widget.primaryColor.withOpacity(0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check_rounded,
                                            color: widget.primaryColor,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      if (!widget.isReadOnly) ...[
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => _onLeftItemClear(leftItemId),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.red.shade400,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ],
                                ),
                              );
                            },
                            onWillAccept: (data) => !widget.isReadOnly,
                            onAccept: (rightItem) {
                              _onDragAccept(rightItem, leftItemId);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Colonne de droite - Design moderne et épuré
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête minimaliste
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Réponses',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Zone des réponses disponibles
                    Expanded(
                      child: _availableRightItems.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 48,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Toutes les réponses\nont été associées',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _availableRightItems.map((rightItem) {
                                  return Draggable<ReponsePossible>(
                                    data: rightItem,
                                    feedback: Material(
                                      elevation: 12,
                                      shadowColor: Colors.blue.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.blue.shade400,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.3),
                                              blurRadius: 16,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.drag_handle_rounded,
                                              size: 18,
                                              color: Colors.blue.shade400,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              rightItem.libelleReponse ?? '',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: Opacity(
                                      opacity: 0.2,
                                      child: _buildAnswerChip(rightItem),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _onRightItemTap(rightItem),
                                        borderRadius: BorderRadius.circular(12),
                                        child: _buildAnswerChip(rightItem),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerChip(ReponsePossible item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.drag_handle_rounded,
            size: 16,
            color: Colors.blue.shade400,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              item.libelleReponse ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

