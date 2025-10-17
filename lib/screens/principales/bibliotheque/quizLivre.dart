import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorSuccess = Color(0xFF32C832); // Vert pour la bonne réponse
const Color _colorUnselected = Color(0xFFE0E0E0); // Gris clair pour les bords non sélectionnés
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une question de quiz
class QuizQuestion {
  final String text;
  final List<String> options;
  final String correctAnswer; // La bonne réponse pour l'affichage immédiat
  
  // Index de la réponse sélectionnée par l'utilisateur (null si non sélectionné)
  int? selectedOptionIndex; 

  QuizQuestion({
    required this.text, 
    required this.options, 
    required this.correctAnswer, 
    this.selectedOptionIndex,
  });
  
  bool get isAnswered => selectedOptionIndex != null;
  bool get isCorrect {
    if (!isAnswered) return false;
    return options[selectedOptionIndex!] == correctAnswer;
  }
}

class BookQuizScreen extends StatefulWidget {
  final String quizTitle;
  
  // Constructeur, ex: BookQuizScreen(quizTitle: 'Le jardin Invisible Quiz')
  const BookQuizScreen({super.key, this.quizTitle = 'Quiz'});

  @override
  State<BookQuizScreen> createState() => _BookQuizScreenState();
}

class _BookQuizScreenState extends State<BookQuizScreen> {
  // Liste des questions simulées
  final List<QuizQuestion> _allQuestions = [
    QuizQuestion(
      text: "Qui est l'acteur principale de ce livre ?",
      options: ['Alfred', 'Albert', 'Guyard'],
      correctAnswer: 'Alfred',
      selectedOptionIndex: 0, // Simule que "Alfred" a été sélectionné
    ),
    QuizQuestion(
      text: "En quelle année l'histoire débute-t-elle ?",
      options: ['2007', '2021', '2010'],
      correctAnswer: '2021',
      selectedOptionIndex: null,
    ),
    // ... plus de questions
  ];
  
  // Index de la question actuellement affichée (basé sur l'image, c'est la première)
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _allQuestions[_currentQuestionIndex];
    final int totalQuestions = _allQuestions.length;
    
    return Scaffold(
      backgroundColor: Colors.white,
      
      // La barre de navigation inférieure est fixe
      bottomNavigationBar: _buildBottomNavBar(),

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
                  
                  // 3. Barre de Progression
                  _buildProgressionBar(totalQuestions),
                  
                  const SizedBox(height: 20),
                  
                  // 4. Contenu de la Question
                  _buildQuestionContent(currentQuestion),
                  
                  const SizedBox(height: 30),
                  
                ],
              ),
            ),
          ),
          
          // 5. Bouton Suivant (placé en bas de la colonne principale)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: _buildNextButton(context, totalQuestions),
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
            // Barre de Statut (simulée)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20 : 20', style: TextStyle(color: _colorBlack, fontSize: 15, fontWeight: FontWeight.w700)),
                Icon(Icons.circle, color: _colorBlack, size: 10),
                Row(
                  children: [
                    Icon(Icons.wifi, color: _colorBlack, size: 20),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, color: _colorBlack, size: 20),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Titre de la page
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.quizTitle, 
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
  
  Widget _buildProgressionBar(int totalQuestions) {
    // 1/2 questions répondues (simulé)
    double progressValue = (_currentQuestionIndex + 1) / totalQuestions;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // La barre de progression
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
          '${_currentQuestionIndex + 1}/$totalQuestions questions répondues',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent(QuizQuestion currentQuestion) {
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
            'Question ${_currentQuestionIndex + 1}/${_allQuestions.length}',
            style: const TextStyle(
              color: _purpleMain,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            currentQuestion.text,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 20),
          
          // Liste des options de réponse
          ...currentQuestion.options.asMap().entries.map((entry) {
            int optionIndex = entry.key;
            String optionText = entry.value;
            bool isSelected = currentQuestion.selectedOptionIndex == optionIndex;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _QuizOption(
                text: optionText,
                isSelected: isSelected,
                isAnswered: currentQuestion.isAnswered,
                onTap: () {
                  if (!currentQuestion.isAnswered) {
                    setState(() {
                      currentQuestion.selectedOptionIndex = optionIndex;
                    });
                  }
                },
              ),
            );
          }).toList(),
          
          const SizedBox(height: 10),

          // Affichage de la correction (si répondu)
          if (currentQuestion.isAnswered)
            Row(
              children: [
                Icon(
                  Icons.check_circle, 
                  color: _colorSuccess, 
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bonne réponse : ${currentQuestion.correctAnswer}',
                  style: const TextStyle(
                    color: _colorSuccess,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, int totalQuestions) {
    final currentQuestion = _allQuestions[_currentQuestionIndex];
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: currentQuestion.isAnswered ? () {
          // Logique pour passer à la question suivante ou terminer
          if (_currentQuestionIndex < totalQuestions - 1) {
            setState(() {
              _currentQuestionIndex++;
            });
          } else {
            // Afficher les résultats
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quiz Terminé !')),
            );
          }
        } : null, // Désactivé si non répondu
        style: ElevatedButton.styleFrom(
          backgroundColor: _purpleMain,
          disabledBackgroundColor: _purpleMain.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Text(
          _currentQuestionIndex < totalQuestions - 1 ? 'Suivant' : 'Voir les résultats',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    // Le code du BottomNavigationBar
    return Container(
      height: 70, 
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(icon: Icons.home, label: 'Accueil'),
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque', isSelected: true), // Bibliothèque est actif
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge'),
          _NavBarItem(icon: Icons.checklist, label: 'Exercice'),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET D'OPTION DE QUIZ (COMPOSANT) ---
// -------------------------------------------------------------------

class _QuizOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final VoidCallback onTap;

  const _QuizOption({
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Détermine la couleur du contour et du fond
    Color borderColor = isSelected ? _purpleMain : Colors.grey.shade300;
    Color bgColor = isSelected ? _purpleMain.withOpacity(0.1) : Colors.white;

    return InkWell(
      onTap: isAnswered ? null : onTap, // Désactiver le tap après avoir répondu
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
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
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavBarItem({required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? _purpleMain : _colorBlack,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? _purpleMain : _colorBlack,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}