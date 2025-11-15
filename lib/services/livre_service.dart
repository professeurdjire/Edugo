import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/livre_models.dart';

class LivreService {
  static final LivreService _instance = LivreService._internal();
  factory LivreService() => _instance;

  late Dio _dio;

  LivreService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8089/api';
    _dio.options.contentType = 'application/json';

    // Utiliser le token d'authentification existant
    final authService = AuthService();
    final token = authService.dio.options.headers['Authorization'];
    if (token != null) {
      _dio.options.headers['Authorization'] = token;
    }
  }

  /// Récupérer l'ID de l'élève connecté depuis AuthService
  int? getCurrentEleveId() {
    return AuthService().currentEleve?.id;
  }

  /// Vérifier si un élève est connecté
  bool isEleveConnected() {
    return getCurrentEleveId() != null;
  }

  /// Récupérer les fichiers d'un livre
  Future<List<FichierLivreDto>> getFichiersLivre(int livreId) async {
    try {
      final response = await _dio.get('/livres/$livreId/fichiers');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => FichierLivreDto.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des fichiers');
    } catch (e) {
      print('Erreur getFichiersLivre: $e');
      throw e;
    }
  }

  /// Récupérer l'URL de téléchargement du document principal (PDF)
  Future<String> getDocumentPdfUrl(int livreId) async {
    try {
      final fichiers = await getFichiersLivre(livreId);

      if (fichiers.isEmpty) {
        throw Exception('Aucun fichier disponible pour ce livre');
      }

      // Chercher le document PDF
      final pdfFile = fichiers.firstWhere(
        (fichier) => fichier.format?.toLowerCase() == 'pdf',
        orElse: () => fichiers.first, // Fallback sur le premier fichier
      );

      return 'http://localhost:8089/api/livres/fichiers/${pdfFile.id}/download';
    } catch (e) {
      print('Erreur getDocumentPdfUrl: $e');
      throw e;
    }
  }

  /// Récupérer tous les livres
  Future<List<LivreResponse>> getAllLivres() async {
    try {
      final response = await _dio.get('/livres');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres');
    } catch (e) {
      print('Erreur getAllLivres: $e');
      throw e;
    }
  }

  /// Récupérer les livres disponibles pour un élève
  Future<List<LivreResponse>> getLivresDisponibles(int eleveId) async {
    try {
      final response = await _dio.get('/livres/disponibles/$eleveId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres disponibles');
    } catch (e) {
      print('Erreur getLivresDisponibles: $e');
      throw e;
    }
  }

  /// Récupérer les livres disponibles pour l'élève connecté
  Future<List<LivreResponse>> getLivresDisponiblesForCurrentUser() async {
    final eleveId = getCurrentEleveId();
    if (eleveId == null) {
      throw Exception('Aucun élève connecté');
    }
    return getLivresDisponibles(eleveId);
  }

  /// Récupérer les détails d'un livre
  Future<LivreDetailResponse> getLivreById(int livreId) async {
    try {
      final response = await _dio.get('/livres/$livreId');
      if (response.statusCode == 200) {
        return LivreDetailResponse.fromJson(response.data);
      }
      throw Exception('Erreur lors de la récupération du livre');
    } catch (e) {
      print('Erreur getLivreById: $e');
      throw e;
    }
  }

  /// Mettre à jour la progression de lecture
  Future<ProgressionResponse> updateProgressionLecture(
      int eleveId, int livreId, int pageActuelle) async {
    try {
      final response = await _dio.post(
        '/livres/progression/$eleveId/$livreId',
        data: {'pageActuelle': pageActuelle},
      );
      if (response.statusCode == 200) {
        return ProgressionResponse.fromJson(response.data);
      }
      throw Exception('Erreur lors de la mise à jour de la progression');
    } catch (e) {
      print('Erreur updateProgressionLecture: $e');
      throw e;
    }
  }

  /// Mettre à jour la progression pour l'élève connecté
  Future<ProgressionResponse> updateProgressionForCurrentUser(int livreId, int pageActuelle) async {
    final eleveId = getCurrentEleveId();
    if (eleveId == null) {
      throw Exception('Aucun élève connecté');
    }
    return updateProgressionLecture(eleveId, livreId, pageActuelle);
  }

  /// Récupérer la progression d'un livre spécifique
  Future<ProgressionResponse?> getProgressionLivre(int eleveId, int livreId) async {
    try {
      final response = await _dio.get('/livres/progression/$eleveId/$livreId');
      if (response.statusCode == 200) {
        return ProgressionResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Erreur getProgressionLivre: $e');
      return null;
    }
  }

  /// Récupérer la progression pour l'élève connecté
  Future<ProgressionResponse?> getProgressionForCurrentUser(int livreId) async {
    final eleveId = getCurrentEleveId();
    if (eleveId == null) {
      return null;
    }
    return getProgressionLivre(eleveId, livreId);
  }

  /// Récupérer la progression de lecture d'un élève
  Future<List<ProgressionResponse>> getProgressionLecture(int eleveId) async {
    try {
      final response = await _dio.get('/livres/progression/$eleveId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ProgressionResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération de la progression');
    } catch (e) {
      print('Erreur getProgressionLecture: $e');
      throw e;
    }
  }

  /// Récupérer la progression de lecture pour l'élève connecté
  Future<List<ProgressionResponse>> getProgressionLectureForCurrentUser() async {
    final eleveId = getCurrentEleveId();
    if (eleveId == null) {
      throw Exception('Aucun élève connecté');
    }
    return getProgressionLecture(eleveId);
  }

  /// Récupérer les statistiques d'un livre
  Future<StatistiquesLivreResponse> getStatistiquesLivre(int livreId) async {
    try {
      final response = await _dio.get('/livres/statistiques/$livreId');
      if (response.statusCode == 200) {
        return StatistiquesLivreResponse.fromJson(response.data);
      }
      throw Exception('Erreur lors de la récupération des statistiques');
    } catch (e) {
      print('Erreur getStatistiquesLivre: $e');
      throw e;
    }
  }

  /// Récupérer les livres populaires
  Future<List<LivrePopulaireResponse>> getLivresPopulaires() async {
    try {
      final response = await _dio.get('/livres/populaires');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivrePopulaireResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres populaires');
    } catch (e) {
      print('Erreur getLivresPopulaires: $e');
      throw e;
    }
  }

  /// Récupérer les livres recommandés pour un élève
  Future<List<LivreResponse>> getLivresRecommandes(int eleveId) async {
    try {
      final response = await _dio.get('/livres/recommandes/$eleveId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres recommandés');
    } catch (e) {
      print('Erreur getLivresRecommandes: $e');
      throw e;
    }
  }

  /// Récupérer les livres recommandés pour l'élève connecté
  Future<List<LivreResponse>> getLivresRecommandesForCurrentUser() async {
    final eleveId = getCurrentEleveId();
    if (eleveId == null) {
      throw Exception('Aucun élève connecté');
    }
    return getLivresRecommandes(eleveId);
  }

  /// Rechercher des livres par titre
  Future<List<LivreResponse>> searchLivresByTitre(String titre) async {
    try {
      final response = await _dio.get('/livres/recherche/titre', queryParameters: {'titre': titre});
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la recherche par titre');
    } catch (e) {
      print('Erreur searchLivresByTitre: $e');
      throw e;
    }
  }

  /// Rechercher des livres par auteur
  Future<List<LivreResponse>> searchLivresByAuteur(String auteur) async {
    try {
      final response = await _dio.get('/livres/recherche/auteur', queryParameters: {'auteur': auteur});
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la recherche par auteur');
    } catch (e) {
      print('Erreur searchLivresByAuteur: $e');
      throw e;
    }
  }

  /// Récupérer les livres récents
  Future<List<LivreResponse>> getLivresRecents() async {
    try {
      final response = await _dio.get('/livres/recents');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres récents');
    } catch (e) {
      print('Erreur getLivresRecents: $e');
      throw e;
    }
  }

  /// Récupérer les livres par matière
  Future<List<LivreResponse>> getLivresByMatiere(int matiereId) async {
    try {
      final response = await _dio.get('/livres/matiere/$matiereId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres par matière');
    } catch (e) {
      print('Erreur getLivresByMatiere: $e');
      throw e;
    }
  }

  /// Récupérer les livres par niveau
  Future<List<LivreResponse>> getLivresByNiveau(int niveauId) async {
    try {
      final response = await _dio.get('/livres/niveau/$niveauId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres par niveau');
    } catch (e) {
      print('Erreur getLivresByNiveau: $e');
      throw e;
    }
  }

  /// Récupérer les livres par classe
  Future<List<LivreResponse>> getLivresByClasse(int classeId) async {
    try {
      final response = await _dio.get('/livres/classe/$classeId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => LivreResponse.fromJson(json))
            .toList();
      }
      throw Exception('Erreur lors de la récupération des livres par classe');
    } catch (e) {
      print('Erreur getLivresByClasse: $e');
      throw e;
    }
  }

  /// Récupérer l'URL du PDF formatée pour WebView
    Future<String> getDocumentPdfUrlForWebView(int livreId) async {
      try {
        final pdfUrl = await getDocumentPdfUrl(livreId);

        // Option: Utiliser Google Docs Viewer pour un meilleur affichage
        // return 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(pdfUrl)}';

        // Retourner l'URL directe (votre serveur doit servir les PDF correctement)
        return pdfUrl;
      } catch (e) {
        print('Erreur getDocumentPdfUrlForWebView: $e');
        throw e;
      }
    }
}