import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/screens/principales/bibliotheque/quizLivre.dart';

class BookReaderScreen extends StatefulWidget {
  final int livreId;
  final String bookTitle;
  final int totalPages;

  const BookReaderScreen({
    super.key,
    required this.livreId,
    required this.bookTitle,
    required this.totalPages,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final LivreService _livreService = LivreService();
  final AuthService _authService = AuthService();

  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _showCompletionOverlay = false;
  bool _isPlayingAudio = false;
  String _errorMessage = '';
  String _pdfUrl = '';

  // Constantes de couleurs et styles
  static const Color _purpleMain = Color(0xFFA885D8);
  static const Color _colorBlack = Color(0xFF000000);
  static const String _fontFamily = 'Roboto';

  @override
  void initState() {
    super.initState();
    _initializeReader();
  }

  Future<void> _initializeReader() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Vérifier si un élève est connecté
      if (!_livreService.isEleveConnected()) {
        throw Exception('Veuillez vous connecter pour lire ce livre');
      }

      // Charger l'URL du PDF
      _pdfUrl = await _livreService.getDocumentPdfUrl(widget.livreId);

      setState(() {
        _isLoading = false;
      });

      // Charger la progression existante
      await _loadProgression();

    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProgression() async {
    try {
      final progression = await _livreService.getProgressionForCurrentUser(widget.livreId);
      if (progression != null && progression.pageActuelle != null) {
        print('Progression chargée: page ${progression.pageActuelle}');
        // Avec WebView, on ne peut pas facilement sauter à une page spécifique
        // On affiche simplement un message
      }
    } catch (e) {
      print('Erreur lors du chargement de la progression: $e');
    }
  }

  Future<void> _saveProgression() async {
    try {
      // Avec WebView, on sauvegarde la progression quand l'utilisateur quitte
      // ou on utilise une valeur par défaut
      final currentPage = 1; // À adapter selon votre logique

      await _livreService.updateProgressionForCurrentUser(
        widget.livreId,
        currentPage
      );
    } catch (e) {
      print('Erreur lors de la sauvegarde de la progression: $e');
    }
  }

  void _toggleAudio() {
    setState(() {
      _isPlayingAudio = !_isPlayingAudio;
    });
    // Intégration de la lecture audio si nécessaire
  }

  void _markAsCompleted() {
    setState(() {
      _showCompletionOverlay = true;
    });
    // Sauvegarder comme terminé
    _livreService.updateProgressionForCurrentUser(widget.livreId, widget.totalPages);
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
        builder: (context) => BookQuizScreen(
          quizTitle: '${widget.bookTitle} Quiz',
        ),
      ),
    );
  }

  Widget _buildCompletionOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
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

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 20.0 : 25.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: isSmallScreen
                ? MediaQuery.of(context).size.width * 0.9
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
                        "Vous venez de terminer '${widget.bookTitle}'",
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
                            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
                            onTap: _navigateToQuiz,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "COMMENCER LE QUIZ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: _fontFamily,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 8 : 10),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: isSmallScreen ? 16 : 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Bouton secondaire pour fermer
                      SizedBox(height: isSmallScreen ? 12 : 15),
                      TextButton(
                        onPressed: _closeCompletionOverlay,
                        child: Text(
                          "Plus tard",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isSmallScreen ? 13 : 14,
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

  Widget _buildCustomAppBar(BuildContext context, bool isSmallScreen) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.0,
          left: isSmallScreen ? 8 : 10,
          right: isSmallScreen ? 16 : 20
        ),
        child: Column(
          children: [
            SizedBox(height: isSmallScreen ? 15 : 20),

            // Titre de la page et Icône de Lecture
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: _colorBlack,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  onPressed: () {
                    _saveProgression();
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.bookTitle,
                      style: TextStyle(
                        color: _colorBlack,
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isPlayingAudio ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    color: _purpleMain,
                    size: isSmallScreen ? 26 : 30,
                  ),
                  onPressed: _toggleAudio,
                ),
                // Bouton pour marquer comme terminé
                IconButton(
                  icon: Icon(
                    Icons.done_all,
                    color: _purpleMain,
                    size: isSmallScreen ? 24 : 28,
                  ),
                  onPressed: _markAsCompleted,
                  tooltip: 'Marquer comme terminé',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  _buildCustomAppBar(context, isSmallScreen),

                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _errorMessage.isNotEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Colors.red[300],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _errorMessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _initializeReader,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFA885D8),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Réessayer'),
                                    ),
                                  ],
                                ),
                              )
                            : WebView(
                                initialUrl: _pdfUrl,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: (WebViewController webViewController) {
                                  _webViewController = webViewController;
                                },
                                onPageStarted: (String url) {
                                  print('Chargement du PDF démarré: $url');
                                },
                                onPageFinished: (String url) {
                                  print('Chargement du PDF terminé: $url');
                                },
                                gestureNavigationEnabled: true,
                                allowsInlineMediaPlayback: true,
                              ),
                  ),
                ],
              ),

              if (_showCompletionOverlay) _buildCompletionOverlay(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _saveProgression(); // Sauvegarder la progression à la fermeture
    super.dispose();
  }
}