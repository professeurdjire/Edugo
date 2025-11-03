import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active/bouton)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorTimeProgress = Color(0xFF32C832); // Vert pour la barre de temps
const Color _colorTimeRemaining = Color(0xFF6A6A6A); // Gris pour le temps restant
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair pour les bords non sélectionnés
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une question de challenge
class ChallengeQuestion {
  final int id;
  final String questionText;
  final List<String> options;
  final bool isBinary; // Vrai/Faux
  int? selectedOptionIndex; // L'index de la réponse sélectionnée par l'utilisateur

  ChallengeQuestion({
    required this.id, 
    required this.questionText, 
    required this.options, 
    this.isBinary = false,
    this.selectedOptionIndex,
  });
  
  bool get isAnswered => selectedOptionIndex != null;
}

class ParticipateChallengeScreen extends StatefulWidget {
  final String challengeTitle;
  
  const ParticipateChallengeScreen({super.key, this.challengeTitle = 'Défi Mathématiques'});

  @override
  State<ParticipateChallengeScreen> createState() => _ParticipateChallengeScreenState();
}

class _ParticipateChallengeScreenState extends State<ParticipateChallengeScreen> {
  // Liste des questions simulées basées sur l'image
  final List<ChallengeQuestion> _allQuestions = [
    // Question Vrai/Faux (Question 1/10)
    ChallengeQuestion(
      id: 1,
      questionText: 'La somme de 2 et 3 font 5 ?',
      options: ['True', 'False'],
      isBinary: true,
      selectedOptionIndex: 0, // Simule que "True" est sélectionné
    ),
    // Question Choix Multiple (Question 1/10 - L'image montre la question 1 deux fois, ici simulée comme question 2)
    ChallengeQuestion(
      id: 2,
      questionText: 'La somme de 2 et 3 font ?',
      options: ['4', '5', '10', '6'],
      isBinary: false,
      selectedOptionIndex: 1, // Simule que "5" est sélectionné
    ),
    // Question suivante (pour simuler le défilement)
    ChallengeQuestion(
      id: 3,
      questionText: 'Quel est l\'aire d\'un carré de côté 4 ?',
      options: ['8', '16', '12', '4'],
      isBinary: false,
      selectedOptionIndex: null,
    ),
  ];
  
  final int _questionsAnswered = 6; // Simuler 6/10 répondues
  final int _totalQuestions = 10;
  final String _timeRemaining = '04 : 32'; // Temps restant
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // 1. App Bar personnalisé 
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // 3. Temps Restant et Barre de Progression
                  _buildTimerAndProgress(),
                  
                  const SizedBox(height: 20),
                  
                  // 4. Contenu des Questions
                  ..._allQuestions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: _ChallengeQuestionCard(
                        question: question,
                        totalQuestions: _totalQuestions,
                        onOptionSelected: (int selectedIndex) {
                          setState(() {
                            question.selectedOptionIndex = selectedIndex;
                            // Logique pour sauvegarder la réponse...
                          });
                        },
                      ),
                    );
                  }).toList(),
                  
                  // Texte de progression au bas de la zone défilante
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                    child: Text(
                      '$_questionsAnswered/$_totalQuestions questions',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 5. Bouton Suivant
          _buildNextButton(context),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
              onPressed: () => Navigator.pop(context), 
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Challenge : ${widget.challengeTitle}', 
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48), 
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimerAndProgress() {
    // Simuler le temps écoulé pour la barre (ex: 5 minutes au total)
    double timeProgressValue = 0.5; // Simuler 50% du temps restant
    double answerProgressValue = _questionsAnswered / _totalQuestions;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Temps restant
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Temps restant',
              style: TextStyle(
                color: _colorTimeRemaining,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _timeRemaining,
              style: const TextStyle(
                color: _colorTimeRemaining,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LinearProgressIndicator(
            value: timeProgressValue,
            backgroundColor: _colorUnselected,
            valueColor: const AlwaysStoppedAnimation<Color>(_colorTimeProgress),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 15),

        // Progression des questions
        const Text(
          'Progression',
          style: TextStyle(
            color: _colorTimeRemaining,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LinearProgressIndicator(
            value: answerProgressValue,
            backgroundColor: _colorUnselected,
            valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$_questionsAnswered/$_totalQuestions questions répondues',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Logique pour passer à la question suivante (dans un quiz standard) 
            // ou soumettre le challenge si toutes les questions sont répondues.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passage à la prochaine question/soumission (simulé)')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _purpleMain,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          child: const Text(
            'Suivant',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET DE CARTE DE QUESTION (COMPOSANT) ---
// -------------------------------------------------------------------

class _ChallengeQuestionCard extends StatelessWidget {
  final ChallengeQuestion question;
  final int totalQuestions;
  final Function(int) onOptionSelected;

  const _ChallengeQuestionCard({
    required this.question,
    required this.totalQuestions,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la question
          Text(
            'Question ${question.id}/$totalQuestions',
            style: const TextStyle(
              color: _purpleMain,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            question.questionText,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 20),
          
          // Options de réponse (Choix Multiple ou Binaire)
          question.isBinary
              ? _buildBinaryOptions()
              : _buildMultipleChoiceOptions(),
        ],
      ),
    );
  }
  
  Widget _buildBinaryOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: question.options.asMap().entries.map((entry) {
        int index = entry.key;
        String text = entry.value;
        bool isSelected = question.selectedOptionIndex == index;
        
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: index == 1 ? 10 : 0, right: index == 0 ? 10 : 0),
            child: _QuizOptionButton(
              text: text,
              isSelected: isSelected,
              isBinary: true,
              onTap: () => onOptionSelected(index),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildMultipleChoiceOptions() {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        int index = entry.key;
        String text = entry.value;
        bool isSelected = question.selectedOptionIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: _QuizOptionButton(
            text: text,
            isSelected: isSelected,
            isBinary: false,
            onTap: () => onOptionSelected(index),
          ),
        );
      }).toList(),
    );
  }
}

class _QuizOptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isBinary;
  final VoidCallback onTap;

  const _QuizOptionButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isBinary = false,
  });

  @override
  Widget build(BuildContext context) {
    // Style pour les options binaires (True/False)
    if (isBinary) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? _purpleMain : _colorUnselected,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? _purpleMain : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : _colorBlack,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
    
    // Style pour les options de choix multiple (avec radio button)
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? _purpleMain.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? _purpleMain : _colorUnselected,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Bouton Radio personnalisé
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _purpleMain : Colors.grey,
                  width: 1.5,
                ),
                color: isSelected ? _purpleMain : Colors.white,
              ),
              child: isSelected 
                ? const Center(child: Icon(Icons.circle, size: 8, color: Colors.white))
                : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}