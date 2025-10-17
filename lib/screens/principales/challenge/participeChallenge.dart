import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active/bouton)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorScore = Color(0xFFFF9800); // Orange pour le score
const Color _colorGreyLight = Color(0xFFF0F0F0); // Fond de carte léger
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour un nouveau challenge
class NewChallenge {
  final String title;
  final String description;
  final String date;

  NewChallenge({required this.title, required this.description, required this.date});
}

// Modèle pour une participation passée
class PastParticipation {
  final String title;
  final String classement;
  final int score;
  final String badgeStatus;

  PastParticipation({
    required this.title,
    required this.classement,
    required this.score,
    required this.badgeStatus,
  });
}

class ChallengeScreen extends StatelessWidget {
   ChallengeScreen({super.key});

  // Données simulées pour les nouveaux challenges
  final List<NewChallenge> _newChallenges =  [
    NewChallenge(
      title: 'Défi Mathématiques',
      description: 'Améliorer vos compétences en mathématiques avec ce challenge stimulant.',
      date: 'Date : 15 mai à 10 : 00',
    ),
    NewChallenge(
      title: 'Défi Mathématiques',
      description: 'Améliorer vos compétences en mathématiques avec ce challenge stimulant.',
      date: 'Date : 15 mai à 10 : 00',
    ),
  ];

  // Données simulées pour les participations passées
  final List<PastParticipation> _pastParticipations =  [
    PastParticipation(
      title: 'Défi Mathématiques',
      classement: '5ème',
      score: 100,
      badgeStatus: 'Pas de badge Obtenu',
    ),
    PastParticipation(
      title: 'Défi Mathématiques',
      classement: '8ème',
      score: 80,
      badgeStatus: 'Badge Bronze Obtenu',
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

                  // Section Nouveaux Challenges
                  _buildSectionTitle('Nouveaux Challenges'),
                  ..._newChallenges.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _NewChallengeCard(challenge: c),
                  )).toList(),
                  
                  const SizedBox(height: 20),

                  // Section Mes Participations
                  _buildSectionTitle('Mes Participations'),
                  ..._pastParticipations.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _PastParticipationCard(participation: p),
                  )).toList(),
                  
                  const SizedBox(height: 80), // Espace final
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
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
              onPressed: () => Navigator.pop(context), 
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Challenges',
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
            ),
            // Placeholder pour aligner le titre
            const SizedBox(width: 48), 
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          color: _colorBlack,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamily,
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

class _NewChallengeCard extends StatelessWidget {
  final NewChallenge challenge;

  const _NewChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _colorGreyLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            challenge.title,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            challenge.description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            challenge.date,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Logique pour participer au challenge
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleMain,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Participer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastParticipationCard extends StatelessWidget {
  final PastParticipation participation;

  const _PastParticipationCard({required this.participation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _colorGreyLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participation.title,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Classement : ${participation.classement}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  participation.badgeStatus,
                  style: TextStyle(
                    color: participation.badgeStatus.contains('Obtenu') ? _colorScore : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Score
              Text(
                'Score : ${participation.score}pts',
                style: const TextStyle(
                  color: _colorScore,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Bouton Détail
              TextButton.icon(
                onPressed: () {
                  // Logique pour voir le détail de la participation
                },
                icon: const Icon(Icons.remove_red_eye_outlined, color: _purpleMain, size: 18),
                label: const Text(
                  'Détail',
                  style: TextStyle(
                    color: _purpleMain,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ],
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