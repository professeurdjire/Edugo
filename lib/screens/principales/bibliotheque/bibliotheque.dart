import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/bibliotheque/telechargement.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const String _fontFamily = 'Roboto';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Corps principal
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  _buildSearchBar(),
                  const SizedBox(height: 15),
                  _buildFilters(context),
                  const SizedBox(height: 15),
                  _buildBookGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- HEADER PERSONNALISÉ ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _purpleMain,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: const Center(
        child: Text(
          "Livres",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily,
          ),
        ),
      ),
    );
  }

  // --- BARRE DE RECHERCHE ---
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Rechercher un livre par nom ou auteur",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // --- FILTRES (Mes Télé, Niveau, Matières, Classe) ---
  Widget _buildFilters(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FilterChip(
          label: 'Mes Téléchargements',
          isPrimary: true,
          showArrow: false, // plus de flèche pour ce bouton
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TelechargementsScreen(),
              ),
            );
          },
        ),
        const _FilterChip(label: 'Niveau', showArrow: true),
        const _FilterChip(label: 'Matières', showArrow: true),
        const _FilterChip(label: 'Classe', showArrow: true),
      ],
    );
  }

  // --- GRILLE DE LIVRES ---
  Widget _buildBookGrid() {
    final List<Map<String, String>> books = [
      {'title': 'Le jardin invisible', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'Le cœur se souvient', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'Libre comme l\'ère', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'En apnée', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'Libre comme l\'ère', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
      {'title': 'En apnée', 'author': 'Auteur : C.S.Lewis', 'image': 'book1.png'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 0.65,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _BookCard(
          title: books[index]['title']!,
          author: books[index]['author']!,
          imagePath: 'assets/images/${books[index]['image']!}',
        );
      },
    );
  }

  // --- BARRE DE NAVIGATION DU BAS ---
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _purpleMain,
      unselectedItemColor: Colors.black54,
      showUnselectedLabels: true,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Bibliothèque'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Challenge'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Exercice'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Assistance'),
      ],
    );
  }
}

// --- WIDGET PERSONNALISÉ POUR LES FILTRES / BOUTONS ---
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool showArrow;

  const _FilterChip({
    required this.label,
    this.icon,
    this.onTap,
    this.isPrimary = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? _purpleMain : Colors.white,
          border: Border.all(
            color: isPrimary ? _purpleMain : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: isPrimary ? Colors.white : Colors.black, size: 18),
            if (icon != null) const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis, // tronque le texte si trop long
                maxLines: 1,
                style: TextStyle(
                  color: isPrimary ? Colors.white : _colorBlack,
                  fontSize: 13,
                  fontFamily: _fontFamily,
                  fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (showArrow) const SizedBox(width: 5),
            if (showArrow)
              Icon(Icons.keyboard_arrow_down,
                  size: 18, color: isPrimary ? Colors.white : _colorBlack),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET PERSONNALISÉ POUR LES LIVRES ---
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: _fontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              author,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: _fontFamily,
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Icon(Icons.download, color: Colors.black87, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
