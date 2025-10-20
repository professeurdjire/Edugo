import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorYellow = Color(0xFFFFA500); // Couleur pour le Score
const String _fontFamily = 'Roboto'; // Police principale

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // 1. App Bar personnalisé (avec barre de statut et titre)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 3. Section Nouveaux Challenges
                  _buildNewChallengesSection(),
                  
                  const SizedBox(height: 30),
                  
                  // 4. Section Mes Participations
                  _buildMyParticipationsSection(),
                  
                  const SizedBox(height: 80), // Espace final pour la barre de navigation
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
                const Expanded(
                  child: Center(
                    child: Text(
                      'Nouveaux Challenges',
                      style: TextStyle(
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
  
  Widget _buildNewChallengesSection() {
    // Données simulées pour les Nouveaux Challenges
    final List<Map<String, String>> newChallenges = [
      {'title': 'Défi Mathématiques', 'description': 'Améliorer vos compétences en mathématiques avec ce challenge stimulant.', 'date': 'Date : 15mai à 10:00'},
      {'title': 'Défi Mathématiques', 'description': 'Améliorer vos compétences en mathématiques avec ce challenge stimulant.', 'date': 'Date : 15mai à 10:00'},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: newChallenges.map((challenge) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _NewChallengeCard(
            title: challenge['title']!,
            description: challenge['description']!,
            date: challenge['date']!,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMyParticipationsSection() {
    // Données simulées pour Mes Participations
    final List<Map<String, dynamic>> participations = [
      {'title': 'Défi Mathématiques', 'ranking': '5ème', 'score': 100, 'badge': false},
      {'title': 'Défi Mathématiques', 'ranking': '12ème', 'score': 50, 'badge': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mes Participations',
          style: TextStyle(
            color: _colorBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        const SizedBox(height: 15),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: participations.length,
          itemBuilder: (context, index) {
            final item = participations[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: _ParticipationCard(
                title: item['title']!,
                ranking: item['ranking']!,
                score: item['score']!,
                hasBadge: item['badge']!,
              ),
            );
          },
        ),
      ],
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _NewChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const _NewChallengeCard({required this.title, required this.description, required this.date});

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
          Text(
            title,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            date,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleMain,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
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

class _ParticipationCard extends StatelessWidget {
  final String title;
  final String ranking;
  final int score;
  final bool hasBadge;

  const _ParticipationCard({required this.title, required this.ranking, required this.score, required this.hasBadge});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _colorBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Score : ',
                    style: TextStyle(
                      color: _colorBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  Text(
                    '${score}pts',
                    style: const TextStyle(
                      color: _colorYellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: _fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Classement : $ranking',
                    style: const TextStyle(
                      color: _colorBlack,
                      fontSize: 14,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    hasBadge ? 'Badge Obtenu' : 'Pas de badge Obtenu',
                    style: TextStyle(
                      color: hasBadge ? _purpleMain : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: _fontFamily,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye_outlined, size: 20, color: _purpleMain),
                label: const Text(
                  'Détail',
                  style: TextStyle(
                    color: _purpleMain,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
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