import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/exercice/resultat.dart';


// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorCheck = Color(0xFF32C832);  // Vert pour icône de validation
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair pour les bords non sélectionnés
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une question
class Question {
  final String text;
  final List<String> options;
  // Index de la réponse sélectionnée par l'utilisateur (null si non sélectionné)
  int? selectedOptionIndex; 

  Question({
    required this.text, 
    required this.options, 
    this.selectedOptionIndex,
  });
}

class QuizScreen extends StatefulWidget {
  final String exerciseTitle;
  
  // Constructeur, ex: QuizScreen(exerciseTitle: 'Algèbre de base')
  const QuizScreen({super.key, required this.exerciseTitle});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Liste des questions simulées
  final List<Question> _questions = [
    Question(
      text: "Quelle est la valeur de 'x' dans l'équation : 2x+3=12 ?",
      options: ['X=3', 'X=4', 'X=5'],
      selectedOptionIndex: 1, // Simule que X=4 est la réponse sélectionnée
    ),
    Question(
      text: "Simplifiez l'expression : 3(x+2)-2x",
      options: ['x+6', '5x+6', 'x-6'],
      selectedOptionIndex: 2, // Simule que x-6 est la réponse sélectionnée
    ),
    // Ajoutez d'autres questions si nécessaire
    Question(
      text: "Question 3 : La racine carrée de 144 est :",
      options: ['10', '12', '14'],
      selectedOptionIndex: null, // Non sélectionné
    ),
  ];
  
  // Progression actuelle (simulée : 6/10 questions)
  int _currentQuestionCount = 6;
  final int _totalQuestionCount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // 1. App Bar personnalisé (avec titre dynamique)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // 3. Barre de Progression
                  _buildProgressionBar(),
                  
                  const SizedBox(height: 20),
                  
                  // 4. Liste des Questions
                  _buildQuestionsList(),
                  
                  const SizedBox(height: 30),

                  // 5. Bouton Soumettre
                  _buildSubmitButton(context),
                  
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Titre de la page (Nom de l'exercice ou de la matière)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.exerciseTitle, // Titre de l'exercice
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressionBar() {
    double progressValue = _currentQuestionCount / _totalQuestionCount;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progression',
          style: const TextStyle(
            color: _colorBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: _colorUnselected,
            valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$_currentQuestionCount/$_totalQuestionCount questions',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: _QuestionWidget(
            questionNumber: index + 1,
            question: _questions[index],
            onOptionSelected: (int selectedIndex) {
              setState(() {
                _questions[index].selectedOptionIndex = selectedIndex;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
         context,
          MaterialPageRoute(builder: (context) => const QuizScreen()),
           );
          // Logique de soumission de l'exercice ici
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exercice soumis !')),
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
          'Soumettre l\'exercice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET DE QUESTION (COMPOSANT) ---
// -------------------------------------------------------------------

class _QuestionWidget extends StatelessWidget {
  final int questionNumber;
  final Question question;
  final Function(int) onOptionSelected;

  const _QuestionWidget({
    required this.questionNumber,
    required this.question,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question $questionNumber : ${question.text}',
          style: const TextStyle(
            color: _colorBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 15),
        
        // Liste des options de réponse
        ...question.options.asMap().entries.map((entry) {
          int optionIndex = entry.key;
          String optionText = entry.value;
          bool isSelected = question.selectedOptionIndex == optionIndex;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: InkWell(
              onTap: () => onOptionSelected(optionIndex),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: isSelected ? _purpleMain.withOpacity(0.05) : Colors.white,
                  border: Border.all(
                    color: isSelected ? _purpleMain : _colorUnselected,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionText,
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                    // Bouton Radio personnalisé (cercle)
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
            ),
          );
        }).toList(),
      ],
    );
  }
}
