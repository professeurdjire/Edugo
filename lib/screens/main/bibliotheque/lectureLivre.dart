import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:edugo/screens/main/bibliotheque/quizLivre.dart'; // Import de la page quiz
import 'package:edugo/screens/main/bibliotheque/pdf_viewer.dart'; // PDF viewer
import 'package:edugo/screens/main/bibliotheque/audioLivre.dart'; // Audio book reader
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/services/book_file_service.dart';
import 'package:edugo/services/livre_service.dart';

// Helper class for word tracking
class Word {
  final String text;
  bool isRead;

  Word({required this.text, this.isRead = false});
}

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur des icônes)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _readColor = Color(0xFFA885D8); // Couleur du texte lu (violet)
const String _fontFamily = 'Roboto'; // Police principale

class BookReaderScreen extends StatefulWidget {
  final String bookTitle;
  final int? livreId;
  final int? eleveId;
  final List<FichierLivre>? fichiers; // Files associated with the book

  const BookReaderScreen({
    super.key, 
    this.bookTitle = "Le jardin Invisible",
    this.livreId,
    this.eleveId,
    this.fichiers,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> with SingleTickerProviderStateMixin {
  // Simulation du contenu du livre avec pagination
  final List<String> _bookPages = [
    """
Alfred se remémore ses souvenirs personnels, ces instants en apparence anodins, mais qui ont été des bascules dans sa vie. Un souvenir en entraînant un autre, il plonge dans sa tête, dans son cheminement, qu'il traduit en dessins.
Il se rappelle ce jour de mars 2021, à Naples, alors qu'il est avec sa fille. Il a rendez-vous sur le tournage de Come Prima, avec l'équipe du film pour les scènes de nuit. Mais dans le taxi, il est complètement perdu. Dans ce port, tout se ressemble. Il panique. Il n'arrive pas à joindre l'équipe de tournage. Le chauffeur s'agace et, à sa grande surprise, sa fille prend les devants. Ils sortent du taxi et elle part en tête. Lui est toujours perdu. Il la voit devant lui, sa petite fille, qui inverse les rôles et le prend sous son aile. Il se laisse guider et quelques centaines de mètres plus loin, elle réussit à atteindre leur objectif.
En novembre 2007, il est à Djibouti, seul, pour mener des ateliers de dessin dans des écoles isolées. C'est la première fois qu'il vient en Afrique. Il est très occupé et il n'a pas toujours le temps de donner de ses nouvelles, ni d'en recevoir de France, car la connexion n'est pas bonne partout. Ce jour-là, il peut accéder à un ordinateur connecté à Internet : le directeur d'une école lui laisse sa place. Au milieu de mails anodins. Il y en a un de sa compagne, qui dit...
""",
    """
...qu'elle attend un enfant. Cette nouvelle le bouleverse. Il se sent à la fois joyeux et anxieux. Comment va-t-il assumer ce nouveau rôle de père ? La distance qui le sépare de la France semble soudain immense. Il décide de terminer sa mission plus rapidement que prévu.

De retour en France, Alfred se plonge dans la préparation de l'arrivée du bébé. Il dessine sans cesse, comme pour apprivoiser ses craintes. Chaque trait est un pas vers la paternité. Les mois passent, et le jour J arrive enfin.

À la naissance de sa fille, Alfred ressent un amour qu'il n'avait jamais connu auparavant. Ce petit être fragile change sa perspective sur la vie. Il comprend que certains moments, bien qu'anodins en apparence, sont en réalité des tournants décisifs.
""",
    """
Des années plus tard, alors qu'il feuillette ses vieux carnets de dessins, Alfred revit ces instants avec une intensité renouvelée. Chaque croquis raconte une histoire, chaque ombre portée cache un souvenir.

Aujourd'hui, assis dans son atelier, entouré de ses œuvres, il sourit en pensant à ce parcours semé d'embûches mais aussi de belles surprises. La vie est un jardin invisible où chaque graine plantée finit par fleurir à son heure.

Il prend son crayon et commence un nouveau dessin : celui de son jardin intérieur, peuplé de tous ces moments qui ont fait de lui l'homme qu'il est devenu.
"""
  ];

  int _currentPage = 0;
  bool _isPlayingAudio = false;
  bool _showCompletionOverlay = false;
  int _currentWordIndex = 0;
  late AnimationController _animationController;
  final PageController _pageController = PageController();
  final BookFileService _bookFileService = BookFileService();
  final LivreService _livreService = LivreService();
  
  // Pour chaque page, on stocke les mots et leur état (lu/non lu)
  late List<List<Word>> _pageWords;
  
  // For file-based books
  bool _isFileBasedBook = false;
  FichierLivre? _selectedFile;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    
    // Check if this is a file-based book
    if (widget.fichiers != null && widget.fichiers!.isNotEmpty) {
      _isFileBasedBook = true;
      _selectedFile = widget.fichiers!.first; // Use the first file for now
    }

    // Initialiser les mots pour chaque page (only for text-based books)
    if (!_isFileBasedBook) {
      _pageWords = _bookPages.map((page) {
        return _splitTextIntoWords(page).map((word) => Word(text: word, isRead: false)).toList();
      }).toList();
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Vitesse de lecture automatique
    );
    
    // If it's a file-based book, try to download/open the file
    if (_isFileBasedBook && _selectedFile != null) {
      // Use addPostFrameCallback to ensure the context is fully initialized
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleFileBasedBook();
      });
    }
  }

  Future<void> _handleFileBasedBook() async {
    if (_selectedFile == null) return;
    
    print('Starting to handle file-based book: ${_selectedFile!.nom}');
    
    // Show loading indicator
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Téléchargement du livre...'),
            ],
          ),
        ),
      );
    }
    
    try {
      // Check if file is already downloaded
      bool isDownloaded = await _bookFileService.isBookDownloaded(_selectedFile!);
      print('Book already downloaded: $isDownloaded');
      
      if (isDownloaded) {
        // Get the file path
        final directory = await getApplicationDocumentsDirectory();
        final downloadDir = Directory('${directory.path}/books');
        final fileName = '${_selectedFile!.id}_${_selectedFile!.nom}.${_selectedFile!.format}';
        _filePath = '${downloadDir.path}/$fileName';
        print('Using existing file path: $_filePath');
      } else {
        // Download the file using the correct API endpoint
        print('Downloading book file...');
        _filePath = await _bookFileService.downloadBookFile(_selectedFile!);
        print('Downloaded file path: $_filePath');
      }
      
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Open the file based on its type
      if (_filePath != null) {
        print('Opening file: $_filePath');
        await _openFileBasedBook();
      } else {
        print('File path is null, showing error');
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors du téléchargement du livre')),
          );
        }
      }
    } catch (e) {
      print('Error handling file-based book: $e');
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ouverture du livre: $e')),
        );
      }
    }
  }

  Future<void> _openFileBasedBook() async {
    if (_selectedFile == null || _filePath == null) return;
    
    print('Opening file-based book: ${_selectedFile!.nom}');
    print('File type: ${_selectedFile!.type}');
    print('File path: $_filePath');
    
    switch (_selectedFile!.type) {
      case FichierLivreTypeEnum.PDF:
        // Navigate to PDF viewer
        print('Opening PDF file');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                filePath: _filePath!,
                title: _selectedFile!.nom ?? 'Document PDF',
              ),
            ),
          );
        }
        break;
        
      case FichierLivreTypeEnum.EPUB:
        // For EPUB files, we would navigate to an EPUB viewer
        print('EPUB file - showing message');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lecture des fichiers EPUB bientôt disponible')),
          );
        }
        break;
        
      case FichierLivreTypeEnum.IMAGE:
        // For image files, we would navigate to an image viewer
        print('Image file - showing message');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Affichage des images bientôt disponible')),
          );
        }
        break;
        
      case FichierLivreTypeEnum.VIDEO:
        // For video files, we would navigate to a video player
        print('Video file - showing message');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lecture des vidéos bientôt disponible')),
          );
        }
        break;
        
      case FichierLivreTypeEnum.AUDIO:
        // For audio files, we would navigate to an audio player
        print('Audio file - opening audio reader');
        if (mounted) {
          // For now, we'll show a message that audio books are supported
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lecture audio disponible - redirection vers le lecteur audio')),
          );
          
          // Navigate to audio book reader
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookAudioReaderScreen(
                bookTitle: widget.bookTitle,
              ),
            ),
          );
        }
        break;
        
      default:
        print('Unknown file type, trying external app');
        // Try to open with external app
        await _bookFileService.openWithExternalApp(_filePath!);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<String> _splitTextIntoWords(String text) {
    // Diviser le texte en mots en gardant la ponctuation
    return text.split(RegExp(r'(?<=[\s.,!?;])'));
  }

  // --- LECTURE AUTOMATIQUE (Audio) ---
  void _startAutoReading() {
    if (_isPlayingAudio) return;

    setState(() {
      _isPlayingAudio = true;
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readNextWordAuto();
      }
    });

    _readNextWordAuto();
  }

  void _stopAutoReading() {
    setState(() {
      _isPlayingAudio = false;
    });
    _animationController.stop();
  }

  void _readNextWordAuto() {
    if (!_isPlayingAudio) return;

    if (_currentWordIndex < _pageWords[_currentPage].length) {
      setState(() {
        _pageWords[_currentPage][_currentWordIndex].isRead = true;
        _currentWordIndex++;
      });

      // Programmer la lecture du mot suivant
      _animationController.forward(from: 0.0);
    } else {
      // Tous les mots de cette page sont lus, passer à la page suivante
      _goToNextPageAuto();
    }
  }

  void _goToNextPageAuto() {
    if (_currentPage < _bookPages.length - 1) {
      setState(() {
        _currentPage++;
        _currentWordIndex = 0;
        _showCompletionOverlay = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Redémarrer la lecture automatique sur la nouvelle page
      if (_isPlayingAudio) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _readNextWordAuto();
        });
      }
    } else {
      // Dernière page terminée - afficher le popup
      _stopAutoReading();
      setState(() {
        _showCompletionOverlay = true;
      });
    }
  }

  // --- LECTURE MANUELLE (Utilisateur) ---
  void _markPageAsReadManually() {
    // Marquer toute la page comme lue manuellement
    setState(() {
      for (var word in _pageWords[_currentPage]) {
        word.isRead = true;
      }
      _currentWordIndex = _pageWords[_currentPage].length;
    });

    // Vérifier si c'est la dernière page
    _checkIfBookFinished();
  }

  void _checkIfBookFinished() {
    // Vérifier si TOUTES les pages sont lues
    bool allPagesRead = true;
    for (int i = 0; i < _pageWords.length; i++) {
      bool pageRead = _pageWords[i].every((word) => word.isRead);
      if (!pageRead) {
        allPagesRead = false;
        break;
      }
    }

    if (allPagesRead) {
      setState(() {
        _showCompletionOverlay = true;
      });
    }
  }

  void _goToNextPageManual() {
    if (_currentPage < _bookPages.length - 1) {
      setState(() {
        _currentPage++;
        _currentWordIndex = 0;
        _showCompletionOverlay = false;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Si on est sur la dernière page, vérifier si elle est lue
      bool currentPageRead = _pageWords[_currentPage].every((word) => word.isRead);
      if (currentPageRead) {
        setState(() {
          _showCompletionOverlay = true;
        });
      } else {
        // Si la dernière page n'est pas lue, proposer de la marquer comme lue
        _markPageAsReadManually();
      }
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _currentWordIndex = 0;
        _showCompletionOverlay = false;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleAudio() {
    if (_isPlayingAudio) {
      _stopAutoReading();
    } else {
      _startAutoReading();
    }
  }

  void _closeCompletionOverlay() {
    setState(() {
      _showCompletionOverlay = false;
    });
    Navigator.of(context).pop();
  }

  void _navigateToQuiz() {
    setState(() {
      _showCompletionOverlay = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookQuizScreen(quizTitle: '${widget.bookTitle} Quiz'),
      ),
    );
  }

  Widget _buildCompletionOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7), // Fond semi-transparent pour l'overlay
        child: Center(
          child: _buildCompletionDialog(),
        ),
      ),
    );
  }

  Widget _buildCompletionDialog() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;
        final bool isLargeScreen = constraints.maxWidth > 900;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 20.0 : 25.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: isSmallScreen
                ? MediaQuery.of(context).size.width * 0.9
                : isLargeScreen
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 20.0 : 25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // En-tête avec dégradé
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_purpleMain, Color(0xFF8A6DC5)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isSmallScreen ? 20 : 25),
                      topRight: Radius.circular(isSmallScreen ? 20 : 25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _purpleMain.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Icône de check (succès)
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: isSmallScreen ? 35 : 40,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 15),
                      Text(
                        "Lecture Terminée !",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: _fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Corps du message
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
                  child: Column(
                    children: [
                      Text(
                        "Félicitations !",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: _colorBlack,
                          fontFamily: _fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 10),
                      Text(
                        "Vous venez de terminer un livre",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 15 : 16,
                          color: _colorBlack,
                          fontFamily: _fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 15),
                      Text(
                        "Répondez au quiz pour tester votre compréhension et gagner des points !",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.grey[700],
                          fontFamily: _fontFamily,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 25),

                      // Bouton principal
                      Container(
                        width: double.infinity,
                        height: isSmallScreen ? 50 : 55,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [_purpleMain, Color(0xFF8A6DC5)],
                          ),
                          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                          boxShadow: [
                            BoxShadow(
                              color: _purpleMain.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _navigateToQuiz,
                            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                            child: Center(
                              child: Text(
                                "Accéder au Quiz",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: _fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 15 : 20),

                      // Bouton secondaire
                      TextButton(
                        onPressed: _closeCompletionOverlay,
                        child: Text(
                          "Plus tard",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: _purpleMain,
                            fontWeight: FontWeight.w600,
                            fontFamily: _fontFamily,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If it's a file-based book, we've already navigated to the appropriate viewer
    // This screen is only for text-based books
    if (_isFileBasedBook) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_purpleMain),
              ),
              SizedBox(height: 16),
              Text(
                'Ouverture du livre...',
                style: TextStyle(
                  color: _colorBlack,
                  fontSize: 16,
                  fontFamily: _fontFamily,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // --- EN-TÊTE CUSTOMISÉE ---
              Container(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFA885D8), Color(0xFF8A6DC5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFA885D8),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Bouton retour
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    
                    // Titre du livre
                    Expanded(
                      child: Text(
                        widget.bookTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: _fontFamily,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // Bouton audio (lecture automatique)
                    IconButton(
                      icon: Icon(
                        _isPlayingAudio ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _toggleAudio,
                    ),
                  ],
                ),
              ),

              // --- CONTENU DU LIVRE ---
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _bookPages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      _currentWordIndex = 0;
                    });
                  },
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildPageContent(index),
                    );
                  },
                ),
              ),

              // --- BARRE DE NAVIGATION INFÉRIEURE ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bouton page précédente
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: _purpleMain,
                      onPressed: _goToPreviousPage,
                    ),
                    
                    // Indicateur de progression
                    Text(
                      "${_currentPage + 1}/${_bookPages.length}",
                      style: const TextStyle(
                        color: _colorBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: _fontFamily,
                      ),
                    ),
                    
                    // Bouton page suivante
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      color: _purpleMain,
                      onPressed: _goToNextPageManual,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --- OVERLAY DE COMPLÉTION ---
          if (_showCompletionOverlay) _buildCompletionOverlay(),
        ],
      ),
    );
  }

  Widget _buildPageContent(int pageIndex) {
    final pageWords = _pageWords[pageIndex];
    final List<TextSpan> textSpans = [];

    for (int i = 0; i < pageWords.length; i++) {
      final word = pageWords[i];
      textSpans.add(
        TextSpan(
          text: word.text,
          style: TextStyle(
            color: word.isRead ? _readColor : _colorBlack,
            fontSize: 16,
            fontFamily: _fontFamily,
            fontWeight: word.isRead ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          fontFamily: _fontFamily,
          height: 1.6,
        ),
        children: textSpans,
      ),
    );
  }
}