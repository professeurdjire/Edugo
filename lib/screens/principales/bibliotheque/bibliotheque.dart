import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES (Réutilisées de HomeScreen) ---

const Color _purpleMain = Color(0xFFA885D8); // Violet principal (pour le BottomNav actif, filtres, etc.)
const Color _backgroundLight = Color(0xFFF5F5F5); // Fond clair pour les cartes
const Color _colorBlack = Color(0xFF000000); // Texte noir
const String _fontFamily = 'Roboto'; // Police principale

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // La barre de navigation inférieure est fixe
      bottomNavigationBar: _buildBottomNavBar(context),

      body: Column(
        children: [
          // 1. App Bar personnalisé (simulant une AppBar sans ombre)
          _buildCustomAppBar(context),

          // 2. Le corps de la page (Défilement)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // 3. Champ de recherche
                  _buildSearchBar(),
                  
                  const SizedBox(height: 20),
                  
                  // 4. Barres de filtres
                  _buildFilterBars(),
                  
                  const SizedBox(height: 20),
                  
                  // 5. Grille des Livres
                  _buildBookGrid(),
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
                Text(
                  '20 : 20',
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                Icon(Icons.circle, color: _colorBlack, size: 10), // Caméra
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
                      'Livres',
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

  Widget _buildBottomNavBar(BuildContext context) {
    // Le code du BottomNavigationBar est réutilisé de HomeScreen
    return Container(
      height: 70, 
      decoration: const BoxDecoration(
        color: Colors.white, // Utilisé blanc ou F5F5F5
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
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque', isSelected: true), // Bibliothèque est actif
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge'),
          _NavBarItem(icon: Icons.checklist, label: 'Exercice'),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance'),
        ],
      ),
    );
  }

  // --- WIDGETS DE CONTENU ---

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un livre par nom ou auteur',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFilterBars() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _FilterChip(label: 'Niveau'),
        SizedBox(width: 10),
        _FilterChip(label: 'Matières'),
        SizedBox(width: 10),
        _FilterChip(label: 'Classe'),
      ],
    );
  }

  Widget _buildBookGrid() {
    // Données de livres simulées (basées sur l'image)
    final List<Map<String, String>> books = [
      {'title': 'Le jardin invisible', 'author': 'Auteur : C.S.Lewis', 'image': 'book_garden_invisible.jpg'},
      {'title': 'Le coeur se souvient', 'author': 'Auteur : C.S.Lewis', 'image': 'book_coeur_souvient.jpg'},
      {'title': 'LIBRE COMME l\'ère', 'author': 'Auteur : C.S.Lewis', 'image': 'book_libre_ere.jpg'},
      {'title': 'En apnée', 'author': 'Auteur : C.S.Lewis', 'image': 'book_en_apnee.jpg'},
      {'title': 'LIBRE COMME l\'ère', 'author': 'Auteur : C.S.Lewis', 'image': 'book_libre_ere_2.jpg'},
      {'title': 'En apnée', 'author': 'Auteur : C.S.Lewis', 'image': 'book_en_apnee_2.jpg'},
    ];
    
    return GridView.builder(
      shrinkWrap: true, // Important pour le GridView dans un SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Le défilement est géré par le parent
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 livres par ligne
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.55, // Rapport pour avoir la bonne hauteur de carte
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _BookCard(
          title: books[index]['title']!,
          author: books[index]['author']!,
          imagePath: 'assets/images/${books[index]['image']!}', // Assurez-vous d'avoir les assets
        );
      },
    );
  }
}

// --- WIDGETS DE COMPOSANTS RÉUTILISABLES ---

class _FilterChip extends StatelessWidget {
  final String label;

  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _colorBlack,
              fontSize: 14,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.keyboard_arrow_down, size: 20, color: _colorBlack),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;

  const _BookCard({required this.title, required this.author, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Espace pour l'image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              // La taille exacte est estimée en fonction du childAspectRatio 0.55
              height: 200, 
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          // Détails du livre
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _colorBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: _fontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8, right: 8),
            child: Text(
              author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: _fontFamily,
              ),
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

// ----------------------------------------------------
// Point d'entrée pour le test :
// ----------------------------------------------------
/*
void main() {
  // Assurez-vous d'avoir configuré vos assets avant d'exécuter
  runApp(const MaterialApp(
    home: LibraryScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
*/