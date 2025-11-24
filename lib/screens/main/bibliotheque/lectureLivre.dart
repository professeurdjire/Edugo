// import 'package:flutter/material.dart';
// import 'package:edugo/services/text_to_speech_service.dart';
// import 'package:edugo/screens/main/bibliotheque/lecture_audio.dart';

// // --- CONSTANTES DE COULEURS ET STYLES ---
// const Color _purpleMain = Color(0xFFA885D8);
// const Color _colorBlack = Color(0xFF000000);
// const String _fontFamily = 'Roboto';

// class BookReaderScreen extends StatefulWidget {
//   final String bookTitle;
//   final int? livreId;
//   final int? eleveId;
//   final List<dynamic> fichiers;

//   const BookReaderScreen({
//     super.key,
//     required this.bookTitle,
//     this.livreId,
//     this.eleveId,
//     required this.fichiers,
//   });

//   @override
//   State<BookReaderScreen> createState() => _BookReaderScreenState();
// }

// class _BookReaderScreenState extends State<BookReaderScreen> {
//   final TextToSpeechService _ttsService = TextToSpeechService();
//   bool _isTTSEnabled = false;
//   bool _isTTSPlaying = false;
//   bool _isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();
//     // TTS is initialized automatically in the service constructor
//     // Just check if it's ready
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//           _isTTSEnabled = _ttsService.isReady;
//         });
        
//         // Automatically start TTS when the screen loads if TTS is enabled
//         if (_isTTSEnabled) {
//           _startTTS();
//         }
//       }
//     });
//   }

//   void _toggleTTS() {
//     setState(() {
//       if (_isTTSPlaying) {
//         _stopTTS();
//       } else {
//         _startTTS();
//       }
//     });
//   }

//   void _startTTS() {
//     // Actually start the text-to-speech functionality
//     // In a real implementation, this would read the actual book content
//     _ttsService.speak('Contenu du livre ${widget.bookTitle} à lire à haute voix. Ceci est une démonstration de la fonctionnalité de lecture automatique.');
//     setState(() {
//       _isTTSPlaying = true;
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Lecture audio démarrée')),
//     );
//   }

//   void _stopTTS() {
//     // Implement actual text-to-speech stop functionality
//     _ttsService.stop();
//     setState(() {
//       _isTTSPlaying = false;
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Lecture audio arrêtée')),
//     );
//   }

//   @override
//   void dispose() {
//     // Stop TTS when the screen is disposed
//     _ttsService.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
//         elevation: 0,
//         title: Text(
//           widget.bookTitle,
//           style: TextStyle(
//             color: _isDarkMode ? Colors.white : _colorBlack,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: _isDarkMode ? Colors.white : _colorBlack,
//           ),
//           onPressed: () {
//             // Stop TTS before navigating back
//             if (_isTTSEnabled && _ttsService.isReady) {
//               _stopTTS();
//             }
//             Navigator.of(context).pop();
//           },
//         ),
//         actions: [
//           // Add audio reader button to app bar
//           if (_isTTSEnabled)
//             IconButton(
//               icon: Icon(
//                 Icons.headphones,
//                 color: _isDarkMode ? Colors.white : _purpleMain,
//               ),
//               onPressed: () {
//                 // Navigate to dedicated audio reader screen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AudioBookReaderScreen(
//                       bookTitle: widget.bookTitle,
//                       bookContent: 'Contenu du livre ${widget.bookTitle}. Ceci est une démonstration de la fonctionnalité de lecture automatique. Dans une application réelle, ce serait le contenu complet du livre.',
//                       livreId: widget.livreId,
//                       eleveId: widget.eleveId,
//                     ),
//                   ),
//                 );
//               },
//               tooltip: 'Lecture audio',
//             ),
//           // Add quiz button to app bar
//           IconButton(
//             icon: Icon(
//               Icons.quiz,
//               color: _isDarkMode ? Colors.white : _purpleMain,
//             ),
//             onPressed: () {
//               // Navigate to the actual quiz for this book using the real API
//               if (widget.livreId != null) {
//                 // Stop TTS before navigating to quiz
//                 if (_isTTSPlaying) {
//                   _stopTTS();
//                 }
                
//                 // TODO: Implement navigation to quiz screen
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Navigation vers le quiz du livre')),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Aucun quiz disponible pour ce livre')),
//                 );
//               }
//             },
//             tooltip: 'Faire le quiz',
//           ),
//           // Settings button
//           PopupMenuButton<String>(
//             icon: Icon(
//               Icons.settings,
//               color: _isDarkMode ? Colors.white : _colorBlack,
//             ),
//             onSelected: (String result) {
//               setState(() {
//                 if (result == 'dark_mode') {
//                   _isDarkMode = !_isDarkMode;
//                 }
//               });
              
//               // Handle audio reader navigation
//               if (result == 'audio_reader') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AudioBookReaderScreen(
//                       bookTitle: widget.bookTitle,
//                       bookContent: 'Contenu du livre ${widget.bookTitle}. Ceci est une démonstration de la fonctionnalité de lecture automatique. Dans une application réelle, ce serait le contenu complet du livre.',
//                       livreId: widget.livreId,
//                       eleveId: widget.eleveId,
//                     ),
//                   ),
//                 );
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'dark_mode',
//                 child: Text('Mode sombre'),
//               ),
//               if (_isTTSEnabled)
//                 const PopupMenuItem<String>(
//                   value: 'tts_settings',
//                   child: Text('Paramètres audio'),
//                 ),
//               if (_isTTSEnabled)
//                 const PopupMenuItem<String>(
//                   value: 'audio_reader',
//                   child: Text('Lecteur audio complet'),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: Container(
//         color: _isDarkMode ? Colors.grey[900] : Colors.white,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.menu_book,
//                 size: 100,
//                 color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Lecteur de livre',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: _isDarkMode ? Colors.white : _colorBlack,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 widget.bookTitle,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               if (_isTTSEnabled)
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Navigate to dedicated audio reader screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AudioBookReaderScreen(
//                           bookTitle: widget.bookTitle,
//                           bookContent: 'Contenu du livre ${widget.bookTitle}. Ceci est une démonstration de la fonctionnalité de lecture automatique. Dans une application réelle, ce serait le contenu complet du livre.',
//                           livreId: widget.livreId,
//                           eleveId: widget.eleveId,
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.headphones),
//                   label: const Text('Lecture audio'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _purpleMain,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               Text(
//                 'Contenu du livre à afficher ici',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:edugo/services/text_to_speech_service.dart';
import 'package:edugo/services/book_file_service.dart';
import 'package:edugo/services/pdf_extractor_service.dart';
import 'package:edugo/services/quiz_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/screens/main/quiz/take_quiz_screen.dart';

class BookReaderScreen extends StatefulWidget {
  final String bookTitle;
  final List<FichierLivre> fichiers;
  final int? livreId;
  final int? eleveId;

  const BookReaderScreen({
    super.key,
    required this.bookTitle,
    required this.fichiers,
    this.livreId,
    this.eleveId,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final TextToSpeechService _ttsService = TextToSpeechService();
  final BookFileService _fileService = BookFileService();
  final QuizService _quizService = QuizService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _extractedText = '';
  bool _isPlaying = false;
  bool _hasQuiz = false;
  int? _quizId;

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
    _checkQuizAvailability();
  }
  
  Future<void> _checkQuizAvailability() async {
    final eleveId = widget.eleveId ?? _authService.currentUserId;
    if (eleveId == null || widget.livreId == null) return;
    
    try {
      final quizzes = await _quizService.getQuizzesForEleve(eleveId);
      if (quizzes != null) {
        final bookQuizzes = quizzes.where((quiz) => quiz.livre?.id == widget.livreId).toList();
        if (bookQuizzes.isNotEmpty) {
          setState(() {
            _hasQuiz = true;
            _quizId = bookQuizzes.first.id;
          });
        }
      }
    } catch (e) {
      print('Error checking quiz availability: $e');
    }
  }
  
  void _navigateToQuiz() async {
    final eleveId = widget.eleveId ?? _authService.currentUserId;
    if (eleveId == null || _quizId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun quiz disponible pour ce livre')),
      );
      return;
    }
    
    // Stop TTS before navigating
    if (_isPlaying) {
      _ttsService.stop();
      setState(() => _isPlaying = false);
    }
    
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

  Future<void> _downloadAndExtract(FichierLivre fichier) async {
    setState(() => _isLoading = true);
    try {
      String? localPath = await _fileService.getDownloadedBookPath(fichier);
      if (localPath == null) {
        localPath = await _fileService.downloadBookFile(fichier);
      }

      if (localPath != null) {
        if ((fichier.format ?? '').toLowerCase() == 'pdf') {
          final text = await PdfExtractorService.extractTextFromFile(localPath);
          setState(() => _extractedText = text);
        } else {
          setState(() => _extractedText = '');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Impossible de récupérer le fichier')));
      }
    } catch (e) {
      print('[BookReader] Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erreur lors du téléchargement')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _togglePlay() {
    if (_isPlaying) {
      _ttsService.stop();
      setState(() => _isPlaying = false);
    } else {
      if (_extractedText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Aucun texte à lire. Téléchargez d\'abord le fichier.')));
        return;
      }
      _ttsService.speak(_extractedText);
      setState(() => _isPlaying = true);
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fichierPdf = widget.fichiers.isNotEmpty
        ? widget.fichiers.firstWhere(
            (f) => (f.format ?? '').toLowerCase() == 'pdf',
            orElse: () => widget.fichiers.first)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookTitle),
        actions: [
          if (_hasQuiz)
            IconButton(
              icon: const Icon(Icons.quiz),
              onPressed: _navigateToQuiz,
              tooltip: 'Passer le quiz',
            ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (fichierPdf != null)
                    ElevatedButton(
                      onPressed: () => _downloadAndExtract(fichierPdf),
                      child: const Text('Télécharger & Préparer la lecture'),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _togglePlay,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(_isPlaying ? 'Pause' : 'Lire'),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _extractedText.isEmpty
                            ? 'Aucun texte extrait'
                            : _extractedText,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

