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
import 'package:edugo/services/offline_cache_service.dart';
import 'package:edugo/services/connectivity_service.dart';
import 'package:built_collection/built_collection.dart';

class LivreService {
  static final LivreService _instance = LivreService._internal();
  
  final AuthService _authService = AuthService();
  final OfflineCacheService _cacheService = OfflineCacheService();
  final ConnectivityService _connectivityService = ConnectivityService();
  
  factory LivreService() {
    return _instance;
  }
  
  LivreService._internal();
  
  Dio get _dio => _authService.dio;
  
  /// Récupérer tous les livres avec gestion des images de couverture
  Future<BuiltList<Livre>?> getAllLivres() async {
    try {
      print('🔄 Récupération de tous les livres...');
      final response = await _dio.get('/api/livres');
      print('✅ Réponse livres: ${response.statusCode}');
      
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          print('📚 ${data.length} livre(s) récupéré(s)');
          
          final livres = data
              .map((json) {
                try {
                  // Handle image cover URL properly
                  if (json is Map<String, dynamic> && json.containsKey('imageCouverture')) {
                    final imageCover = json['imageCouverture'] as String?;
                    // Check if image is valid (not null, not empty, and not the default placeholder)
                    if (imageCover != null && 
                        imageCover.isNotEmpty && 
                        imageCover != "Chemin de l'image" &&
                        !imageCover.contains("Chemin")) {
                      // If it's already a full URL, use it as is
                      if (imageCover.startsWith('http://') || imageCover.startsWith('https://')) {
                        json['imageCouverture'] = imageCover;
                      } else if (imageCover.startsWith('/')) {
                        final baseUrl = _dio.options.baseUrl;
                        // Remove trailing slash from baseUrl if present
                        final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                        // Remove '/api' prefix from imageCover if it exists (since baseUrl already contains /api)
                        String cleanPath = imageCover;
                        if (cleanPath.startsWith('/api/')) {
                          cleanPath = cleanPath.substring(4); // Remove '/api'
                        }
                        // Ensure cleanPath starts with /
                        if (!cleanPath.startsWith('/')) {
                          cleanPath = '/$cleanPath';
                        }
                        // Combine without double slashes
                        json['imageCouverture'] = '$cleanBaseUrl$cleanPath';
                      } else {
                        // Relative path without leading slash
                        final baseUrl = _dio.options.baseUrl;
                        final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                        json['imageCouverture'] = '$cleanBaseUrl/$imageCover';
                      }
                    } else {
                      // Set to null or empty string to use default image in UI
                      json['imageCouverture'] = null;
                    }
                  }
                  
                  return standardSerializers.deserializeWith(Livre.serializer, json);
                } catch (e) {
                  print('⚠️ Erreur désérialisation livre: $e');
                  print('   JSON: $json');
                  return null;
                }
              })
              .whereType<Livre>()
              .toList();
          
          print('✅ ${livres.length} livre(s) traité(s) avec succès');
          return livres.toBuiltList();
        } else {
          print('⚠️ Format de réponse inattendu: ${response.data.runtimeType}');
        }
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des livres: $e');
      if (e is DioException) {
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Status: ${e.response?.statusCode}');
        print('   Data: ${e.response?.data}');
      }
    }
    return BuiltList<Livre>();
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
  Future<BuiltList<Livre>?> getLivresByClasse(int classeId) async {
    try {
      final response = await _dio.get('/api/livres/classe/$classeId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) {
              // Handle image cover URL properly
              if (json is Map<String, dynamic> && json.containsKey('imageCouverture')) {
                final imageCover = json['imageCouverture'] as String?;
                if (imageCover != null && 
                    imageCover.isNotEmpty && 
                    imageCover != "Chemin de l'image" &&
                    !imageCover.contains("Chemin")) {
                  // If it's already a full URL, use it as is
                  if (imageCover.startsWith('http://') || imageCover.startsWith('https://')) {
                    json['imageCouverture'] = imageCover;
                  } else if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove trailing slash from baseUrl if present
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    // Remove '/api' prefix from imageCover if it exists (since baseUrl already contains /api)
                    String cleanPath = imageCover;
                    if (cleanPath.startsWith('/api/')) {
                      cleanPath = cleanPath.substring(4); // Remove '/api'
                    }
                    // Ensure cleanPath starts with /
                    if (!cleanPath.startsWith('/')) {
                      cleanPath = '/$cleanPath';
                    }
                    // Combine without double slashes
                    json['imageCouverture'] = '$cleanBaseUrl$cleanPath';
                  } else {
                    // Relative path without leading slash
                    final baseUrl = _dio.options.baseUrl;
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    json['imageCouverture'] = '$cleanBaseUrl/$imageCover';
                  }
                } else {
                  // Set to null to use default image in UI
                  json['imageCouverture'] = null;
                }
              }
              return standardSerializers.deserializeWith(
                Livre.serializer,
                json,
              );
            })
            .whereType<Livre>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching books by class: $e');
    }
    return BuiltList<Livre>();
  }
  
  /// Récupérer les livres par matière
  Future<BuiltList<Livre>?> getLivresByMatiere(int matiereId) async {
    try {
      final response = await _dio.get('/api/livres/matiere/$matiereId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) {
              // Handle image cover URL properly
              if (json is Map<String, dynamic> && json.containsKey('imageCouverture')) {
                final imageCover = json['imageCouverture'] as String?;
                if (imageCover != null && 
                    imageCover.isNotEmpty && 
                    imageCover != "Chemin de l'image" &&
                    !imageCover.contains("Chemin")) {
                  // If it's already a full URL, use it as is
                  if (imageCover.startsWith('http://') || imageCover.startsWith('https://')) {
                    json['imageCouverture'] = imageCover;
                  } else if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove trailing slash from baseUrl if present
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    // Remove '/api' prefix from imageCover if it exists (since baseUrl already contains /api)
                    String cleanPath = imageCover;
                    if (cleanPath.startsWith('/api/')) {
                      cleanPath = cleanPath.substring(4); // Remove '/api'
                    }
                    // Ensure cleanPath starts with /
                    if (!cleanPath.startsWith('/')) {
                      cleanPath = '/$cleanPath';
                    }
                    // Combine without double slashes
                    json['imageCouverture'] = '$cleanBaseUrl$cleanPath';
                  } else {
                    // Relative path without leading slash
                    final baseUrl = _dio.options.baseUrl;
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    json['imageCouverture'] = '$cleanBaseUrl/$imageCover';
                  }
                } else {
                  // Set to null to use default image in UI
                  json['imageCouverture'] = null;
                }
              }
              return standardSerializers.deserializeWith(
                Livre.serializer,
                json,
              );
            })
            .whereType<Livre>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching books by subject: $e');
    }
    return BuiltList<Livre>();
  }
  
  /// Récupérer les livres par niveau
  Future<BuiltList<Livre>?> getLivresByNiveau(int niveauId) async {
    try {
      final response = await _dio.get('/api/livres/niveau/$niveauId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) {
              // Handle image cover URL properly
              if (json is Map<String, dynamic> && json.containsKey('imageCouverture')) {
                final imageCover = json['imageCouverture'] as String?;
                if (imageCover != null && 
                    imageCover.isNotEmpty && 
                    imageCover != "Chemin de l'image" &&
                    !imageCover.contains("Chemin")) {
                  // If it's already a full URL, use it as is
                  if (imageCover.startsWith('http://') || imageCover.startsWith('https://')) {
                    json['imageCouverture'] = imageCover;
                  } else if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove trailing slash from baseUrl if present
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    // Remove '/api' prefix from imageCover if it exists (since baseUrl already contains /api)
                    String cleanPath = imageCover;
                    if (cleanPath.startsWith('/api/')) {
                      cleanPath = cleanPath.substring(4); // Remove '/api'
                    }
                    // Ensure cleanPath starts with /
                    if (!cleanPath.startsWith('/')) {
                      cleanPath = '/$cleanPath';
                    }
                    // Combine without double slashes
                    json['imageCouverture'] = '$cleanBaseUrl$cleanPath';
                  } else {
                    // Relative path without leading slash
                    final baseUrl = _dio.options.baseUrl;
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    json['imageCouverture'] = '$cleanBaseUrl/$imageCover';
                  }
                } else {
                  // Set to null to use default image in UI
                  json['imageCouverture'] = null;
                }
              }
              return standardSerializers.deserializeWith(
                Livre.serializer,
                json,
              );
            })
            .whereType<Livre>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching books by level: $e');
    }
    return BuiltList<Livre>();
  }
  
  /// Récupérer les livres disponibles pour un élève (avec support hors ligne)
  Future<BuiltList<Livre>?> getLivresDisponibles(int eleveId) async {
    // Vérifier la connectivité
    final isConnected = await _connectivityService.isConnected();
    
    // Si hors ligne, récupérer depuis le cache
    if (!isConnected) {
      print('[LivreService] Mode hors ligne - Récupération depuis le cache');
      final cachedBooks = await _cacheService.getCachedBooks(eleveId);
      if (cachedBooks != null && cachedBooks.isNotEmpty) {
        print('[LivreService] ✅ ${cachedBooks.length} livres récupérés du cache');
        return cachedBooks;
      }
      print('[LivreService] ⚠️ Aucun livre en cache disponible');
      return BuiltList<Livre>();
    }
    
    // Si en ligne, récupérer depuis l'API et mettre en cache
    try {
      final response = await _dio.get('/api/livres/disponibles/$eleveId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final livres = data
            .map((json) {
              // Handle image cover URL properly
              if (json is Map<String, dynamic> && json.containsKey('imageCouverture')) {
                final imageCover = json['imageCouverture'] as String?;
                if (imageCover != null && 
                    imageCover.isNotEmpty && 
                    imageCover != "Chemin de l'image" &&
                    !imageCover.contains("Chemin")) {
                  // If it's already a full URL, use it as is
                  if (imageCover.startsWith('http://') || imageCover.startsWith('https://')) {
                    json['imageCouverture'] = imageCover;
                  } else if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove trailing slash from baseUrl if present
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    // Remove '/api' prefix from imageCover if it exists (since baseUrl already contains /api)
                    String cleanPath = imageCover;
                    if (cleanPath.startsWith('/api/')) {
                      cleanPath = cleanPath.substring(4); // Remove '/api'
                    }
                    // Ensure cleanPath starts with /
                    if (!cleanPath.startsWith('/')) {
                      cleanPath = '/$cleanPath';
                    }
                    // Combine without double slashes
                    json['imageCouverture'] = '$cleanBaseUrl$cleanPath';
                  } else {
                    // Relative path without leading slash
                    final baseUrl = _dio.options.baseUrl;
                    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
                    json['imageCouverture'] = '$cleanBaseUrl/$imageCover';
                  }
                } else {
                  // Set to null to use default image in UI
                  json['imageCouverture'] = null;
                }
              }
              return standardSerializers.deserializeWith(
                Livre.serializer,
                json,
              );
            })
            .whereType<Livre>()
            .toList();
        
        final livresList = livres.toBuiltList();
        
        // Mettre en cache pour usage hors ligne
        await _cacheService.cacheBooks(livresList, eleveId);
        
        return livresList;
      }
    } catch (e) {
      print('Error fetching available books: $e');
      // En cas d'erreur, essayer de récupérer depuis le cache
      final cachedBooks = await _cacheService.getCachedBooks(eleveId);
      if (cachedBooks != null && cachedBooks.isNotEmpty) {
        print('[LivreService] ✅ Récupération depuis le cache après erreur');
        return cachedBooks;
      }
    }
    return BuiltList<Livre>();
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
          if (data.isEmpty) {
            return BuiltList<ProgressionResponse>();
          }
          return data
              .map((json) {
                try {
                  return standardSerializers.deserializeWith(
                    ProgressionResponse.serializer,
                    json,
                  );
                } catch (e) {
                  print('Error deserializing progression item: $e');
                  return null;
                }
              })
              .whereType<ProgressionResponse>()
              .toList()
              .toBuiltList();
        } else if (response.data == null || response.data == '') {
          // Empty response, return empty list
          return BuiltList<ProgressionResponse>();
        } else {
          print('Unexpected response format for reading progress: ${response.data}');
          return BuiltList<ProgressionResponse>();
        }
      }
    } catch (e) {
      // Don't print error for empty responses, just return empty list
      if (e is DioException && e.response?.statusCode == 404) {
        return BuiltList<ProgressionResponse>();
      }
      print('Error fetching reading progress: $e');
    }
    return BuiltList<ProgressionResponse>();
  }
  
  /// Récupérer la progression d'un livre spécifique
  /// Endpoint: GET /api/livres/progression/{eleveId}/{livreId}
  /// Response: ProgressionResponse ou null si aucune progression n'existe
  Future<ProgressionResponse?> getProgressionLivre(int eleveId, int livreId) async {
    try {
      final response = await _dio.get('/api/livres/progression/$eleveId/$livreId');
      if (response.statusCode == 200) {
        // Si la réponse est null, aucune progression n'existe pour ce livre
        if (response.data == null) {
          print('[LivreService] No progression found for book $livreId and student $eleveId');
          return null;
        }
        
        // Check if response data is a map/object
        if (response.data is Map<String, dynamic>) {
          return standardSerializers.deserializeWith(
            ProgressionResponse.serializer,
            response.data,
          );
        } else {
          print('[LivreService] Unexpected response format for book progress: ${response.data}');
          return null;
        }
      }
    } catch (e) {
      // Si c'est une 404, c'est normal (aucune progression n'existe)
      if (e is DioException && e.response?.statusCode == 404) {
        print('[LivreService] No progression found for book $livreId and student $eleveId (404)');
        return null;
      }
      print('[LivreService] Error fetching book progress: $e');
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
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
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
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
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
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
    }
    return null;
  }
  
  /// Mettre à jour la progression de lecture
  /// POST /api/livres/progression/{eleveId}/{livreId}
  /// Body: { "pageActuelle": pageNumber }
  Future<ProgressionResponse?> updateProgressionLecture(int eleveId, int livreId, int pageNumber) async {
    try {
      final progressionUpdate = ProgressionUpdateRequest((b) => b
        ..pageActuelle = pageNumber
      );
      
      // Utiliser l'endpoint correct selon la spécification: /api/livres/progression/{eleveId}/{livreId}
      final response = await _dio.post(
        '/api/livres/progression/$eleveId/$livreId',
        data: standardSerializers.serialize(progressionUpdate),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final progression = standardSerializers.deserializeWith(
          ProgressionResponse.serializer,
          response.data,
        ) as ProgressionResponse;
        print('[LivreService] ✅ Progression mise à jour: livre $livreId, page $pageNumber, ${progression.pourcentageCompletion}%');
        return progression;
      }
    } catch (e) {
      print('[LivreService] ❌ Erreur lors de la mise à jour de la progression: $e');
      if (e is DioException) {
        print('[LivreService] Status code: ${e.response?.statusCode}');
        print('[LivreService] Response data: ${e.response?.data}');
      }
    }
    return null;
  }

}