import 'package:flutter/material.dart';
import 'package:edugo/services/text_to_speech_service.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/services/book_file_service.dart';
import 'package:edugo/services/pdf_extractor_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:edugo/screens/main/bibliotheque/pdf_viewer.dart'; // Add PDF viewer

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _colorBlack = Color(0xFF000000);
const Color _colorGrey = Color(0xFF757575);
const String _fontFamily = 'Roboto';

class AudioBookReaderScreen extends StatefulWidget {
  final String bookTitle;
  final String? bookContent;
  final int? livreId;
  final int? eleveId;
  final FichierLivre? fichierLivre;

  const AudioBookReaderScreen({
    super.key,
    required this.bookTitle,
    this.bookContent,
    this.livreId,
    this.eleveId,
    this.fichierLivre,
  });

  @override
  State<AudioBookReaderScreen> createState() => _AudioBookReaderScreenState();
}

class _AudioBookReaderScreenState extends State<AudioBookReaderScreen> {
  final TextToSpeechService _ttsService = TextToSpeechService();
  final BookFileService _bookFileService = BookFileService();
  final ThemeService _themeService = ThemeService();
  bool _isPlaying = false;
  bool _isInitialized = false;
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;
  bool _isLoadingContent = true;
  String _loadingMessage = 'Chargement du contenu...';
  bool _isContentExtracted = false; // Track if we have extracted text content
  
  // For highlighting current word/phrase
  String _currentWord = '';
  int _currentPosition = 0;
  double _progress = 0.0;
  int _currentSentenceIndex = 0;
  
  // For book content display
  List<String> _sentences = [];
  ScrollController _scrollController = ScrollController();
  String _actualBookContent = '';
  String? _bookFilePath; // Store the book file path

  @override
  void initState() {
    super.initState();
    _initializeContent();
    if (!kIsWeb) {
      _initializeTTS();
    }
  }
  
  void _initializeContent() async {
    String content = '';
    
    // Vérifier que nous avons un fichier de livre valide
    if (widget.fichierLivre == null) {
      print('[AudioBookReader] ERROR: No fichierLivre provided!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur: Aucun fichier de livre fourni'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _actualBookContent = '';
        _isContentExtracted = false;
        _isLoadingContent = false;
      });
      return;
    }
    
    print('[AudioBookReader] Initializing content for book: ${widget.bookTitle}');
    print('[AudioBookReader] FichierLivre ID: ${widget.fichierLivre!.id}, Format: ${widget.fichierLivre!.format}, Nom: ${widget.fichierLivre!.nom}');
    
    try {
      setState(() {
        _isLoadingContent = true;
        _loadingMessage = 'Téléchargement du livre...';
      });
      
      // First, ensure the book is downloaded
      String? filePath = await _bookFileService.getDownloadedBookPath(widget.fichierLivre!);
      
      if (filePath == null) {
        print('[AudioBookReader] File not found locally, downloading...');
        setState(() {
          _loadingMessage = 'Téléchargement du livre...';
        });
        filePath = await _bookFileService.downloadBookFile(widget.fichierLivre!);
      }
      
      if (filePath == null) {
        print('[AudioBookReader] ERROR: Failed to download book file');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur: Impossible de télécharger le fichier du livre'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          _actualBookContent = '';
          _isContentExtracted = false;
          _isLoadingContent = false;
        });
        return;
      }
      
      print('[AudioBookReader] Book file downloaded to: $filePath');
      setState(() {
        _bookFilePath = filePath;
        _loadingMessage = 'Extraction du contenu du livre...';
      });
      
      // Try to extract text content from the PDF file
      print('[AudioBookReader] Extracting text from PDF file...');
      content = await PdfExtractorService.extractTextFromFile(filePath);
      
      print('[AudioBookReader] Extracted text length: ${content.length}');
      print('[AudioBookReader] Extracted text preview: ${content.length > 100 ? content.substring(0, 100) : content}...');
      
      // Check if extraction was successful
      if (content.isNotEmpty && 
          !content.contains("Impossible d'extraire") && 
          !content.contains("Aucun texte trouvé") &&
          content.length > 50) { // Ensure we have substantial content
        print('[AudioBookReader] Text extraction successful!');
        setState(() {
          _isContentExtracted = true;
        });
      } else {
        print('[AudioBookReader] WARNING: Text extraction failed or returned empty content');
        print('[AudioBookReader] Content: ${content.length > 200 ? content.substring(0, 200) : content}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Attention: Impossible d\'extraire le texte de ce livre. Le contenu audio n\'est pas disponible.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
        }
        setState(() {
          _isContentExtracted = false;
        });
        // Ne pas utiliser de contenu par défaut - laisser vide pour forcer l'utilisateur à ouvrir le PDF
        content = '';
      }
    } catch (e) {
      print('[AudioBookReader] ERROR loading book content: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement du livre: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      setState(() {
        _isContentExtracted = false;
      });
      content = '';
    }
    
    setState(() {
      _actualBookContent = content;
      if (content.isNotEmpty) {
        _sentences = content.split('\n')
            .map((paragraph) => paragraph.trim())
            .where((paragraph) => paragraph.isNotEmpty)
            .toList();
      } else {
        _sentences = [];
      }
      _isLoadingContent = false;
    });
    
    // Démarrer la lecture automatique après l'extraction du contenu
    if (!kIsWeb && _isContentExtracted && _actualBookContent.isNotEmpty) {
      // Attendre que le TTS soit initialisé avant de démarrer
      _waitForTTSAndPlay();
    }
  }
  
  // Supprimé: Ne plus utiliser de contenu par défaut
  // Si l'extraction échoue, on affiche un message d'erreur et on laisse l'utilisateur ouvrir le PDF

  Future<void> _initializeTTS() async {
    if (kIsWeb) {
      return;
    }
    
    try {
      await _ttsService.initialize();
      
      await _ttsService.setSpeechRate(_speechRate);
      await _ttsService.setVolume(_volume);
      await _ttsService.setPitch(_pitch);
      
      setState(() {
        _isInitialized = _ttsService.isReady;
      });
      
      if (!_isInitialized) {
        print('TTS service is not ready');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le service de lecture audio n\'est pas disponible sur cet appareil')),
          );
        }
      } else {
        // Si le contenu est déjà extrait, démarrer la lecture
        if (_isContentExtracted && _actualBookContent.isNotEmpty) {
          _waitForTTSAndPlay();
        }
      }
    } catch (e) {
      print('Error initializing TTS: $e');
      setState(() {
        _isInitialized = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'initialisation de la lecture audio')),
        );
      }
    }
  }
  
  Future<void> _waitForTTSAndPlay() async {
    // Attendre que le TTS soit initialisé
    int attempts = 0;
    while (!_isInitialized && attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (_ttsService.isReady) {
        setState(() {
          _isInitialized = true;
        });
        break;
      }
      attempts++;
    }
    
    // Si le TTS est prêt et le contenu est extrait, démarrer la lecture
    if (_isInitialized && _isContentExtracted && _actualBookContent.isNotEmpty && mounted) {
      print('[AudioBookReader] Starting automatic playback...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isPlaying) {
          _play();
        }
      });
    }
  }
  
  void _togglePlayPause() {
    if (kIsWeb) {
      // On web, open the PDF directly
      _openPdfFile();
      return;
    }
    
    setState(() {
      if (_isPlaying) {
        _pause();
      } else {
        _play();
      }
    });
  }

  void _play() {
    if (kIsWeb) {
      _openPdfFile();
      return;
    }
    
    if (!_isInitialized) {
      print('Cannot play: TTS is not initialized');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le service de lecture audio n\'est pas disponible')),
        );
      }
      return;
    }
    
    if (!_isContentExtracted) {
      print('Cannot play: No text content available');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de lire le contenu audio de ce livre')),
        );
      }
      return;
    }
    
    setState(() {
      _isPlaying = true;
    });
    
    print('[AudioBookReader] Starting TTS playback with content length: ${_actualBookContent.length}');
    
    _ttsService.speakWithProgress(
      _actualBookContent, 
      (word) {
        if (mounted) {
          setState(() {
            _currentWord = word;
          });
        }
      },
      (start, end) {
        if (mounted) {
          setState(() {
            if (_actualBookContent.isNotEmpty) {
              _progress = (end / _actualBookContent.length).clamp(0.0, 1.0);
              _currentPosition = end;
            }
          });
          
          if (_sentences.isNotEmpty && _actualBookContent.isNotEmpty) {
            final estimatedIndex = (end / _actualBookContent.length * _sentences.length).toInt();
            final safeIndex = estimatedIndex.clamp(0, _sentences.length - 1);
            
            setState(() {
              _currentSentenceIndex = safeIndex;
            });
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent + 
                  (_scrollController.position.maxScrollExtent - _scrollController.position.minScrollExtent) * 
                  (_currentSentenceIndex / _sentences.length),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          }
        }
      },
    ).then((_) {
      // La lecture est terminée
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }).catchError((error) {
      print('[AudioBookReader] Error during TTS playback: $error');
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la lecture: $error')),
        );
      }
    });
    
    setState(() {
      _isPlaying = true;
    });
  }

  void _stop() {
    if (kIsWeb) {
      return;
    }
    
    _ttsService.stop();
    setState(() {
      _isPlaying = false;
      _currentWord = '';
      _progress = 0.0;
      _currentSentenceIndex = 0;
    });
  }

  void _pause() {
    if (kIsWeb) {
      return;
    }
    
    _ttsService.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  // Open PDF file directly
  void _openPdfFile() {
    if (_bookFilePath != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(
            filePath: _bookFilePath!,
            title: widget.bookTitle,
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir le livre')),
      );
    }
  }

  Future<void> _updateSpeechRate(double rate) async {
    if (kIsWeb) {
      return;
    }
    
    setState(() {
      _speechRate = rate;
    });
    await _ttsService.setSpeechRate(rate);
  }

  Future<void> _updateVolume(double volume) async {
    if (kIsWeb) {
      return;
    }
    
    setState(() {
      _volume = volume;
    });
    await _ttsService.setVolume(volume);
  }

  Future<void> _updatePitch(double pitch) async {
    if (kIsWeb) {
      return;
    }
    
    setState(() {
      _pitch = pitch;
    });
    await _ttsService.setPitch(pitch);
  }
  
  Future<void> _retryInitializeTTS() async {
    if (kIsWeb) {
      _openPdfFile();
      return;
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Réinitialisation du service audio...')),
      );
    }
    
    try {
      await _ttsService.reinitialize();
      await _initializeTTS();
      
      if (_isInitialized && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service audio réinitialisé avec succès')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de la réinitialisation du service audio')),
        );
      }
    } catch (e) {
      print('Error retrying TTS initialization: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la réinitialisation du service audio')),
        );
      }
    }
  }
  
  @override
  void dispose() {
    if (!kIsWeb) {
      _ttsService.stop();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              widget.bookTitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                _stop();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              // Play/Pause button in app bar
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: primaryColor,
                ),
            onPressed: (_isInitialized && _isContentExtracted) || kIsWeb ? _togglePlayPause : null,
          ),
          // Stop button in app bar (only on mobile)
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.stop, color: _colorGrey),
              onPressed: _isPlaying ? _stop : null,
            ),
          // Settings button in app bar (only on mobile)
          if (!kIsWeb && _isContentExtracted)
            IconButton(
              icon: const Icon(Icons.settings, color: _colorGrey),
              onPressed: () {
                _showSettingsDialog();
              },
            ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Progress indicator (only show on mobile)
            if (_isInitialized && !kIsWeb)
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[300],
                color: primaryColor,
                minHeight: 4,
              ),
            
            // Current word highlight (only show on mobile)
            if (_currentWord.isNotEmpty && !kIsWeb)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                color: primaryColor.withOpacity(0.1),
                child: Text(
                  _currentWord,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            
            // Main content area
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Loading indicator
                    if (_isLoadingContent)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _loadingMessage,
                              style: const TextStyle(
                                fontSize: 16,
                                color: _colorGrey,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (kIsWeb)
                      // On web, show book info and PDF opening option
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _colorBlack,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Icon(
                              Icons.picture_as_pdf,
                              size: 64,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Lecture audio non disponible sur le web',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _colorBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Cliquez sur le bouton de lecture pour ouvrir le livre PDF.',
                              style: TextStyle(
                                fontSize: 14,
                                color: _colorGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      // Book content with sentence highlighting (mobile)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _colorBlack,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_isContentExtracted)
                              ..._sentences.asMap().entries.map((entry) {
                                final index = entry.key;
                                final sentence = entry.value;
                                final isCurrent = index == _currentSentenceIndex;
                                
                                return Container(
                                  key: ValueKey('sentence_$index'),
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  padding: EdgeInsets.all(isCurrent ? 8.0 : 0),
                                  decoration: BoxDecoration(
                                    color: isCurrent ? primaryColor.withOpacity(0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    sentence,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isCurrent ? primaryColor : _colorGrey,
                                      height: 1.6,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList()
                            else
                              // Show message when text extraction failed
                              Column(
                                children: [
                                  const Icon(
                                    Icons.warning,
                                    size: 48,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Impossible d\'extraire le texte',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _colorBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Le contenu audio n\'est pas disponible pour ce livre.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _colorGrey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _openPdfFile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Ouvrir le PDF'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    
                    // Playback controls
                    if (!kIsWeb && !_isLoadingContent)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Play/Pause button
                            Center(
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  onPressed: (_isInitialized && _isContentExtracted) ? _togglePlayPause : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Progress indicator (simplified)
                            LinearProgressIndicator(
                              value: _progress,
                              backgroundColor: Colors.grey[300],
                              color: primaryColor,
                              minHeight: 4,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('0:00', style: TextStyle(fontSize: 12, color: _colorGrey)),
                                Text('5:30', style: TextStyle(fontSize: 12, color: _colorGrey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    
                    // Web-specific message
                    if (kIsWeb && !_isLoadingContent)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info,
                              size: 48,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Lecture audio non disponible sur le web',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _colorBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Cliquez sur le bouton de lecture dans la barre d\'outils pour ouvrir le livre PDF.',
                              style: TextStyle(
                                fontSize: 14,
                                color: _colorGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    
                    // Retry TTS initialization button (only shown when TTS is not initialized and not on web)
                    if (!_isInitialized && !kIsWeb && !_isLoadingContent && _isContentExtracted)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: _retryInitializeTTS,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Réessayer l\'initialisation audio',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }
  
  void _showSettingsDialog() {
    if (kIsWeb) {
      return;
    }
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<Color>(
          valueListenable: _themeService.primaryColorNotifier,
          builder: (context, primaryColor, child) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paramètres audio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _colorBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSettingSlider(
                    label: 'Vitesse',
                    value: _speechRate,
                    min: 0.1,
                    max: 1.0,
                    onChanged: _updateSpeechRate,
                    primaryColor: primaryColor,
                  ),
                  
                  _buildSettingSlider(
                    label: 'Volume',
                    value: _volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: _updateVolume,
                    primaryColor: primaryColor,
                  ),
                  
                  _buildSettingSlider(
                    label: 'Tonalité',
                    value: _pitch,
                    min: 0.5,
                    max: 2.0,
                    onChanged: _updatePitch,
                    primaryColor: primaryColor,
                  ),
                  
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Fermer'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildSettingSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: _colorBlack,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                fontSize: 14,
                color: _colorGrey,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: primaryColor,
          inactiveColor: Colors.grey[300],
          onChanged: onChanged,
        ),
      ],
    );
  }
}