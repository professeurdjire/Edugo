import 'package:flutter/material.dart';
import 'package:edugo/screens/main/bibliotheque/telechargement.dart';
import 'package:edugo/screens/main/bibliotheque/lectureLivre.dart';
import 'package:edugo/screens/main/bibliotheque/pdf_viewer.dart';
import 'package:edugo/screens/main/bibliotheque/lecture_audio.dart'; // Add audio reader import
import 'package:edugo/screens/main/quiz/take_quiz_screen.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/book_file_service.dart';
import 'package:edugo/services/quiz_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/models/livre.dart';
import 'package:edugo/models/livre_response.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/models/progression_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart'; // Add Dio import
import 'dart:typed_data'; // Add Uint8List import

// --- CONSTANTES DE COULEURS ET STYLES ---
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
  final QuizService _quizService = QuizService();
  final ThemeService _themeService = ThemeService();
  
  // Liste complète des livres disponibles
  BuiltList<Livre>? _allBooks;
  BuiltList<Livre>? _filteredBooks;
  
  // Progression de lecture pour chaque livre
  Map<int, ProgressionResponse?> _bookProgressions = {};
  
  // Download status for each book
  Map<int, bool> _bookDownloadStatus = {};
  
  // Loading states
  bool _isLoading = true;
  bool _isRefreshing = false;
  
  TextEditingController _searchController = TextEditingController();

  // Filtres actifs
  String _selectedLevel = 'Tous';
  String _selectedSubject = 'Tous';
  String _selectedClass = 'Tous';
  
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
      BuiltList<Livre>? books;
      
      // If we have a user ID, get books available for that user
      if (_currentEleveId != null) {
        books = await _livreService.getLivresDisponibles(_currentEleveId!);
      } 
      // Otherwise, get all books
      else {
        books = await _livreService.getAllLivres();
      }
      
      // Check if we received any books
      if (books == null) {
        print('No books received from service');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors du chargement des livres')),
          );
        }
      } else {
        print('Received ${books.length} books from service');
      }
      
      // Load progressions and download status for each book
      if (books != null && _currentEleveId != null) {
        for (var book in books) {
          if (book.id != null) {
            // Load progression
            final progression = await _livreService.getProgressionLivre(_currentEleveId!, book.id!);
            
            // Check download status
            bool isDownloaded = false;
            try {
              final fichiers = await _livreService.getFichiersLivre(book.id!);
              if (fichiers != null && fichiers.isNotEmpty) {
                isDownloaded = await _bookFileService.isBookDownloaded(fichiers.first);
              }
            } catch (e) {
              print('Error checking download status for book ${book.id}: $e');
            }
            
            if (mounted) {
              setState(() {
                _bookProgressions[book.id!] = progression;
                _bookDownloadStatus[book.id!] = isDownloaded;
              });
            }
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors du chargement des livres. Veuillez réessayer.')),
        );
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

        // Filtre par matière
        bool matchesSubject = _selectedSubject == 'Tous' || 
            (book.matiere?.nom?.toLowerCase().contains(_selectedSubject.toLowerCase()) ?? false);

        // Filtre par classe
        bool matchesClass = _selectedClass == 'Tous';

        return matchesSearch && matchesLevel && matchesSubject && matchesClass;
      }).toBuiltList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedLevel = 'Tous';
      _selectedSubject = 'Tous';
      _selectedClass = 'Tous';
      _searchController.clear();
    });
    _filterBooks();
  }
  
  Future<void> _refreshBookDownloadStatus(int bookId) async {
    try {
      final fichiers = await _livreService.getFichiersLivre(bookId);
      if (fichiers != null && fichiers.isNotEmpty) {
        final isDownloaded = await _bookFileService.isBookDownloaded(fichiers.first);
        setState(() {
          _bookDownloadStatus[bookId] = isDownloaded;
        });
      }
    } catch (e) {
      print('Error refreshing download status for book $bookId: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
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
          appBar: AppBar(
            title: const Text(
              'Bibliothèque',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              IconButton(
                icon: const Icon(Icons.download_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelechargementsScreen()),
                  );
                },
                tooltip: 'Téléchargements',
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- BARRE DE RECHERCHE ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                  child: _buildSearchBar(isSmallScreen, isVerySmallScreen, primaryColor),
                ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- TAB BAR FILTERS ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                  child: _buildFilterTabs(isSmallScreen, isVerySmallScreen, primaryColor),
                ),
                SizedBox(height: isVerySmallScreen ? 8 : 12),

                // --- COMPTEUR DE RÉSULTATS ---
                if (_filteredBooks != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0),
                    child: _buildResultsCounter(isSmallScreen, isVerySmallScreen, primaryColor),
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
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
                    child: _buildEmptyState(isSmallScreen, isVerySmallScreen, primaryColor),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshBooks,
                      child: _buildBookGrid(context, crossAxisCount, isSmallScreen, isVerySmallScreen, primaryColor),
                    ),
                  ),
              ],
            ),
          ),
        );
          },
        );
      },
    );
  }


  // --- BARRE DE RECHERCHE ---
  Widget _buildSearchBar(bool isSmallScreen, bool isVerySmallScreen, Color primaryColor) {
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
            color: primaryColor,
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

  // --- TAB BAR FILTERS ---
  Widget _buildFilterTabs(bool isSmallScreen, bool isVerySmallScreen, Color primaryColor) {
    return Container(
      height: isVerySmallScreen ? 40 : 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : 12),
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
          // General filter
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLevel = 'Tous';
                  _selectedSubject = 'Tous';
                  _selectedClass = 'Tous';
                });
                _filterBooks();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedLevel == 'Tous' && _selectedSubject == 'Tous' && _selectedClass == 'Tous' 
                    ? primaryColor 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(isVerySmallScreen ? 10 : 12),
                ),
                child: Center(
                  child: Text(
                    'Général',
                    style: TextStyle(
                      color: _selectedLevel == 'Tous' && _selectedSubject == 'Tous' && _selectedClass == 'Tous' 
                        ? Colors.white 
                        : _colorGrey,
                      fontSize: isVerySmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Subject filter
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showSubjectFilterDialog();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade200),
                    right: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedSubject == 'Tous' ? 'Matière' : _selectedSubject,
                        style: TextStyle(
                          color: _selectedSubject == 'Tous' ? _colorGrey : primaryColor,
                          fontSize: isVerySmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: _colorGrey,
                        size: isVerySmallScreen ? 16 : 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Class filter
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showClassFilterDialog();
              },
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedClass == 'Tous' ? 'Classe' : _selectedClass,
                        style: TextStyle(
                          color: _selectedClass == 'Tous' ? _colorGrey : primaryColor,
                          fontSize: isVerySmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: _colorGrey,
                        size: isVerySmallScreen ? 16 : 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIALOGS FOR FILTERS ---
  void _showSubjectFilterDialog() {
    final subjects = ['Tous', 'Littérature', 'Philosophie', 'Science-Fiction', 'Aventure', 'Fantastique', 'Mathématiques', 'Physique', 'Chimie', 'Biologie'];
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrer par Matière',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return RadioListTile<String>(
                      title: Text(subject),
                      value: subject,
                      groupValue: _selectedSubject,
                      onChanged: (value) {
                        setState(() {
                          _selectedSubject = value!;
                        });
                        _filterBooks();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClassFilterDialog() {
    final classes = ['Tous', 'Collège', 'Seconde', 'Première', 'Terminale', 'Général', 'Technologique'];
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrer par Classe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final classItem = classes[index];
                    return RadioListTile<String>(
                      title: Text(classItem),
                      value: classItem,
                      groupValue: _selectedClass,
                      onChanged: (value) {
                        setState(() {
                          _selectedClass = value!;
                        });
                        _filterBooks();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- COMPTEUR DE RÉSULTATS ---
  Widget _buildResultsCounter(bool isSmallScreen, bool isVerySmallScreen, Color primaryColor) {
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
  Widget _buildBookGrid(BuildContext context, int crossAxisCount, bool isSmallScreen, bool isVerySmallScreen, Color primaryColor) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isVerySmallScreen ? 8.0 : isSmallScreen ? 12.0 : 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Toujours 2 colonnes comme demandé
          crossAxisSpacing: isVerySmallScreen ? 12.0 : isSmallScreen ? 14.0 : 16.0,
          mainAxisSpacing: isVerySmallScreen ? 12.0 : isSmallScreen ? 14.0 : 16.0,
          childAspectRatio: isVerySmallScreen ? 0.5 : isSmallScreen ? 0.55 : 0.6, // Ajusté pour 2 colonnes
        ),
        itemCount: _filteredBooks?.length ?? 0,
        itemBuilder: (context, index) {
          final book = _filteredBooks![index];
          
          // Get progression for this book
          final progression = book.id != null ? _bookProgressions[book.id!] : null;
          final progressValue = progression?.pourcentageCompletion != null 
              ? progression!.pourcentageCompletion! / 100.0 
              : 0.0;

          // Check if the book is downloaded
          final isDownloaded = book.id != null ? _bookDownloadStatus[book.id!] ?? false : false;
          
          // Debug book image path
          print('Book: ${book.titre}, Image path: ${book.imageCouverture}');
          
          return _BookCard(
            title: book.titre ?? 'Livre sans titre',
            author: book.auteur ?? 'Auteur inconnu',
            imagePath: book.imageCouverture ?? '',
            progress: progressValue,
            category: book.matiere?.nom ?? 'Matière inconnue',
            pages: book.totalPages ?? 0,
            isDownloaded: isDownloaded,
            isSmallScreen: isSmallScreen,
            isVerySmallScreen: isVerySmallScreen,
            primaryColor: primaryColor,
            onTap: () async {
              // Ouvrir le livre directement depuis le serveur (lecture en ligne)
              // Le téléchargement est un concept séparé géré par onDownload
              if (book.id == null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Livre invalide')),
                  );
                }
                return;
              }

              // Récupérer les fichiers du livre
              final fichiers = await _livreService.getFichiersLivre(book.id!);
              
              if (fichiers == null || fichiers.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Aucun fichier disponible pour ce livre')),
                  );
                }
                return;
              }

              // Vérifier si le livre est téléchargé
              bool isDownloaded = _bookDownloadStatus[book.id!] ?? false;
              
              if (isDownloaded) {
                // Si téléchargé, ouvrir depuis le fichier local en transmettant les infos pour la progression
                final file = fichiers.first;
                final filePath = await _bookFileService.getDownloadedBookPath(file);
                if (filePath != null) {
                  await _bookFileService.openBookFile(
                    file,
                    filePath,
                    context,
                    livreId: book.id,
                    eleveId: _currentEleveId,
                    totalPages: book.totalPages,
                  );
                } else {
                  // Si le fichier local n'existe plus, ouvrir en ligne avec suivi de progression
                  await _bookFileService.openBookFileOnline(
                    file,
                    context,
                    livreId: book.id,
                    eleveId: _currentEleveId,
                    totalPages: book.totalPages,
                  );
                }
              } else {
                // Ouvrir directement depuis le serveur (lecture en ligne) avec suivi de progression
                final file = fichiers.first;
                await _bookFileService.openBookFileOnline(
                  file,
                  context,
                  livreId: book.id,
                  eleveId: _currentEleveId,
                  totalPages: book.totalPages,
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
                    // Refresh the download status
                    await _refreshBookDownloadStatus(book.id!);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors du téléchargement')),
                  );
                }
              }
            },
            onAudio: () async {
              // Navigate to audio book reader screen with actual book file
              if (context.mounted) {
                try {
                  // Get the book files for THIS specific book
                  print('[Bibliotheque] Loading files for book ID: ${book.id}, Title: ${book.titre}');
                  final fichiers = await _livreService.getFichiersLivre(book.id!);
                  FichierLivre? fichierLivre;
                  
                  // Find the first PDF file, or any available file
                  if (fichiers != null && fichiers.isNotEmpty) {
                    // Try to find a PDF file first
                    fichierLivre = fichiers.firstWhere(
                      (f) => (f.format ?? '').toLowerCase() == 'pdf',
                      orElse: () => fichiers.first, // Fallback to first file if no PDF
                    );
                    print('[Bibliotheque] Selected file for audio: ID=${fichierLivre.id}, Format=${fichierLivre.format}, Nom=${fichierLivre.nom}');
                  } else {
                    print('[Bibliotheque] WARNING: No files found for book ${book.id}');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Aucun fichier disponible pour ce livre'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                    return;
                  }
                  
                  // Navigate to audio reader with the actual file
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioBookReaderScreen(
                          bookTitle: book.titre ?? 'Livre sans titre',
                          livreId: book.id,
                          eleveId: _currentEleveId,
                          fichierLivre: fichierLivre, // Pass the actual file info
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  print('[Bibliotheque] Error loading book files: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur lors du chargement du livre: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            onQuiz: () async {
              // Handle quiz logic here
              if (_currentEleveId != null) {
                try {
                  // Check if the book has a quiz directly
                  if (book.quiz != null && book.quiz!.id != null) {
                    // Navigate to the real quiz screen
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakeQuizScreen(
                            quizId: book.quiz!.id!,
                            eleveId: _currentEleveId!,
                          ),
                        ),
                      );
                    }
                  } else {
                    // If no direct quiz, try to fetch quizzes for this student and filter by book
                    final quizzes = await _quizService.getQuizzesForEleve(_currentEleveId!);
                    final bookQuizzes = quizzes?.where((quiz) => quiz.livre?.id == book.id).toList();
                    
                    if (bookQuizzes != null && bookQuizzes.isNotEmpty) {
                      // For now, take the first quiz
                      final quiz = bookQuizzes.first;
                      
                      // Navigate to the real quiz screen
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakeQuizScreen(
                              quizId: quiz.id!,
                              eleveId: _currentEleveId!,
                            ),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aucun quiz disponible pour ce livre')),
                        );
                      }
                    }
                  }
                } catch (e) {
                  print('Error fetching quizzes: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erreur lors du chargement du quiz')),
                    );
                  }
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez vous connecter pour accéder aux quiz')),
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
  Widget _buildEmptyState(bool isSmallScreen, bool isVerySmallScreen, Color primaryColor) {
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
                backgroundColor: primaryColor,
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
  final Color primaryColor;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final VoidCallback onAudio; // Add audio callback
  final VoidCallback? onQuiz;

  _BookCard({
    required this.title,
    required this.author,
    required this.imagePath,
    required this.progress,
    required this.category,
    required this.pages,
    required this.isDownloaded,
    required this.isSmallScreen,
    required this.isVerySmallScreen,
    required this.primaryColor,
    required this.onTap,
    required this.onDownload,
    required this.onAudio, // Add audio callback
    this.onQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isVerySmallScreen ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du livre avec bordures arrondies
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isVerySmallScreen ? 16 : 20),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Book cover image with error handling
                    _buildBookImage(imagePath, isVerySmallScreen, primaryColor),
                    // Overlay pour le téléchargement
                    if (isDownloaded)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(isVerySmallScreen ? 6 : 8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.download_done,
                            color: Colors.white,
                            size: isVerySmallScreen ? 16 : 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Informations du livre avec padding amélioré
            Padding(
              padding: EdgeInsets.all(isVerySmallScreen ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre avec taille de texte adaptative
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 14 : isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF000000),
                      fontFamily: 'Roboto',
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: isVerySmallScreen ? 4 : 6),

                  // Auteur avec style amélioré
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 12 : isSmallScreen ? 14 : 15,
                      color: const Color(0xFF757575),
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isVerySmallScreen ? 6 : 8),

                  // Catégorie et pages avec badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge catégorie
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isVerySmallScreen ? 8 : 10,
                          vertical: isVerySmallScreen ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1D4F5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: isVerySmallScreen ? 10 : isSmallScreen ? 11 : 12,
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      // Pages avec icône
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            size: isVerySmallScreen ? 14 : 16,
                            color: const Color(0xFF757575),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "$pages p",
                            style: TextStyle(
                              fontSize: isVerySmallScreen ? 11 : isSmallScreen ? 12 : 13,
                              color: const Color(0xFF757575),
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: isVerySmallScreen ? 6 : 8),

                  // Barre de progression avec style amélioré
                  if (progress > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade300,
                            color: primaryColor,
                            minHeight: isVerySmallScreen ? 6 : 8,
                          ),
                        ),
                        SizedBox(height: isVerySmallScreen ? 4 : 6),
                        Text(
                          "${(progress * 100).round()}% lu",
                          style: TextStyle(
                            fontSize: isVerySmallScreen ? 10 : 12,
                            color: const Color(0xFF757575),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: isVerySmallScreen ? 6 : 8),

                  // Action buttons row avec style amélioré
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Download button
                      IconButton(
                        icon: Icon(
                          isDownloaded ? Icons.download_done : Icons.download_outlined,
                          size: isVerySmallScreen ? 18 : 20,
                          color: isDownloaded ? primaryColor : const Color(0xFF757575),
                        ),
                        onPressed: onDownload,
                        tooltip: isDownloaded ? 'Téléchargé' : 'Télécharger',
                      ),
                      // Audio button
                      IconButton(
                        icon: Icon(
                          Icons.headphones_outlined,
                          size: isVerySmallScreen ? 18 : 20,
                          color: const Color(0xFF757575),
                        ),
                        onPressed: onAudio, // Use dedicated audio handler
                        tooltip: 'Écouter',
                      ),
                      // Quiz button
                      if (onQuiz != null)
                        IconButton(
                          icon: Icon(
                            Icons.quiz_outlined,
                            size: isVerySmallScreen ? 18 : 20,
                            color: const Color(0xFF757575),
                          ),
                          onPressed: onQuiz,
                          tooltip: 'Quiz',
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
  Widget _buildBookImage(String? imagePath, bool isVerySmallScreen, Color primaryColor) {
    print('Attempting to load book image: $imagePath');
    
    // Check if the image path is valid
    if (imagePath == null || imagePath.isEmpty || imagePath == "Chemin de l'image") {
      print('Invalid image path, using default image');
      return _getDefaultBookImage(isVerySmallScreen, primaryColor);
    }
    
    // For network images (URLs) - already absolute URLs
    if (imagePath.startsWith('http')) {
      print('Loading network image: $imagePath');
      return _buildAuthenticatedImage(imagePath, isVerySmallScreen, primaryColor);
    }
    
    // For relative paths from the backend - these should already be handled in the service
    // But we'll still handle them here as a fallback
    try {
      final baseUrl = AuthService().dio.options.baseUrl;
      print('Base URL: $baseUrl');
      
      // Handle different path formats
      String fullImageUrl;
      
      // Check if it's already an absolute path or API path
      if (imagePath.startsWith('http')) {
        fullImageUrl = imagePath;
      } else if (imagePath.startsWith('/api/')) {
        // Already an API path, prepend base URL
        final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
        fullImageUrl = '$cleanBaseUrl$imagePath';
      } else if (imagePath.startsWith('/')) {
        // Relative path starting with /, prepend base URL
        final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
        fullImageUrl = '$cleanBaseUrl$imagePath';
      } else {
        // Relative path without leading slash, prepend base URL with slash
        final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
        fullImageUrl = '$cleanBaseUrl/$imagePath';
      }
      
      print('Loading book image from constructed URL: $fullImageUrl');
      
      return _buildAuthenticatedImage(fullImageUrl, isVerySmallScreen, primaryColor);
    } catch (e) {
      print('Error constructing image URL: $e');
      return _getDefaultBookImage(isVerySmallScreen, primaryColor);
    }
  }
  
  // Helper method to build authenticated image
  Widget _buildAuthenticatedImage(String imageUrl, bool isVerySmallScreen, Color primaryColor) {
    return FutureBuilder<Uint8List?>(
      future: _loadImageBytes(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isVerySmallScreen ? 16 : 20),
            ),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error displaying image from memory: $error');
                return _getDefaultBookImage(isVerySmallScreen, primaryColor);
              },
            ),
          );
        }
        
        // Fallback to default image
        return _getDefaultBookImage(isVerySmallScreen, primaryColor);
      },
    );
  }
  
  // Helper method to load image bytes with authentication
  Future<Uint8List?> _loadImageBytes(String imageUrl) async {
    try {
      final authService = AuthService();
      final response = await authService.dio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': authService.dio.options.headers['Authorization']?.toString() ?? '',
          },
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        return response.data as Uint8List;
      }
    } catch (e) {
      print('Error loading image bytes: $e');
    }
    return null;
  }
  
  // Default book image placeholder
  Widget _getDefaultBookImage(bool isVerySmallScreen, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE1D4F5),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isVerySmallScreen ? 16 : 20),
        ),
      ),
      child: Icon(
        Icons.menu_book,
        color: primaryColor,
        size: 40,
      ),
    );
  }
}
