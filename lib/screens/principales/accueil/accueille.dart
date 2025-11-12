import 'dart:async';
import 'package:edugo/screens/principales/accueil/activiteRecente.dart';
import 'package:edugo/screens/principales/accueil/partenaire.dart';
import 'package:edugo/screens/principales/bibliotheque/mesLectures.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/profil/profil.dart';
import 'package:edugo/screens/principales/accueil/badges.dart';
import 'package:edugo/screens/principales/accueil/notification.dart';
import 'package:edugo/screens/conversionData/listeConversion.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/models/eleve.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _purpleHeader = Color(0xFFA885D8);
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

  const CurrentReading({required this.title, this.author, required this.progress});
}

class HomeScreen extends StatefulWidget {
  final int? eleveId;

  const HomeScreen({super.key, this.eleveId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final EleveService _eleveService = EleveService();

  // Données réelles de l'utilisateur
  String _userName = 'Chargement...';
  String _userPhotoProfil = '';
  int _userPoints = 0;
  int? _currentEleveId;

  // Données simulées pour les autres sections
  double _dailyChallengeProgress = 0.0;
  bool _isChallengeCompleted = false;
  final int _booksRead = 3;
  final int _totalBooksGoal = 5;
  final int _daysRemaining = 3;

  final List<Map<String, dynamic>> _recentActivities = const [
    {'icon': Icons.check_circle, 'color': _colorSuccessCheck, 'text': 'Quiz sur le livre Harry Potter à l\'école, il y a 2 jours'},
    {'icon': Icons.book, 'color': _colorBookIcon, 'text': 'Nouveau livre débuté, il y a 4 jours'},
    {'icon': Icons.emoji_events, 'color': _colorTrophyIcon, 'text': 'Dernière challenge participé, il y a 2 jours'},
  ];

  final List<CurrentReading> _currentReadings = const [
    CurrentReading(title: 'Le Petit Prince', progress: 0.75),
    CurrentReading(title: 'Le jardin invisible', progress: 0.45),
    CurrentReading(title: 'Le coeur se souvient', progress: 0.25),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Priorité 1: Utiliser l'ID passé en paramètre
      if (widget.eleveId != null) {
        _currentEleveId = widget.eleveId;
        print('🎯 Chargement des données avec ID depuis MainScreen: $_currentEleveId');

        final eleveData = await _eleveService.getEleveProfile(_currentEleveId!);
        if (eleveData != null) {
          _updateUIWithEleveData(eleveData);
          _authService.setCurrentEleve(eleveData);
          return;
        }
      }

      // Priorité 2: Essayer de récupérer depuis AuthService
      final eleve = _authService.currentEleve;
      if (eleve != null) {
        _updateUIWithEleveData(eleve);
        _currentEleveId = eleve.id;
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
          return;
        }
      }

      // Dernier recours: données simulées
      _setDefaultData();

    } catch (e) {
      print('❌ Erreur lors du chargement des données utilisateur: $e');
      _setDefaultData();
    }
  }

  void _updateUIWithEleveData(Eleve eleve) {
    setState(() {
      _userName = '${eleve.prenom ?? ''} ${eleve.nom ?? ''}'.trim();
      _userPhotoProfil = eleve.photoProfil ?? '';
      _userPoints = eleve.pointAccumule ?? 0;
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
    print('⚠️ Utilisation des données par défaut');
  }

  // Fonction pour afficher le popup de défi
  void _showChallengeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _ChallengePopup();
      },
    );
  }

  // Fonction pour compléter le défi (appelée depuis le popup)
  void _completeChallenge(bool isCorrect, BuildContext context) {
    setState(() {
      _dailyChallengeProgress = 1.0;
      _isChallengeCompleted = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return isCorrect
              ? _GoodResultPopup()
              : _BadResultPopup();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildReadingGoals(context),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildBadgesSection(context),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildRecentActivitySection(context),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildRecommendationsSection(),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildCurrentReadingsSection(context),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildPartnersSection(context),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // --- WIDGETS PRINCIPAUX ---
  // -------------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    final double effectiveHeaderHeight = 210.0;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _FixedHeaderDelegate(
        minHeight: effectiveHeaderHeight,
        maxHeight: effectiveHeaderHeight,
        child: _buildHeaderContent(context),
      ),
    );
  }

Widget _buildHeaderContent(BuildContext context) {
  return Container(
    color: Colors.white,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
          decoration: const BoxDecoration(
            color: _purpleHeader,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
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
                            eleveId: _currentEleveId,
                          )),
                        );
                      },
                      child: _buildUserAvatar(),
                    ),
                    const SizedBox(width: 15),
                    Expanded( // ← AJOUTEZ EXPANDED ICI
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
                            overflow: TextOverflow.ellipsis, // ← AJOUTEZ OVERFLOW
                            maxLines: 1, // ← LIMITEZ À 1 LIGNE
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
                              MaterialPageRoute(builder: (context) => const PointExchangeScreen()),
                            );
                          },
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 120), // ← LIMITEZ LA LARGEUR
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
                              mainAxisSize: MainAxisSize.min, // ← AJOUTEZ CECI
                              children: [
                                const Icon(Icons.star, color: _colorGold, size: 18),
                                const SizedBox(width: 5),
                                Flexible( // ← AJOUTEZ FLEXIBLE
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationScreen()),
                            );
                          },
                          child: const Icon(
                            Icons.notifications,
                            color: _colorGold,
                            size: 26,
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
          bottom: -30,
          left: 20,
          right: 20,
          child: _buildDailyChallengeCard(),
        ),
      ],
    ),
  );
}

  Widget _buildUserAvatar() {
    if (_userPhotoProfil.isNotEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(_userPhotoProfil),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback si l'image ne charge pas
          setState(() {
            _userPhotoProfil = '';
          });
        },
      );
    }

    // Avatar par défaut avec initiales
    return CircleAvatar(
      radius: 30,
      backgroundColor: _colorWhite,
      child: _userName != 'Chargement...' && _userName != 'Utilisateur'
          ? Text(
              _getUserInitials(),
              style: const TextStyle(
                color: _purpleMain,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          : const Icon(Icons.person, color: _purpleMain, size: 40),
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

  Widget _buildDailyChallengeCard() {
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
                    if (!_isChallengeCompleted)
                      GestureDetector(
                        onTap: () => _showChallengeDialog(context),
                        child: const Icon(Icons.edit, color: Colors.grey, size: 18),
                      ),
                  ],
                ),
                Text(
                  progressText,
                  style: TextStyle(
                      color: _isChallengeCompleted ? Colors.green : Colors.grey,
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
                    _isChallengeCompleted ? Colors.green : _colorWarning
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingGoals(BuildContext context) {
    double weeklyGoalProgress = _booksRead / _totalBooksGoal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Objectifs ',
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                _showGoalDialog(context);
              },
              child: const Text(
                'Définir un objectif',
                style: TextStyle(
                  color: _purpleMain,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Objectif hebdomadaire', style: TextStyle(color: _colorBlack, fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('$_daysRemaining jours restant', style: const TextStyle(color: _purpleMain, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.book, color: _purpleMain, size: 24),
                  const SizedBox(width: 8),
                  Text('$_totalBooksGoal Livres', style: const TextStyle(color: _purpleMain, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: weeklyGoalProgress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(_purpleMain),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: Text('$_booksRead/$_totalBooksGoal livres lus', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection(BuildContext context) {
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
                    MaterialPageRoute(builder: (context) => const BadgesScreen()),
                  );
                },
                child: const Text('Voir tout', style: TextStyle(color: _purpleMain, fontSize: 14, fontWeight: FontWeight.w500))
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BadgeItem(iconColor: _colorGold, label: 'Génie math'),
            _BadgeItem(iconColor: _colorBronze, label: '20 question/10min'),
            _BadgeItem(iconColor: _colorSilver, label: 'Calcul mental'),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(BuildContext context) {
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
                    MaterialPageRoute(builder: (context) => const RecentActivitiesScreen()),
                  );
                },
                child: const Text('Voir tout', style: TextStyle(color: _purpleMain, fontSize: 14, fontWeight: FontWeight.w500))
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
            children: _recentActivities.map((activity) =>
                _ActivityRow(icon: activity['icon'], color: activity['color'], text: activity['text'])
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommandation pour toi',
          style: TextStyle(
            color: _colorBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Voir tout',
            style: TextStyle(
              color: _purpleMain,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _RecommendationCard(
                title: 'Le jardin invisible',
                author: 'Auteur : C.S.Lewis',
                coverAsset: 'book1.png',
              ),
              _RecommendationCard(
                title: 'Le coeur se souvient',
                author: 'Auteur : C.S.Lewis',
                coverAsset: 'book1.png',
              ),
              _RecommendationCard(
                title: 'Libre comme l\'ère',
                author: 'Auteur : C.S.Lewis',
                coverAsset: 'book1.png',
              ),
              _RecommendationCard(
                title: 'En apnée',
                author: 'Auteur : C.S.Lewis',
                coverAsset: 'book1.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentReadingsSection(BuildContext context) {
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyReadingsScreen()));
              },
              child: const Text(
                'Voir tout',
                style: TextStyle(
                  color: _purpleMain,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._currentReadings.map((reading) =>
            _ReadingProgressRow(reading: reading)
        ).toList(),
      ],
    );
  }

  Widget _buildPartnersSection(BuildContext context) {
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const PartnersScreen()));
              },
              child: const Text(
                'Voir tout',
                style: TextStyle(
                  color: _purpleMain,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _PartnerCard(
                title: 'Khan Academy',
                description: 'Des milliers de leçons gratuites sur tous les sujets',
                backgroundColor: _colorPartnerKhaki,
              ),
              _PartnerCard(
                title: 'Duolingo',
                description: 'Apprendre des leçons gratuites en s\'amusant !',
                backgroundColor: _colorPartnerGreen,
              ),
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
        return _GoalPopup();
      },
    );
  }
}

// -------------------------------------------------------------------
// --- POPUP DE DÉFI AVEC TIMER DYNAMIQUE ---
// -------------------------------------------------------------------

class _ChallengePopup extends StatefulWidget {
  const _ChallengePopup();

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
          return isCorrect ? _GoodResultPopup() : _BadResultPopup();
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
            style: const TextStyle(
              color: _purpleMain,
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
                  backgroundColor: _purpleMain,
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
  const _GoodResultPopup();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Bonne réponse !',
            style: TextStyle(
              color: Colors.green,
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
              backgroundColor: _purpleMain,
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
  const _BadResultPopup();

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Mauvaise réponse',
            style: TextStyle(
              color: Colors.red,
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
                backgroundColor: _purpleMain,
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
// --- WIDGETS DE COMPOSANTS (inchangés) ---
// -------------------------------------------------------------------

class _BadgeItem extends StatelessWidget {
  final Color iconColor;
  final String label;
  const _BadgeItem({required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.emoji_events, color: iconColor, size: 50),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: _colorBlack, fontSize: 14, fontWeight: FontWeight.w500)),
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
  const _RecommendationCard({required this.title, required this.author, required this.coverAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/$coverAsset',
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
    );
  }
}

class _ReadingProgressRow extends StatelessWidget {
  final CurrentReading reading;
  const _ReadingProgressRow({required this.reading});

  @override
  Widget build(BuildContext context) {
    int percentage = (reading.progress * 100).toInt();
    Color progressColor = reading.progress < 0.40 ? Colors.orange : _purpleMain;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reading.title,
                style: const TextStyle(color: _colorBlack, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                '$percentage%',
                style: TextStyle(color: progressColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  const _PartnerCard({required this.title, required this.description, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: _colorWhite, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(color: _colorWhite.withOpacity(0.8), fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
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

class _GoalPopup extends StatelessWidget {
  const _GoalPopup();

  static const List<String> _goalTypes = ['Hebdomadaire', 'Mensuel', 'Annuel'];
  final String _defaultGoalType = 'choisissez un type';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Définir un nouvel objectif',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _purpleMain,
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
                  value: null,
                  hint: Text(_defaultGoalType, style: const TextStyle(color: Colors.grey)),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: _goalTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nombre de Livre',
              style: TextStyle(
                color: _colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'renseigner un nombre',
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
                  onPressed: () {
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purpleMain,
                    foregroundColor: _colorWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 2,
                  ),
                  child: const Text('Définir', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}