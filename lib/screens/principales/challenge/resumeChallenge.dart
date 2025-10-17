import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active/bouton)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorYellow = Color(0xFFE8981A); // Couleur Jaune pour le numéro de question
const Color _colorInactiveOption = Color(0xFFF2F2F2); // Gris clair pour les fonds inactifs
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une question dans le résumé (simple)
class ChallengeQuestion {
  final int id;
  final String questionText;
  final String? userAnswerText;
  final Map<String, String>? matchingAnswers; // Pour les questions de type correspondance

  ChallengeQuestion({
    required this.id,
    required this.questionText,
    this.userAnswerText,
    this.matchingAnswers,
  });
}

class ChallengeSummaryScreen extends StatelessWidget {
   ChallengeSummaryScreen({super.key});
  
  // Données de questions simulées basées sur l'image
  final List<ChallengeQuestion> _questions = [
    ChallengeQuestion(
      id: 1,
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswerText: 'Réponses : 4', // Réponse simple sélectionnée
    ),
    ChallengeQuestion(
      id: 2,
      questionText: 'La somme de 2 et 3 font 5 ?',
      userAnswerText: 'Réponses : 4',
    ),
    ChallengeQuestion(
      id: 3,
      questionText: 'Correspondre les pays avec leurs capitales',
      matchingAnswers: const { // Réponses de correspondance sélectionnées
        'France': 'Paris',
        'Mali': 'Ouagadou',
        'Burkina': 'Bamako',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // La barre de navigation inférieure est fixe
      bottomNavigationBar: _buildBottomNavBar(),

      body: Column(
        children: [
          // 1. App Bar personnalisé (avec barre de statut)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Titre principal
                  const Center(
                    child: Text(
                      'Resumé du Challenge',
                      style: TextStyle(
                        color: _colorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Liste des questions du résumé
                  ..._questions.map((q) => Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _ChallengeSummaryItem(question: q),
                  )).toList(),
                  
                  // Espace pour simuler les tirets de l'image
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text('...................', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 3. Bouton Soumettre
          _buildSubmitButton(context),
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
            
            // Flèche de retour masquée pour la vue résumé, mais incluse pour la cohérence
            const SizedBox(height: 10), 
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Logique de soumission du challenge
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Challenge Soumis !')),
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
            'Soumettre',
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
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque'),
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge', isSelected: true), // Challenge est actif
          _NavBarItem(icon: Icons.checklist, label: 'Exercice'),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _ChallengeSummaryItem extends StatelessWidget {
  final ChallengeQuestion question;

  const _ChallengeSummaryItem({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
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
          // Numéro de question et Texte
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cercle Jaune pour le numéro
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: _colorYellow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    question.id.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Texte de la question
              Expanded(
                child: Text(
                  question.questionText,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Affichage de la réponse selon le type
          if (question.userAnswerText != null) 
            // Type Choix Multiple/Texte
            _buildSimpleAnswer(question.userAnswerText!),
          
          if (question.matchingAnswers != null)
            // Type Correspondance
            _buildMatchingAnswers(question.matchingAnswers!),
        ],
      ),
    );
  }
  
  Widget _buildSimpleAnswer(String answerText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: _purpleMain.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        answerText,
        style: TextStyle(
          color: _purpleMain,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildMatchingAnswers(Map<String, String> answers) {
    return Column(
      children: answers.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Colonne A
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: _purpleMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      entry.key,
                      style: const TextStyle(color: _purpleMain, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              ),
              // Colonne B
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: _purpleMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      entry.value,
                      style: const TextStyle(color: _purpleMain, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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