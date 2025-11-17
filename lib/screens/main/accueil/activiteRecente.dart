import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

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

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // 1. App Bar personnalisé (avec barre de statut et titre)
              _buildCustomAppBar(context),

              // 2. Le corps de la page (Liste des activités)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildActivitySections(primaryColor),
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

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Titre de la page
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_sharp, color: _colorBlack), // Flèche en noir
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: const Text(
                      'Activités Récentes',
                      style: TextStyle(
                        color: _colorBlack, // Titre en noir
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

  List<Widget> _buildActivitySections(Color primaryColor) {
    List<Widget> sections = [];

    _simulatedActivities.forEach((date, activities) {
      // Titre de la section (Aujourd'hui, Hier, etc.)
      sections.add(
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
          child: Text(
            date,
            style: TextStyle(
              color: primaryColor, // Sous-titres en couleur du thème
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),
        ),
      );

      // Liste des activités pour cette section
      for (var activity in activities) {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: _ActivityTile(activity: activity, primaryColor: primaryColor),
          ),
        );
      }
    });

    return sections;
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
              color: primaryColor.withOpacity(0.1),
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