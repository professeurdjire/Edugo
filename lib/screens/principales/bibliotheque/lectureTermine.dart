import 'package:flutter/material.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur active/bouton)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _colorSuccess = Color(0xFF32C832); // Vert pour la validation (coche)
const Color _colorGreyLight = Color(0xFFF0F0F0); // Gris clair pour le fond des onglets inactifs
const Color _colorWhite = Color(0xFFFFFFFF);
const String _fontFamily = 'Roboto'; // Police principale

// Modèle pour un livre
class Book {
  final String title;
  final String author;
  final String coverAsset;
  final bool isFinished;

  Book({
    required this.title, 
    required this.author, 
    required this.coverAsset, 
    this.isFinished = false,
  });
}

class FinishedBooksScreen extends StatelessWidget {
   FinishedBooksScreen({super.key});

  // Données simulées pour les livres terminés
  final List<Book> _finishedBooks =  [
    Book(
      title: 'Le jardin invisible',
      author: 'Auteur : C.S.Lewis',
      coverAsset: 'le_jardin_invisible_cover',
      isFinished: true,
    ),
    Book(
      title: 'Les larmes du lac',
      author: 'Marie Havard',
      coverAsset: 'les_larmes_du_lac_cover',
      isFinished: true,
    ),
    Book(
      title: 'Le jardin invisible',
      author: 'Auteur : C.S.Lewis',
      coverAsset: 'fleuve_de_sang_cover',
      isFinished: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // 3. Barre de recherche
                  _buildSearchBar(),
                  
                  const SizedBox(height: 15),

                  // 4. Onglets de filtre (Tout, Encours, Terminé)
                  _buildFilterTabs(),
                  
                  const SizedBox(height: 20),

                  // 5. Liste des livres terminés
                  ..._finishedBooks.map((book) => Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _FinishedBookTile(book: book),
                  )).toList(),
                  
                  const SizedBox(height: 80), // Espace final
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: _colorBlack),
              onPressed: () => Navigator.pop(context), 
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Toutes mes Lectures',
                  style: TextStyle(
                    color: _colorBlack,
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
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: _colorGreyLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un livre par nom ou auteur',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
        ),
        style: TextStyle(color: _colorBlack),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _FilterTab(label: 'Tout', isSelected: false, onTap: () {}),
        const SizedBox(width: 10),
        _FilterTab(label: 'Encours', isSelected: false, onTap: () {}),
        const SizedBox(width: 10),
        _FilterTab(label: 'Terminé', isSelected: true, onTap: () {}), // Terminé est sélectionné
      ],
    );
  }
}

// -------------------------------------------------------------------
// --- WIDGETS DE COMPOSANTS ---
// -------------------------------------------------------------------

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _purpleMain : _colorGreyLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _colorWhite : _colorBlack,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _FinishedBookTile extends StatelessWidget {
  final Book book;

  const _FinishedBookTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _colorWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Row(
        children: [
          // Couverture (simulée avec un Container coloré)
          Container(
            width: 70,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blueGrey, // Couleur de remplacement pour la couverture
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage('assets/${book.coverAsset}.png'), // Utiliser une image asset simulée
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          
          // Détails du livre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    color: _colorBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  book.author,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Coche Verte pour 'Terminé'
                if (book.isFinished)
                  const Icon(Icons.check_circle, color: _colorSuccess, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}