import 'package:flutter/material.dart';
import 'package:edugo/services/text_to_speech_service.dart';
import 'package:edugo/screens/main/bibliotheque/lecture_audio.dart';

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8);
const Color _colorBlack = Color(0xFF000000);
const String _fontFamily = 'Roboto';

class BookReaderScreen extends StatefulWidget {
  final String bookTitle;
  final int? livreId;
  final int? eleveId;
  final List<dynamic> fichiers;

  const BookReaderScreen({
    super.key,
    required this.bookTitle,
    this.livreId,
    this.eleveId,
    required this.fichiers,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final TextToSpeechService _ttsService = TextToSpeechService();
  bool _isTTSEnabled = false;
  bool _isTTSPlaying = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // TTS is initialized automatically in the service constructor
    // Just check if it's ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isTTSEnabled = _ttsService.isReady;
        });
        
        // Automatically start TTS when the screen loads if TTS is enabled
        if (_isTTSEnabled) {
          _startTTS();
        }
      }
    });
  }

  void _toggleTTS() {
    setState(() {
      if (_isTTSPlaying) {
        _stopTTS();
      } else {
        _startTTS();
      }
    });
  }

  void _startTTS() {
    // Actually start the text-to-speech functionality
    // In a real implementation, this would read the actual book content
    _ttsService.speak('Contenu du livre ${widget.bookTitle} à lire à haute voix. Ceci est une démonstration de la fonctionnalité de lecture automatique.');
    setState(() {
      _isTTSPlaying = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lecture audio démarrée')),
    );
  }

  void _stopTTS() {
    // Implement actual text-to-speech stop functionality
    _ttsService.stop();
    setState(() {
      _isTTSPlaying = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lecture audio arrêtée')),
    );
  }

  @override
  void dispose() {
    // Stop TTS when the screen is disposed
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
        elevation: 0,
        title: Text(
          widget.bookTitle,
          style: TextStyle(
            color: _isDarkMode ? Colors.white : _colorBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _isDarkMode ? Colors.white : _colorBlack,
          ),
          onPressed: () {
            // Stop TTS before navigating back
            if (_isTTSEnabled && _ttsService.isReady) {
              _stopTTS();
            }
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // Add audio reader button to app bar
          if (_isTTSEnabled)
            IconButton(
              icon: Icon(
                Icons.headphones,
                color: _isDarkMode ? Colors.white : _purpleMain,
              ),
              onPressed: () {
                // Navigate to dedicated audio reader screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioBookReaderScreen(
                      bookTitle: widget.bookTitle,
                      bookContent: 'Contenu du livre ${widget.bookTitle}. Ceci est une démonstration de la fonctionnalité de lecture automatique. Dans une application réelle, ce serait le contenu complet du livre.',
                      livreId: widget.livreId,
                      eleveId: widget.eleveId,
                    ),
                  ),
                );
              },
              tooltip: 'Lecture audio',
            ),
          // Add quiz button to app bar
          IconButton(
            icon: Icon(
              Icons.quiz,
              color: _isDarkMode ? Colors.white : _purpleMain,
            ),
            onPressed: () {
              // Navigate to the actual quiz for this book using the real API
              if (widget.livreId != null) {
                // Stop TTS before navigating to quiz
                if (_isTTSPlaying) {
                  _stopTTS();
                }
                
                // TODO: Implement navigation to quiz screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigation vers le quiz du livre')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aucun quiz disponible pour ce livre')),
                );
              }
            },
            tooltip: 'Faire le quiz',
          ),
          // Settings button
          PopupMenuButton<String>(
            icon: Icon(
              Icons.settings,
              color: _isDarkMode ? Colors.white : _colorBlack,
            ),
            onSelected: (String result) {
              setState(() {
                if (result == 'dark_mode') {
                  _isDarkMode = !_isDarkMode;
                }
              });
              
              // Handle audio reader navigation
              if (result == 'audio_reader') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioBookReaderScreen(
                      bookTitle: widget.bookTitle,
                      bookContent: 'Contenu du livre ${widget.bookTitle}. Ceci est une démonstration de la fonctionnalité de lecture automatique. Dans une application réelle, ce serait le contenu complet du livre.',
                      livreId: widget.livreId,
                      eleveId: widget.eleveId,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'dark_mode',
                child: Text('Mode sombre'),
              ),
              if (_isTTSEnabled)
                const PopupMenuItem<String>(
                  value: 'tts_settings',
                  child: Text('Paramètres audio'),
                ),
              if (_isTTSEnabled)
                const PopupMenuItem<String>(
                  value: 'audio_reader',
                  child: Text('Lecteur audio complet'),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        color: _isDarkMode ? Colors.grey[900] : Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book,
                size: 100,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(height: 20),
              Text(
                'Lecteur de livre',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : _colorBlack,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.bookTitle,
                style: TextStyle(
                  fontSize: 18,
                  color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (_isTTSEnabled)
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to dedicated audio reader screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioBookReaderScreen(
                          bookTitle: widget.bookTitle,
                          bookContent: 'Contenu du livre ${widget.bookTitle}. Ceci est une démonstration de la fonctionnalité de lecture automatique. Dans une application réelle, ce serait le contenu complet du livre.',
                          livreId: widget.livreId,
                          eleveId: widget.eleveId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.headphones),
                  label: const Text('Lecture audio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purpleMain,
                    foregroundColor: Colors.white,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Contenu du livre à afficher ici',
                style: TextStyle(
                  fontSize: 16,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}