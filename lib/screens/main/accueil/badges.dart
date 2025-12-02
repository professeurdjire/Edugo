import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/badge_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/models/badge.dart' as BadgeModel;
import 'package:edugo/models/badge_eleve_response.dart';
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
  
  List<BadgeEleveResponse>? _allBadges;
  bool _isLoading = true;
  bool _showOnlyObtained = false; // Toggle pour afficher uniquement les badges obtenus

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
        print('[BadgesScreen] Loading all badges with status for student $eleveId');
        
        // Vérifier les points de l'élève pour déterminer s'il devrait avoir des badges de progression
        // Utiliser currentEleve?.pointAccumule en priorité, sinon userPoints, sinon récupérer depuis le backend
        int userPoints = _authService.currentEleve?.pointAccumule ?? _authService.userPoints;
        if (userPoints == 0) {
          // Si les points sont toujours 0, les récupérer depuis le backend
          try {
            final eleveService = EleveService();
            final pointsFromBackend = await eleveService.getElevePoints(eleveId);
            if (pointsFromBackend != null) {
              userPoints = pointsFromBackend;
              print('[BadgesScreen] Points récupérés depuis le backend: $userPoints');
            }
          } catch (e) {
            print('[BadgesScreen] ⚠️ Erreur lors de la récupération des points: $e');
          }
        }
        print('[BadgesScreen] User has $userPoints points');
        
        // Si l'utilisateur a des points mais pas de badges de progression, déclencher la vérification rétroactive
        if (userPoints >= 100) {
          // D'abord, essayer d'initialiser les badges de progression s'ils n'existent pas
          print('[BadgesScreen] 🔄 Vérification de l\'initialisation des badges de progression...');
          await _badgeService.initialiserBadgesProgression();
          
          // Attendre un peu pour que l'initialisation se termine
          await Future.delayed(const Duration(milliseconds: 300));
          
          // Vérifier si l'utilisateur a déjà des badges de progression OBTENUS
          final progressionBadges = await _badgeService.getProgressionBadges(eleveId);
          final obtainedProgressionBadges = progressionBadges?.where((b) => b.obtenu == true).toList() ?? [];
          final hasObtainedProgressionBadges = obtainedProgressionBadges.isNotEmpty;
          
          print('[BadgesScreen] 📊 Points: $userPoints');
          print('[BadgesScreen] 📊 Badges de progression existants: ${progressionBadges?.length ?? 0}');
          print('[BadgesScreen] 📊 Badges de progression OBTENUS: ${obtainedProgressionBadges.length}');
          
          // Vérifier quels badges l'utilisateur devrait avoir selon ses points
          final seuils = await _badgeService.getProgressionBadgeThresholds();
          int badgesManquants = 0;
          if (seuils != null && seuils.isNotEmpty) {
            for (var entry in seuils.entries) {
              final seuil = entry.key;
              final nom = entry.value;
              if (userPoints >= seuil) {
                // L'utilisateur devrait avoir ce badge
                final aCeBadge = obtainedProgressionBadges.any((b) => b.nom == nom || b.id == seuil);
                if (!aCeBadge) {
                  badgesManquants++;
                  print('[BadgesScreen] ⚠️ Badge manquant: $nom ($seuil points) - L\'utilisateur a $userPoints points');
                }
              }
            }
          }
          
          if (!hasObtainedProgressionBadges || badgesManquants > 0) {
            print('[BadgesScreen] ⚠️ User has $userPoints points but ${badgesManquants > 0 ? "$badgesManquants badge(s) manquant(s)" : "no progression badges obtained"}. Triggering retroactive check...');
            final success = await _badgeService.verifierEtAttribuerBadgesProgressionRetroactifs(eleveId);
            if (success) {
              print('[BadgesScreen] ✅ Retroactive badge check completed. Reloading badges...');
              // Attendre un peu pour que le backend traite la requête et mette à jour la base de données
              await Future.delayed(const Duration(milliseconds: 1000));
              // Recharger les badges pour afficher les nouveaux badges obtenus
              print('[BadgesScreen] 🔄 Rechargement des badges après vérification rétroactive...');
            } else {
              print('[BadgesScreen] ⚠️ Retroactive badge check failed. The backend endpoint may not be implemented yet.');
              print('[BadgesScreen] 💡 Les badges seront attribués automatiquement lors de votre prochaine activité.');
            }
          } else {
            print('[BadgesScreen] ✅ L\'utilisateur a déjà ${obtainedProgressionBadges.length} badge(s) de progression obtenu(s)');
          }
        } else {
          print('[BadgesScreen] ℹ️ User has $userPoints points (minimum 100 required for progression badges)');
        }
        
        final badges = await _badgeService.getAllBadgesWithStatus(eleveId);
        print('[BadgesScreen] Loaded ${badges?.length ?? 0} badges');
        
        if (mounted) {
          setState(() {
            _allBadges = badges;
            _isLoading = false;
          });
        }
      } else {
        print('[BadgesScreen] No student ID available');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('[BadgesScreen] Error loading badges: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  /// Méthode pour forcer la vérification rétroactive des badges de progression
  Future<void> _forceRetroactiveCheck() async {
    final eleveId = _authService.currentUserId;
    if (eleveId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de vérifier les badges : utilisateur non connecté')),
      );
      return;
    }
    
    final userPoints = _authService.userPoints;
    if (userPoints < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vous avez $userPoints points. Il faut au moins 100 points pour obtenir des badges de progression.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // D'abord initialiser les badges de progression
      print('[BadgesScreen] 🔄 Initialisation des badges de progression...');
      await _badgeService.initialiserBadgesProgression();
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Ensuite forcer la vérification
      print('[BadgesScreen] 🔄 Vérification rétroactive des badges...');
      final success = await _badgeService.verifierEtAttribuerBadgesProgressionRetroactifs(eleveId);
      
      if (mounted) {
        Navigator.of(context).pop(); // Fermer le dialog de chargement
        
        // Attendre un peu pour que le backend traite
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Recharger les badges
        await _loadBadges();
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Vérification des badges de progression terminée !'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ La vérification a échoué. Le backend doit implémenter l\'endpoint de vérification rétroactive. Les badges seront attribués automatiquement lors de votre prochaine activité.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Fermer le dialog de chargement
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la vérification: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
  
  List<BadgeEleveResponse> get _displayedBadges {
    if (_allBadges == null) return [];
    if (_showOnlyObtained) {
      return _allBadges!.where((b) => b.obtenu).toList();
    }
    return _allBadges!;
  }
  
  int get _obtainedCount => _allBadges?.where((b) => b.obtenu).length ?? 0;
  int get _totalCount => _allBadges?.length ?? 0;
  double get _progressPercentage => _totalCount > 0 ? (_obtainedCount / _totalCount) : 0.0;

  // Convertir BadgeEleveResponse en BadgeInfo pour l'affichage
  BadgeInfo _convertBadgeToBadgeInfo(BadgeEleveResponse badge) {
    // Déterminer la couleur selon le type de badge
    Color color;
    IconData icon;
    
    switch (badge.type.toUpperCase()) {
      case 'PROGRESSION':
        color = const Color(0xFF9C27B0); // Violet pour les badges de progression
        icon = Icons.trending_up;
        break;
      case 'OR':
        color = const Color(0xFFFFD700);
        icon = Icons.star;
        break;
      case 'ARGENT':
        color = const Color(0xFFC0C0C0);
        icon = Icons.star_half;
        break;
      case 'BRONZE':
        color = const Color(0xFFCD7F32);
        icon = Icons.emoji_events;
        break;
      case 'SPECIAL':
      case 'CHALLENGE':
      case 'CLASSEMENT':
      case 'PARTICIPATION':
        color = const Color(0xFF9C27B0);
        icon = Icons.military_tech;
        break;
      default:
        color = const Color(0xFF9E9E9E);
        icon = Icons.star_border;
    }
    
    return BadgeInfo(
      badge.nom,
      color,
      icon,
    );
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
            actions: [
              // Bouton pour forcer la vérification rétroactive des badges de progression
              IconButton(
                icon: const Icon(Icons.sync, color: Colors.black),
                tooltip: 'Vérifier les badges de progression',
                onPressed: _forceRetroactiveCheck,
              ),
              IconButton(
                icon: Icon(
                  _showOnlyObtained ? Icons.filter_alt : Icons.filter_alt_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _showOnlyObtained = !_showOnlyObtained;
                  });
                },
                tooltip: _showOnlyObtained ? 'Afficher tous les badges' : 'Afficher uniquement les badges obtenus',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: _loadBadges,
                tooltip: 'Actualiser',
              ),
            ],
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
                        // Section "Vous avez collecté" avec progression
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
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
                                  '$_obtainedCount / $_totalCount Badges',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Barre de progression
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: _progressPercentage,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                    minHeight: 8,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${(_progressPercentage * 100).toStringAsFixed(0)}% complété',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Titre de la section des badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _showOnlyObtained ? 'Badges obtenus' : 'Tous les badges',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            if (_allBadges != null && _allBadges!.isNotEmpty)
                              Text(
                                '${_displayedBadges.length} badge${_displayedBadges.length > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Grille des badges
                        _allBadges == null || _allBadges!.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey.shade400),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Aucun badge disponible',
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
                            : _displayedBadges.isEmpty && _showOnlyObtained
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
                                    itemCount: _displayedBadges.length,
                                    itemBuilder: (context, index) {
                                      final badgeEleve = _displayedBadges[index];
                                      final badgeInfo = _convertBadgeToBadgeInfo(badgeEleve);
                                      return BadgeCardWithStatus(
                                        badgeEleve: badgeEleve,
                                        badgeInfo: badgeInfo,
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

// Widget pour représenter un badge individuel avec statut d'obtention
class BadgeCardWithStatus extends StatelessWidget {
  final BadgeEleveResponse badgeEleve;
  final BadgeInfo badgeInfo;
  final Color primaryColor;

  const BadgeCardWithStatus({
    super.key,
    required this.badgeEleve,
    required this.badgeInfo,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBadgeDetails(context, badgeEleve),
      child: BadgeCard(
        badge: badgeInfo,
        badgeModel: null,
        primaryColor: primaryColor,
        isObtained: badgeEleve.obtenu,
        dateObtention: badgeEleve.dateObtention,
        challengeTitre: badgeEleve.challengeTitre,
        badgeIcone: badgeEleve.icone, // Passer l'icône emoji
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeEleveResponse badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(badge.nom),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                badge.icone,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              Text(
                badge.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              if (badge.obtenu) ...[
                const SizedBox(height: 16),
                if (badge.dateObtention != null)
                  Text(
                    'Obtenu le ${DateFormat('dd/MM/yyyy').format(badge.dateObtention!)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                if (badge.challengeTitre != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Via: ${badge.challengeTitre}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ] else ...[
                const SizedBox(height: 16),
                Text(
                  'Badge verrouillé\nGagnez un challenge pour débloquer ce badge!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// Widget pour représenter un badge individuel (ancien, gardé pour compatibilité)
class BadgeCard extends StatelessWidget {
  final BadgeInfo badge;
  final BadgeModel.Badge? badgeModel; // Modèle Badge optionnel pour afficher la description
  final Color primaryColor;
  final bool isObtained;
  final DateTime? dateObtention;
  final String? challengeTitre;
  final String? badgeIcone; // Icône emoji du badge

  const BadgeCard({
    super.key,
    required this.badge,
    this.badgeModel,
    required this.primaryColor,
    this.isObtained = true,
    this.dateObtention,
    this.challengeTitre,
    this.badgeIcone,
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
    return Opacity(
      opacity: isObtained ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: isObtained ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isObtained 
                ? primaryColor.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isObtained 
                  ? primaryColor.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
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
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: isObtained ? primaryColor : Colors.grey,
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
                        color: isObtained 
                            ? _getRibbonColor(badge.color)
                            : Colors.grey,
                      ),
                      // L'icône principale (emoji depuis badgeIcone ou icon depuis badge)
                      ((badgeIcone?.isNotEmpty ?? false))
                          ? Text(
                              badgeIcone!,
                              style: const TextStyle(fontSize: 30),
                            )
                          : Icon(
                              badge.icon,
                              size: 30,
                              color: isObtained ? badge.color : Colors.grey,
                            ),
                    ],
                  ),
                ),
                // Icône de cadenas si non obtenu
                if (!isObtained)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
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
                      fontWeight: isObtained ? FontWeight.w600 : FontWeight.normal,
                      color: isObtained 
                          ? primaryColor.withOpacity(0.8)
                          : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isObtained && dateObtention != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yy').format(dateObtention!),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}