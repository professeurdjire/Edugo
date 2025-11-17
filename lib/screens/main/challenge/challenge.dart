import 'package:flutter/material.dart';
import 'package:edugo/screens/main/challenge/participeChallenge.dart';
import 'package:edugo/services/defi_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/defi_response.dart';
import 'package:edugo/models/eleve_defi_response.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal
const Color _purpleLight = Color(0xFFE1D4F5); // Violet clair
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorYellow = Color(0xFFFFA500); // Couleur pour le Score
const Color _colorGreen = Color(0xFF4CAF50); // Vert pour les badges
const Color _colorGrey = Color(0xFF757575); // Gris pour texte secondaire
const String _fontFamily = 'Roboto'; // Police principale

class ChallengeScreen extends StatefulWidget {
  final int? eleveId;

  const ChallengeScreen({super.key, this.eleveId});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final DefiService _defiService = DefiService();
  final AuthService _authService = AuthService();
  
  BuiltList<DefiResponse>? _availableChallenges;
  BuiltList<EleveDefiResponse>? _participatedChallenges;
  bool _isLoading = true;
  int? _currentEleveId;

  @override
  void initState() {
    super.initState();
    _currentEleveId = widget.eleveId ?? _authService.currentUserId;
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    if (_currentEleveId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load available challenges
      final available = await _defiService.getDefisDisponibles(_currentEleveId!);
      
      // Load participated challenges
      final participated = await _defiService.getDefisParticipes(_currentEleveId!);
      
      if (mounted) {
        setState(() {
          _availableChallenges = available;
          _participatedChallenges = participated;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading challenges: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
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
    // Use real data if available, otherwise use simulated data
    List<Map<String, dynamic>> newChallenges = [];
    
    if (_availableChallenges != null) {
      newChallenges = _availableChallenges!.map((defi) {
        return {
          'id': defi.id,
          'title': defi.titre ?? 'Défi sans titre',
          'description': 'Aucune description disponible',
          'date': defi.dateAjout?.toString() ?? 'Date inconnue',
          'participants': defi.nbreParticipations ?? 0,
          'difficulty': defi.typeDefi ?? 'Inconnu',
          'icon': _getIconForChallengeType(defi.typeDefi),
          'color': _getColorForChallengeType(defi.typeDefi),
          'pointDefi': defi.pointDefi ?? 0,
        };
      }).toList();
    } else {
      // Données simulées pour les Nouveaux Challenges
      newChallenges = [
        {
          'id': 1,
          'title': 'Défi Mathématiques',
          'description': 'Améliorez vos compétences en mathématiques avec ce challenge stimulant.',
          'date': '15 mai à 10:00',
          'participants': 245,
          'difficulty': 'Intermédiaire',
          'icon': Icons.calculate,
          'color': Colors.blue,
          'pointDefi': 50,
        },
        {
          'id': 2,
          'title': 'Challenge Littéraire',
          'description': 'Testez votre culture littéraire et découvrez de nouveaux auteurs.',
          'date': '18 mai à 14:00',
          'participants': 189,
          'difficulty': 'Facile',
          'icon': Icons.menu_book,
          'color': Colors.green,
          'pointDefi': 30,
        },
        {
          'id': 3,
          'title': 'Quiz Sciences',
          'description': 'Physique, chimie, biologie : un défi complet pour les scientifiques.',
          'date': '20 mai à 16:30',
          'participants': 156,
          'difficulty': 'Difficile',
          'icon': Icons.science,
          'color': Colors.orange,
          'pointDefi': 70,
        },
      ];
    }

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
                pointDefi: challenge['pointDefi']!,
                onTap: () {
                  // Navigate to participate in challenge
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeParticipeScreen(defiId: challenge['id']!),
                    ),
                  );
                },
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
                pointDefi: challenge['pointDefi']!,
                onTap: () {
                  // Navigate to participate in challenge
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeParticipeScreen(defiId: challenge['id']!),
                    ),
                  );
                },
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildMyParticipationsSection(bool isSmallScreen, bool isLargeScreen) {
    // Use real data if available, otherwise use simulated data
    List<Map<String, dynamic>> participations = [];
    
    if (_participatedChallenges != null) {
      participations = _participatedChallenges!.map((eleveDefi) {
        final statut = eleveDefi.statut ?? 'En cours';
        
        // Calculate ranking and progress based on status
        String ranking = 'En cours';
        double progress = 0.0;
        int score = 0;
        bool hasBadge = false;
        
        if (statut == 'Terminé') {
          ranking = 'Terminé';
          progress = 1.0;
          // Since we don't have the full defi object, we can't get pointDefi here
          score = 0;
          hasBadge = true;
        } else if (statut == 'En cours') {
          ranking = 'En cours';
          progress = 0.5; // Default progress for ongoing challenges
        }
        
        return {
          'id': eleveDefi.id,
          'title': eleveDefi.defiTitre ?? 'Défi sans titre',
          'ranking': ranking,
          'score': score,
          'badge': hasBadge,
          'progress': progress,
          'totalParticipants': 0, // We don't have this information in EleveDefiResponse
          'date': eleveDefi.dateEnvoie?.toString() ?? 'Date inconnue',
          'statut': statut,
        };
      }).toList();
    } else {
      // Données simulées pour Mes Participations
      participations = [
        {
          'id': 1,
          'title': 'Défi Mathématiques',
          'ranking': '5ème',
          'score': 100,
          'badge': true,
          'progress': 0.8,
          'totalParticipants': 50,
          'date': '10 mai 2024',
          'statut': 'Terminé',
        },
        {
          'id': 2,
          'title': 'Quiz Culture Générale',
          'ranking': '12ème',
          'score': 75,
          'badge': false,
          'progress': 0.6,
          'totalParticipants': 120,
          'date': '8 mai 2024',
          'statut': 'Terminé',
        },
        {
          'id': 3,
          'title': 'Challenge Histoire',
          'ranking': '3ème',
          'score': 150,
          'badge': true,
          'progress': 0.9,
          'totalParticipants': 80,
          'date': '5 mai 2024',
          'statut': 'Terminé',
        },
      ];
    }

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
                statut: item['statut']!,
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
                statut: item['statut']!,
              ),
            );
          }).toList(),
      ],
    );
  }

  // Helper methods to get icons and colors based on challenge type
  IconData _getIconForChallengeType(String? typeDefi) {
    switch (typeDefi?.toLowerCase()) {
      case 'mathématiques':
      case 'mathematiques':
        return Icons.calculate;
      case 'littérature':
      case 'litterature':
        return Icons.menu_book;
      case 'sciences':
        return Icons.science;
      case 'histoire':
        return Icons.history;
      case 'géographie':
      case 'geographie':
        return Icons.map;
      case 'langues':
        return Icons.language;
      default:
        return Icons.quiz;
    }
  }

  Color _getColorForChallengeType(String? typeDefi) {
    switch (typeDefi?.toLowerCase()) {
      case 'mathématiques':
      case 'mathematiques':
        return Colors.blue;
      case 'littérature':
      case 'litterature':
        return Colors.green;
      case 'sciences':
        return Colors.orange;
      case 'histoire':
        return Colors.red;
      case 'géographie':
      case 'geographie':
        return Colors.purple;
      case 'langues':
        return Colors.teal;
      default:
        return _purpleMain;
    }
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
  final int pointDefi;
  final VoidCallback onTap;

  const _NewChallengeCard({
    required this.title,
    required this.description,
    required this.date,
    required this.participants,
    required this.difficulty,
    required this.icon,
    required this.iconColor,
    required this.isSmallScreen,
    required this.pointDefi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and difficulty
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: isSmallScreen ? 18 : 20),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 10,
                      vertical: isSmallScreen ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: _purpleLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        color: _purpleMain,
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isSmallScreen ? 8 : 12),

              // Title
              Text(
                title,
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: _fontFamily,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: isSmallScreen ? 4 : 6),

              // Description
              Text(
                description,
                style: TextStyle(
                  color: _colorGrey,
                  fontSize: isSmallScreen ? 11 : 12,
                  fontFamily: _fontFamily,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: isSmallScreen ? 8 : 10),

              // Footer with date, participants and points
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: _colorGrey,
                      fontSize: isSmallScreen ? 10 : 11,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.group, color: _colorGrey, size: isSmallScreen ? 12 : 14),
                      SizedBox(width: isSmallScreen ? 2 : 4),
                      Text(
                        '$participants',
                        style: TextStyle(
                          color: _colorGrey,
                          fontSize: isSmallScreen ? 10 : 11,
                          fontFamily: _fontFamily,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                      Icon(Icons.stars, color: Colors.amber, size: isSmallScreen ? 12 : 14),
                      SizedBox(width: isSmallScreen ? 2 : 4),
                      Text(
                        '$pointDefi pts',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: isSmallScreen ? 10 : 11,
                          fontWeight: FontWeight.w500,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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
  final String statut;

  const _ParticipationCard({
    required this.title,
    required this.ranking,
    required this.score,
    required this.hasBadge,
    required this.progress,
    required this.totalParticipants,
    required this.date,
    required this.isSmallScreen,
    required this.statut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: _colorBlack,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: _fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasBadge)
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
                    decoration: const BoxDecoration(
                      color: _colorGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: isSmallScreen ? 14 : 16,
                    ),
                  ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 8 : 10),

            // Ranking and score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 10,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: _purpleLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ranking,
                    style: TextStyle(
                      color: _purpleMain,
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: _fontFamily,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.stars, color: _colorYellow, size: isSmallScreen ? 14 : 16),
                    SizedBox(width: isSmallScreen ? 2 : 4),
                    Text(
                      '$score pts',
                      style: TextStyle(
                        color: _colorYellow,
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 8 : 10),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progression',
                  style: TextStyle(
                    color: _colorGrey,
                    fontSize: isSmallScreen ? 10 : 11,
                    fontFamily: _fontFamily,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 4 : 6),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  color: statut == 'Terminé' ? _colorGreen : _purpleMain,
                  minHeight: isSmallScreen ? 6 : 8,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).round()}% complété',
                      style: TextStyle(
                        color: _colorGrey,
                        fontSize: isSmallScreen ? 9 : 10,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    Text(
                      '$totalParticipants participants',
                      style: TextStyle(
                        color: _colorGrey,
                        fontSize: isSmallScreen ? 9 : 10,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 6 : 8),

            // Date
            Text(
              date,
              style: TextStyle(
                color: _colorGrey,
                fontSize: isSmallScreen ? 10 : 11,
                fontFamily: _fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}