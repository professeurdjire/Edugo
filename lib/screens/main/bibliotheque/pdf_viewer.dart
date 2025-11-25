import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:edugo/services/quiz_service.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/text_to_speech_service.dart';
import 'package:edugo/services/pdf_extractor_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/screens/main/quiz/take_quiz_screen.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Note: Web PDF viewer is handled separately for web platform
// On Android/iOS, we use SfPdfViewer.memory directly

class PdfViewerScreen extends StatefulWidget {
  final String filePath; // Can be a local file path or a URL
  final String title;
  final bool isOnline; // Indicates if filePath is a URL
  final Uint8List? pdfBytes; // PDF bytes in memory (for online reading without saving)
  final int? livreId; // Book ID for quiz detection and progress tracking
  final int? eleveId; // Student ID for quiz detection and progress tracking
  final int? totalPages; // Total pages of the book for completion detection

  const PdfViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
    this.isOnline = false,
    this.pdfBytes, // Optional: if provided, use this instead of filePath
    this.livreId,
    this.eleveId,
    this.totalPages,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final QuizService _quizService = QuizService();
  final LivreService _livreService = LivreService();
  final AuthService _authService = AuthService();
  final TextToSpeechService _ttsService = TextToSpeechService();
  bool _isLoading = true;
  bool _hasQuiz = false;
  int? _quizId;
  int _currentPage = 1;
  int _totalPages = 0;
  int _lastSavedPage = 0; // Dernière page sauvegardée
  bool _hasShownCompletionDialog = false;
  Timer? _progressionTimer; // Timer pour sauvegarder périodiquement
  
  // TTS State
  bool _isTTSInitialized = false;
  bool _isTTSPlaying = false;
  bool _isExtractingText = false;
  String _extractedText = '';
  double _ttsProgress = 0.0;
  int _ttsCurrentPosition = 0;
  String _currentWord = '';
  double _speechRate = 0.5;
  double _volume = 1.0;
  bool _showTTSControls = false;

  @override
  void initState() {
    super.initState();
    _checkQuizAvailability();
    _loadBookDetails();
    _loadExistingProgression(); // Charger la progression existante
    _initializeTTS();
    _startProgressionTimer(); // Démarrer le timer de sauvegarde périodique
    
    // For memory-based PDFs, we can load immediately
    // For file-based PDFs, add a small delay to ensure the file is fully written
    if (widget.pdfBytes != null) {
      // PDF bytes are already in memory, load immediately
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
      // Extract text from PDF bytes for TTS
      _extractTextFromPdfBytes();
    } else if (widget.filePath.isNotEmpty && !widget.isOnline && !widget.filePath.startsWith('http')) {
      // For file-based PDFs, add a small delay
      Future.delayed(Duration(milliseconds: widget.isOnline ? 50 : 100), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
      // Extract text from PDF file for TTS
      _extractTextFromPdfFile();
    } else {
      // For file-based PDFs, add a small delay
      Future.delayed(Duration(milliseconds: widget.isOnline ? 50 : 100), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
  
  /// Charger la progression existante à l'ouverture du livre
  Future<void> _loadExistingProgression() async {
    if (widget.livreId == null || widget.eleveId == null) return;
    
    try {
      final progression = await _livreService.getProgressionLivre(
        widget.eleveId!,
        widget.livreId!,
      );
      
      if (progression != null && mounted) {
        final savedPage = progression.pageActuelle ?? 1;
        setState(() {
          _currentPage = savedPage;
          _lastSavedPage = savedPage;
        });
        print('[PdfViewerScreen] ✅ Progression chargée: page $savedPage (${progression.pourcentageCompletion}%)');
        
        // La navigation vers la page sauvegardée se fera dans onDocumentLoaded
        // car le PDF doit être chargé avant de pouvoir naviguer
      } else {
        print('[PdfViewerScreen] ℹ️ Aucune progression existante pour ce livre');
      }
    } catch (e) {
      print('[PdfViewerScreen] ❌ Erreur lors du chargement de la progression: $e');
    }
  }
  
  /// Naviguer vers la page sauvegardée après le chargement du PDF
  void _navigateToSavedPage() {
    if (_currentPage > 1 && _totalPages > 0) {
      // Attendre un peu pour que le PDF soit complètement chargé
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _totalPages > 0) {
          try {
            // S'assurer que la page demandée est dans les limites
            final targetPage = (_currentPage - 1).clamp(0, _totalPages - 1);
            _pdfViewerController.jumpToPage(targetPage); // Les pages commencent à 0 dans le viewer
            print('[PdfViewerScreen] ✅ Navigation vers la page $_currentPage');
          } catch (e) {
            print('[PdfViewerScreen] ❌ Erreur lors de la navigation: $e');
          }
        }
      });
    }
  }
  
  /// Démarrer le timer pour sauvegarder la progression périodiquement
  void _startProgressionTimer() {
    if (widget.livreId == null || widget.eleveId == null) return;
    
    // Sauvegarder toutes les 30 secondes ou toutes les 5 pages
    _progressionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      // Sauvegarder seulement si la page a changé
      if (_currentPage != _lastSavedPage) {
        _updateProgression();
      }
    });
  }
  
  /// Mettre à jour la progression (méthode dédiée)
  Future<void> _updateProgression() async {
    if (widget.livreId == null || widget.eleveId == null) return;
    if (_currentPage == _lastSavedPage) return; // Déjà sauvegardé
    
    try {
      final progression = await _livreService.updateProgressionLecture(
        widget.eleveId!,
        widget.livreId!,
        _currentPage,
      );
      
      if (progression != null) {
        _lastSavedPage = _currentPage;
        final int localPercent = _totalPages > 0
            ? ((_currentPage * 100.0) / _totalPages).round().clamp(0, 100)
            : 0;
        print('[PdfViewerScreen] ✅ Progression sauvegardée: page $_currentPage (${localPercent}%)');
      }
    } catch (e) {
      print('[PdfViewerScreen] ❌ Erreur lors de la sauvegarde de la progression: $e');
    }
  }

  Future<void> _initializeTTS() async {
    if (kIsWeb) return; // TTS not available on web
    
    try {
      await _ttsService.initialize();
      if (mounted) {
        setState(() {
          _isTTSInitialized = _ttsService.isReady;
        });
      }
    } catch (e) {
      print('[PdfViewerScreen] Error initializing TTS: $e');
    }
  }

  Future<void> _extractTextFromPdfBytes() async {
    if (kIsWeb || widget.pdfBytes == null) return;
    
    setState(() {
      _isExtractingText = true;
    });
    
    try {
      // Use PdfExtractorService to extract text from bytes
      final String text = PdfExtractorService.extractTextFromBytes(widget.pdfBytes!);
      
      if (mounted) {
        setState(() {
          _extractedText = text.isNotEmpty && 
                          !text.contains("Impossible d'extraire") && 
                          !text.contains("Aucun texte trouvé") 
                          ? text : '';
          _isExtractingText = false;
        });
      }
    } catch (e) {
      print('[PdfViewerScreen] Error extracting text from PDF bytes: $e');
      if (mounted) {
        setState(() {
          _isExtractingText = false;
        });
      }
    }
  }

  Future<void> _extractTextFromPdfFile() async {
    if (kIsWeb || widget.filePath.isEmpty || widget.isOnline || widget.filePath.startsWith('http')) return;
    
    setState(() {
      _isExtractingText = true;
    });
    
    try {
      final String text = await PdfExtractorService.extractTextFromFile(widget.filePath);
      if (mounted) {
        setState(() {
          _extractedText = text.isNotEmpty && !text.contains("Impossible d'extraire") ? text : '';
          _isExtractingText = false;
        });
      }
    } catch (e) {
      print('[PdfViewerScreen] Error extracting text from PDF file: $e');
      if (mounted) {
        setState(() {
          _isExtractingText = false;
        });
      }
    }
  }

  void _toggleTTSPlay() {
    if (kIsWeb || !_isTTSInitialized) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lecture audio non disponible')),
        );
      }
      return;
    }
    
    if (_extractedText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Extraction du texte en cours...')),
        );
      }
      return;
    }
    
    if (_isTTSPlaying) {
      _pauseTTS();
    } else {
      _playTTS();
    }
  }

  void _playTTS() {
    if (_extractedText.isEmpty) return;
    
    _ttsService.speakWithProgress(
      _extractedText,
      (word) {
        if (mounted) {
          setState(() {
            _currentWord = word;
          });
        }
      },
      (start, end) {
        if (mounted && _extractedText.isNotEmpty) {
          setState(() {
            _ttsProgress = (end / _extractedText.length).clamp(0.0, 1.0);
            _ttsCurrentPosition = end;
          });
        }
      },
    );
    
    setState(() {
      _isTTSPlaying = true;
      _showTTSControls = true;
    });
  }

  void _pauseTTS() {
    _ttsService.pause();
    setState(() {
      _isTTSPlaying = false;
    });
  }

  void _stopTTS() {
    _ttsService.stop();
    setState(() {
      _isTTSPlaying = false;
      _ttsProgress = 0.0;
      _ttsCurrentPosition = 0;
      _currentWord = '';
    });
  }

  @override
  @override
  void dispose() {
    // Sauvegarder la progression avant de fermer
    if (widget.livreId != null && widget.eleveId != null && _currentPage != _lastSavedPage) {
      _updateProgression();
    }
    
    // Arrêter le timer
    _progressionTimer?.cancel();
    
    // Arrêter TTS
    _ttsService.stop();
    
    super.dispose();
  }

  Future<void> _loadBookDetails() async {
    if (widget.livreId != null) {
      try {
        final book = await _livreService.getLivreById(widget.livreId!);
        if (mounted) {
          setState(() {
            if (book?.totalPages != null) {
              _totalPages = book!.totalPages!;
            } else if (widget.totalPages != null) {
              _totalPages = widget.totalPages!;
            }
          });
        }
      } catch (e) {
        print('[PdfViewerScreen] Error loading book details: $e');
      }
    } else if (widget.totalPages != null) {
      setState(() {
        _totalPages = widget.totalPages!;
      });
    }
  }

  Future<void> _checkQuizAvailability() async {
    final eleveId = widget.eleveId ?? _authService.currentUserId;
    if (eleveId == null || widget.livreId == null) return;
    
    try {
      // First, try to get the book and check if it has a quiz directly
      final book = await _livreService.getLivreById(widget.livreId!);
      if (book != null && book.quiz != null && book.quiz!.id != null) {
        if (mounted) {
          setState(() {
            _hasQuiz = true;
            _quizId = book.quiz!.id;
          });
        }
        return;
      }
      
      // If no direct quiz, try to fetch quizzes for this student and filter by book
      final quizzes = await _quizService.getQuizzesForEleve(eleveId);
      if (quizzes != null) {
        final bookQuizzes = quizzes.where((quiz) => quiz.livre?.id == widget.livreId).toList();
        if (bookQuizzes.isNotEmpty) {
          if (mounted) {
            setState(() {
              _hasQuiz = true;
              _quizId = bookQuizzes.first.id;
            });
          }
        }
      }
    } catch (e) {
      print('[PdfViewerScreen] Error checking quiz availability: $e');
    }
  }

  void _navigateToQuiz() async {
    final eleveId = widget.eleveId ?? _authService.currentUserId;
    if (eleveId == null || _quizId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun quiz disponible pour ce livre')),
        );
      }
      return;
    }
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakeQuizScreen(
            quizId: _quizId!,
            eleveId: eleveId,
          ),
        ),
      );
    }
  }

  void _onPageChanged(int pageNumber) {
    setState(() {
      _currentPage = pageNumber;
    });
    
    // Mettre à jour la progression (le timer s'occupera de la sauvegarde périodique)
    // On peut aussi sauvegarder immédiatement si on change de plus de 5 pages
    if (widget.livreId != null && widget.eleveId != null) {
      final pageDifference = (pageNumber - _lastSavedPage).abs();
      
      // Sauvegarder immédiatement si on a changé de plus de 5 pages
      if (pageDifference >= 5) {
        _updateProgression();
      }
    }
    
    // Check if we've reached the end of the book
    if (_totalPages > 0 && pageNumber >= _totalPages && !_hasShownCompletionDialog) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    if (_hasShownCompletionDialog || !_hasQuiz) return;
    
    _hasShownCompletionDialog = true;
    final primaryColor = ThemeService().currentPrimaryColor;
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.celebration, color: Colors.amber, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Félicitations !',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vous venez de terminer la lecture de ce livre !',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Voulez-vous faire le quiz pour tester votre compréhension, valider le livre et gagner des points ?',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.quiz, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Gagnez des points',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Plus tard',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Faire le quiz',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: ThemeService().primaryColorNotifier,
      builder: (context, primaryColor, _) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                if (_totalPages > 0)
                  Builder(
                    builder: (context) {
                      final double ratio = _totalPages > 0
                          ? (_currentPage / _totalPages).clamp(0.0, 1.0)
                          : 0.0;
                      final int percent = (ratio * 100).round();
                      return Text(
                        'Page $_currentPage / $_totalPages • ${percent}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      );
                    },
                  ),
              ],
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
        actions: [
          // TTS Toggle button
          if (_isTTSInitialized && !kIsWeb)
            IconButton(
              icon: Icon(
                _showTTSControls ? Icons.volume_up : Icons.volume_down,
                color: _isTTSPlaying ? Colors.amber : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _showTTSControls = !_showTTSControls;
                  if (!_showTTSControls && _isTTSPlaying) {
                    _stopTTS();
                  }
                });
              },
              tooltip: _showTTSControls ? 'Masquer la lecture audio' : 'Afficher la lecture audio',
            ),
          if (_hasQuiz)
            IconButton(
              icon: const Icon(Icons.quiz),
              onPressed: _navigateToQuiz,
              tooltip: 'Passer le quiz',
            ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25;
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              if (_pdfViewerController.zoomLevel > 0.25) {
                _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25;
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // PDF Viewer
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : widget.pdfBytes != null
                  ? _buildPdfViewerFromMemory()
                  : widget.isOnline || widget.filePath.startsWith('http://') || widget.filePath.startsWith('https://')
                      ? SfPdfViewer.network(
                          widget.filePath,
                          controller: _pdfViewerController,
                          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                            print('PDF load failed: ${details.error}');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erreur lors du chargement du PDF'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                            if (mounted) {
                              setState(() {
                                if (_totalPages == 0) {
                                  _totalPages = details.document.pages.count;
                                }
                              });
                              // Naviguer vers la page sauvegardée après le chargement
                              _navigateToSavedPage();
                            }
                          },
                          onPageChanged: (PdfPageChangedDetails details) {
                            _onPageChanged(details.newPageNumber);
                          },
                        )
                      : SfPdfViewer.file(
                          File(widget.filePath),
                          controller: _pdfViewerController,
                          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                            print('PDF load failed: ${details.error}');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erreur lors du chargement du PDF'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                            if (mounted) {
                              setState(() {
                                if (_totalPages == 0) {
                                  _totalPages = details.document.pages.count;
                                }
                              });
                              // Naviguer vers la page sauvegardée après le chargement
                              _navigateToSavedPage();
                            }
                          },
                          onPageChanged: (PdfPageChangedDetails details) {
                            _onPageChanged(details.newPageNumber);
                          },
                        ),
          
          // TTS Progress Indicator (top bar)
          if (_isTTSPlaying || _showTTSControls)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTTSProgressBar(primaryColor),
            ),
          
          // TTS Controls (floating bottom)
          if (_isTTSInitialized && !kIsWeb && _showTTSControls)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildTTSControls(primaryColor),
            ),
        ],
      ),
        );
      },
    );
  }

  Widget _buildPdfViewerFromMemory() {
    // Validate PDF bytes before trying to load
    if (widget.pdfBytes == null || widget.pdfBytes!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Aucune donnée PDF disponible'),
          ],
        ),
      );
    }

    // Check if it's a valid PDF by checking the header
    if (widget.pdfBytes!.length >= 4) {
      final header = String.fromCharCodes(widget.pdfBytes!.take(4));
      if (!header.startsWith('%PDF')) {
        print('[PdfViewerScreen] Warning: File header is not %PDF, got: $header');
        // Check first 100 bytes to see if it's HTML/JSON error
        final preview = String.fromCharCodes(widget.pdfBytes!.take(100));
        if (preview.contains('<html') || preview.contains('{')) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Le fichier téléchargé n\'est pas un PDF valide'),
                const SizedBox(height: 8),
                Text('Header: $header', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        }
        // Still try to load it, might work
      }
    }

    // On web, we would use iframe, but for now use SfPdfViewer.memory on all platforms
    // TODO: Implement web-specific PDF viewer if needed
    // On mobile platforms, use SfPdfViewer.memory
    return SfPdfViewer.memory(
      widget.pdfBytes!,
      controller: _pdfViewerController,
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        print('[PdfViewerScreen] PDF load failed');
        print('[PdfViewerScreen] Error: ${details.error}');
        print('[PdfViewerScreen] Description: ${details.description}');
        print('[PdfViewerScreen] PDF bytes length: ${widget.pdfBytes!.length}');
        if (widget.pdfBytes!.length > 0) {
          final preview = String.fromCharCodes(widget.pdfBytes!.take(100));
          print('[PdfViewerScreen] First 100 bytes: $preview');
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors du chargement du PDF: ${details.description ?? details.error.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
        print('[PdfViewerScreen] PDF loaded successfully');
        print('[PdfViewerScreen] Pages: ${details.document.pages.count}');
        if (mounted) {
          setState(() {
            if (_totalPages == 0) {
              _totalPages = details.document.pages.count;
            }
          });
          // Naviguer vers la page sauvegardée après le chargement
          _navigateToSavedPage();
          // Extract text after PDF is loaded
          if (widget.pdfBytes != null && !kIsWeb) {
            _extractTextFromPdfBytes();
          }
        }
      },
      onPageChanged: (PdfPageChangedDetails details) {
        _onPageChanged(details.newPageNumber);
      },
    );
  }

  // Web PDF viewer removed - using SfPdfViewer.memory on all platforms for now

  Widget _buildTTSProgressBar(Color primaryColor) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _ttsProgress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor,
                ThemeService().mediumVariant,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTTSControls(Color primaryColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Play/Pause button with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleTTSPlay,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isTTSPlaying
                          ? [
                              primaryColor,
                              ThemeService().mediumVariant,
                            ]
                          : [
                              ThemeService().mediumVariant,
                              primaryColor,
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isTTSPlaying ? primaryColor : ThemeService().mediumVariant)
                            .withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isTTSPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Progress indicator and current word
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _ttsProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            ThemeService().mediumVariant,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Current word indicator with animation
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _currentWord.isNotEmpty
                      ? Container(
                          key: ValueKey(_currentWord),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.15),
                                ThemeService().mediumVariant.withOpacity(0.15),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.record_voice_over,
                                size: 16,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _currentWord,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          key: const ValueKey('idle'),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.headphones,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Prêt à lire',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Stop button
          if (_isTTSPlaying)
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _stopTTS,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red[200]!,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.stop,
                      color: Colors.red[600],
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          
          // Settings button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showTTSSettings,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.tune,
                  color: Colors.grey[700],
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTTSSettings() {
    final primaryColor = ThemeService().currentPrimaryColor;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paramètres de lecture',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            
            // Speech Rate
            Text(
              'Vitesse: ${(_speechRate * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _speechRate,
              min: 0.25,
              max: 1.0,
              divisions: 15,
              activeColor: ThemeService().currentPrimaryColor,
              onChanged: (value) {
                setState(() {
                  _speechRate = value;
                });
                _ttsService.setSpeechRate(value);
              },
            ),
            
            const SizedBox(height: 16),
            
            // Volume
            Text(
              'Volume: ${(_volume * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _volume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              activeColor: ThemeService().currentPrimaryColor,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
                _ttsService.setVolume(value);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
