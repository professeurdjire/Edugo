import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur des icônes)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale

class BookReaderScreen extends StatelessWidget {
  final String bookTitle;

  // Le texte simulé du livre est basé sur l'image fournie
  final String bookContent = """
Alfred se remémore ses souvenirs personnels, ces instants en apparence anodins, mais qui ont été des bascules dans sa vie. Un souvenir en entraînant un autre, il plonge dans sa tête, dans son cheminement, qu'il traduit en dessins.
Il se rappelle ce jour de mars 2021, à Naples, alors qu'il est avec sa fille. Il a rendez-vous sur le tournage de Come Prima, avec l'équipe du film pour les scènes de nuit. Mais dans le taxi, il est complètement perdu. Dans ce port, tout se ressemble. Il panique. Il n'arrive pas à joindre l'équipe de tournage. Le chauffeur s'agace et, à sa grande surprise, sa fille prend les devants. Ils sortent du taxi et elle part en tête. Lui est toujours perdu. Il la voit devant lui, sa petite fille, qui inverse les rôles et le prend sous son aile. Il se laisse guider et quelques centaines de mètres plus loin, elle réussit à atteindre leur objectif.
En novembre 2007, il est à Djibouti, seul, pour mener des ateliers de dessin dans des écoles isolées. C'est la première fois qu'il vient en Afrique. Il est très occupé et il n'a pas toujours le temps de donner de ses nouvelles, ni d'en recevoir de France, car la connexion n'est pas bonne partout. Ce jour-là, il peut accéder à un ordinateur connecté à Internet : le directeur d'une école lui laisse sa place. Au milieu de...
""";

  const BookReaderScreen({super.key, this.bookTitle = "Le jardin Invisible"});

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

          // 2. Le corps de la page (Texte du livre défilant)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                bookContent,
                style: const TextStyle(
                  color: _colorBlack,
                  fontSize: 15,
                  height: 1.6, // Interlignage
                  fontFamily: _fontFamily,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

  Widget _buildCustomAppBar(BuildContext context) {
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

            // Titre de la page et Icône de Lecture
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
                  onPressed: () => Navigator.pop(context), 
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      bookTitle, // Ex: "Le jardin Invisible"
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_outline, color: _purpleMain, size: 30),
                  onPressed: () {
                    // Logique pour démarrer la lecture audio
                  },
                ),
              ],
            ),
          ],
        ),
      ),
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
          _NavBarItem(icon: Icons.home, label: 'Accueil'),
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque', isSelected: true), // La Bibliothèque est la section active
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge'),
          _NavBarItem(icon: Icons.checklist, label: 'Exercice'),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGET DE NAVIGATION (COMPOSANT) ---
// -------------------------------------------------------------------

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