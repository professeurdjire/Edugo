import 'package:flutter/material.dart';
import 'package:edugo/screens/main/challenge/challenge.dart';
import 'package:edugo/services/defi_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/eleve_defi_response.dart';
import 'package:edugo/models/defi_detail_response.dart';
import 'package:built_collection/built_collection.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const Color _colorWhite = Color(0xFFFFFFFF);
const Color _colorBackground = Color(0xFFF8F9FA);
const Color _colorGold = Color(0xFFFFD700);
const Color _colorSilver = Color(0xFFC0C0C0);
const Color _colorBronze = Color(0xFFCD7F32);
const Color _colorSuccess = Color(0xFF32C832);
const Color _colorUserCard = Color(0xFFE8F5E9);
const String _fontFamily = 'Roboto';

class RankingUser {
  final String name;
  final int points;
  final int rank;
  final bool hasBadge;
  final bool isCurrentUser;

  RankingUser({
    required this.name,
    required this.points,
    required this.rank,
    required this.hasBadge,
    this.isCurrentUser = false,
  });
}

class ChallengeRankingScreen extends StatefulWidget {
  final bool hasBadge;
  final int? defiId;

  const ChallengeRankingScreen({super.key, this.hasBadge = true, this.defiId});

  @override
  State<ChallengeRankingScreen> createState() => _ChallengeRankingScreenState();
}

class _ChallengeRankingScreenState extends State<ChallengeRankingScreen> {
  final DefiService _defiService = DefiService();
  final AuthService _authService = AuthService();
  
  BuiltList<EleveDefiResponse>? _rankingList;
  bool _isLoading = true;
  int? _currentEleveId;
  DefiDetailResponse? _defiDetails;

  @override
  void initState() {
    super.initState();
    _currentEleveId = _authService.currentUserId;
    if (widget.defiId != null && _currentEleveId != null) {
      _loadRanking();
      _loadDefiDetails();
    }
  }

  Future<void> _loadDefiDetails() async {
    if (widget.defiId == null) return;
    
    try {
      final details = await _defiService.getDefiById(widget.defiId!);
      
      if (mounted) {
        setState(() {
          _defiDetails = details;
        });
      }
    } catch (e) {
      print('Error loading challenge details: $e');
    }
  }

  Future<void> _loadRanking() async {
    if (_currentEleveId == null || widget.defiId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load the actual ranking data for this challenge
      final participated = await _defiService.getDefisParticipes(_currentEleveId!);
      
      if (mounted) {
        setState(() {
          _rankingList = participated;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading ranking: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  RankingUser? _getCurrentUser() {
    if (_rankingList == null) return null;
    
    // In a real implementation, we would find the current user in the ranking list
    // For now, we'll just return a placeholder
    return RankingUser(
      name: 'Utilisateur Actuel',
      points: 150,
      rank: 1,
      hasBadge: widget.hasBadge,
      isCurrentUser: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallScreen = constraints.maxWidth < 400;
            final bool isLargeScreen = constraints.maxWidth > 600;

            return Column(
              children: [
                // Header avec informations du challenge
                _buildHeaderSection(isSmallScreen, context),

                // Contenu principal avec défilement
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12.0 : 20.0,
                            vertical: isSmallScreen ? 12 : 20,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              children: [
                                // Section de félicitations (si badge gagné)
                                if (_getCurrentUser()?.hasBadge == true)
                                  _buildCongratulationsSection(isSmallScreen),

                                // Classement
                                _buildRankingSection(isSmallScreen, isLargeScreen),

                                SizedBox(height: isSmallScreen ? 20 : 30),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isSmallScreen, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isSmallScreen ? 20 : 30,
        bottom: isSmallScreen ? 20 : 30,
        left: isSmallScreen ? 16 : 20,
        right: isSmallScreen ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_purpleMain.withOpacity(0.9), _purpleMain],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Bouton retour et titre
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: _colorWhite,
                  size: isSmallScreen ? 20 : 24,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChallengeScreen()));
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Classement',
                      style: TextStyle(
                        color: _colorWhite,
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      _defiDetails?.titre ?? 'Défi Mathématiques',
                      style: TextStyle(
                        color: _colorWhite,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text(
                      'Classement général',
                      style: TextStyle(
                        color: _colorWhite.withOpacity(0.9),
                        fontSize: isSmallScreen ? 12 : 14,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              // Espace pour équilibrer le layout avec le bouton retour
              SizedBox(
                width: isSmallScreen ? 48 : 56,
                height: isSmallScreen ? 48 : 56,
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 15 : 20),

          // Statistiques du challenge
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: _colorWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.groups,
                  value: _rankingList?.length ?? 0,
                  label: 'Participants',
                  isSmallScreen: isSmallScreen,
                ),
                Container(
                  width: 1,
                  height: isSmallScreen ? 30 : 40,
                  color: _colorWhite.withOpacity(0.5),
                ),
                _buildStatItem(
                  icon: Icons.emoji_events,
                  value: _getCurrentUser()?.rank ?? 0,
                  label: 'Votre rang',
                  isSmallScreen: isSmallScreen,
                ),
                Container(
                  width: 1,
                  height: isSmallScreen ? 30 : 40,
                  color: _colorWhite.withOpacity(0.5),
                ),
                _buildStatItem(
                  icon: Icons.stars,
                  value: _getCurrentUser()?.points ?? 0,
                  label: 'Points',
                  isSmallScreen: isSmallScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int value,
    required String label,
    required bool isSmallScreen,
  }) {
    return Column(
      children: [
        Icon(icon, color: _colorWhite, size: isSmallScreen ? 18 : 22),
        SizedBox(height: isSmallScreen ? 4 : 6),
        Text(
          '$value',
          style: TextStyle(
            color: _colorWhite,
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: _colorWhite.withOpacity(0.9),
            fontSize: isSmallScreen ? 10 : 12,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildCongratulationsSection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isSmallScreen ? 20 : 30),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_colorSuccess, Color(0xFF28A745)],
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 15 : 20),
        boxShadow: [
          BoxShadow(
            color: _colorSuccess.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            color: _colorWhite,
            size: isSmallScreen ? 36 : 40,
          ),
          SizedBox(height: isSmallScreen ? 10 : 15),
          Text(
            'Félicitations !',
            style: TextStyle(
              color: _colorWhite,
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          SizedBox(height: isSmallScreen ? 5 : 8),
          Text(
            'Vous avez terminé ce challenge avec succès !',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _colorWhite,
              fontSize: isSmallScreen ? 14 : 16,
              fontFamily: _fontFamily,
            ),
          ),
          SizedBox(height: isSmallScreen ? 10 : 15),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: _colorWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.stars,
                  color: _colorGold,
                  size: isSmallScreen ? 16 : 18,
                ),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Text(
                  '+50 points',
                  style: TextStyle(
                    color: _colorWhite,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingSection(bool isSmallScreen, bool isLargeScreen) {
    List<RankingUser> rankingData = [];
    
    if (_rankingList != null) {
      // Convert real data to display format
      rankingData = _rankingList!.asList().map((eleveDefi) {
        return RankingUser(
          name: '${eleveDefi.prenom ?? ''} ${eleveDefi.nom ?? ''}'.trim(),
          points: 0, // We don't have point data in the current model
          rank: 0, // We don't have rank data in the current model
          hasBadge: eleveDefi.statut == 'Terminé',
        );
      }).toList();
    } else {
      // Fallback to simulated data
      rankingData = [
        RankingUser(
          name: 'Haoua Haïdara',
          isCurrentUser: true,
          points: 150,
          rank: 1,
          hasBadge: true,
        ),
        RankingUser(
          name: 'Idrissa Haïdara',
          points: 120,
          rank: 2,
          hasBadge: true,
        ),
        RankingUser(
          name: 'Fatoumata Diawara',
          points: 115,
          rank: 3,
          hasBadge: true,
        ),
        RankingUser(
          name: 'Aïssata Koné',
          points: 110,
          rank: 4,
          hasBadge: false,
        ),
        RankingUser(
          name: 'Mahamadou Koné',
          points: 98,
          rank: 5,
          hasBadge: false,
        ),
        RankingUser(
          name: 'Awa Keïta',
          points: 60,
          rank: 6,
          hasBadge: false,
        ),
        RankingUser(
          name: 'Nouhoum Dembélé',
          points: 55,
          rank: 7,
          hasBadge: false,
        ),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 15 : 20),
          child: Text(
            'Classement',
            style: TextStyle(
              color: _colorBlack,
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rankingData.length,
          itemBuilder: (context, index) {
            final user = rankingData[index];
            return _buildRankingItem(user, index + 1, isSmallScreen);
          },
        ),
      ],
    );
  }

  Widget _buildRankingItem(RankingUser user, int rank, bool isSmallScreen) {
    Color getRankColor(int rank) {
      switch (rank) {
        case 1:
          return _colorGold;
        case 2:
          return _colorSilver;
        case 3:
          return _colorBronze;
        default:
          return Colors.grey;
      }
    }

    IconData getRankIcon(int rank) {
      switch (rank) {
        case 1:
          return Icons.workspace_premium;
        case 2:
          return Icons.workspace_premium;
        case 3:
          return Icons.workspace_premium;
        default:
          return Icons.emoji_events_outlined;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 15),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: user.isCurrentUser ? _colorUserCard : _colorWhite,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rang
          Container(
            width: isSmallScreen ? 36 : 40,
            height: isSmallScreen ? 36 : 40,
            decoration: BoxDecoration(
              color: getRankColor(rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: rank <= 3
                  ? Icon(
                      getRankIcon(rank),
                      color: _colorWhite,
                      size: isSmallScreen ? 18 : 20,
                    )
                  : Text(
                      '$rank',
                      style: TextStyle(
                        color: _colorWhite,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),

          // Informations de l'utilisateur
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: _fontFamily,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  '${user.points} points',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isSmallScreen ? 12 : 14,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),

          // Badge ou icône de statut
          if (user.hasBadge)
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
              decoration: const BoxDecoration(
                color: _colorSuccess,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: _colorWhite,
                size: isSmallScreen ? 14 : 16,
              ),
            ),
        ],
      ),
    );
  }
}

// --- ÉCRAN SANS BADGE ---
class ChallengeRankingNoBadgeScreen extends StatelessWidget {
  const ChallengeRankingNoBadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallScreen = constraints.maxWidth < 400;
            final bool isLargeScreen = constraints.maxWidth > 600;

            return Column(
              children: [
                // Header avec informations du challenge
                _buildHeaderSection(isSmallScreen, context),

                // Contenu principal avec défilement
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12.0 : 20.0,
                      vertical: isSmallScreen ? 12 : 20,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          // Section d'encouragement
                          _buildEncouragementSection(isSmallScreen),

                          // Classement
                          _buildRankingSection(isSmallScreen, isLargeScreen),

                          SizedBox(height: isSmallScreen ? 20 : 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isSmallScreen, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isSmallScreen ? 20 : 30,
        bottom: isSmallScreen ? 20 : 30,
        left: isSmallScreen ? 16 : 20,
        right: isSmallScreen ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_purpleMain.withOpacity(0.9), _purpleMain],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Bouton retour et titre
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: _colorWhite,
                  size: isSmallScreen ? 20 : 24,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChallengeScreen()));
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Classement',
                      style: TextStyle(
                        color: _colorWhite,
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      'Défi Mathématiques',
                      style: TextStyle(
                        color: _colorWhite,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text(
                      'Classement général',
                      style: TextStyle(
                        color: _colorWhite.withOpacity(0.9),
                        fontSize: isSmallScreen ? 12 : 14,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              // Espace pour équilibrer le layout avec le bouton retour
              SizedBox(
                width: isSmallScreen ? 48 : 56,
                height: isSmallScreen ? 48 : 56,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragementSection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isSmallScreen ? 20 : 30),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: _colorWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: _purpleMain.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.trending_up,
              color: _purpleMain,
              size: isSmallScreen ? 24 : 30,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Continuez vos efforts ! 💪',
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 4 : 5),
                Text(
                  'Vous progressez bien. Un peu plus d\'efforts pour décrocher un badge !',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingSection(bool isSmallScreen, bool isLargeScreen) {
    final List<RankingUser> rankingList = [
      RankingUser(
        name: 'Idrissa Haïdara',
        points: 120,
        rank: 1,
        hasBadge: true,
      ),
      RankingUser(
        name: 'Fatoumata Diawara',
        points: 115,
        rank: 2,
        hasBadge: true,
      ),
      RankingUser(
        name: 'Aïssata Koné',
        points: 110,
        rank: 3,
        hasBadge: true,
      ),
      RankingUser(
        name: 'Haoua Haïdara',
        isCurrentUser: true,
        points: 100,
        rank: 4,
        hasBadge: false,
      ),
      RankingUser(
        name: 'Mahamadou Koné',
        points: 98,
        rank: 5,
        hasBadge: false,
      ),
      RankingUser(
        name: 'Awa Keïta',
        points: 60,
        rank: 6,
        hasBadge: false,
      ),
      RankingUser(
        name: 'Nouhoum Dembélé',
        points: 55,
        rank: 7,
        hasBadge: false,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: _colorWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Classement des Participants',
            style: TextStyle(
              color: _colorBlack,
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 5),
          Text(
            '${rankingList.length} participants au total',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          SizedBox(height: isSmallScreen ? 15 : 20),

          // Liste du classement
          ...rankingList.map((user) {
            Color getRankColor(int rank) {
              switch (rank) {
                case 1:
                  return _colorGold;
                case 2:
                  return _colorSilver;
                case 3:
                  return _colorBronze;
                default:
                  return Colors.grey;
              }
            }

            IconData getRankIcon(int rank) {
              switch (rank) {
                case 1:
                  return Icons.workspace_premium;
                case 2:
                  return Icons.workspace_premium;
                case 3:
                  return Icons.workspace_premium;
                default:
                  return Icons.emoji_events_outlined;
              }
            }

            return Container(
              margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 15),
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: user.isCurrentUser ? _colorUserCard : _colorWhite,
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Rang
                  Container(
                    width: isSmallScreen ? 36 : 40,
                    height: isSmallScreen ? 36 : 40,
                    decoration: BoxDecoration(
                      color: getRankColor(user.rank),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: user.rank <= 3
                          ? Icon(
                              getRankIcon(user.rank),
                              color: _colorWhite,
                              size: isSmallScreen ? 18 : 20,
                            )
                          : Text(
                              '${user.rank}',
                              style: TextStyle(
                                color: _colorWhite,
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: _fontFamily,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),

                  // Informations de l'utilisateur
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            color: _colorBlack,
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: _fontFamily,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 2 : 4),
                        Text(
                          '${user.points} points',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isSmallScreen ? 12 : 14,
                            fontFamily: _fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge ou icône de statut
                  if (user.hasBadge)
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                      decoration: const BoxDecoration(
                        color: _colorSuccess,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: _colorWhite,
                        size: isSmallScreen ? 14 : 16,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// --- UTILISATION ---
/*
// Pour afficher le classement avec badge :
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChallengeRankingScreen(hasBadge: true)),
);

// Pour afficher le classement sans badge :
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChallengeRankingNoBadgeScreen()),
);
*/