import 'package:flutter/material.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/screens/principales/bibliotheque/lectureLivre.dart';
import 'package:edugo/models/livre_models.dart'; // Import des modèles

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final LivreService _livreService = LivreService();
  final AuthService _authService = AuthService();

  List<dynamic> _livres = []; // Garder dynamic pour compatibilité
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLivres();
  }

  Future<void> _loadLivres() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Utiliser la méthode avec fallback
      final livres = await _livreService.getAllLivresWithFallback();
      setState(() {
        _livres = livres;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur de chargement: $e');
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  // Méthode pour obtenir le titre d'un livre (gère les deux formats)
  String _getLivreTitre(dynamic livre) {
    if (livre is LivreResponse) {
      return livre.titre;
    } else if (livre is Map<String, dynamic>) {
      return livre['titre']?.toString() ?? 'Titre inconnu';
    }
    return 'Titre inconnu';
  }

  // Méthode pour obtenir l'auteur d'un livre (gère les deux formats)
  String _getLivreAuteur(dynamic livre) {
    if (livre is LivreResponse) {
      return livre.auteur;
    } else if (livre is Map<String, dynamic>) {
      return livre['auteur']?.toString() ?? 'Auteur inconnu';
    }
    return 'Auteur inconnu';
  }

  // Méthode pour obtenir le nombre de pages (gère les deux formats)
  int _getLivreNombrePages(dynamic livre) {
    if (livre is LivreResponse) {
      return livre.totalPages ?? 100;
    } else if (livre is Map<String, dynamic>) {
      return (livre['totalPages'] as int?) ??
             (livre['nombrePages'] as int?) ??
             100;
    }
    return 100;
  }

  // Méthode pour obtenir l'ID (gère les deux formats)
  int _getLivreId(dynamic livre) {
    if (livre is LivreResponse) {
      return livre.id;
    } else if (livre is Map<String, dynamic>) {
      return (livre['id'] as int?) ?? 0;
    }
    return 0;
  }

  List<dynamic> get _filteredLivres {
    if (_searchQuery.isEmpty) return _livres;
    return _livres.where((livre) {
      final titre = _getLivreTitre(livre).toLowerCase();
      final auteur = _getLivreAuteur(livre).toLowerCase();
      return titre.contains(_searchQuery.toLowerCase()) ||
             auteur.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _onLivreTap(dynamic livre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookReaderScreen(
          livreId: _getLivreId(livre),
          bookTitle: _getLivreTitre(livre),
          totalPages: _getLivreNombrePages(livre),
        ),
      ),
    );
  }

  Widget _buildLivreCard(dynamic livre, bool isSmallScreen) {
    final titre = _getLivreTitre(livre);
    final auteur = _getLivreAuteur(livre);
    final nombrePages = _getLivreNombrePages(livre);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onLivreTap(livre),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            minHeight: isSmallScreen ? 100 : 120,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Couverture du livre
              Container(
                width: isSmallScreen ? 60 : 80,
                height: isSmallScreen ? 80 : 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFA885D8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.book_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          auteur,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.pages, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '$nombrePages pages',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un livre...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
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
              onPressed: _loadLivres,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA885D8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA885D8)),
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des livres...',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'Aucun livre disponible'
                  : 'Aucun livre trouvé pour "$_searchQuery"',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[700],
                ),
                child: const Text('Effacer la recherche'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLivresList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _filteredLivres.length,
      itemBuilder: (context, index) {
        final livre = _filteredLivres[index];
        return _buildLivreCard(livre, MediaQuery.of(context).size.width < 600);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Bibliothèque',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? _buildLoadingWidget()
                : _errorMessage.isNotEmpty
                    ? _buildErrorWidget()
                    : _filteredLivres.isEmpty
                        ? _buildEmptyWidget()
                        : _buildLivresList(),
          ),
        ],
      ),
    );
  }
}