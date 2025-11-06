import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/challenge/participeChallenge.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
const Color _purpleLight = Color(0xFFE1D4F5); // Violet clair
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorYellow = Color(0xFFFFA500); // Couleur pour le Score
const Color _colorGreen = Color(0xFF4CAF50); // Vert pour les badges
const Color _colorGrey = Color(0xFF757575); // Gris pour texte secondaire
const String _fontFamily = 'Roboto'; // Police principale

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation de LayoutBuilder pour adapter le design selon la taille de l'écran
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;
        final bool isLargeScreen = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: Column(
            children: [
              // 1. App Bar personnalisé
              _buildCustomAppBar(context, isSmallScreen),

              // 2. Le corps de la page (Défilement)
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16.0 : 20.0,
                    vertical: isSmallScreen ? 10.0 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: isSmallScreen ? 15 : 25),

                      // Bannière de bienvenue
                      _buildWelcomeBanner(isSmallScreen),

                      SizedBox(height: isSmallScreen ? 20 : 30),

                      // 3. Section Nouveaux Challenges
                      _buildNewChallengesSection(isSmallScreen, isLargeScreen),

                      SizedBox(height: isSmallScreen ? 20 : 30),

                      // 4. Section Mes Participations
                      _buildMyParticipationsSection(isSmallScreen, isLargeScreen),

                      SizedBox(height: isSmallScreen ? 30 : 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context, bool isSmallScreen) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            left: isSmallScreen ? 16 : 20,
            right: isSmallScreen ? 16 : 20,
            bottom: 15
          ),
          child: Column(
            children: [
              // Titre de la page
              Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Challenges',
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: 22, // Taille fixe pour le titre
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_purpleMain, Color(0xFF8A6DC5)],
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: _purpleMain.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Défiez-vous !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Participez à nos challenges et gagnez des récompenses',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isSmallScreen ? 13 : 14,
                    fontFamily: _fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 15),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              color: Colors.white,
              size: isSmallScreen ? 25 : 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewChallengesSection(bool isSmallScreen, bool isLargeScreen) {
    // Données simulées pour les Nouveaux Challenges
    final List<Map<String, dynamic>> newChallenges = [
      {
        'title': 'Défi Mathématiques',
        'description': 'Améliorez vos compétences en mathématiques avec ce challenge stimulant.',
        'date': '15 mai à 10:00',
        'participants': 245,
        'difficulty': 'Intermédiaire',
        'icon': Icons.calculate,
        'color': Colors.blue,
      },
      {
        'title': 'Challenge Littéraire',
        'description': 'Testez votre culture littéraire et découvrez de nouveaux auteurs.',
        'date': '18 mai à 14:00',
        'participants': 189,
        'difficulty': 'Facile',
        'icon': Icons.menu_book,
        'color': Colors.green,
      },
      {
        'title': 'Quiz Sciences',
        'description': 'Physique, chimie, biologie : un défi complet pour les scientifiques.',
        'date': '20 mai à 16:30',
        'participants': 156,
        'difficulty': 'Difficile',
        'icon': Icons.science,
        'color': Colors.orange,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 15),
          child: Row(
            children: [
              Icon(Icons.new_releases, color: _purpleMain, size: isSmallScreen ? 20 : 22),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'Nouveaux Challenges',
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
            ],
          ),
        ),

        // Pour les grands écrans, afficher en grille
        if (isLargeScreen)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: newChallenges.length,
            itemBuilder: (context, index) {
              final challenge = newChallenges[index];
              return _NewChallengeCard(
                title: challenge['title']!,
                description: challenge['description']!,
                date: challenge['date']!,
                participants: challenge['participants']!,
                difficulty: challenge['difficulty']!,
                icon: challenge['icon']!,
                iconColor: challenge['color']!,
                isSmallScreen: isSmallScreen,
              );
            },
          )
        else
          ...newChallenges.map((challenge) {
            return Padding(
              padding: EdgeInsets.only(bottom: isSmallScreen ? 12.0 : 16.0),
              child: _NewChallengeCard(
                title: challenge['title']!,
                description: challenge['description']!,
                date: challenge['date']!,
                participants: challenge['participants']!,
                difficulty: challenge['difficulty']!,
                icon: challenge['icon']!,
                iconColor: challenge['color']!,
                isSmallScreen: isSmallScreen,
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildMyParticipationsSection(bool isSmallScreen, bool isLargeScreen) {
    // Données simulées pour Mes Participations
    final List<Map<String, dynamic>> participations = [
      {
        'title': 'Défi Mathématiques',
        'ranking': '5ème',
        'score': 100,
        'badge': true,
        'progress': 0.8,
        'totalParticipants': 50,
        'date': '10 mai 2024',
      },
      {
        'title': 'Quiz Culture Générale',
        'ranking': '12ème',
        'score': 75,
        'badge': false,
        'progress': 0.6,
        'totalParticipants': 120,
        'date': '8 mai 2024',
      },
      {
        'title': 'Challenge Histoire',
        'ranking': '3ème',
        'score': 150,
        'badge': true,
        'progress': 0.9,
        'totalParticipants': 80,
        'date': '5 mai 2024',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 15),
          child: Row(
            children: [
              Icon(Icons.history, color: _purpleMain, size: isSmallScreen ? 20 : 22),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'Mes Participations',
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
              ),
            ],
          ),
        ),

        // Pour les grands écrans, afficher en grille
        if (isLargeScreen)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: participations.length,
            itemBuilder: (context, index) {
              final item = participations[index];
              return _ParticipationCard(
                title: item['title']!,
                ranking: item['ranking']!,
                score: item['score']!,
                hasBadge: item['badge']!,
                progress: item['progress']!,
                totalParticipants: item['totalParticipants']!,
                date: item['date']!,
                isSmallScreen: isSmallScreen,
              );
            },
          )
        else
          ...participations.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: isSmallScreen ? 12.0 : 16.0),
              child: _ParticipationCard(
                title: item['title']!,
                ranking: item['ranking']!,
                score: item['score']!,
                hasBadge: item['badge']!,
                progress: item['progress']!,
                totalParticipants: item['totalParticipants']!,
                date: item['date']!,
                isSmallScreen: isSmallScreen,
              ),
            );
          }).toList(),
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
  final int participants;
  final String difficulty;
  final IconData icon;
  final Color iconColor;
  final bool isSmallScreen;

  const _NewChallengeCard({
    required this.title,
    required this.description,
    required this.date,
    required this.participants,
    required this.difficulty,
    required this.icon,
    required this.iconColor,
    required this.isSmallScreen
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: isSmallScreen ? 8 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Icon(icon, color: iconColor, size: isSmallScreen ? 20 : 24),
              ),
              SizedBox(width: isSmallScreen ? 12 : 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _colorBlack,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: _colorGrey,
                        fontSize: isSmallScreen ? 13 : 14,
                        fontFamily: _fontFamily,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),

                    // Informations supplémentaires
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip(Icons.people_outline, '$participants participants'),
                        _buildInfoChip(Icons.speed, difficulty),
                      ],
                    ),

                    SizedBox(height: isSmallScreen ? 8 : 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: isSmallScreen ? 14 : 16, color: _colorGrey),
                            SizedBox(width: isSmallScreen ? 4 : 5),
                            Text(
                              date,
                              style: TextStyle(
                                color: _colorGrey,
                                fontSize: isSmallScreen ? 12 : 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChallengeParticipeScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleMain,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Participer maintenant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Icon(Icons.arrow_forward_rounded, size: isSmallScreen ? 16 : 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _purpleLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: _purpleMain),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: _purpleMain,
              fontSize: 11,
              fontWeight: FontWeight.w500,
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
  final double progress;
  final int totalParticipants;
  final String date;
  final bool isSmallScreen;

  const _ParticipationCard({
    required this.title,
    required this.ranking,
    required this.score,
    required this.hasBadge,
    required this.progress,
    required this.totalParticipants,
    required this.date,
    required this.isSmallScreen
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: isSmallScreen ? 8 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasBadge)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _colorGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _colorGreen, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 12, color: _colorGreen),
                      const SizedBox(width: 3),
                      Text(
                        'Badge',
                        style: TextStyle(
                          color: _colorGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),

          // Barre de progression du classement
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Classement : $ranking',
                    style: TextStyle(
                      color: _colorBlack,
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Sur $totalParticipants',
                    style: TextStyle(
                      color: _colorGrey,
                      fontSize: isSmallScreen ? 11 : 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: _purpleLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress > 0.7 ? _colorGreen :
                    progress > 0.4 ? _colorYellow : _purpleMain
                  ),
                  minHeight: isSmallScreen ? 5 : 6,
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 12 : 15),

          // Layout adaptatif pour les petits écrans
          if (isSmallScreen)
            _buildMobileLayout()
          else
            _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Score',
                  style: TextStyle(
                    color: _colorGrey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, color: _colorYellow, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      '${score}pts',
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(
                    color: _colorGrey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigation vers les détails
            },
            icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.white),
            label: const Text(
              'Voir détails',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _purpleMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Score',
              style: TextStyle(
                color: _colorGrey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: _colorYellow, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${score}pts',
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date',
              style: TextStyle(
                color: _colorGrey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                color: _colorBlack,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Container(
          decoration: BoxDecoration(
            color: _purpleMain,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton.icon(
            onPressed: () {
              // Navigation vers les détails
            },
            icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.white),
            label: const Text(
              'Détails',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}