import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/bibliotheque/telechargement.dart';
import 'package:edugo/screens/principales/bibliotheque/lectureLivre.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _purpleLight = Color(0xFFE1D4F5);
const Color _colorBlack = Color(0xFF000000);
const Color _colorGrey = Color(0xFF757575);
const Color _colorBackground = Color(0xFFF8F9FA);
const String _fontFamily = 'Roboto';

class LibraryScreen extends StatefulWidget {
  final int? eleveId;

    const LibraryScreen({super.key, this.eleveId});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Liste complète des livres disponibles
  final List<Map<String, dynamic>> _allBooks = [
    {
      'title': 'Le jardin invisible',
      'author': 'C.S. Lewis',
      'image': 'book1.png',
      'progress': 0.7,
      'category': 'Roman',
      'pages': 320,
      'isDownloaded': true,
      'level': 'Tous niveaux',
      'subject': 'Littérature',
      'class': 'Général'
    },
    {
      'title': 'Le cœur se souvient',
      'author': 'C.S. Lewis',
      'image': 'book1.png',
      'progress': 0.3,
      'category': 'Philosophie',
      'pages': 280,
      'isDownloaded': false,
      'level': 'Avancé',
      'subject': 'Philosophie',
      'class': 'Terminale'
    },
    {
      'title': 'Libre comme l\'ère',
      'author': 'C.S. Lewis',
      'image': 'book1.png',
      'progress': 0.0,
      'category': 'Science-Fiction',
      'pages': 450,
      'isDownloaded': false,
      'level': 'Intermédiaire',
      'subject': 'Science-Fiction',
      'class': 'Première'
    },
    {
      'title': 'En apnée',
      'author': 'C.S. Lewis',
      'image': 'book1.png',
      'progress': 1.0,
      'category': 'Aventure',
      'pages': 380,
      'isDownloaded': true,
      'level': 'Tous niveaux',
      'subject': 'Aventure',
      'class': 'Général'
    },
    {
      'title': 'Les mystères du temps',
      'author': 'C.S. Lewis',
      'image': 'book1.png',
      'progress': 0.5,
      'category': 'Fantastique',
      'pages': 410,
      'isDownloaded': true,
      'level': 'Intermédiaire',
      'subject': 'Fantastique',
      'class': 'Seconde'
    },
    {
      'title': 'L\'horizon perdu',
      'author': 'C.S. Lewis',
      'image': 'book1.png',
      'progress': 0.0,
      'category': 'Roman',
      'pages': 290,
      'isDownloaded': false,
      'level': 'Débutant',
      'subject': 'Littérature',
      'class': 'Collège'
    },
  ];

  List<Map<String, dynamic>> _filteredBooks = [];
  TextEditingController _searchController = TextEditingController();

  // Filtres actifs
  String _selectedLevel = 'Tous';
  String _selectedSubject = 'Tous';
  String _selectedClass = 'Tous';
  bool _showDownloadedOnly = false;

  @override
  void initState() {
    super.initState();
    _filteredBooks = _allBooks;
    _searchController.addListener(_filterBooks);
  }

  void _filterBooks() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredBooks = _allBooks.where((book) {
        // Filtre par recherche
        bool matchesSearch = book['title']!.toLowerCase().contains(query) ||
            book['author']!.toLowerCase().contains(query) ||
            book['category']!.toLowerCase().contains(query);

        // Filtre par niveau
        bool matchesLevel = _selectedLevel == 'Tous' || book['level'] == _selectedLevel;

        // Filtre par matière
        bool matchesSubject = _selectedSubject == 'Tous' || book['subject'] == _selectedSubject;

        // Filtre par classe
        bool matchesClass = _selectedClass == 'Tous' || book['class'] == _selectedClass;

        // Filtre par téléchargement
        bool matchesDownload = !_showDownloadedOnly || book['isDownloaded'] == true;

        return matchesSearch && matchesLevel && matchesSubject && matchesClass && matchesDownload;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedLevel = 'Tous';
      _selectedSubject = 'Tous';
      _selectedClass = 'Tous';
      _showDownloadedOnly = false;
      _searchController.clear();
    });
    _filterBooks();
  }

  void _toggleDownload(int index) {
    setState(() {
      _allBooks[index]['isDownloaded'] = !_allBooks[index]['isDownloaded'];
    });
    _filterBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;
        final bool isVerySmallScreen = constraints.maxWidth < 400;
        final bool isLargeScreen = constraints.maxWidth > 900;

        // Adaptation dynamique du nombre de colonnes
        int crossAxisCount;
        if (isVerySmallScreen) {
          crossAxisCount = 1; // 1 colonne pour très petits écrans
        } else if (isSmallScreen) {
          crossAxisCount = 2; // 2 colonnes pour mobiles
        } else if (isLargeScreen) {
          crossAxisCount = 4; // 4 colonnes pour grands écrans
        } else {
          crossAxisCount = 3; // 3 colonnes par défaut
        }

        return Scaffold(
          backgroundColor: _colorBackground,
          body: SafeArea(
            child: Column(
              children: [
                // --- HEADER ---
                _buildHeader(isSmallScreen),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- BARRE DE RECHERCHE ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                  child: _buildSearchBar(isSmallScreen, isVerySmallScreen),
                ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- BOUTON TÉLÉCHARGEMENTS ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                  child: _buildDownloadsButton(context, isSmallScreen, isVerySmallScreen),
                ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- FILTRES ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                  child: _buildFiltersSection(isSmallScreen, isVerySmallScreen),
                ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- COMPTEUR DE RÉSULTATS ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                  child: _buildResultsCounter(isSmallScreen, isVerySmallScreen),
                ),
                SizedBox(height: isVerySmallScreen ? 6 : 8),

                // --- LISTE DES LIVRES ---
                Expanded(
                  child: _filteredBooks.isEmpty
                      ? _buildEmptyState(isSmallScreen, isVerySmallScreen)
                      : _buildBookGrid(context, crossAxisCount, isSmallScreen, isVerySmallScreen),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- HEADER ---
  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.only(
        top: 8, bottom: 8,
        left: isSmallScreen ? 12 : 20,
        right: isSmallScreen ? 12 : 20
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ma Bibliothèque",
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: isSmallScreen ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${_allBooks.length} livres disponibles",
                  style: TextStyle(
                    color: _colorGrey,
                    fontSize: isSmallScreen ? 12 : 14,
                    fontFamily: _fontFamily,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: _purpleMain,
              size: isSmallScreen ? 20 : 28,
            ),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
    );
  }

  // --- BARRE DE RECHERCHE ---
  Widget _buildSearchBar(bool isSmallScreen, bool isVerySmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 10 : 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : 15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: _purpleMain,
            size: isVerySmallScreen ? 18 : isSmallScreen ? 20 : 24
          ),
          SizedBox(width: isVerySmallScreen ? 6 : 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un livre, auteur...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: isVerySmallScreen ? 13 : isSmallScreen ? 14 : 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16
                ),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey.shade500,
                size: isVerySmallScreen ? 16 : 20
              ),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
    );
  }

  // --- BOUTON TÉLÉCHARGEMENTS ---
  Widget _buildDownloadsButton(BuildContext context, bool isSmallScreen, bool isVerySmallScreen) {
    final downloadedCount = _allBooks.where((book) => book['isDownloaded'] == true).length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TelechargementsScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(isVerySmallScreen ? 10 : isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: _purpleMain,
          borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : 12),
          boxShadow: [
            BoxShadow(
              color: _purpleMain.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isVerySmallScreen ? 4 : 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.download_rounded,
                color: Colors.white,
                size: isVerySmallScreen ? 16 : isSmallScreen ? 18 : 20,
              ),
            ),
            SizedBox(width: isVerySmallScreen ? 8 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mes Téléchargements",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: _fontFamily,
                    ),
                  ),
                  Text(
                    "$downloadedCount livre${downloadedCount > 1 ? 's' : ''} téléchargé${downloadedCount > 1 ? 's' : ''}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 13,
                      fontFamily: _fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: isVerySmallScreen ? 14 : isSmallScreen ? 16 : 18,
            ),
          ],
        ),
      ),
    );
  }

  // --- SECTION FILTRES ---
  Widget _buildFiltersSection(bool isSmallScreen, bool isVerySmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Filtres actifs:",
              style: TextStyle(
                color: _colorGrey,
                fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 13 : 14,
                fontWeight: FontWeight.w500,
                fontFamily: _fontFamily,
              ),
            ),
            const Spacer(),
            if (_selectedLevel != 'Tous' || _selectedSubject != 'Tous' || _selectedClass != 'Tous' || _showDownloadedOnly)
              GestureDetector(
                onTap: _resetFilters,
                child: Text(
                  "Tout effacer",
                  style: TextStyle(
                    color: _purpleMain,
                    fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: isVerySmallScreen ? 6 : 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (_selectedLevel != 'Tous') _buildActiveFilterChip('Niveau: $_selectedLevel', isSmallScreen, isVerySmallScreen),
              if (_selectedSubject != 'Tous') _buildActiveFilterChip('Matière: $_selectedSubject', isSmallScreen, isVerySmallScreen),
              if (_selectedClass != 'Tous') _buildActiveFilterChip('Classe: $_selectedClass', isSmallScreen, isVerySmallScreen),
              if (_showDownloadedOnly) _buildActiveFilterChip('Téléchargés', isSmallScreen, isVerySmallScreen),
              if (_selectedLevel == 'Tous' && _selectedSubject == 'Tous' && _selectedClass == 'Tous' && !_showDownloadedOnly)
                Text(
                  "Aucun filtre actif",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 13 : 14,
                    fontFamily: _fontFamily,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveFilterChip(String label, bool isSmallScreen, bool isVerySmallScreen) {
    return Container(
      margin: EdgeInsets.only(right: isVerySmallScreen ? 6 : 8),
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmallScreen ? 8 : 12,
        vertical: isVerySmallScreen ? 4 : 6
      ),
      decoration: BoxDecoration(
        color: _purpleLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _purpleMain),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _purpleMain,
              fontSize: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 13,
              fontWeight: FontWeight.w500,
              fontFamily: _fontFamily,
            ),
          ),
          SizedBox(width: isVerySmallScreen ? 3 : 4),
          GestureDetector(
            onTap: _resetFilters,
            child: Icon(
              Icons.close,
              size: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
              color: _purpleMain
            ),
          ),
        ],
      ),
    );
  }

  // --- COMPTEUR DE RÉSULTATS ---
  Widget _buildResultsCounter(bool isSmallScreen, bool isVerySmallScreen) {
    return Row(
      children: [
        Text(
          "${_filteredBooks.length} livre${_filteredBooks.length > 1 ? 's' : ''} trouvé${_filteredBooks.length > 1 ? 's' : ''}",
          style: TextStyle(
            color: _colorGrey,
            fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily,
          ),
        ),
        const Spacer(),
        if (_filteredBooks.length < _allBooks.length)
          Text(
            "Filtré sur ${_allBooks.length}",
            style: TextStyle(
              color: _colorGrey,
              fontSize: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 13,
              fontFamily: _fontFamily,
            ),
          ),
      ],
    );
  }

  // --- GRILLE DES LIVRES ---
  Widget _buildBookGrid(BuildContext context, int crossAxisCount, bool isSmallScreen, bool isVerySmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 8.0 : isSmallScreen ? 12.0 : 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isVerySmallScreen ? 8.0 : isSmallScreen ? 10.0 : 12.0,
          mainAxisSpacing: isVerySmallScreen ? 8.0 : isSmallScreen ? 10.0 : 12.0,
          childAspectRatio: isVerySmallScreen ? 0.55 : isSmallScreen ? 0.6 : 0.65,
        ),
        itemCount: _filteredBooks.length,
        itemBuilder: (context, index) {
          final book = _filteredBooks[index];
          final originalIndex = _allBooks.indexWhere((b) => b['title'] == book['title']);

          return _BookCard(
            title: book['title']!,
            author: book['author']!,
            imagePath: 'assets/images/${book['image']!}',
            progress: book['progress']!,
            category: book['category']!,
            pages: book['pages']!,
            isDownloaded: book['isDownloaded']!,
            isSmallScreen: isSmallScreen,
            isVerySmallScreen: isVerySmallScreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookReaderScreen(bookTitle: book['title']!),
                ),
              );
            },
            onDownload: () => _toggleDownload(originalIndex),
          );
        },
      ),
    );
  }

  // --- ÉTAT VIDE ---
  Widget _buildEmptyState(bool isSmallScreen, bool isVerySmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isVerySmallScreen ? 20 : 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Colors.grey.shade400,
            size: isVerySmallScreen ? 60 : 80,
          ),
          SizedBox(height: isVerySmallScreen ? 12 : 20),
          Text(
            "Aucun livre trouvé",
            style: TextStyle(
              fontSize: isVerySmallScreen ? 16 : isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: _colorGrey,
              fontFamily: _fontFamily,
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 6 : 10),
          Text(
            "Essayez de modifier vos critères de recherche ou vos filtres",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
              color: Colors.grey.shade500,
              fontFamily: _fontFamily,
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 12 : 20),
          ElevatedButton(
            onPressed: _resetFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: _purpleMain,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isVerySmallScreen ? 8 : 12),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isVerySmallScreen ? 16 : 24,
                vertical: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 14
              ),
            ),
            child: Text(
              "Réinitialiser les filtres",
              style: TextStyle(
                fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
                fontFamily: _fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIALOG DE FILTRES ---
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Filtrer les livres", style: TextStyle(fontFamily: _fontFamily)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterDropdown(
                title: "Niveau",
                value: _selectedLevel,
                items: ['Tous', 'Débutant', 'Intermédiaire', 'Avancé', 'Tous niveaux'],
                onChanged: (value) => setState(() => _selectedLevel = value!),
              ),
              _buildFilterDropdown(
                title: "Matière",
                value: _selectedSubject,
                items: ['Tous', 'Littérature', 'Philosophie', 'Science-Fiction', 'Aventure', 'Fantastique'],
                onChanged: (value) => setState(() => _selectedSubject = value!),
              ),
              _buildFilterDropdown(
                title: "Classe",
                value: _selectedClass,
                items: ['Tous', 'Collège', 'Seconde', 'Première', 'Terminale', 'Général'],
                onChanged: (value) => setState(() => _selectedClass = value!),
              ),
              SwitchListTile(
                title: Text("Livres téléchargés uniquement", style: TextStyle(fontFamily: _fontFamily)),
                value: _showDownloadedOnly,
                onChanged: (value) => setState(() => _showDownloadedOnly = value),
                activeColor: _purpleMain,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler", style: TextStyle(color: _colorGrey, fontFamily: _fontFamily)),
          ),
          ElevatedButton(
            onPressed: () {
              _filterBooks();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _purpleMain),
            child: Text("Appliquer", style: TextStyle(fontFamily: _fontFamily)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontFamily: _fontFamily)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontFamily: _fontFamily)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET CARTE LIVRE OPTIMISÉ ---
class _BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imagePath;
  final double progress;
  final String category;
  final int pages;
  final bool isDownloaded;
  final bool isSmallScreen;
  final bool isVerySmallScreen;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  const _BookCard({
    required this.title,
    required this.author,
    required this.imagePath,
    required this.progress,
    required this.category,
    required this.pages,
    required this.isDownloaded,
    required this.isSmallScreen,
    required this.isVerySmallScreen,
    required this.onTap,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = isVerySmallScreen ? 120 : (isSmallScreen ? 140 : 160);
    final double paddingValue = isVerySmallScreen ? 6 : (isSmallScreen ? 8 : 12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isVerySmallScreen ? 12 : 16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badges
            Stack(
              children: [
                // Image de couverture
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isVerySmallScreen ? 12 : 16),
                    topRight: Radius.circular(isVerySmallScreen ? 12 : 16),
                  ),
                  child: Container(
                    height: imageHeight,
                    width: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: _purpleLight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book_rounded,
                                color: _purpleMain,
                                size: isVerySmallScreen ? 24 : 32,
                              ),
                              SizedBox(height: isVerySmallScreen ? 4 : 6),
                              Text(
                                _getInitials(title),
                                style: TextStyle(
                                  color: _purpleMain,
                                  fontSize: isVerySmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: _fontFamily,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Badge de catégorie
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isVerySmallScreen ? 4 : 6,
                      vertical: isVerySmallScreen ? 2 : 3
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(isVerySmallScreen ? 8 : 10),
                    ),
                    child: Text(
                      category.length > (isVerySmallScreen ? 6 : 8)
                          ? '${category.substring(0, isVerySmallScreen ? 6 : 8)}...'
                          : category,
                      style: TextStyle(
                        fontSize: isVerySmallScreen ? 8 : 9,
                        fontWeight: FontWeight.w600,
                        color: _purpleMain,
                        fontFamily: _fontFamily,
                      ),
                    ),
                  ),
                ),

                // Badge téléchargé
                if (isDownloaded)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: EdgeInsets.all(isVerySmallScreen ? 2 : 3),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.download_done_rounded,
                        color: Colors.white,
                        size: isVerySmallScreen ? 10 : 12,
                      ),
                    ),
                  ),

                // Barre de progression
                if (progress > 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress == 1.0 ? Colors.green : _purpleMain
                      ),
                      minHeight: isVerySmallScreen ? 2 : 3,
                    ),
                  ),
              ],
            ),

            // Contenu texte
            Padding(
              padding: EdgeInsets.all(paddingValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isVerySmallScreen ? 11 : (isSmallScreen ? 12 : 13),
                      fontFamily: _fontFamily,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: isVerySmallScreen ? 2 : 3),
                  Text(
                    author,
                    style: TextStyle(
                      color: _colorGrey,
                      fontSize: isVerySmallScreen ? 9 : (isSmallScreen ? 10 : 11),
                      fontFamily: _fontFamily,
                    ),
                  ),
                  SizedBox(height: isVerySmallScreen ? 3 : 4),

                  // Informations
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: isVerySmallScreen ? 10 : 11,
                        color: Colors.grey.shade500
                      ),
                      SizedBox(width: isVerySmallScreen ? 2 : 3),
                      Text(
                        '$pages pages',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: isVerySmallScreen ? 8 : 9,
                          fontFamily: _fontFamily,
                        ),
                      ),
                      const Spacer(),
                      if (progress > 0)
                        Text(
                          progress == 1.0 ? 'Terminé' : '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            color: progress == 1.0 ? Colors.green : _purpleMain,
                            fontSize: isVerySmallScreen ? 8 : 9,
                            fontWeight: FontWeight.w600,
                            fontFamily: _fontFamily,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Boutons d'action
            Padding(
              padding: EdgeInsets.all(paddingValue),
              child: Row(
                children: [
                  // Bouton lecture/quiz
                  Expanded(
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: isVerySmallScreen ? 5 : 6),
                        decoration: BoxDecoration(
                          color: _purpleLight,
                          borderRadius: BorderRadius.circular(isVerySmallScreen ? 6 : 8),
                        ),
                        child: Icon(
                          progress == 1.0 ? Icons.quiz_outlined : Icons.play_arrow_rounded,
                          color: _purpleMain,
                          size: isVerySmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isVerySmallScreen ? 4 : 6),
                  // Bouton téléchargement
                  GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      padding: EdgeInsets.all(isVerySmallScreen ? 5 : 6),
                      decoration: BoxDecoration(
                        color: isDownloaded ? Colors.green.withOpacity(0.1) : _purpleLight,
                        borderRadius: BorderRadius.circular(isVerySmallScreen ? 6 : 8),
                        border: Border.all(
                          color: isDownloaded ? Colors.green : _purpleMain,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isDownloaded ? Icons.download_done_rounded : Icons.download_rounded,
                        color: isDownloaded ? Colors.green : _purpleMain,
                        size: isVerySmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String title) {
    final words = title.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (title.isNotEmpty) {
      return title.substring(0, 1).toUpperCase();
    }
    return 'B';
  }
}