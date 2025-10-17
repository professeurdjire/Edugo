import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur principale)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorChallenge = Color(0xFFFFA500); // Orange pour "Nouveau Challenge"
const Color _colorQuiz = Color(0xFFA885D8); // Violet pour "Quiz"
const Color _colorDefi = Color(0xFF32C832); // Vert pour "Nouveau défi"
const Color _colorData = Color(0xFFFFCC00); // Jaune pour "Data internet"
const String _fontFamily = 'Roboto'; // Police principale

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // La barre de navigation inférieure est fixe
      bottomNavigationBar: _buildBottomNavBar(),

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
                  _buildNotificationList(),
                  
                  const SizedBox(height: 80), // Espace final pour la barre de navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context) {
    // Cette section simule la barre de statut (20:20, icônes) et l'AppBar
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Column(
          children: [
            // Barre de Statut (simulée)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('20 : 20', style: TextStyle(color: _colorBlack, fontSize: 15, fontWeight: FontWeight.w700)),
                Icon(Icons.circle, color: _colorBlack, size: 10),
                Row(
                  children: [
                    Icon(Icons.wifi, color: _colorBlack, size: 20),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, color: _colorBlack, size: 20),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Titre de la page
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), // Retour à la page précédente
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: _colorBlack,
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
  
  Widget _buildNotificationList() {
    // Données de notifications simulées (basées sur l'image)
    final List<Map<String, dynamic>> notifications = [
      {'type': 'Challenge', 'title': 'Nouveau Challenge', 'body': 'Une nouvelle aventure pour vous...! Participez au challenge "Genie Mathématicien" faites vous distinguer et gagner des récompenses.', 'icon': Icons.emoji_events, 'color': _colorChallenge},
      {'type': 'Quiz', 'title': 'Quiz', 'body': 'Excellent travail ! Vous avez obtenu 200 points qu quiz sur le livre " Le Jardin Invisible".', 'icon': Icons.question_answer, 'color': _colorQuiz},
      {'type': 'Défi', 'title': 'Nouveau défi', 'body': 'Un nouveau jour, un nouveau défi ! Venez gagner des points et vous améliorez.', 'icon': Icons.volume_up, 'color': _colorDefi},
      {'type': 'Data', 'title': 'Data internet', 'body': 'Conversion réussi ! Vous venez de transformer 100 points en data. Restez connecter et continuer d\'apprendre !', 'icon': Icons.public, 'color': _colorData},
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
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    // Le code du BottomNavigationBar
    return Container(
      height: 70, 
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(icon: Icons.home, label: 'Accueil', isSelected: true), // On garde Accueil actif car on vient de là
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque'),
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge'),
          _NavBarItem(icon: Icons.checklist, label: 'Exercice'),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
        ],
      ),
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

  const _NotificationCard({
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
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
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
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
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: Colors.grey,
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

  const _NavBarItem({required this.icon, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? _purpleMain : _colorBlack,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? _purpleMain : _colorBlack,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: _fontFamily,
          ),
        ),
      ],
    );
  }
}