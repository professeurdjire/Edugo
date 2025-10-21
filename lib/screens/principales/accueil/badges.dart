import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Badges Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const BadgesScreen(),
    );
  }
}

class BadgeInfo {
  final String title;
  final Color color; // Pour simuler les différents métaux (Or, Argent, Bronze)
  final IconData icon;

  const BadgeInfo(this.title, this.color, this.icon);
}

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  // Liste des badges à afficher dans la grille
  final List<BadgeInfo> badges = const [
    BadgeInfo('Génie math', Color(0xFFFFD700), Icons.star),
    BadgeInfo('20 question/10min', Color(0xFFCD7F32), Icons.emoji_events), // remplace medal
    BadgeInfo('Calcul mental', Color(0xFFC0C0C0), Icons.military_tech),
    BadgeInfo('Génie math', Color(0xFFCD7F32), Icons.star),
    BadgeInfo('Génie math', Color(0xFFC0C0C0), Icons.star),
    BadgeInfo('Génie math', Color(0xFFCD7F32), Icons.star),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // App Bar
      appBar: AppBar(
        // Utilisation d'un widget personnalisé pour simuler l'en-tête de l'image
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mes Badges',
          style: TextStyle(
            color: Colors.black,
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
                    color: const Color(0xFFEEE7F7), // Couleur de fond violet très clair
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Vous avez collecté',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${badges.length} Badges',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF7900), // Couleur violette
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Titre de la section des badges
              const Text(
                'Badges gagnés',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 15),

              // Grille des badges
              GridView.builder(
                shrinkWrap: true, // Important pour utiliser dans un SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Désactiver le défilement du GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 éléments par ligne comme dans l'image
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0, // Carré
                ),
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  return BadgeCard(badge: badges[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget pour représenter un badge individuel
class BadgeCard extends StatelessWidget {
  final BadgeInfo badge;

  const BadgeCard({super.key, required this.badge});

  // Fonction pour déterminer la couleur du ruban en fonction du "métal"
  Color _getRibbonColor(Color metalColor) {
    if (metalColor == const Color(0xFFFFD700)) {
      return Colors.blue; // Ruban bleu pour l'or
    } else if (metalColor == const Color(0xFFC0C0C0)) {
      return Colors.blueGrey; // Ruban bleu-gris pour l'argent
    } else {
      return Colors.deepPurple; // Ruban violet foncé pour le bronze
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black.withOpacity(0.2), // Stroke noir à 20 %
          width: 1, // la largeur du contour
        ),
        boxShadow: [
          // Ombre légère pour le look "carte"
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // L'icône du badge (simulée avec un Container circulaire)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFA885D8), // violet clair
                width: 3.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ruban (simulé par une icône)
                Icon(
                  Icons.card_membership, // Icône pour simuler un ruban
                  size: 60,
                  color: _getRibbonColor(badge.color),
                ),
                // L'icône principale (la plus petite sur le badge)
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}