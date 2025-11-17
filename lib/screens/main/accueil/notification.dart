import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

// --- CONSTANTES DE STYLES ---
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorChallenge = Color(0xFFFFA500); // Orange pour "Nouveau Challenge"
const Color _colorQuiz = Color(0xFF32C832); // Vert pour "Quiz"
const Color _colorDefi = Color(0xFF2196F3); // Bleu pour "Nouveau défi"
const Color _colorData = Color(0xFFFFCC00); // Jaune pour "Data internet"
const String _fontFamily = 'Roboto'; // Police principale

class NotificationScreen extends StatefulWidget {
  final ThemeService? themeService; // Rendez optionnel

  const NotificationScreen({super.key, this.themeService}); // Enlevez required

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    // Utilisez le themeService passé ou créez-en un nouveau
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

              // 2. Le corps de la page (Défilement)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // 3. Liste des Notifications
                      _buildNotificationList(primaryColor),

                      const SizedBox(height: 80), // Espace final pour la barre de navigation
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
                const Expanded(
                  child: Center(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: _colorBlack, // Titre en noir
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Espace pour aligner le titre au centre
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(Color primaryColor) {
    // Données de notifications simulées (basées sur l'image)
    final List<Map<String, dynamic>> notifications = [
      {
        'type': 'Challenge',
        'title': 'Nouveau Challenge',
        'body': 'Une nouvelle aventure pour vous...! Participez au challenge "Genie Mathématicien" faites vous distinguer et gagner des récompenses.',
        'icon': Icons.emoji_events,
        'color': _colorChallenge
      },
      {
        'type': 'Quiz',
        'title': 'Quiz',
        'body': 'Excellent travail ! Vous avez obtenu 200 points qu quiz sur le livre " Le Jardin Invisible".',
        'icon': Icons.question_answer,
        'color': primaryColor // Quiz utilise la couleur du thème
      },
      {
        'type': 'Défi',
        'title': 'Nouveau défi',
        'body': 'Un nouveau jour, un nouveau défi ! Venez gagner des points et vous améliorez.',
        'icon': Icons.volume_up,
        'color': _colorDefi
      },
      {
        'type': 'Data',
        'title': 'Data internet',
        'body': 'Conversion réussi ! Vous venez de transformer 100 points en data. Restez connecter et continuer d\'apprendre !',
        'icon': Icons.public,
        'color': _colorData
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _NotificationCard(
            title: item['title']!,
            body: item['body']!,
            icon: item['icon'] as IconData,
            color: item['color'] as Color,
            primaryColor: primaryColor,
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final Color primaryColor;

  const _NotificationCard({
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1), // Ombre adaptée au thème
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.1), // Bordure subtile adaptée au thème
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône de la notification
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: 15),

          // Contenu du texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7), // Texte du corps adapté au thème
                    fontSize: 14,
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
        Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : _colorBlack.withOpacity(0.6),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}