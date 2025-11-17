import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/livre_response.dart';
import 'package:edugo/models/livre_detail_response.dart';
import 'package:edugo/models/livre_populaire_response.dart';
import 'package:edugo/models/progression_response.dart';
import 'package:edugo/models/progression_update_request.dart';
import 'package:edugo/models/statistiques_livre_response.dart';
import 'package:edugo/models/livre.dart'; // Add this import
import 'package:edugo/models/fichier_livre.dart'; // Add this import
import 'package:edugo/services/serializers.dart';
import 'package:built_collection/built_collection.dart';

class LivreService {
  static final LivreService _instance = LivreService._internal();
  
  final AuthService _authService = AuthService();
  
  factory LivreService() {
    return _instance;
  }
  
  LivreService._internal();
  
  Dio get _dio => _authService.dio;
  
  /// Récupérer tous les livres
  Future<BuiltList<LivreResponse>?> getAllLivres() async {
    try {
      final response = await _dio.get('/api/livres');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching all books: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
    }
    return null;
  }
  
  /// Récupérer un livre par ID with full details including files
  Future<Livre?> getLivreById(int id) async {
    try {
      final response = await _dio.get('/api/livres/$id');
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(
          Livre.serializer,
          response.data,
        );
      }
    } catch (e) {
      print('Error fetching book by ID: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
    }
    return null;
  }
  
  /// Récupérer un livre par ID (simplified version)
  Future<LivreDetailResponse?> getLivreDetailById(int id) async {
    try {
      final response = await _dio.get('/api/livres/$id');
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(
          LivreDetailResponse.serializer,
          response.data,
        );
      }
    } catch (e) {
      print('Error fetching book by ID: $e');
    }
    return null;
  }
  
  /// Récupérer les livres par classe
  Future<BuiltList<LivreResponse>?> getLivresByClasse(int classeId) async {
    try {
      final response = await _dio.get('/api/livres/classe/$classeId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching books by class: $e');
    }
    return null;
  }
  
  /// Récupérer les livres par matière
  Future<BuiltList<LivreResponse>?> getLivresByMatiere(int matiereId) async {
    try {
      final response = await _dio.get('/api/livres/matiere/$matiereId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching books by subject: $e');
    }
    return null;
  }
  
  /// Récupérer les livres par niveau
  Future<BuiltList<LivreResponse>?> getLivresByNiveau(int niveauId) async {
    try {
      final response = await _dio.get('/api/livres/niveau/$niveauId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching books by level: $e');
    }
    return null;
  }
  
  /// Récupérer les livres disponibles pour un élève
  Future<BuiltList<LivreResponse>?> getLivresDisponibles(int eleveId) async {
    try {
      final response = await _dio.get('/api/livres/disponibles/$eleveId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching available books: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
    }
    return null;
  }
  
  /// Récupérer les livres populaires
  Future<BuiltList<LivrePopulaireResponse>?> getLivresPopulaires() async {
    try {
      final response = await _dio.get('/api/livres/populaires');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivrePopulaireResponse.serializer,
                  json,
                ))
            .whereType<LivrePopulaireResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching popular books: $e');
    }
    return null;
  }
  
  /// Récupérer les livres récents
  Future<BuiltList<LivreResponse>?> getLivresRecents() async {
    try {
      final response = await _dio.get('/api/livres/recents');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching recent books: $e');
    }
    return null;
  }
  
  /// Récupérer les livres recommandés
  Future<BuiltList<LivreResponse>?> getLivresRecommandes(int eleveId) async {
    try {
      final response = await _dio.get('/api/livres/recommandes/$eleveId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching recommended books: $e');
    }
    return null;
  }
  
  /// Récupérer la progression de lecture d'un élève
  Future<BuiltList<ProgressionResponse>?> getProgressionLecture(int eleveId) async {
    try {
      final response = await _dio.get('/api/livres/progression/$eleveId');
      if (response.statusCode == 200) {
        // Check if response data is a list
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data
              .map((json) => standardSerializers.deserializeWith(
                    ProgressionResponse.serializer,
                    json,
                  ))
              .whereType<ProgressionResponse>()
              .toList()
              .toBuiltList();
        } else {
          print('Unexpected response format for reading progress: ${response.data}');
          return BuiltList<ProgressionResponse>();
        }
      }
    } catch (e) {
      print('Error fetching reading progress: $e');
    }
    return null;
  }
  
  /// Récupérer la progression d'un livre spécifique
  Future<ProgressionResponse?> getProgressionLivre(int eleveId, int livreId) async {
    try {
      final response = await _dio.get('/api/livres/progression/$eleveId/$livreId');
      if (response.statusCode == 200) {
        // Check if response data is a map/object
        if (response.data is Map<String, dynamic>) {
          return standardSerializers.deserializeWith(
            ProgressionResponse.serializer,
            response.data,
          );
        } else {
          print('Unexpected response format for book progress: ${response.data}');
          return null;
        }
      }
    } catch (e) {
      print('Error fetching book progress: $e');
    }
    return null;
  }
  
  /// Récupérer les statistiques d'un livre
  Future<StatistiquesLivreResponse?> getStatistiquesLivre(int livreId) async {
    try {
      final response = await _dio.get('/api/livres/statistiques/$livreId');
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(
          StatistiquesLivreResponse.serializer,
          response.data,
        );
      }
    } catch (e) {
      print('Error fetching book statistics: $e');
    }
    return null;
  }
  
  /// Rechercher des livres par auteur
  Future<BuiltList<LivreResponse>?> searchLivresByAuteur(String auteur) async {
    try {
      final response = await _dio.get('/api/livres/recherche/auteur', 
        queryParameters: {'auteur': auteur});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error searching books by author: $e');
    }
    return null;
  }
  
  /// Rechercher des livres par titre
  Future<BuiltList<LivreResponse>?> searchLivresByTitre(String titre) async {
    try {
      final response = await _dio.get('/api/livres/recherche/titre', 
        queryParameters: {'titre': titre});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  LivreResponse.serializer,
                  json,
                ))
            .whereType<LivreResponse>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error searching books by title: $e');
    }
    return null;
  }
  
  /// Mettre à jour la progression de lecture
  Future<ProgressionResponse?> updateProgressionLecture(int eleveId, int livreId, int pageActuelle) async {
    try {
      final request = ProgressionUpdateRequest((b) => b
        ..pageActuelle = pageActuelle
      );
      
      final serialized = standardSerializers.serialize(request);
      final response = await _dio.post(
        '/api/livres/progression/$eleveId/$livreId',
        data: serialized,
      );
      
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(
          ProgressionResponse.serializer,
          response.data,
        );
      }
    } catch (e) {
      print('Error updating reading progress: $e');
    }
    return null;
  }
  
  /// Récupérer les fichiers d'un livre
  Future<BuiltList<FichierLivre>?> getFichiersLivre(int livreId) async {
    try {
      final response = await _dio.get('/api/livres/$livreId/fichiers');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  FichierLivre.serializer,
                  json,
                ))
            .whereType<FichierLivre>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching book files: $e');
    }
    return null;
  }
  
  /// Télécharger un fichier de livre
  Future<Response> downloadFichierLivre(int fichierId) async {
    try {
      final response = await _dio.get(
        '/api/livres/fichiers/$fichierId/download',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error downloading book file: $e');
      rethrow;
    }
  }
}