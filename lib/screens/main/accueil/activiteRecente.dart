import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/activite_service.dart';
import 'package:edugo/services/auth_service.dart';

// --- CONSTANTES DE STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorSuccess = Color(0xFF32C832); // Vert pour la validation (Quiz terminé)
const Color _colorBadge = Color(0xFFE8981A); // Couleur Bronze/Trophée
const Color _colorBook = Color(0xFF90A4AE); // Couleur Livre (gris-bleu)
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une activité
class Activity {
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;

  Activity({
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

// Données d'activité simulées basées sur l'image
final Map<String, List<Activity>> _simulatedActivities = {
  'Aujourd\'hui': [
    Activity(
      description: 'Quiz sur le livre "jardin Invisible" terminé avec un score de 95%',
      time: '10 : 42',
      icon: Icons.check_circle,
      iconColor: _colorSuccess,
    ),
    Activity(
      description: 'Quiz sur le livre "jardin Invisible" terminé avec un score de 95%',
      time: '10 : 42',
      icon: Icons.emoji_events,
      iconColor: _colorBadge,
    ),
  ],
  'Hier': [
    Activity(
      description: 'Quiz sur le livre "jardin Invisible" terminé avec un score de 95%',
      time: '10 : 42',
      icon: Icons.check_circle,
      iconColor: _colorSuccess,
    ),
    Activity(
      description: 'Quiz sur le livre "jardin Invisible" terminé avec un score de 95%',
      time: '10 : 42',
      icon: Icons.book,
      iconColor: _colorBook,
    ),
  ],
};

class RecentActivitiesScreen extends StatefulWidget {
  final ThemeService? themeService; // Rendez optionnel

  const RecentActivitiesScreen({super.key, this.themeService}); // Enlevez required

  @override
  State<RecentActivitiesScreen> createState() => _RecentActivitiesScreenState();
}

class _RecentActivitiesScreenState extends State<RecentActivitiesScreen> {
  late ThemeService _themeService;
  final ActiviteService _activiteService = ActiviteService();
  final AuthService _authService = AuthService();
  List<ActiviteRecente> _activites = [];
  Map<String, List<ActiviteRecente>> _activitesGroupes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
    _loadActivites();
  }

  Future<void> _loadActivites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final eleveId = _authService.currentUserId;
      if (eleveId != null) {
        final activites = await _activiteService.getActivitesRecentess(eleveId);
        final groupes = _activiteService.grouperParJour(activites);
        
        if (mounted) {
          setState(() {
            _activites = activites;
            _activitesGroupes = groupes;
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
      print('Error loading activities: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Activités Récentes',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _activitesGroupes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Aucune activité récente',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontFamily: _fontFamily,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildActivitySections(primaryColor),
                      ),
                    ),
        );
      },
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  List<Widget> _buildActivitySections(Color primaryColor) {
    List<Widget> sections = [];

    // Trier les clés pour afficher "Aujourd'hui" et "Hier" en premier
    final sortedKeys = _activitesGroupes.keys.toList()
      ..sort((a, b) {
        if (a == 'Aujourd\'hui') return -1;
        if (b == 'Aujourd\'hui') return 1;
        if (a == 'Hier') return -1;
        if (b == 'Hier') return 1;
        return b.compareTo(a); // Dates plus récentes en premier
      });

    for (var date in sortedKeys) {
      final activites = _activitesGroupes[date]!;
      
      // Titre de la section (Aujourd'hui, Hier, etc.)
      sections.add(
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
          child: Text(
            date,
            style: TextStyle(
              color: primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
        ),
      );

      // Liste des activités pour cette section
      for (var activite in activites) {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: _ActiviteRecenteTile(activite: activite, primaryColor: primaryColor),
          ),
        );
      }
    }

    return sections;
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour : $minute';
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _ActivityTile extends StatelessWidget {
  final Activity activity;
  final Color primaryColor;

  const _ActivityTile({required this.activity, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône d'activité
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity.iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.icon,
              color: activity.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),

          // Détails de l'activité
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.time,
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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
}

class _ActiviteRecenteTile extends StatelessWidget {
  final ActiviteRecente activite;
  final Color primaryColor;

  const _ActiviteRecenteTile({required this.activite, required this.primaryColor});

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour : $minute';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône d'activité
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activite.iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activite.icon,
              color: activite.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),

          // Détails de l'activité
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activite.description,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 14,
                    fontFamily: _fontFamily,
                  ),
                ),
                if (activite.score != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      activite.totalPoints != null
                          ? 'Score: ${activite.score}/${activite.totalPoints}'
                          : 'Score: ${activite.score}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Heure
          Text(
            _formatTime(activite.date),
            style: TextStyle(
              color: primaryColor.withOpacity(0.7),
              fontSize: 12,
              fontFamily: _fontFamily,
            ),
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
  final Color primaryColor;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primaryColor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? primaryColor : _colorBlack.withOpacity(0.6),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : _colorBlack.withOpacity(0.6),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}