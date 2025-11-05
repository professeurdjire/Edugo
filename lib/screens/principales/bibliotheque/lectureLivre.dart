import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/bibliotheque/quizLivre.dart'; // Import de la page quiz

// --- CONSTANTES DE COULEURS ET STYLES ---
const Color _purpleMain = Color(0xFFA885D8); // Violet principal (couleur des icônes)
const Color _colorBlack = Color(0xFF000000); // Texte noir
const Color _readColor = Color(0xFFA885D8); // Couleur du texte lu (violet)
const String _fontFamily = 'Roboto'; // Police principale

class BookReaderScreen extends StatefulWidget {
  final String bookTitle;

  const BookReaderScreen({super.key, this.bookTitle = "Le jardin Invisible"});

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

  // Pour chaque page, on stocke les mots et leur état (lu/non lu)
  late List<List<Word>> _pageWords;

  @override
  void initState() {
    super.initState();

    // Initialiser les mots pour chaque page
    _pageWords = _bookPages.map((page) {
      return _splitTextIntoWords(page).map((word) => Word(text: word, isRead: false)).toList();
    }).toList();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Vitesse de lecture automatique
    );
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

  // Widget pour afficher le texte avec coloration
  Widget _buildColoredText(int pageIndex, bool isSmallScreen) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: _pageWords[pageIndex].map((word) {
              return TextSpan(
                text: word.text,
                style: TextStyle(
                  color: word.isRead ? _readColor : _colorBlack,
                  fontSize: isSmallScreen ? 14 : 15,
                  height: isSmallScreen ? 1.5 : 1.6,
                  fontFamily: _fontFamily,
                  fontWeight: word.isRead ? FontWeight.w500 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          textAlign: TextAlign.justify,
        ),

        // Bouton pour marquer la page comme lue (seulement en lecture manuelle)
        if (!_isPlayingAudio && !_pageWords[pageIndex].every((word) => word.isRead)) ...[
          SizedBox(height: isSmallScreen ? 15 : 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _purpleMain,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12.0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 10 : 12
              ),
            ),
            onPressed: _markPageAsReadManually,
            child: Text(
              "Marquer cette page comme lue",
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                fontFamily: _fontFamily,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 600;
        final bool isLargeScreen = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Contenu principal de la lecture
              Column(
                children: [
                  // App Bar personnalisé (avec barre de statut et titre)
                  _buildCustomAppBar(context, isSmallScreen),

                  // Le corps de la page (PageView pour la pagination)
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _bookPages.length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                          _currentWordIndex = 0;
                          _showCompletionOverlay = false;
                        });
                      },
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16.0 : 20.0,
                            vertical: isSmallScreen ? 8.0 : 10.0
                          ),
                          child: _buildColoredText(index, isSmallScreen),
                        );
                      },
                    ),
                  ),

                  // Barre de pagination en bas
                  _buildPaginationBar(isSmallScreen),
                ],
              ),

              // Popup de fin de lecture (s'affiche en overlay par-dessus tout)
              if (_showCompletionOverlay) _buildCompletionOverlay(),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGETS DE STRUCTURE PRINCIPALE ---

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
                  onPressed: () => Navigator.pop(context),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationBar(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : 20.0,
        vertical: isSmallScreen ? 12.0 : 16.0
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton précédent
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: isSmallScreen ? 18 : 20
            ),
            onPressed: _currentPage > 0 ? _goToPreviousPage : null,
            color: _currentPage > 0 ? _purpleMain : Colors.grey,
          ),

          // Indicateur de pagination
          Text(
            "${_currentPage + 1}/${_bookPages.length}",
            style: TextStyle(
              color: _colorBlack,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              fontFamily: _fontFamily,
            ),
          ),

          // Bouton suivant
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen ? 18 : 20
            ),
            onPressed: _currentPage < _bookPages.length - 1 ? _goToNextPageManual : () {
              // Si on est sur la dernière page, vérifier si elle est lue
              bool currentPageRead = _pageWords[_currentPage].every((word) => word.isRead);
              if (currentPageRead) {
                setState(() {
                  _showCompletionOverlay = true;
                });
              } else {
                _markPageAsReadManually();
              }
            },
            color: _purpleMain,
          ),
        ],
      ),
    );
  }
}

// Classe pour représenter un mot avec son état de lecture
class Word {
  final String text;
  bool isRead;

  Word({required this.text, required this.isRead});
}