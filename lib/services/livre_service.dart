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
                    if (imageCover != null && imageCover.isNotEmpty) {
                      // If it's a relative path, make it absolute with the correct base URL
                      if (imageCover.startsWith('/')) {
                        final baseUrl = _dio.options.baseUrl;
                        // Remove '/api' prefix if it exists to avoid double prefix
                        final cleanPath = imageCover.startsWith('/api/') ? imageCover.substring(4) : imageCover;
                        json['imageCouverture'] = '$baseUrl$cleanPath';
                      }
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
                if (imageCover != null && imageCover.isNotEmpty) {
                  // If it's a relative path, make it absolute with the correct base URL
                  if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove '/api' prefix if it exists to avoid double prefix
                    final cleanPath = imageCover.startsWith('/api/') ? imageCover.substring(4) : imageCover;
                    json['imageCouverture'] = '$baseUrl$cleanPath';
                  }
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
                if (imageCover != null && imageCover.isNotEmpty) {
                  // If it's a relative path, make it absolute with the correct base URL
                  if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove '/api' prefix if it exists to avoid double prefix
                    final cleanPath = imageCover.startsWith('/api/') ? imageCover.substring(4) : imageCover;
                    json['imageCouverture'] = '$baseUrl$cleanPath';
                  }
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
                if (imageCover != null && imageCover.isNotEmpty) {
                  // If it's a relative path, make it absolute with the correct base URL
                  if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove '/api' prefix if it exists to avoid double prefix
                    final cleanPath = imageCover.startsWith('/api/') ? imageCover.substring(4) : imageCover;
                    json['imageCouverture'] = '$baseUrl$cleanPath';
                  }
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
  
  /// Récupérer les livres disponibles pour un élève
  Future<BuiltList<Livre>?> getLivresDisponibles(int eleveId) async {
    try {
      final response = await _dio.get('/api/livres/disponibles/$eleveId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) {
              // Handle image cover URL properly
              if (json is Map<String, dynamic> && json.containsKey('imageCouverture')) {
                final imageCover = json['imageCouverture'] as String?;
                if (imageCover != null && imageCover.isNotEmpty) {
                  // If it's a relative path, make it absolute with the correct base URL
                  if (imageCover.startsWith('/')) {
                    final baseUrl = _dio.options.baseUrl;
                    // Remove '/api' prefix if it exists to avoid double prefix
                    final cleanPath = imageCover.startsWith('/api/') ? imageCover.substring(4) : imageCover;
                    json['imageCouverture'] = '$baseUrl$cleanPath';
                  }
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
      print('Error fetching available books: $e');
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
        '/livres/progression/$eleveId/$livreId',
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
  /// Essaie d'abord /livres/{id}/fichiers, sinon récupère le livre complet et extrait les fichiers
  Future<BuiltList<FichierLivre>?> getFichiersLivre(int livreId) async {
    try {
      print('🔍 Récupération des fichiers pour le livre $livreId');
      
      // Essayer d'abord l'endpoint spécifique pour les fichiers (baseUrl contient déjà /api)
      try {
        final response = await _dio.get('/api/livres/$livreId/fichiers');
        print('📡 URL complète: ${_dio.options.baseUrl}/livres/$livreId/fichiers');
        print('✅ Réponse fichiers: ${response.statusCode}');
        
        if (response.statusCode == 200 && response.data != null) {
          if (response.data is List) {
            final List<dynamic> data = response.data;
            print('📋 ${data.length} fichier(s) dans la réponse');
            
            // Debug: afficher la structure du premier fichier
            if (data.isNotEmpty) {
              print('📄 Structure du premier fichier: ${data[0]}');
              print('📄 Clés du premier fichier: ${(data[0] as Map<String, dynamic>).keys.toList()}');
            }
            
            final fichiers = data
                .map((json) {
                  try {
                    // Debug: afficher les clés de chaque fichier
                    if (json is Map<String, dynamic>) {
                      print('🔑 Clés du fichier: ${json.keys.toList()}');
                      // Handle both 'chemin' and 'cheminFichier' keys
                      if (json.containsKey('chemin') && !json.containsKey('cheminFichier')) {
                        json['cheminFichier'] = json['chemin'];
                      }
                      print('📁 Chemin disponible: ${json['cheminFichier'] ?? json['chemin']}');
                    }
                    
                    final fichier = standardSerializers.deserializeWith(
                      FichierLivre.serializer,
                      json,
                    );
                    
                    // Debug: vérifier le chemin après désérialisation
                    print('📁 Fichier désérialisé - ID: ${fichier?.id}, Nom: ${fichier?.nom}, Chemin: ${fichier?.cheminFichier}');
                    
                    return fichier;
                  } catch (e) {
                    print('⚠️ Erreur désérialisation fichier: $e');
                    print('   JSON: $json');
                    return null;
                  }
                })
                .whereType<FichierLivre>()
                .toList();
            
            if (fichiers.isNotEmpty) {
              print('✅ ${fichiers.length} fichier(s) trouvé(s) via /fichiers');
              return fichiers.toBuiltList();
            }
          } else {
            print('⚠️ Format de réponse inattendu pour fichiers: ${response.data.runtimeType}');
            print('   Contenu: ${response.data}');
          }
        }
      } catch (e) {
        print('⚠️ Endpoint /livres/$livreId/fichiers non disponible: $e');
      }
      
      // Si l'endpoint spécifique échoue, récupérer le livre complet et extraire les fichiers
      print('🔄 Tentative alternative: récupération du livre complet...');
      final livre = await getLivreById(livreId);
      
      if (livre != null && livre.fichiers != null && livre.fichiers!.isNotEmpty) {
        print('✅ ${livre.fichiers!.length} fichier(s) trouvé(s) dans le livre complet');
        return livre.fichiers;
      }
      
      print('❌ Aucun fichier trouvé pour le livre $livreId');
      return BuiltList<FichierLivre>();
      
    } catch (e) {
      print('❌ Erreur lors de la récupération des fichiers: $e');
      if (e is DioException) {
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Status: ${e.response?.statusCode}');
        print('   Data: ${e.response?.data}');
        print('   URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      }
      return BuiltList<FichierLivre>();
    }
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