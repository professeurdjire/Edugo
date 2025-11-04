import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/bibliotheque/telechargement.dart';
import 'package:edugo/screens/principales/bibliotheque/lectureLivre.dart'; // <-- ajout import

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const String _fontFamily = 'Roboto';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Liste des livres
  final List<Map<String, String>> books = [
    {'title': 'Le jardin invisible', 'author': 'C.S.Lewis', 'image': 'book1.png'},
    {'title': 'Le cœur se souvient', 'author': 'C.S.Lewis', 'image': 'book1.png'},
    {'title': 'Libre comme l\'ère', 'author': 'C.S.Lewis', 'image': 'book1.png'},
    {'title': 'En apnée', 'author': 'C.S.Lewis', 'image': 'book1.png'},
    {'title': 'Libre comme l\'ère', 'author': 'C.S.Lewis', 'image': 'book1.png'},
    {'title': 'En apnée', 'author': 'C.S.Lewis', 'image': 'book1.png'},
  ];

  // Liste filtrée des livres (initialisée avec la liste complète des livres)
  List<Map<String, String>> filteredBooks = [];

  // Contrôleur de texte pour la barre de recherche
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredBooks = books; // Initialisation de filteredBooks avec la liste complète des livres
    _searchController.addListener(_filterBooks); // Écoute des changements dans la recherche
  }

  // Fonction pour filtrer les livres en fonction du texte de recherche
  void _filterBooks() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        return book['title']!.toLowerCase().contains(query) ||
            book['author']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // --- HEADER FIXE ---
            _buildHeader(),
            const SizedBox(height: 10),

            // --- BARRE DE RECHERCHE FIXE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 10),

            // --- FILTRES FIXES ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildFilters(context),
            ),
            const SizedBox(height: 10),

            // --- SEULE LA LISTE DES LIVRES DÉFILE ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildBookGrid(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      child: const Center(
        child: Text(
          "Livres",
          style: TextStyle(
            color: Colors.black, // Remplacer par la couleur de ton choix
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
        color: Colors.white, // fond blanc
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: "Rechercher un livre par nom ou auteur",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // --- FILTRES ---
  Widget _buildFilters(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FilterChip(
          label: 'Mes Téléchargements',
          isPrimary: true,
          showArrow: false,
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

  // --- GRILLE DES LIVRES FILTRÉE ---
  Widget _buildBookGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 0.6, // Réduction de la taille des cartes de livres
      ),
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Lorsqu’on clique sur un livre → page de lecture
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookReaderScreen(
                  bookTitle: filteredBooks[index]['title']!,
                ),
              ),
            );
          },
          child: _BookCard(
            title: filteredBooks[index]['title']!,
            author: filteredBooks[index]['author']!,
            imagePath: 'assets/images/${filteredBooks[index]['image']!}',
          ),
        );
      },
    );
  }
}

// --- WIDGET POUR LES FILTRES ---
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
        constraints: const BoxConstraints(maxWidth: 120, minWidth: 80),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                overflow: TextOverflow.ellipsis,
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

// --- WIDGET POUR CHAQUE LIVRE ---
class _BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;

  const _BookCard({
    required this.title,
    required this.author,
    required this.imagePath,
  });

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
              padding: const EdgeInsets.only(right: 8, bottom: 10), // Déplacement de l'icône
              child: Icon(Icons.download, color: Colors.black87, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
