import 'package:flutter/material.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/livre_models.dart';
import 'package:edugo/screens/principales/bibliotheque/lectureLivre.dart';
import 'package:cached_network_image/cached_network_image.dart';

class  LibraryScreen extends StatefulWidget {
  const  LibraryScreen({super.key});

  @override
  State< LibraryScreen> createState() => _ LibraryScreenState();
}

class _ LibraryScreenState extends State< LibraryScreen> {
  final LivreService _livreService = LivreService();
  final AuthService _authService = AuthService();

  List<LivreResponse> _livres = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _userName = '';
  int? _currentEleveId; // ✅ AJOUT: Stocker l'ID pour le debug

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadLivres();
  }

  void _loadUserData() {
    final eleve = _authService.currentEleve;
    if (eleve != null) {
      setState(() {
        _userName = '${eleve.prenom} ${eleve.nom}';
        _currentEleveId = eleve.id; // ✅ AJOUT: Stocker l'ID
      });
      print('✅ Élève connecté: $_userName (ID: $_currentEleveId)'); // ✅ AJOUT: Debug
    } else {
      print('❌ Aucun élève connecté dans AuthService'); // ✅ AJOUT: Debug
    }
  }

  Future<void> _loadLivres() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // ✅ AMÉLIORATION: Vérification plus robuste
      final eleveId = _livreService.getCurrentEleveId();
      if (eleveId == null) {
        throw Exception('Veuillez vous connecter pour accéder à la bibliothèque');
      }

      print('🔄 Chargement des livres pour l\'élève ID: $eleveId'); // ✅ AJOUT: Debug

      List<LivreResponse> livres;
      try {
        // Essayer de récupérer les livres disponibles pour l'élève connecté
        livres = await _livreService.getLivresDisponiblesForCurrentUser();
        print('✅ ${livres.length} livres chargés avec succès'); // ✅ AJOUT: Debug
      } catch (e) {
        // Fallback: récupérer tous les livres
        print('⚠️ Fallback: chargement de tous les livres - $e');
        livres = await _livreService.getAllLivres();
        print('✅ ${livres.length} livres chargés (fallback)'); // ✅ AJOUT: Debug
      }

      setState(() {
        _livres = livres;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement: $e'); // ✅ AJOUT: Debug
      setState(() {
        _errorMessage = 'Erreur lors du chargement des livres: $e';
        _isLoading = false;
      });
    }
  }

  void _onLivreTap(LivreResponse livre) {
    if (!_livreService.isEleveConnected()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez vous connecter pour lire ce livre'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookReaderScreen(
          livreId: livre.id,
          bookTitle: livre.titre,
          totalPages: livre.totalPages ?? 1,
        ),
      ),
    );
  }

  Widget _buildLivreCard(LivreResponse livre) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _onLivreTap(livre),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ AMÉLIORATION: Image avec caching
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: livre.imageCouverture != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: livre.imageCouverture!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.book, size: 30, color: Colors.grey[400]),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.book, size: 40, color: Colors.grey[400]),
                      ),
              ),
              const SizedBox(width: 16),
              // Informations du livre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livre.titre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Par ${livre.auteur}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Roboto',
                      ),
                    ),
                    if (livre.totalPages != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${livre.totalPages} pages',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                    // ✅ AJOUT: Indicateur de disponibilité
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'Disponible',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    if (_userName.isEmpty) {
      // ✅ AMÉLIORATION: Meilleur message quand non connecté
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Non connecté',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange[800],
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    'Connectez-vous pour accéder à tous les livres',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[600],
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFA885D8).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA885D8).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: const Color(0xFFA885D8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connecté en tant que:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
                // ✅ AJOUT: Affichage de l'ID pour debug
                if (_currentEleveId != null)
                  Text(
                    'ID: $_currentEleveId',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                      fontFamily: 'Roboto',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          // ✅ AMÉLIORATION: Toujours afficher le bouton refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLivres,
            tooltip: 'Actualiser la bibliothèque',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Chargement de votre bibliothèque...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            )
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
                        onPressed: _loadLivres,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA885D8),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Réessayer'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          // Option: Rediriger vers la page de connexion
                        },
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildUserInfo(),
                    // ✅ AJOUT: Compteur de livres
                    if (_livres.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              '${_livres.length} livre${_livres.length > 1 ? 's' : ''} disponible${_livres.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: _livres.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.book, size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'Aucun livre disponible',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Revenez plus tard ou contactez votre administrateur',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'Roboto',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadLivres,
                              color: const Color(0xFFA885D8),
                              child: ListView.builder(
                                itemCount: _livres.length,
                                itemBuilder: (context, index) {
                                  return _buildLivreCard(_livres[index]);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}