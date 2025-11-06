import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/challenge/challenge.dart';

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

class ChallengeRankingScreen extends StatefulWidget {
  final bool hasBadge;

  const ChallengeRankingScreen({super.key, this.hasBadge = true});

  @override
  State<ChallengeRankingScreen> createState() => _ChallengeRankingScreenState();
}

class _ChallengeRankingScreenState extends State<ChallengeRankingScreen> {
  final List<RankingUser> _rankingList = [
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
          SizedBox(height: isSmallScreen ? 15 : 20),

          // Statistiques rapides
          _buildQuickStats(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildQuickStats(bool isSmallScreen) {
    final currentUser = _getCurrentUser();
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 15),
      decoration: BoxDecoration(
        color: _colorWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickStatItem(
            value: currentUser?.rank.toString() ?? '-',
            label: 'Votre rang',
            color: _colorWhite,
            isSmallScreen: isSmallScreen,
          ),
          _QuickStatItem(
            value: currentUser?.points.toString() ?? '0',
            label: 'Points',
            color: _colorWhite,
            isSmallScreen: isSmallScreen,
          ),
          _QuickStatItem(
            value: _rankingList.length.toString(),
            label: 'Participants',
            color: _colorWhite,
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildCongratulationsSection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isSmallScreen ? 15 : 25),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_colorGold.withOpacity(0.1), _colorSuccess.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _colorGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: _colorGold,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: _colorWhite,
              size: isSmallScreen ? 24 : 30,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Félicitations ! 🎉',
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 4 : 5),
                Text(
                  'Vous avez gagné un badge pour votre performance exceptionnelle',
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
            '${_rankingList.length} participants au total',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
          SizedBox(height: isSmallScreen ? 15 : 20),

          // Liste du classement
          ..._rankingList.map((user) => _RankingItem(
            user: user,
            isSmallScreen: isSmallScreen,
            isLargeScreen: isLargeScreen,
          )).toList(),
        ],
      ),
    );
  }

  RankingUser? _getCurrentUser() {
    return _rankingList.firstWhere((user) => user.isCurrentUser);
  }
}

// --- MODÈLE DE DONNÉES ---
class RankingUser {
  final String name;
  final int points;
  final int rank;
  final bool isCurrentUser;
  final bool hasBadge;

  RankingUser({
    required this.name,
    required this.points,
    required this.rank,
    this.isCurrentUser = false,
    this.hasBadge = false,
  });
}

// --- WIDGETS DE COMPOSANTS ---

class _QuickStatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isSmallScreen;

  const _QuickStatItem({
    required this.value,
    required this.label,
    required this.color,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isSmallScreen ? 2 : 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: isSmallScreen ? 10 : 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _RankingItem extends StatelessWidget {
  final RankingUser user;
  final bool isSmallScreen;
  final bool isLargeScreen;

  const _RankingItem({
    required this.user,
    required this.isSmallScreen,
    required this.isLargeScreen,
  });

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return _colorGold;
      case 2:
        return _colorSilver;
      case 3:
        return _colorBronze;
      default:
        return Colors.grey.shade400;
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.person;
    }
  }

  String _getRankSuffix(int rank) {
    if (rank == 1) return 'er';
    return 'ème';
  }

  @override
  Widget build(BuildContext context) {
    final isPodium = user.rank <= 3;
    final rankColor = _getRankColor(user.rank);
    final rankIcon = _getRankIcon(user.rank);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: user.isCurrentUser ? _colorUserCard : _colorWhite,
        borderRadius: BorderRadius.circular(15),
        border: user.isCurrentUser
            ? Border.all(color: _purpleMain, width: 2)
            : Border.all(color: Colors.grey.shade200),
        boxShadow: user.isCurrentUser
            ? [
                BoxShadow(
                  color: _purpleMain.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        children: [
          // Badge de rang - Taille fixe
          Container(
            width: isSmallScreen ? 32 : 40,
            height: isSmallScreen ? 32 : 40,
            decoration: BoxDecoration(
              color: isPodium ? rankColor : Colors.transparent,
              shape: BoxShape.circle,
              border: isPodium ? null : Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: isPodium
                  ? Icon(rankIcon,
                      color: _colorWhite,
                      size: isSmallScreen ? 16 : 20)
                  : Text(
                      user.rank.toString(),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 15),

          // Informations utilisateur - Prend l'espace disponible
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _truncateName(user.name, isSmallScreen),
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (user.isCurrentUser) ...[
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6 : 8,
                          vertical: isSmallScreen ? 1 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: _purpleMain,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Vous',
                          style: TextStyle(
                            color: _colorWhite,
                            fontSize: isSmallScreen ? 9 : 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  '${user.points} points',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Indicateur de badge - Taille conditionnelle
          if (user.hasBadge)
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
              decoration: BoxDecoration(
                color: _colorGold.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: _colorGold),
              ),
              child: Icon(
                Icons.verified,
                color: _colorGold,
                size: isSmallScreen ? 12 : 16,
              ),
            ),

          // Texte du rang - Taille fixe
          SizedBox(width: isSmallScreen ? 6 : 10),
          Container(
            constraints: BoxConstraints(
              minWidth: isSmallScreen ? 30 : 40,
            ),
            child: Text(
              '${user.rank}${_getRankSuffix(user.rank)}',
              style: TextStyle(
                color: isPodium ? rankColor : Colors.grey.shade600,
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _truncateName(String name, bool isSmallScreen) {
    if (isSmallScreen && name.length > 15) {
      return '${name.substring(0, 12)}...';
    }
    return name;
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
      margin: EdgeInsets.only(bottom: isSmallScreen ? 15 : 25),
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
          ...rankingList.map((user) => _RankingItem(
            user: user,
            isSmallScreen: isSmallScreen,
            isLargeScreen: isLargeScreen,
          )).toList(),
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