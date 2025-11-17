import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

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

  // Liste des badges à afficher dans la grille
  final List<BadgeInfo> badges = const [
    BadgeInfo('Génie math', Color(0xFFFFD700), Icons.star),
    BadgeInfo('20 question/10min', Color(0xFFCD7F32), Icons.emoji_events),
    BadgeInfo('Calcul mental', Color(0xFFC0C0C0), Icons.military_tech),
    BadgeInfo('Génie math', Color(0xFFCD7F32), Icons.star),
    BadgeInfo('Génie math', Color(0xFFC0C0C0), Icons.star),
    BadgeInfo('Génie math', Color(0xFFCD7F32), Icons.star),
  ];

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
          // App Bar
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black), // Flèche en noir
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Mes Badges',
              style: TextStyle(
                color: Colors.black, // Titre en noir
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
          ),

          // Corps de la page
          body: SingleChildScrollView(
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
                            '${badges.length} Badges',
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      return BadgeCard(badge: badges[index], primaryColor: primaryColor);
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
  final Color primaryColor;

  const BadgeCard({super.key, required this.badge, required this.primaryColor});

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
            child: Text(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor.withOpacity(0.8), // Texte avec couleur du thème
              ),
            ),
          ),
        ],
      ),
    );
  }
}