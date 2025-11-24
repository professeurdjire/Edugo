import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/badge_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/badge.dart' as BadgeModel;
import 'package:built_collection/built_collection.dart';

class BadgeInfo {
  final String title;
  final Color color; // Pour simuler les différents métaux (Or, Argent, Bronze)
  final IconData icon;

  const BadgeInfo(this.title, this.color, this.icon);
}

class BadgesScreen extends StatefulWidget {
  final ThemeService? themeService; // Rendez optionnel

  const BadgesScreen({super.key, this.themeService}); // Enlevez required

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  late ThemeService _themeService;
  final BadgeService _badgeService = BadgeService();
  final AuthService _authService = AuthService();
  
  BuiltList<BadgeModel.Badge>? _badges;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final eleveId = _authService.currentUserId;
      if (eleveId != null) {
        final badges = await _badgeService.getBadges(eleveId);
        if (mounted) {
          setState(() {
            _badges = badges;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading badges: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Convertir Badge en BadgeInfo pour l'affichage
  List<BadgeInfo> _convertBadgesToBadgeInfo() {
    if (_badges == null || _badges!.isEmpty) {
      // Retourner des badges par défaut si aucun badge n'est disponible
      return const [
        BadgeInfo('Aucun badge', Color(0xFF9E9E9E), Icons.star_border),
      ];
    }
    
    return _badges!.map<BadgeInfo>((BadgeModel.Badge badge) {
      // Déterminer la couleur selon le type de badge
      Color color;
      IconData icon;
      
      switch (badge.type) {
        case BadgeModel.BadgeTypeEnum.OR:
          color = const Color(0xFFFFD700);
          icon = Icons.star;
          break;
        case BadgeModel.BadgeTypeEnum.ARGENT:
          color = const Color(0xFFC0C0C0);
          icon = Icons.star_half;
          break;
        case BadgeModel.BadgeTypeEnum.BRONZE:
          color = const Color(0xFFCD7F32);
          icon = Icons.emoji_events;
          break;
        case BadgeModel.BadgeTypeEnum.SPECIAL:
          color = const Color(0xFF9C27B0);
          icon = Icons.military_tech;
          break;
        default:
          color = const Color(0xFF9E9E9E);
          icon = Icons.star_border;
      }
      
      return BadgeInfo(
        badge.nom ?? 'Badge',
        color,
        icon,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          // App Bar
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Mes Badges',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
          ),

          // Corps de la page
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Section "Vous avez collecté"
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1), // Couleur de fond adaptée au thème
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Vous avez collecté',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${_badges?.length ?? 0} Badges',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor, // Couleur principale du thème
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Titre de la section des badges
                        Text(
                          'Badges gagnés',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor, // Couleur du thème
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Grille des badges
                        _badges == null || _badges!.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey.shade400),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Aucun badge obtenu pour le moment',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.0,
                                  mainAxisSpacing: 16.0,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: _badges!.length,
                                itemBuilder: (context, index) {
                                  final badge = _badges![index];
                                  final badgeInfo = _convertBadgesToBadgeInfo()[index];
                                  return BadgeCard(
                                    badge: badgeInfo,
                                    badgeModel: badge,
                                    primaryColor: primaryColor,
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

// Widget pour représenter un badge individuel
class BadgeCard extends StatelessWidget {
  final BadgeInfo badge;
  final BadgeModel.Badge? badgeModel; // Modèle Badge optionnel pour afficher la description
  final Color primaryColor;

  const BadgeCard({
    super.key,
    required this.badge,
    this.badgeModel,
    required this.primaryColor,
  });

  // Fonction pour déterminer la couleur du ruban en fonction du "métal"
  Color _getRibbonColor(Color metalColor) {
    if (metalColor == const Color(0xFFFFD700)) {
      return Colors.blue; // Ruban bleu pour l'or
    } else if (metalColor == const Color(0xFFC0C0C0)) {
      return Colors.blueGrey; // Ruban bleu-gris pour l'argent
    } else {
      return primaryColor; // Ruban avec la couleur du thème pour le bronze
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: primaryColor.withOpacity(0.3), // Stroke avec couleur du thème
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1), // Ombre colorée adaptée au thème
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // L'icône du badge
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: primaryColor, // Bordure avec couleur du thème
                width: 3.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ruban
                Icon(
                  Icons.card_membership,
                  size: 60,
                  color: _getRibbonColor(badge.color),
                ),
                // L'icône principale
                Icon(
                  badge.icon,
                  size: 30,
                  color: badge.color,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Le titre du badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor.withOpacity(0.8), // Texte avec couleur du thème
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (badgeModel?.description != null && badgeModel!.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    badgeModel!.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}