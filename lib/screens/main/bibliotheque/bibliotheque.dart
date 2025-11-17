import 'package:flutter/material.dart';
import 'package:edugo/screens/main/bibliotheque/telechargement.dart';
import 'package:edugo/screens/main/bibliotheque/lectureLivre.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/book_file_service.dart';
import 'package:edugo/models/livre_response.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/models/progression_response.dart';
import 'package:built_collection/built_collection.dart';

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
  final LivreService _livreService = LivreService();
  final AuthService _authService = AuthService();
  final BookFileService _bookFileService = BookFileService();
  
  // Liste complète des livres disponibles
  BuiltList<LivreResponse>? _allBooks;
  BuiltList<LivreResponse>? _filteredBooks;
  
  // Progression de lecture pour chaque livre
  Map<int, ProgressionResponse?> _bookProgressions = {};
  
  // Loading states
  bool _isLoading = true;
  bool _isRefreshing = false;
  
  TextEditingController _searchController = TextEditingController();

  // Filtres actifs
  String _selectedLevel = 'Tous';
  String _selectedSubject = 'Tous';
  String _selectedClass = 'Tous';
  bool _showDownloadedOnly = false;
  
  // Current user ID
  int? _currentEleveId;

  @override
  void initState() {
    super.initState();
    _currentEleveId = widget.eleveId ?? _authService.currentUserId;
    _loadBooks();
    _searchController.addListener(_filterBooks);
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      BuiltList<LivreResponse>? books;
      
      // If we have a user ID, get books available for that user
      if (_currentEleveId != null) {
        books = await _livreService.getLivresDisponibles(_currentEleveId!);
      } 
      // Otherwise, get all books
      else {
        books = await _livreService.getAllLivres();
      }
      
      // Load progressions for each book
      if (books != null && _currentEleveId != null) {
        for (var book in books) {
          if (book.id != null) {
            final progression = await _livreService.getProgressionLivre(_currentEleveId!, book.id!);
            setState(() {
              _bookProgressions[book.id!] = progression;
            });
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _allBooks = books;
          _filteredBooks = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading books: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshBooks() async {
    setState(() {
      _isRefreshing = true;
    });
    
    await _loadBooks();
    
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _filterBooks() {
    if (_allBooks == null) return;
    
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredBooks = _allBooks!.where((book) {
        // Filtre par recherche
        bool matchesSearch = (book.titre?.toLowerCase().contains(query) ?? false) ||
            (book.auteur?.toLowerCase().contains(query) ?? false);

        // Filtre par niveau - for now we'll use a simple approach
        bool matchesLevel = _selectedLevel == 'Tous';

        // Filtre par matière - for now we'll use a simple approach
        bool matchesSubject = _selectedSubject == 'Tous';

        // Filtre par classe - for now we'll use a simple approach
        bool matchesClass = _selectedClass == 'Tous';

        // Filtre par téléchargement - for now we'll use a simple approach
        bool matchesDownload = !_showDownloadedOnly;

        return matchesSearch && matchesLevel && matchesSubject && matchesClass && matchesDownload;
      }).toBuiltList();
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
                SizedBox(height: isVerySmallScreen ? 12 : 16),

                // --- SECTION FILTRES ---
                if (_filteredBooks != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                    child: _buildFiltersSection(isSmallScreen, isVerySmallScreen),
                  ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- COMPTEUR DE RÉSULTATS ---
                if (_filteredBooks != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                    child: _buildResultsCounter(isSmallScreen, isVerySmallScreen),
                  ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- CONTENU PRINCIPAL ---
                if (_isLoading)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(_purpleMain),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Chargement des livres...',
                            style: TextStyle(
                              color: _colorGrey,
                              fontSize: isVerySmallScreen ? 14 : 16,
                              fontFamily: _fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_filteredBooks == null || _filteredBooks!.isEmpty)
                  Expanded(
                    child: _buildEmptyState(isSmallScreen, isVerySmallScreen),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshBooks,
                      child: _buildBookGrid(context, crossAxisCount, isSmallScreen, isVerySmallScreen),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- HEADER CUSTOMISÉ ---
  Widget _buildHeader(bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 20.0),
      child: Row(
        children: [
          // Titre de la bibliothèque
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bibliothèque",
                  style: TextStyle(
                    color: _colorBlack,
                    fontSize: isSmallScreen ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily,
                  ),
                ),
                Text(
                  "Découvrez et lisez des livres",
                  style: TextStyle(
                    color: _colorGrey,
                    fontSize: isSmallScreen ? 14 : 16,
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

  // --- BARRE DE RECHERCHE ---
  Widget _buildSearchBar(bool isSmallScreen, bool isVerySmallScreen) {
    return Container(
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
    // For now, we'll use a placeholder count
    final downloadedCount = 0;

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
            mainAxisSize: MainAxisSize.min,
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
          "${_filteredBooks?.length ?? 0} livre${(_filteredBooks?.length ?? 0) > 1 ? 's' : ''} trouvé${(_filteredBooks?.length ?? 0) > 1 ? 's' : ''}",
          style: TextStyle(
            color: _colorGrey,
            fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily,
          ),
        ),
        const Spacer(),
        if (_filteredBooks != null && _allBooks != null && _filteredBooks!.length < _allBooks!.length)
          Text(
            "Filtré sur ${_allBooks!.length}",
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
        itemCount: _filteredBooks?.length ?? 0,
        itemBuilder: (context, index) {
          final book = _filteredBooks![index];
          
          // Get progression for this book
          final progression = book.id != null ? _bookProgressions[book.id!] : null;
          final progressValue = progression?.pourcentageCompletion != null 
              ? progression!.pourcentageCompletion! / 100.0 
              : 0.0;

          return _BookCard(
            title: book.titre ?? 'Livre sans titre',
            author: book.auteur ?? 'Auteur inconnu',
            imagePath: book.imageCouverture ?? '',
            progress: progressValue,
            category: 'Littérature', // Placeholder for now
            pages: book.totalPages ?? 0,
            isDownloaded: false,
            isSmallScreen: isSmallScreen,
            isVerySmallScreen: isVerySmallScreen,
            onTap: () async {
              // Get full book details and files
              final fullBook = await _livreService.getLivreById(book.id!);
              final fichiers = await _livreService.getFichiersLivre(book.id!);
              
              if (fichiers != null && fichiers.isNotEmpty) {
                // Navigate to the book reader screen which will handle downloading and opening
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookReaderScreen(
                      bookTitle: book.titre ?? 'Livre sans titre',
                      livreId: book.id,
                      eleveId: _currentEleveId,
                      fichiers: fichiers.toList(),
                    ),
                  ),
                );
              } else {
                // Show error if no files available
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aucun fichier disponible pour ce livre')),
                );
              }
            },
            onDownload: () async {
              // Handle download logic here
              final fichiers = await _livreService.getFichiersLivre(book.id!);
              if (fichiers != null && fichiers.isNotEmpty) {
                // Download the first file (or implement multiple file download)
                final file = fichiers.first;
                try {
                  final filePath = await _bookFileService.downloadBookFile(file);
                  if (filePath != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Livre téléchargé avec succès')),
                    );
                    setState(() {
                      // Refresh the UI to show downloaded status
                    });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors du téléchargement')),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  // --- ÉTAT VIDE ---
  Widget _buildEmptyState(bool isSmallScreen, bool isVerySmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isVerySmallScreen ? 20 : 30),
      child: SingleChildScrollView(
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isVerySmallScreen ? 12 : 15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du livre
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isVerySmallScreen ? 12 : 15),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Book cover image with error handling
                    _buildBookImage(imagePath),
                    // Overlay pour le téléchargement
                    if (isDownloaded)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(isVerySmallScreen ? 4 : 6),
                          decoration: BoxDecoration(
                            color: _purpleMain.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.download_done,
                            color: Colors.white,
                            size: isVerySmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Informations du livre
            Padding(
              padding: EdgeInsets.all(isVerySmallScreen ? 8 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: _colorBlack,
                      fontFamily: _fontFamily,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: isVerySmallScreen ? 2 : 4),

                  // Auteur
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 14,
                      color: _colorGrey,
                      fontFamily: _fontFamily,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isVerySmallScreen ? 4 : 6),

                  // Catégorie et pages
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isVerySmallScreen ? 6 : 8,
                          vertical: isVerySmallScreen ? 2 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: _purpleLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: isVerySmallScreen ? 8 : isSmallScreen ? 10 : 11,
                            color: _purpleMain,
                            fontWeight: FontWeight.w500,
                            fontFamily: _fontFamily,
                          ),
                        ),
                      ),
                      Text(
                        "$pages pages",
                        style: TextStyle(
                          fontSize: isVerySmallScreen ? 10 : isSmallScreen ? 12 : 13,
                          color: _colorGrey,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isVerySmallScreen ? 4 : 6),

                  // Barre de progression
                  if (progress > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade300,
                          color: _purpleMain,
                          minHeight: isVerySmallScreen ? 4 : 6,
                        ),
                        SizedBox(height: isVerySmallScreen ? 2 : 4),
                        Text(
                          "${(progress * 100).round()}% lu",
                          style: TextStyle(
                            fontSize: isVerySmallScreen ? 9 : 11,
                            color: _colorGrey,
                            fontFamily: _fontFamily,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build book image with error handling
  Widget _buildBookImage(String imagePath) {
    // Check if the image path is valid
    if (imagePath.isEmpty || imagePath == "Chemin de l'image") {
      return _getDefaultBookImage();
    }
    
    // For network images (URLs)
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _getDefaultBookImage();
        },
      );
    }
    
    // For relative paths from the backend (assuming they're served from the same server)
    return Image.network(
      '${AuthService().dio.options.baseUrl}/$imagePath',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _getDefaultBookImage();
      },
    );
  }
  
  // Default book image placeholder
  Widget _getDefaultBookImage() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.menu_book,
        color: Colors.grey[600],
        size: 40,
      ),
    );
  }
}
