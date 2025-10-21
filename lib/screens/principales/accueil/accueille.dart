import 'package:edugo/screens/principales/accueil/activiteRecente.dart';
import 'package:edugo/screens/principales/accueil/partenaire.dart';
import 'package:edugo/screens/principales/bibliotheque/mesLectures.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/profil/profil.dart';
import 'package:edugo/screens/principales/accueil/badges.dart';
import 'package:edugo/screens/principales/accueil/notification.dart';
import 'package:edugo/screens/principales/bibliotheque/mesLectures.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active/bouton)
const Color _purpleHeader = Color(0xFFA885D8); // Violet pour l'en-tête
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorWhite = Color(0xFFFFFFFF);
const Color _colorWarning = Color(0xFFFF9800); // Orange pour la barre de défi/score
const Color _colorGold = Color(0xFFFFD200); // Or pour le badge
const Color _colorBronze = Color(0xFFCD7F32); // Bronze pour le badge
const Color _colorSilver = Color(0xFFC0C0C0); // Argent pour le badge
const Color _colorSuccessCheck = Color(0xFF32C832); // Vert pour la coche
const Color _colorBookIcon = Color(0xFF90A4AE); // Gris-bleu pour l'icône de livre
const Color _colorTrophyIcon = Color(0xFFE8981A); // Orange pour l'icône de trophée
const Color _colorPartnerKhaki = Color(0xFF3B5998); // Bleu foncé pour Khan Academy
const Color _colorPartnerGreen = Color(0xFF6AC259); // Vert pour Duolingo (simulé)
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour une lecture en cours
class CurrentReading {
  final String title;
  final String? author;
  final double progress;

  const CurrentReading({required this.title, this.author, required this.progress});
}

class HomeScreen extends StatelessWidget {
   const HomeScreen({super.key});

  // Données simulées (tirées des images précédentes)
  final String _userName = 'Haoua Haïdara';
  final int _userPoints = 1000;
  final double _dailyChallengeProgress = 1.0;
  final int _booksRead = 3;
  final int _totalBooksGoal = 5;
  final int _daysRemaining = 3;

  final List<Map<String, dynamic>> _recentActivities = const [
    {'icon': Icons.check_circle, 'color': _colorSuccessCheck, 'text': 'Quiz sur le livre Hanry Potter à l\'école, il y a 2 jours'},
    {'icon': Icons.book, 'color': _colorBookIcon, 'text': 'Nouveau livre débuté, il y a 4 jours'},
    {'icon': Icons.emoji_events, 'color': _colorTrophyIcon, 'text': 'Dernière challenge participé, il y a 2 jours'},
  ];
  
  // Données manquantes ajoutées (tirées de image_e0b7ff.jpg)
  final List<CurrentReading> _currentReadings = const [
    CurrentReading(title: 'Le Petit Prince', progress: 0.75),
    CurrentReading(title: 'Le jardin invisible', progress: 0.45),
    CurrentReading(title: 'Le coeur se souvient', progress: 0.25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. En-tête (Informations utilisateur et Défi du jour)
            _buildHeader(context),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 2. Objectifs de Lectures
                  _buildReadingGoals(),
                  
                  const SizedBox(height: 30),

                  // 3. Succès et Badges
                  _buildBadgesSection(),

                  const SizedBox(height: 30),

                  // 4. Activité Récentes
                  _buildRecentActivitySection(context),
                  
                  // --- NOUVELLES SECTIONS AJOUTÉES ---

                  const SizedBox(height: 30),
                  
                  // 5. Recommandation pour toi
                  _buildRecommendationsSection(),

                  const SizedBox(height: 30),

                  // 6. Lectures (Progression)
                  _buildCurrentReadingsSection(context),

                  const SizedBox(height: 30),

                  // 7. Nos partenaires éducatifs
                  _buildPartnersSection(context),

                  const SizedBox(height: 80), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // -------------------------------------------------------------------
  // --- WIDGETS DE NOUVELLES SECTIONS (Ajoutées) ---
  // -------------------------------------------------------------------
  
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
          height: 200, // Hauteur fixe pour la liste horizontale de cartes
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _RecommendationCard(
                title: 'Le jardin invisible', 
                author: 'Auteur : C.S.Lewis', 
                coverAsset: 'le_jardin_invisible_cover',
              ),
              _RecommendationCard(
                title: 'Le coeur se souvient', 
                author: 'Auteur : C.S.Lewis', 
                coverAsset: 'le_coeur_se_souvient_cover',
              ),
              _RecommendationCard(
                title: 'Libre comme l\'ère', 
                author: 'Auteur : C.S.Lewis', 
                coverAsset: 'libre_comme_lere_cover',
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
                // Action pour inscription
                debugPrint('Inscription cliquée.');
                 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyReadingsScreen()),
            );
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
        
        // Liste des lectures en cours
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
        
        // Liste horizontale des partenaires
        SizedBox(
          height: 150, // Hauteur fixe pour les cartes partenaires
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
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
              // Ajouter d'autres cartes si nécessaire
            ],
          ),
        ),
      ],
    );
  }


  // -------------------------------------------------------------------
  // --- WIDGETS DE STRUCTURE PRINCIPALE (Réutilisés/Simplifiés) ---
  // -------------------------------------------------------------------

   Widget _buildHeader(BuildContext context) {
     return Stack(
       clipBehavior: Clip.none,
       children: [
         // --- Conteneur violet (fond) ---
         Container(
           padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80), // 🔹 plus de bas pour laisser la place à la carte
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
                           MaterialPageRoute(builder: (context) => const ProfilScreen()),
                         );
                       },
                       child: const CircleAvatar(
                         radius: 30,
                         backgroundColor: _colorWhite,
                         child: Icon(Icons.person, color: _purpleMain, size: 40),
                       ),
                     ),
                     const SizedBox(width: 15),
                     Expanded(
                       child: Text(
                         'Bienvenue\n$_userName',
                         style: const TextStyle(
                           color: _colorWhite,
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                           fontFamily: _fontFamily,
                         ),
                       ),
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Container(
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
                             children: [
                               const Icon(Icons.star, color: _colorGold, size: 18),
                               const SizedBox(width: 5),
                               Text(
                                 '$_userPoints',
                                 style: const TextStyle(
                                   color: _colorWhite,
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ],
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

         // --- Carte du Défi du jour (chevauche le violet) ---
         Positioned(
           bottom: -30, // 🔹 décale la carte pour qu’elle sorte du violet
           left: 20,
           right: 20,
           child: _buildDailyChallengeCard(),
         ),
       ],
     );
   }




   Widget _buildDailyChallengeCard() {
    final String progressText = _dailyChallengeProgress == 1.0 ? 'Complété' : '5min restantes';

    return Container(
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
              const Row(
                children: [
                  Text('Défi du jour', style: TextStyle(color: _colorBlack, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(Icons.edit, color: Colors.grey, size: 18),
                ],
              ),
              Text(progressText, style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: _dailyChallengeProgress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(_colorWarning),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingGoals() {
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
                overflow: TextOverflow.ellipsis, // évite le dépassement
              ),
            ),
            TextButton(
              onPressed: () {},
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

  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Succès et Badges', style: TextStyle(color: _colorBlack, fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BadgesScreen()),
              );
            }, child: const Text('Voir tout', style: TextStyle(color: _purpleMain, fontSize: 14, fontWeight: FontWeight.w500))),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
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
            TextButton(onPressed: () { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecentActivitiesScreen()),
            );

            }, child: const Text('Voir tout', style: TextStyle(color: _purpleMain, fontSize: 14, fontWeight: FontWeight.w500))),
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
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
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
          // Couverture (simulée avec un Container)
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.blueGrey, 
              borderRadius: BorderRadius.circular(10),
              // Simuler une image de couverture
              image: const DecorationImage(
                image: AssetImage('assets/book_cover_placeholder.png'),
                fit: BoxFit.cover,
              ),
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
    
    // Définir la couleur de la barre de progression en fonction du pourcentage (similaire aux autres vues)
    Color progressColor;
    if (reading.progress < 0.40) {
      progressColor = Colors.orange;
    } else if (reading.progress < 0.70) {
      progressColor = _purpleMain;
    } else {
      progressColor = _purpleMain; // ou vert si > 75%
    }

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
          // Placeholder pour le bouton "Voir plus" ou logo si nécessaire
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  const _NavBarItem({required this.icon, required this.label, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? _purpleMain : _colorBlack, size: 24),
        Text(label, style: TextStyle(color: isSelected ? _purpleMain : _colorBlack, fontSize: 11, fontWeight: FontWeight.w400, fontFamily: _fontFamily)),
      ],
    );
  }
}