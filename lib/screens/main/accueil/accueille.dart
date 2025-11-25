import 'dart:async';
import 'package:edugo/screens/main/accueil/activiteRecente.dart';
import 'package:edugo/screens/main/bibliotheque/webview_screen.dart';
import 'package:edugo/screens/main/accueil/partenaire.dart';
import 'package:edugo/screens/main/bibliotheque/mesLectures.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/profil/profil.dart';
import 'package:edugo/screens/main/accueil/badges.dart';
import 'package:edugo/screens/main/accueil/notification.dart';
import 'package:edugo/screens/conversionData/listeConversion.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/services/objectifService.dart';
import 'package:edugo/models/objectifRequest.dart';
import 'package:edugo/models/objectifResponse.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/models/progression_response.dart';
import 'package:edugo/models/livre_response.dart';
import 'package:edugo/models/livre.dart';
import 'package:edugo/services/badge_service.dart';
import 'package:edugo/services/statistique_service.dart';
import 'package:edugo/models/badge.dart' as BadgeModel;
import 'package:edugo/models/badge_response.dart';
import 'package:edugo/screens/main/bibliotheque/bibliotheque.dart';
import 'package:edugo/services/partenaire_service.dart';
import 'package:edugo/models/partenaire.dart';
import 'package:edugo/services/defi_service.dart';
import 'package:edugo/models/defi_response.dart';
import 'package:edugo/models/eleve_defi_response.dart';
import 'package:edugo/services/activite_service.dart';
import 'package:edugo/screens/main/defi/take_defi_screen.dart';
import 'package:edugo/services/book_file_service.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/services/notification_service.dart';
import 'package:edugo/widgets/notification_badge.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'dart:async';

// --- CONSTANTES DE STYLES ---
const Color _colorBlack = Color(0xFF000000);
const Color _colorWhite = Color(0xFFFFFFFF);
const Color _colorWarning = Color(0xFFFF9800);
const Color _colorGold = Color(0xFFFFD200);
const Color _colorBronze = Color(0xFFCD7F32);
const Color _colorSilver = Color(0xFFC0C0C0);
const Color _colorSuccessCheck = Color(0xFF32C832);
const Color _colorBookIcon = Color(0xFF90A4AE);
const Color _colorTrophyIcon = Color(0xFFE8981A);
const Color _colorPartnerKhaki = Color(0xFF3B5998);
const Color _colorPartnerGreen = Color(0xFF6AC259);
const String _fontFamily = 'Roboto';

// Modèle pour une lecture en cours
class CurrentReading {
  final String title;
  final String? author;
  final double progress;
  final int? livreId; // ID du livre pour navigation
  final int? eleveId; // ID de l'élève pour navigation
  final int? pageActuelle; // Page actuelle de lecture

  const CurrentReading({
    required this.title,
    this.author,
    required this.progress,
    this.livreId,
    this.eleveId,
    this.pageActuelle,
  });
}

class HomeScreen extends StatefulWidget {
  final int? eleveId;
  final ThemeService themeService;

  const HomeScreen({super.key, this.eleveId, required this.themeService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
  // Méthode statique pour rafraîchir depuis l'extérieur
  static void refresh(BuildContext? context) {
    if (context != null) {
      final state = context.findAncestorStateOfType<_HomeScreenState>();
      state?.refreshData();
    }
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final EleveService _eleveService = EleveService();
  final ObjectifService _objectifService = ObjectifService();
  final LivreService _livreService = LivreService();
  final BadgeService _badgeService = BadgeService();
  final StatistiqueService _statistiqueService = StatistiqueService();
  final PartenaireService _partenaireService = PartenaireService();
  final DefiService _defiService = DefiService();
  final ActiviteService _activiteService = ActiviteService();
  final NotificationService _notificationService = NotificationService();
  
  // État pour le compteur de notifications
  int _unreadNotificationCount = 0;
  Timer? _notificationTimer;

  // Données réelles de l'utilisateur
  String _userName = 'Chargement...';
  String _userPhotoProfil = '';
  int _userPoints = 0;
  int? _currentEleveId;

  // Variables pour l'objectif - TYPE CORRIGÉ
  ObjectifResponse? _currentObjectif;
  bool _isLoadingObjectif = false;

  // Données pour les défis
  BuiltList<DefiResponse>? _defisDisponibles;
  bool _isLoadingDefis = false;
  double _dailyChallengeProgress = 0.0;
  bool _isChallengeCompleted = false;
  final int _booksRead = 3;
  final int _totalBooksGoal = 5;
  final int _daysRemaining = 3;

  final List<Map<String, dynamic>> _defaultRecentActivities = const [
    {'icon': Icons.check_circle, 'color': _colorSuccessCheck, 'text': 'Quiz sur le livre Harry Potter à l\'école, il y a 2 jours'},
    {'icon': Icons.book, 'color': _colorBookIcon, 'text': 'Nouveau livre débuté, il y a 4 jours'},
    {'icon': Icons.emoji_events, 'color': _colorTrophyIcon, 'text': 'Dernière challenge participé, il y a 2 jours'},
  ];

  final List<CurrentReading> _defaultCurrentReadings = const [
    CurrentReading(title: 'Le Petit Prince', progress: 0.75),
    CurrentReading(title: 'Le jardin invisible', progress: 0.45),
    CurrentReading(title: 'Le coeur se souvient', progress: 0.25),
  ];

  BuiltList<ProgressionResponse>? _readingProgress;
  bool _isLoadingReadings = false;
  
  // Activités récentes
  List<ActiviteRecente> _activites = [];
  bool _isLoadingActivites = false;
  Timer? _refreshTimer;
  
  // Badges et statistiques
  BuiltList<BadgeModel.Badge>? _badges; // Badges obtenus
  BuiltList<BadgeModel.Badge>? _allBadges; // Tous les badges disponibles
  JsonObject? _statistiques;
  bool _isLoadingBadges = false;
  bool _isLoadingStats = false;
  
  // Recommandations (livres disponibles non lus)
  BuiltList<Livre>? _recommendedBooks;
  bool _isLoadingRecommendations = false;
  
  // Partenaires
  BuiltList<Partenaire>? _partners;
  bool _isLoadingPartners = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Rafraîchir les données périodiquement (toutes les 30 secondes)
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted && _currentEleveId != null) {
        _loadReadingProgress();
        _loadActivites();
        _refreshPoints();
      } else {
        timer.cancel();
      }
    });
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    _notificationTimer?.cancel();
    super.dispose();
  }
  
  // Recharger les données quand on revient sur cette page
  void refreshData() {
    if (_currentEleveId != null) {
      _refreshPoints();
      _loadReadingProgress();
      _loadRecommendations();
      _loadBadges();
      _loadStatistiques();
      _loadActivites();
      _loadUnreadNotificationCount();
    }
  }
  
  /// Charger le nombre de notifications non lues
  Future<void> _loadUnreadNotificationCount() async {
    if (_currentEleveId == null) return;
    
    try {
      final count = await _notificationService.getUnreadNotificationCount(_currentEleveId!);
      if (mounted) {
        setState(() {
          _unreadNotificationCount = count;
        });
        print('[HomeScreen] 📬 Notifications non lues: $count');
      }
    } catch (e) {
      print('[HomeScreen] ❌ Erreur lors du chargement du compteur de notifications: $e');
    }
  }
  
  /// Démarrer le timer pour rafraîchir le compteur de notifications
  void _startNotificationTimer() {
    _notificationTimer?.cancel();
    _notificationTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (mounted && _currentEleveId != null) {
        _loadUnreadNotificationCount();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _loadUserData() async {
    try {
      // Priorité 1: Utiliser l'ID passé en paramètre
      if (widget.eleveId != null) {
        _currentEleveId = widget.eleveId;
        print(' Chargement des données avec ID depuis MainScreen: $_currentEleveId');

        final eleveData = await _eleveService.getEleveProfile(_currentEleveId!);
        if (eleveData != null) {
          _updateUIWithEleveData(eleveData);
          _authService.setCurrentEleve(eleveData);
          // Rafraîchir les points explicitement
          await _refreshPoints();
          await _loadCurrentObjectif();
          await _loadReadingProgress();
          await _loadBadges();
          await _loadStatistiques();
          await _loadRecommendations();
          await _loadPartners();
          await _loadDefis();
          await _loadUnreadNotificationCount();
          _startNotificationTimer();
          return;
        }
      }

      // Priorité 2: Essayer de récupérer depuis AuthService
      final eleve = _authService.currentEleve;
      if (eleve != null) {
        _updateUIWithEleveData(eleve);
        _currentEleveId = eleve.id;
        await _loadCurrentObjectif();
        await _loadReadingProgress();
        await _loadBadges();
        await _loadStatistiques();
        await _loadRecommendations();
        await _loadActivites();
        await _loadUnreadNotificationCount();
        _startNotificationTimer();
        return;
      }

      // Priorité 3: Essayer de récupérer l'ID depuis AuthService
      final userId = _authService.currentUserId;
      if (userId != null) {
        _currentEleveId = userId;
        final eleveData = await _eleveService.getEleveProfile(userId);
        if (eleveData != null) {
          _updateUIWithEleveData(eleveData);
          _authService.setCurrentEleve(eleveData);
          // Rafraîchir les points explicitement
          await _refreshPoints();
          await _loadCurrentObjectif();
          await _loadReadingProgress();
          await _loadBadges();
          await _loadStatistiques();
          await _loadRecommendations();
          await _loadPartners();
          await _loadDefis();
          await _loadUnreadNotificationCount();
          _startNotificationTimer();
          return;
        }
      }

      // Dernier recours: données simulées
      _setDefaultData();

    } catch (e) {
      print(' Erreur lors du chargement des données utilisateur: $e');
      _setDefaultData();
    }
  }

  Future<void> _loadCurrentObjectif() async {
    if (_currentEleveId == null) {
      print('❌ ID élève non disponible pour charger l\'objectif');
      return;
    }

    setState(() {
      _isLoadingObjectif = true;
    });

    try {
      print('🔄 Chargement de l\'objectif pour l\'élève ID: $_currentEleveId');
      final objectif = await _objectifService.getObjectifEnCours(_currentEleveId!);

      if (objectif != null) {
        setState(() {
          _currentObjectif = objectif;
        });
        print('✅ Objectif chargé: ${objectif.typeObjectif}, Livres: ${objectif.nbreLivre}');
      } else {
        print('ℹ️ Aucun objectif en cours trouvé pour cet élève');
        setState(() {
          _currentObjectif = null;
        });
      }
    } catch (e) {
      print('❌ Erreur détaillée lors du chargement de l\'objectif: $e');
      setState(() {
        _currentObjectif = null;
      });
    } finally {
      setState(() {
        _isLoadingObjectif = false;
      });
    }
  }

  Future<void> _loadReadingProgress() async {
    if (_currentEleveId == null) return;
    setState(() {
      _isLoadingReadings = true;
    });

    try {
      final progressions = await _livreService.getProgressionLecture(_currentEleveId!);
      if (mounted) {
        setState(() {
          _readingProgress = progressions;
        });
      }
    } catch (e) {
      print('❌ Erreur lors du chargement des lectures: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingReadings = false;
        });
      }
    }
  }

  Future<void> _loadBadges() async {
    if (_currentEleveId == null) return;
    setState(() {
      _isLoadingBadges = true;
    });

    try {
      // Charger les badges obtenus et tous les badges disponibles en parallèle
      final results = await Future.wait([
        _badgeService.getBadges(_currentEleveId!),
        _badgeService.getAllBadges(),
      ]);
      
      final earnedBadges = results[0] as BuiltList<BadgeModel.Badge>?;
      final allBadgesResponse = results[1] as BuiltList<BadgeResponse>?;
      
      if (mounted) {
        setState(() {
          _badges = earnedBadges;
          // Convertir BadgeResponse en Badge pour l'affichage
          if (allBadgesResponse != null) {
            final convertedBadges = allBadgesResponse
                .map((br) => _badgeService.convertBadgeResponseToBadge(br))
                .whereType<BadgeModel.Badge>()
                .toList();
            _allBadges = BuiltList<BadgeModel.Badge>(convertedBadges);
          }
        });
      }
    } catch (e) {
      print('Error loading badges: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBadges = false;
        });
      }
    }
  }

  Future<void> _loadStatistiques() async {
    if (_currentEleveId == null) return;
    setState(() {
      _isLoadingStats = true;
    });

    try {
      final stats = await _statistiqueService.getStatistiques(_currentEleveId!);
      if (mounted) {
        setState(() {
          _statistiques = stats;
        });
      }
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStats = false;
        });
      }
    }
  }

  Future<void> _loadDefis() async {
    if (_currentEleveId == null) return;
    setState(() {
      _isLoadingDefis = true;
    });

    try {
      final defis = await _defiService.getDefisDisponibles(_currentEleveId!);
      final defisParticipes = await _defiService.getDefisParticipes(_currentEleveId!);
      
      if (mounted) {
        setState(() {
          _defisDisponibles = defis;
          
          // Déterminer le défi du jour (premier défi disponible)
          if (defis != null && defis.isNotEmpty) {
            final defiDuJour = defis.first;
            
            // Vérifier si l'élève a participé à ce défi
            if (defisParticipes != null && defisParticipes.isNotEmpty) {
              // Chercher la participation pour ce défi
              EleveDefiResponse? participation;
              try {
                participation = defisParticipes.firstWhere(
                  (p) => p.defiId == defiDuJour.id,
                );
              } catch (e) {
                // Aucune participation trouvée
                participation = null;
              }
              
              if (participation != null) {
                // Si l'élève a participé, vérifier si le défi est complété
                // On considère qu'un défi est complété si le statut est "complété" ou "terminé"
                final statut = participation.statut?.toLowerCase() ?? '';
                final estComplete = statut.contains('complété') || 
                                   statut.contains('terminé') || 
                                   statut.contains('complete') ||
                                   statut.contains('termine');
                
                _dailyChallengeProgress = estComplete ? 1.0 : 0.5; // 50% si en cours, 100% si complété
                _isChallengeCompleted = estComplete;
              } else {
                // Pas encore participé
                _dailyChallengeProgress = 0.0;
                _isChallengeCompleted = false;
              }
            } else {
              // Aucune participation
              _dailyChallengeProgress = 0.0;
              _isChallengeCompleted = false;
            }
          } else {
            // Aucun défi disponible
            _dailyChallengeProgress = 0.0;
            _isChallengeCompleted = false;
          }
        });
      }
    } catch (e) {
      print('Error loading defis: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDefis = false;
        });
      }
    }
  }

  Future<void> _loadRecommendations() async {
    if (_currentEleveId == null) return;
    setState(() {
      _isLoadingRecommendations = true;
    });

    try {
      // Récupérer les livres disponibles
      final availableBooks = await _livreService.getLivresDisponibles(_currentEleveId!);
      
      if (availableBooks != null && mounted) {
        // Filtrer les livres non lus (ceux qui n'ont pas de progression ou progression < 100%)
        final readBookIds = _readingProgress
            ?.where((p) => (p.pourcentageCompletion ?? 0) >= 100)
            .map((p) => p.livreId)
            .toSet() ?? <int>{};
        
        final unreadBooks = availableBooks
            .where((book) => book.id != null && !readBookIds.contains(book.id))
            .take(10) // Limiter à 10 livres pour les recommandations
            .toList();
        
        setState(() {
          _recommendedBooks = BuiltList<Livre>(unreadBooks);
        });
      }
    } catch (e) {
      print('Error loading recommendations: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRecommendations = false;
        });
      }
    }
  }
  
  // Recharger les points après un quiz
  Future<void> _refreshPoints() async {
    if (_currentEleveId == null) return;
    try {
      print('🔄 Rafraîchissement des points pour l\'élève $_currentEleveId');
      // Utiliser uniquement getElevePoints pour éviter les conflits
      final points = await _eleveService.getElevePoints(_currentEleveId!);
      print('📊 Points récupérés: $points');
      if (points != null && mounted) {
        setState(() {
          _userPoints = points;
        });
        print('✅ Points mis à jour dans l\'UI: $_userPoints');
      }
    } catch (e) {
      print('❌ Erreur lors du rafraîchissement des points: $e');
    }
  }

  void _updateUIWithEleveData(Eleve eleve) {
    final newPoints = eleve.pointAccumule ?? 0;
    setState(() {
      _userName = '${eleve.prenom ?? ''} ${eleve.nom ?? ''}'.trim();
      _userPhotoProfil = eleve.photoProfil ?? '';
      // Toujours mettre à jour les points pour éviter qu'ils disparaissent
      _userPoints = newPoints;
      print('✅ Points mis à jour: $_userPoints');
      _currentEleveId = eleve.id;
    });
    print('✅ Données utilisateur mises à jour: $_userName, Points: $_userPoints');
  }

  void _setDefaultData() {
    setState(() {
      _userName = 'Utilisateur';
      _userPhotoProfil = '';
      _userPoints = 0;
    });
    print(' Utilisation des données par défaut');
  }

  // Fonction pour afficher le popup de défi (redirection vers page dédiée)
  void _showChallengeDialog(BuildContext context) {
    // Navigation vers la page dédiée au lieu du popup
    if (_defisDisponibles != null && _defisDisponibles!.isNotEmpty && _currentEleveId != null) {
      final defiDuJour = _defisDisponibles!.first;
      if (defiDuJour.id != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TakeDefiScreen(
              defiId: defiDuJour.id!,
              eleveId: _currentEleveId!,
              defiTitle: defiDuJour.titre,
            ),
          ),
        ).then((_) {
          // Rafraîchir les défis et points après retour
          _loadDefis();
          _refreshPoints();
        });
      }
    }
  }

  // Fonction pour compléter le défi (désactivée - gérée par la page dédiée)
  void _completeChallenge(bool isCorrect, BuildContext context) {
    // Ne fait rien - la soumission est gérée dans TakeDefiScreen
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: widget.themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              _buildHeader(context, primaryColor),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildReadingGoals(context, primaryColor),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildBadgesSection(context, primaryColor),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildRecentActivitySection(context, primaryColor),
                    ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildRecommendationsSection(primaryColor),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildCurrentReadingsSection(context, primaryColor),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildPartnersSection(context, primaryColor),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
        );
      },
    );
  }

  // -------------------------------------------------------------------
  // --- WIDGETS PRINCIPAUX ---
  // -------------------------------------------------------------------

  Widget _buildHeader(BuildContext context, Color primaryColor) {
    final double effectiveHeaderHeight = 170.0;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FixedHeaderDelegate(
        minHeight: effectiveHeaderHeight,
        maxHeight: effectiveHeaderHeight,
        child: _buildHeaderContent(context, primaryColor),
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context, Color primaryColor) {
    return Container(
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40), // Réduire de 80 à 70 pour remonter l'ellipse/rectangle
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilScreen(
                              eleveId: _currentEleveId
                            )),
                          );
                        },
                        child: _buildUserAvatar(primaryColor),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bienvenue',
                              style: TextStyle(
                                color: _colorWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: _fontFamily,
                              ),
                            ),
                            Text(
                              _userName,
                              style: const TextStyle(
                                color: _colorWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: _fontFamily,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PointExchangeScreen(themeService: widget.themeService)),
                              );
                            },
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 120),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, color: _colorGold, size: 18),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      '$_userPoints',
                                      style: const TextStyle(
                                        color: _colorWhite,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              // Marquer toutes les notifications comme lues lors de l'ouverture
                              if (_currentEleveId != null && _unreadNotificationCount > 0) {
                                await _notificationService.markAllAsRead(_currentEleveId!);
                                // Rafraîchir le compteur
                                await _loadUnreadNotificationCount();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(
                                    themeService: widget.themeService,
                                    eleveId: _currentEleveId,
                                  ),
                                ),
                              ).then((_) {
                                // Rafraîchir le compteur après retour de la page de notifications
                                _loadUnreadNotificationCount();
                              });
                            },
                            child: NotificationBadge(
                              count: _unreadNotificationCount,
                              badgeColor: Colors.red,
                              textColor: Colors.white,
                              badgeSize: 18.0,
                              fontSize: 11.0,
                              padding: const EdgeInsets.all(2.0),
                              child: const Icon(
                                Icons.notifications,
                                color: _colorGold,
                                size: 26,
                              ),
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
          Positioned(
            bottom: -30, // Remonter la carte de défi (de -30 à -20)
            left: 20,
            right: 20,
            child: _buildDailyChallengeCard(primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(Color primaryColor) {
    if (_userPhotoProfil.isNotEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(_userPhotoProfil),
        onBackgroundImageError: (exception, stackTrace) {
          setState(() {
            _userPhotoProfil = '';
          });
        },
      );
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: _colorWhite,
      child: _userName != 'Chargement...' && _userName != 'Utilisateur'
          ? Text(
              _getUserInitials(),
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          : Icon(Icons.person, color: primaryColor, size: 40),
    );
  }

  String _getUserInitials() {
    if (_userName.isEmpty || _userName == 'Chargement...' || _userName == 'Utilisateur') {
      return '';
    }

    final parts = _userName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '';
  }

  Widget _buildDailyChallengeCard(Color primaryColor) {
    final String progressText = _isChallengeCompleted
        ? 'Complété'
        : '5min';

    return GestureDetector(
      onTap: !_isChallengeCompleted
          ? () => _showChallengeDialog(context)
          : null,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _colorWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Défi du jour', style: TextStyle(color: _colorBlack, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    if (!_isChallengeCompleted && _defisDisponibles != null && _defisDisponibles!.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          final defiDuJour = _defisDisponibles!.first;
                          if (defiDuJour.id != null && _currentEleveId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TakeDefiScreen(
                                  defiId: defiDuJour.id!,
                                  eleveId: _currentEleveId!,
                                  defiTitle: defiDuJour.titre,
                                ),
                              ),
                            ).then((_) {
                              // Rafraîchir les défis après retour
                              _loadDefis();
                              _refreshPoints();
                            });
                          }
                        },
                        child: const Icon(Icons.edit, color: Colors.grey, size: 18),
                      ),
                  ],
                ),
                Text(
                  progressText,
                  style: TextStyle(
                      color: _isChallengeCompleted ? primaryColor : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: LinearProgressIndicator(
                value: _dailyChallengeProgress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                    _isChallengeCompleted ? primaryColor : _colorWarning
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingGoals(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Objectifs de Lecture',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                if (_currentObjectif != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vous avez déjà un objectif en cours.'),
                    ),
                  );
                } else {
                  _showGoalDialog(context);
                }
              },
              child: Text(
                'Définir',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
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
                    _isLoadingObjectif
                      ? 'Chargement...'
                      : _currentObjectif?.typeObjectif ?? 'Aucun objectif',
                    style: const TextStyle(
                      color: _colorBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentObjectif?.nbreLivre ?? 0} livres',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_currentObjectif != null) ...[
                Text(
                  'Progression: ${_currentObjectif!.livresLus ?? 0}/${_currentObjectif!.nbreLivre} livres',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: LinearProgressIndicator(
                    value: _currentObjectif!.nbreLivre > 0
                      ? (_currentObjectif!.livresLus ?? 0) / _currentObjectif!.nbreLivre
                      : 0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 8,
                  ),
                ),
              ] else ...[
                const Text(
                  'Définissez un objectif pour suivre votre progression',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _GoalPopup(
          eleveId: _currentEleveId,
          themeService: widget.themeService,
          onObjectifCreated: () {
            _loadCurrentObjectif();
          },
        );
      },
    );
  }

  Widget _buildBadgesSection(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Succès et Badges', style: TextStyle(color: _colorBlack, fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  BadgesScreen(themeService: widget.themeService)),
                );
              },
              child: Text(
                'Voir tout',
                style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500)
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _isLoadingBadges
            ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildBadgeItems(primaryColor),
              ),
      ],
    );
  }

  Widget _buildRecentActivitySection(BuildContext context, Color primaryColor) {
    final activities = _recentActivitiesList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Activité Récentes', style: TextStyle(color: _colorBlack, fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>   RecentActivitiesScreen(themeService: widget.themeService)),
                );
              },
              child: Text(
                'Voir tout',
                style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500)
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: activities.map((activity) =>
                _ActivityRow(icon: activity['icon'], color: activity['color'], text: activity['text'])
            ).toList(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBadgeItems(Color primaryColor) {
    // Si on a tous les badges disponibles, les afficher avec ceux obtenus débloqués
    if (_allBadges != null && _allBadges!.isNotEmpty) {
      final earnedBadgeIds = _badges?.map((b) => b.id).toSet() ?? <int>{};
      
      return _allBadges!.take(3).map((BadgeModel.Badge badge) {
        final isUnlocked = earnedBadgeIds.contains(badge.id);
        Color color;
        switch (badge.type) {
          case BadgeModel.BadgeTypeEnum.OR:
            color = _colorGold;
            break;
          case BadgeModel.BadgeTypeEnum.ARGENT:
            color = _colorSilver;
            break;
          case BadgeModel.BadgeTypeEnum.BRONZE:
            color = _colorBronze;
            break;
          default:
            color = primaryColor;
        }
        return _BadgeItem(
          iconColor: color,
          label: badge.nom ?? 'Badge',
          isUnlocked: isUnlocked,
        );
      }).toList();
    }
    
    // Sinon, afficher les badges obtenus + des badges par défaut verrouillés
    final items = <Widget>[];
    
    if (_badges != null && _badges!.isNotEmpty) {
      items.addAll(_badges!.take(3).map((BadgeModel.Badge badge) {
        Color color;
        switch (badge.type) {
          case BadgeModel.BadgeTypeEnum.OR:
            color = _colorGold;
            break;
          case BadgeModel.BadgeTypeEnum.ARGENT:
            color = _colorSilver;
            break;
          case BadgeModel.BadgeTypeEnum.BRONZE:
            color = _colorBronze;
            break;
          default:
            color = primaryColor;
        }
        return _BadgeItem(
          iconColor: color,
          label: badge.nom ?? 'Badge',
          isUnlocked: true,
        );
      }));
    }
    
    // Ajouter des badges verrouillés pour compléter jusqu'à 3
    final remaining = 3 - items.length;
    if (remaining > 0) {
      final defaultBadges = [
        {'color': _colorGold, 'label': 'Génie math'},
        {'color': _colorBronze, 'label': '20 question/10min'},
        {'color': _colorSilver, 'label': 'Calcul mental'},
      ];
      for (int i = 0; i < remaining; i++) {
        final badge = defaultBadges[i % defaultBadges.length];
        items.add(_BadgeItem(
          iconColor: badge['color'] as Color,
          label: badge['label'] as String,
          isUnlocked: false,
        ));
      }
    }
    
    return items;
  }

  Widget _buildRecommendationsSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommandation pour toi',
              style: TextStyle(color: _colorBlack, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Rediriger vers la bibliothèque
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LibraryScreen(eleveId: _currentEleveId),
                  ),
                ).then((_) {
                  _loadReadingProgress();
                  _loadCurrentObjectif();
                });
              },
              child: Text(
                'Voir tout',
                style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500)
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 15),
        _isLoadingRecommendations
            ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : _recommendedBooks == null || _recommendedBooks!.isEmpty
                ? SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'Aucune recommandation disponible',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _recommendedBooks!.map((book) {
                        // Use default image if imageCouverture is null or invalid
                        final imageUrl = book.imageCouverture;
                        // Construire l'URL complète si c'est un chemin relatif
                        String? coverAsset;
                        if (imageUrl != null && imageUrl.isNotEmpty && !imageUrl.contains('Chemin')) {
                          if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
                            coverAsset = imageUrl;
                          } else if (imageUrl.startsWith('/')) {
                            // Chemin absolu, construire l'URL complète
                            final baseUrl = _authService.dio.options.baseUrl.replaceAll('/api', '');
                            coverAsset = '$baseUrl$imageUrl';
                          } else {
                            // Chemin relatif
                            final baseUrl = _authService.dio.options.baseUrl.replaceAll('/api', '');
                            coverAsset = '$baseUrl/uploads/images/$imageUrl';
                          }
                        } else {
                          coverAsset = 'assets/images/book1.png';
                        }
                        return _RecommendationCard(
                          title: book.titre ?? 'Livre sans titre',
                          author: 'Auteur : ${book.auteur ?? 'Inconnu'}',
                          coverAsset: coverAsset ?? 'assets/images/book1.png',
                          livreId: book.id,
                        );
                      }).toList(),
                    ),
                  ),
      ],
    );
  }

  List<CurrentReading> _currentReadingList() {
    final data = _readingProgress;
    // Toujours retourner les vraies progressions, même si vides
    if (data == null || data.isEmpty) {
      // Retourner une liste vide au lieu des données par défaut
      return [];
    }
    return data.map((progress) {
      final percent = ((progress.pourcentageCompletion ?? 0).clamp(0, 100)) / 100;
      return CurrentReading(
        title: progress.livreTitre ?? 'Livre',
        author: progress.eleveNom,
        progress: percent,
        livreId: progress.livreId,
        eleveId: progress.eleveId,
        pageActuelle: progress.pageActuelle,
      );
    }).toList();
  }

  List<Map<String, dynamic>> _recentActivitiesList() {
    // Utiliser les vraies activités depuis ActiviteService
    if (_activites.isEmpty) {
      return _defaultRecentActivities;
    }
    
    // Prendre les 3 premières activités les plus récentes
    final recentActivites = _activites.take(3).toList();
    return recentActivites.map((activite) {
      final timeText = _relativeTime(activite.date);
      return {
        'icon': activite.icon,
        'color': activite.iconColor,
        'text': '${activite.description} $timeText',
      };
    }).toList();
  }

  String _relativeTime(DateTime? date) {
    if (date == null) return 'récemment';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return 'il y a ${diff.inDays} j';
    }
    if (diff.inHours > 0) {
      return 'il y a ${diff.inHours} h';
    }
    if (diff.inMinutes > 0) {
      return 'il y a ${diff.inMinutes} min';
    }
    return 'à l’instant';
  }

  Widget _buildCurrentReadingsSection(BuildContext context, Color primaryColor) {
    final readings = _currentReadingList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lectures',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=>  MyReadingsScreen(themeService: widget.themeService),
                  ),
                ).then((_) {
                  _loadReadingProgress();
                  _loadCurrentObjectif();
                });
              },
              child: Text(
                'Voir tout',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_isLoadingReadings)
          const Center(child: CircularProgressIndicator())
        else if (readings.isEmpty)
          const Text(
            'Aucune lecture en cours pour le moment.',
            style: TextStyle(color: Colors.grey),
          )
        else
          ...readings.map(
            (reading) => _ReadingProgressRow(
              reading: reading,
              primaryColor: primaryColor,
            ),
          ),
      ],
    );
  }

  Future<void> _loadPartners() async {
    setState(() {
      _isLoadingPartners = true;
    });
    
    try {
      final partners = await _partenaireService.getPartenairesActifs();
      if (mounted) {
        setState(() {
          _partners = partners;
          _isLoadingPartners = false;
        });
      }
    } catch (e) {
      print('Error loading partners: $e');
      if (mounted) {
        setState(() {
          _isLoadingPartners = false;
        });
      }
    }
  }

  Future<void> _loadActivites() async {
    if (_currentEleveId == null) return;
    // Ne pas mettre à jour l'état de chargement pour éviter les rebuilds inutiles
    // Charger en arrière-plan
    try {
      final activites = await _activiteService.getActivitesRecentess(_currentEleveId!);
      if (mounted) {
        setState(() {
          _activites = activites;
          _isLoadingActivites = false;
        });
      }
    } catch (e) {
      print('Error loading activities: $e');
      if (mounted) {
        setState(() {
          _isLoadingActivites = false;
        });
      }
    }
  }

  Widget _buildPartnersSection(BuildContext context, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nos partenaires éducatifs',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>  PartnersScreen(themeService: widget.themeService)));
              },
              child: Text(
                'Voir tout',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 260, // Hauteur ajustée pour la nouvelle card plus grande
          child: _isLoadingPartners
              ? const Center(child: CircularProgressIndicator())
              : _partners == null || _partners!.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun partenaire disponible',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      children: _partners!.map((partner) {
                        return _HomePartnerCard(
                          partner: partner,
                          primaryColor: primaryColor,
                        );
                      }).toList(),
                    ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------------
// --- CLASSES SÉPARÉES POUR LES POPUPS ---
// -------------------------------------------------------------------

class _GoalPopup extends StatefulWidget {
  final int? eleveId;
  final Function()? onObjectifCreated;
  final ThemeService themeService;

  const _GoalPopup({this.eleveId, this.onObjectifCreated, required this.themeService});

  @override
  State<_GoalPopup> createState() => _GoalPopupState();
}

class _GoalPopupState extends State<_GoalPopup> {
  final ObjectifService _objectifService = ObjectifService();
  final TextEditingController _livresController = TextEditingController();

  String _selectedType = 'HEBDOMADAIRE';
  final List<String> _goalTypes = ['HEBDOMADAIRE', 'MENSUEL'];

  bool _isLoading = false;

  Future<void> _createObjectif() async {
    if (widget.eleveId == null) {
      print('❌ ID élève non disponible dans le popup');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur: ID élève non disponible')),
      );
      return;
    }

    final nbreLivre = int.tryParse(_livresController.text);
    if (nbreLivre == null || nbreLivre <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un nombre de livres valide')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now().toIso8601String().split('T')[0];

      print('🔄 Création d\'objectif pour élève ID: ${widget.eleveId}');
      final result = await _objectifService.createObjectif(
        eleveId: widget.eleveId!,
        typeObjectif: _selectedType,
        nbreLivre: nbreLivre,
        dateEnvoie: now,
      );

      if (result != null) {
        print('✅ Objectif créé avec succès: ${result.typeObjectif}');
        if (widget.onObjectifCreated != null) {
          widget.onObjectifCreated!();
        }
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Objectif créé avec succès!')),
        );
      } else {
        print('❌ Erreur lors de la création de l\'objectif');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la création de l\'objectif')),
        );
      }
    } catch (e) {
      print('❌ Erreur détaillée: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.themeService.currentPrimaryColor;

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Définir un nouvel objectif',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type Objectif',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedType,
                  items: _goalTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_formatDisplayType(value)),
                    );
                  }).toList(),
                  onChanged: _isLoading ? null : (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nombre de Livres',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _livresController,
              keyboardType: TextInputType.number,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Ex: 5',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorWhite,
                    foregroundColor: _colorBlack,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('Annuler', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createObjectif,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: _colorWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(_colorWhite),
                          ),
                        )
                      : const Text('Définir', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDisplayType(String type) {
    switch (type) {
      case 'HEBDOMADAIRE': return 'Hebdomadaire';
      case 'MENSUEL': return 'Mensuel';
      default: return type;
    }
  }
}

// -------------------------------------------------------------------
// --- POPUP DE DÉFI AVEC TIMER DYNAMIQUE ---
// -------------------------------------------------------------------

class _ChallengePopup extends StatefulWidget {
  final ThemeService themeService;

  const _ChallengePopup({required this.themeService});

  @override
  State<_ChallengePopup> createState() => _ChallengePopupState();
}

class _ChallengePopupState extends State<_ChallengePopup> {
  final TextEditingController _answerController = TextEditingController();
  int _remainingTime = 92;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        _submitAnswer(false);
      }
    });
  }

  void _submitAnswer(bool isCorrect) {
    if (_timer.isActive) {
      _timer.cancel();
    }

    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeScreenState != null) {
      homeScreenState._completeChallenge(isCorrect, context);
    } else {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return isCorrect
              ? _GoodResultPopup(themeService: widget.themeService)
              : _BadResultPopup(themeService: widget.themeService);
        },
      );
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.themeService.currentPrimaryColor;

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          const Text(
            'Défi Quotidien',
            style: TextStyle(
              color: _colorBlack,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatTime(_remainingTime),
            style: TextStyle(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quelle est la formule chimique de l\'eau ?',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Votre réponse …….',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  bool isCorrect = _answerController.text.trim().toUpperCase() == 'H2O';
                  _submitAnswer(isCorrect);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: _colorWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Soumettre', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- POPUP DE BONNE RÉPONSE ---
// -------------------------------------------------------------------

class _GoodResultPopup extends StatelessWidget {
  final ThemeService themeService;

  const _GoodResultPopup({required this.themeService});

  @override
  Widget build(BuildContext context) {
    final primaryColor = themeService.currentPrimaryColor;

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bonne réponse !',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Félicitations ! vous avez gagné\n10 points',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _colorBlack,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: _colorWhite,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('OK', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- POPUP DE MAUVAISE RÉPONSE ---
// -------------------------------------------------------------------

class _BadResultPopup extends StatelessWidget {
  final ThemeService themeService;

  const _BadResultPopup({required this.themeService});

  @override
  Widget build(BuildContext context) {
    final primaryColor = themeService.currentPrimaryColor;

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mauvaise réponse',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Question :\nQuelle est la formule chimique de l\'eau ?',
            style: TextStyle(
              color: _colorBlack,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'Votre Réponse\nH3O',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'Bonne réponse\nH2O',
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: _colorWhite,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Fermer', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _BadgeItem extends StatelessWidget {
  final Color iconColor;
  final String label;
  final bool isUnlocked;
  const _BadgeItem({
    required this.iconColor, 
    required this.label,
    this.isUnlocked = true,
  });

  @override
  Widget build(BuildContext context) {
    // Griser si non débloqué
    final effectiveColor = isUnlocked ? iconColor : Colors.grey.shade300;
    final textColor = isUnlocked ? _colorBlack : Colors.grey.shade400;
    
    return Column(
      children: [
        Icon(
          Icons.emoji_events, 
          color: effectiveColor, 
          size: 50,
        ),
        const SizedBox(height: 5),
        Text(
          label, 
          textAlign: TextAlign.center, 
          style: TextStyle(
            color: textColor, 
            fontSize: 14, 
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _ActivityRow({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: const TextStyle(color: _colorBlack, fontSize: 15))),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String author;
  final String coverAsset;
  final int? livreId;
  const _RecommendationCard({
    required this.title,
    required this.author,
    required this.coverAsset,
    this.livreId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: livreId != null
          ? () {
              // Naviguer vers la bibliothèque
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LibraryScreen(eleveId: null),
                ),
              );
            }
          : null,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: coverAsset.startsWith('http')
                  ? Image.network(
                      coverAsset,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      coverAsset.startsWith('assets/') ? coverAsset : 'assets/images/$coverAsset',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            Text(author, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ReadingProgressRow extends StatelessWidget {
  final CurrentReading reading;
  final Color primaryColor;
  const _ReadingProgressRow({required this.reading, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    int percentage = (reading.progress * 100).toInt();
    final isFinished = reading.progress >= 1.0;
    Color progressColor = isFinished 
        ? Colors.green 
        : (reading.progress < 0.40 ? Colors.orange : primaryColor);

    return GestureDetector(
      onTap: reading.livreId != null && reading.eleveId != null
          ? () => _openBook(context, reading.livreId!, reading.eleveId!)
          : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        reading.title,
                        style: TextStyle(
                          color: _colorBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: isFinished ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (isFinished) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      ],
                    ],
                  ),
                ),
                Text(
                  isFinished ? 'Terminé' : '$percentage%',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (reading.pageActuelle != null && reading.pageActuelle! > 0 && !isFinished) ...[
              const SizedBox(height: 4),
              Text(
                'Page ${reading.pageActuelle}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: LinearProgressIndicator(
                value: reading.progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _openBook(BuildContext context, int livreId, int eleveId) async {
    try {
      final livreService = LivreService();
      final bookFileService = BookFileService();
      
      // Charger les détails du livre pour obtenir les fichiers
      final livre = await livreService.getLivreById(livreId);
      if (livre == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impossible de charger les détails du livre')),
          );
        }
        return;
      }
      
      // Obtenir les fichiers du livre
      final fichiers = await livreService.getFichiersLivre(livreId);
      if (fichiers == null || fichiers.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aucun fichier disponible pour ce livre')),
          );
        }
        return;
      }
      
      // Trouver le premier fichier PDF
      final pdfFile = fichiers.firstWhere(
        (f) => f.type == FichierLivreTypeEnum.PDF,
        orElse: () => fichiers.first,
      );
      
      // Ouvrir le livre avec la progression
      if (context.mounted) {
        await bookFileService.openBookFileOnline(
          pdfFile,
          context,
          livreId: livreId,
          eleveId: eleveId,
          totalPages: livre.totalPages,
        );
      }
    } catch (e) {
      print('Error opening book: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ouverture du livre: $e')),
        );
      }
    }
  }
}

// Nouvelle belle card de partenaire pour la page d'accueil (identique à celle de partenaire.dart)
class _HomePartnerCard extends StatelessWidget {
  final Partenaire partner;
  final Color primaryColor;

  const _HomePartnerCard({
    required this.partner,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final name = partner.nom ?? 'Partenaire';
    final description = partner.description ?? '';
    final logoUrl = partner.logoUrl;
    final siteWeb = partner.siteWeb;
    final domaine = partner.domaine;
    final type = partner.type;
    final pays = partner.pays;
    
    return GestureDetector(
      onTap: siteWeb != null && siteWeb!.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url: siteWeb!.startsWith('http') ? siteWeb! : 'https://$siteWeb',
                    title: name,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        width: 260, // Largeur ajustée pour l'affichage côte à côte avec hauteur 220
        height: 220, // Hauteur fixe comme demandé
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Preview du site (header avec logo) - Réduit pour s'adapter à 220
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Logo centré
                  Center(
                    child: logoUrl != null && logoUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                logoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                  Icons.business,
                                  color: primaryColor,
                                  size: 30,
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                                  Icons.business,
                                  color: primaryColor,
                                  size: 30,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            
            // Contenu de la card - Ajusté pour hauteur 220
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nom du partenaire
                  Text(
                    name,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: _fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Description
                  if (description.isNotEmpty) ...[
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Attributs supplémentaires - Réduits
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (domaine != null && domaine!.isNotEmpty)
                        _buildPartnerAttributeChip(
                          Icons.category,
                          domaine!,
                          primaryColor,
                        ),
                      if (type != null && type!.isNotEmpty)
                        _buildPartnerAttributeChip(
                          Icons.business_center,
                          type!,
                          primaryColor,
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 8), // Remplace Spacer() pour éviter l'erreur de layout
                  
                  // Bouton Visiter - Réduit
                  if (siteWeb != null && siteWeb!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.open_in_new, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Visiter',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: _fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPartnerAttributeChip(IconData icon, String label, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class _FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _FixedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_FixedHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}