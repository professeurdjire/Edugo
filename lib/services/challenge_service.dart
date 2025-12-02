import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/challenges_api.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/services/bearer_auth.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/models/participation.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:edugo/models/leaderboard_entry.dart';
import 'package:built_collection/built_collection.dart';

/// Métadonnées d'un challenge (points et nombre de questions)
/// Ces champs sont retournés par l'API mais ne sont pas dans le modèle Challenge auto-généré
class ChallengeMetadata {
  final int points;
  final int nombreQuestions;

  ChallengeMetadata({
    required this.points,
    required this.nombreQuestions,
  });

  factory ChallengeMetadata.fromJson(Map<String, dynamic> json) {
    return ChallengeMetadata(
      points: json['points'] as int? ?? 0,
      nombreQuestions: json['nombreQuestions'] as int? ?? 0,
    );
  }
}

class ChallengeService {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;

  final AuthService _authService = AuthService();
  late LveApi _lveApi;
  late ChallengesApi _challengesApi;

  ChallengeService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
    _challengesApi = ChallengesApi(_authService.dio, standardSerializers);
    
    // Configurer le BearerAuthInterceptor si présent
    _configureBearerAuth();
  }
  
  /// Configurer l'authentification Bearer pour les APIs générées
  void _configureBearerAuth() {
    final token = _authService.getAuthToken();
    if (token != null) {
      // Chercher le BearerAuthInterceptor dans les interceptors de Dio
      for (var interceptor in _authService.dio.interceptors) {
        if (interceptor is BearerAuthInterceptor) {
          interceptor.tokens['bearerAuth'] = token;
          print('[ChallengeService] BearerAuthInterceptor configured with token');
          break;
        }
      }
    }
  }

  /// Map pour stocker les métadonnées (points et nombreQuestions) par challenge ID
  final Map<int, ChallengeMetadata> _challengeMetadata = {};

  /// Récupérer les métadonnées d'un challenge (points et nombreQuestions)
  ChallengeMetadata? getChallengeMetadata(int challengeId) {
    return _challengeMetadata[challengeId];
  }

  /// Récupérer les challenges disponibles pour un élève
  /// ⚠️ IMPORTANT: Les métadonnées (points et nombreQuestions) sont stockées dans _challengeMetadata
  Future<BuiltList<Challenge>?> getChallengesDisponibles(int eleveId) async {
    try {
      print('Fetching challenges for student ID: $eleveId');
      
      // Utiliser dio directement pour accéder à la réponse JSON brute
      final url = '/api/eleve/challenges/disponibles/$eleveId';
      final response = await _authService.dio.get(url);
      
      print('API response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data as List<dynamic>;
        print('Successfully fetched challenges. Data length: ${rawData.length}');
        
        // Désérialiser les challenges d'abord
        final challenges = rawData.map((item) {
          return standardSerializers.deserializeWith(
            Challenge.serializer,
            item,
          ) as Challenge;
        }).toList();
        
        // Extraire les métadonnées depuis la réponse JSON brute et calculer nombreQuestions
        _challengeMetadata.clear();
        for (var i = 0; i < rawData.length && i < challenges.length; i++) {
          final item = rawData[i];
          final challenge = challenges[i];
          if (item is Map<String, dynamic>) {
            final challengeId = item['id'] as int?;
            if (challengeId != null) {
              // Calculer nombreQuestions depuis les questions du challenge si disponible
              final questionsCount = challenge.questionsChallenge?.length ?? 0;
              final metadata = ChallengeMetadata.fromJson(item);
              // Utiliser le nombreQuestions calculé si le backend ne le fournit pas
              final finalNombreQuestions = metadata.nombreQuestions > 0 
                  ? metadata.nombreQuestions 
                  : questionsCount;
              
              _challengeMetadata[challengeId] = ChallengeMetadata(
                points: metadata.points,
                nombreQuestions: finalNombreQuestions,
              );
              print('[ChallengeService] Challenge $challengeId: points=${_challengeMetadata[challengeId]!.points}, nombreQuestions=${_challengeMetadata[challengeId]!.nombreQuestions} (from backend: ${metadata.nombreQuestions}, from questions: $questionsCount)');
            }
          }
        }
        
        return BuiltList<Challenge>(challenges);
      } else {
        print('Error fetching available challenges: Status code ${response.statusCode}');
        print('Response data: ${response.data}');
      }
    } catch (e) {
      print('Error fetching available challenges: $e');
    }
    return null;
  }

  /// Récupérer les challenges auxquels l'élève a participé
  /// ⚠️ IMPORTANT: Les métadonnées (points et nombreQuestions) sont stockées dans _challengeMetadata
  Future<BuiltList<Participation>?> getChallengesParticipes(int eleveId) async {
    try {
      // Utiliser dio directement pour accéder à la réponse JSON brute
      final url = '/api/eleve/challenges/participes/$eleveId';
      final response = await _authService.dio.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data as List<dynamic>;
        
        // Désérialiser les participations d'abord
        final participations = rawData.map((item) {
          return standardSerializers.deserializeWith(
            Participation.serializer,
            item,
          ) as Participation;
        }).toList();
        
        // Extraire les métadonnées depuis les participations
        // Les participations contiennent un objet challenge avec les métadonnées
        for (var i = 0; i < rawData.length && i < participations.length; i++) {
          final item = rawData[i];
          final participation = participations[i];
          if (item is Map<String, dynamic>) {
            final challengeData = item['challenge'] as Map<String, dynamic>?;
            if (challengeData != null) {
              final challengeId = challengeData['id'] as int?;
              if (challengeId != null) {
                // Calculer nombreQuestions depuis les questions du challenge si disponible
                final questionsCount = participation.challenge?.questionsChallenge?.length ?? 0;
                final metadata = ChallengeMetadata.fromJson(challengeData);
                // Utiliser le nombreQuestions calculé si le backend ne le fournit pas
                final finalNombreQuestions = metadata.nombreQuestions > 0 
                    ? metadata.nombreQuestions 
                    : questionsCount;
                
                _challengeMetadata[challengeId] = ChallengeMetadata(
                  points: metadata.points,
                  nombreQuestions: finalNombreQuestions,
                );
                print('[ChallengeService] Challenge $challengeId (from participation): points=${_challengeMetadata[challengeId]!.points}, nombreQuestions=${_challengeMetadata[challengeId]!.nombreQuestions} (from backend: ${metadata.nombreQuestions}, from questions: $questionsCount)');
              }
            }
          }
        }
        
        return BuiltList<Participation>(participations);
      } else {
        print('Error fetching participated challenges: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching participated challenges: $e');
    }
    return null;
  }

  /// Récupérer un challenge par ID avec tous les détails
  /// ⚠️ IMPORTANT: Les métadonnées (points et nombreQuestions) sont stockées dans _challengeMetadata
  Future<Challenge?> getChallengeById(int challengeId) async {
    try {
      // Utiliser dio directement pour accéder à la réponse JSON brute
      final url = '/api/eleve/challenges/$challengeId';
      final response = await _authService.dio.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> rawData = response.data as Map<String, dynamic>;
        
        // Désérialiser le challenge d'abord
        final challenge = standardSerializers.deserializeWith(
          Challenge.serializer,
          rawData,
        ) as Challenge;
        
        // Extraire les métadonnées depuis la réponse JSON brute et calculer nombreQuestions
        // Calculer nombreQuestions depuis les questions du challenge si disponible
        final questionsCount = challenge.questionsChallenge?.length ?? 0;
        final metadata = ChallengeMetadata.fromJson(rawData);
        // Utiliser le nombreQuestions calculé si le backend ne le fournit pas
        final finalNombreQuestions = metadata.nombreQuestions > 0 
            ? metadata.nombreQuestions 
            : questionsCount;
        
        _challengeMetadata[challengeId] = ChallengeMetadata(
          points: metadata.points,
          nombreQuestions: finalNombreQuestions,
        );
        print('[ChallengeService] Challenge $challengeId: points=${_challengeMetadata[challengeId]!.points}, nombreQuestions=${_challengeMetadata[challengeId]!.nombreQuestions} (from backend: ${metadata.nombreQuestions}, from questions: $questionsCount)');
        
        return challenge;
      } else {
        print('Error fetching challenge by ID: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching challenge by ID: $e');
    }
    return null;
  }

  /// Participer à un challenge
  /// Endpoint: POST /api/challenges/participer/{eleveId}/{challengeId}
  /// ⚠️ IMPORTANT: L'élève DOIT participer au challenge AVANT de soumettre ses réponses
  /// La participation crée une entrée Participation avec statut "EN_COURS"
  Future<Participation?> participerChallenge(int eleveId, int challengeId) async {
    try {
      print('[ChallengeService] Participating in challenge $challengeId for student $eleveId');
      
      // Configurer le BearerAuthInterceptor avec le token actuel
      _configureBearerAuth();
      
      // Vérifier que le token est présent
      var token = _authService.getAuthToken();
      var authHeader = _authService.dio.options.headers['Authorization'];
      
      print('[ChallengeService] Token value: ${token != null ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "null"}');
      
      if (token == null || token.isEmpty) {
        print('[ChallengeService] ❌ ERREUR CRITIQUE: No token found! User may not be logged in.');
        print('[ChallengeService] Headers globaux: ${_authService.dio.options.headers.keys}');
        throw Exception('Vous devez être connecté pour participer à un challenge. Veuillez vous reconnecter.');
      }
      
      // S'assurer que le token est dans les headers globaux
      if (authHeader == null || authHeader.toString().isEmpty || !authHeader.toString().startsWith('Bearer ')) {
        _authService.setAuthToken(token);
        authHeader = _authService.dio.options.headers['Authorization'];
        print('[ChallengeService] Token ajouté aux headers globaux de Dio');
      }
      
      // Essayer d'abord avec l'API générée LveApi.participerChallenge
      // qui utilise /api/eleve/challenges/participer/{eleveId}/{challengeId}
      try {
        print('[ChallengeService] Trying with LveApi.participerChallenge (endpoint: /api/eleve/challenges/participer)...');
        final response = await _lveApi.participerChallenge(
          eleveId: eleveId,
          challengeId: challengeId,
        );
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('[ChallengeService] Successfully participated using LveApi');
          return response.data;
        } else {
          print('[ChallengeService] LveApi returned status code: ${response.statusCode}');
        }
      } catch (e) {
        print('[ChallengeService] LveApi.participerChallenge failed: $e');
        if (e is DioException) {
          print('[ChallengeService] LveApi DioException status: ${e.response?.statusCode}');
          print('[ChallengeService] LveApi DioException data: ${e.response?.data}');
        }
      }
      
      // Essayer avec ChallengesApi.participerChallenge1
      // qui utilise /api/challenges/participer/{eleveId}/{challengeId}
      try {
        print('[ChallengeService] Trying with ChallengesApi.participerChallenge1 (endpoint: /api/challenges/participer)...');
        final response = await _challengesApi.participerChallenge1(
          eleveId: eleveId,
          challengeId: challengeId,
        );
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('[ChallengeService] Successfully participated using ChallengesApi');
          return response.data;
        } else {
          print('[ChallengeService] ChallengesApi returned status code: ${response.statusCode}');
        }
      } catch (e) {
        print('[ChallengeService] ChallengesApi.participerChallenge1 failed: $e');
        if (e is DioException) {
          print('[ChallengeService] ChallengesApi DioException status: ${e.response?.statusCode}');
          print('[ChallengeService] ChallengesApi DioException data: ${e.response?.data}');
        }
      }
      
      // S'assurer que le token est dans les headers globaux (réutiliser authHeader déjà déclaré)
      authHeader = _authService.dio.options.headers['Authorization'];
      if (authHeader == null || authHeader.toString().isEmpty || !authHeader.toString().startsWith('Bearer ')) {
        _authService.setAuthToken(token);
        authHeader = _authService.dio.options.headers['Authorization'];
        print('[ChallengeService] Token ajouté aux headers globaux de Dio pour fallback');
      }
      
      // Fallback: utiliser directement dio avec le token dans les headers
      // Essayer d'abord /api/eleve/challenges/participer
      try {
        print('[ChallengeService] Falling back to direct dio call (endpoint: /api/eleve/challenges/participer)...');
        final url1 = '/api/eleve/challenges/participer/$eleveId/$challengeId';
        print('[ChallengeService] Full URL will be: ${_authService.dio.options.baseUrl}$url1');
        print('[ChallengeService] Token présent: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
        
        // L'intercepteur ajoutera automatiquement le token
        final response1 = await _authService.dio.post(
          url1,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              // Le token sera ajouté automatiquement par l'intercepteur
            },
          ),
        );
        
        print('[ChallengeService] Direct dio call 1 response status: ${response1.statusCode}');
        print('[ChallengeService] Direct dio call 1 response data: ${response1.data}');
        
        if (response1.statusCode == 200 || response1.statusCode == 201) {
          final participation = standardSerializers.deserializeWith(
            Participation.serializer,
            response1.data,
          ) as Participation;
          print('[ChallengeService] Successfully participated using direct dio call 1. Status: ${participation.statut}');
          return participation;
        }
      } catch (e) {
        print('[ChallengeService] Direct dio call 1 failed: $e');
        if (e is DioException) {
          print('[ChallengeService] Direct dio call 1 status: ${e.response?.statusCode}');
          print('[ChallengeService] Direct dio call 1 data: ${e.response?.data}');
        }
      }
      
      // Essayer /api/challenges/participer
      try {
        print('[ChallengeService] Falling back to direct dio call (endpoint: /api/challenges/participer)...');
        final url2 = '/api/challenges/participer/$eleveId/$challengeId';
        print('[ChallengeService] Full URL will be: ${_authService.dio.options.baseUrl}$url2');
        print('[ChallengeService] Token présent: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
        
        // L'intercepteur ajoutera automatiquement le token
        final response2 = await _authService.dio.post(
          url2,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              // Le token sera ajouté automatiquement par l'intercepteur
            },
          ),
        );
        
        print('[ChallengeService] Direct dio call 2 response status: ${response2.statusCode}');
        print('[ChallengeService] Direct dio call 2 response data: ${response2.data}');
        
        if (response2.statusCode == 200 || response2.statusCode == 201) {
          final participation = standardSerializers.deserializeWith(
            Participation.serializer,
            response2.data,
          ) as Participation;
          print('[ChallengeService] Successfully participated using direct dio call 2. Status: ${participation.statut}');
          return participation;
        }
      } catch (e) {
        print('[ChallengeService] Direct dio call 2 failed: $e');
        if (e is DioException) {
          print('[ChallengeService] Direct dio call 2 status: ${e.response?.statusCode}');
          print('[ChallengeService] Direct dio call 2 data: ${e.response?.data}');
        }
      }
      
      print('[ChallengeService] All participation attempts failed');
    } catch (e) {
      print('[ChallengeService] Error participating in challenge: $e');
      if (e is DioException) {
        print('[ChallengeService] DioException type: ${e.type}');
        print('[ChallengeService] DioException response: ${e.response?.data}');
        print('[ChallengeService] DioException status code: ${e.response?.statusCode}');
        print('[ChallengeService] DioException request path: ${e.requestOptions.uri.path}');
        print('[ChallengeService] DioException request method: ${e.requestOptions.method}');
        print('[ChallengeService] DioException request headers: ${e.requestOptions.headers}');
        
        // Analyser le message d'erreur pour fournir un message plus clair
        final errorData = e.response?.data;
        if (errorData != null) {
          final errorString = errorData.toString().toLowerCase();
          final statusCode = e.response?.statusCode;

          if (statusCode == 409 ||
              errorString.contains('déjà participé') ||
              errorString.contains('vous participez déjà') ||
              errorString.contains('already participated')) {
            print('[ChallengeService] User has already participated in this challenge (HTTP ${statusCode})');
            // Ne pas retourner null, mais plutôt lancer une exception spécifique
            throw Exception('Vous participez déjà à ce challenge');
          } else if (errorString.contains('pas actuellement disponible') || 
                     errorString.contains('not currently available') ||
                     errorString.contains('not active')) {
            print('[ChallengeService] Challenge is not currently available');
            throw Exception('Ce challenge n\'est pas actuellement disponible');
          } else if (errorString.contains('introuvable') || errorString.contains('not found')) {
            print('[ChallengeService] Challenge or student not found');
            throw Exception('Challenge ou élève introuvable');
          }
        }
      }
      // Si c'est une exception personnalisée, la relancer
      final errorString = e.toString();
      if (e is Exception && (errorString.contains('participez déjà') || 
          errorString.contains('pas actuellement disponible'))) {
        rethrow;
      }
    }
    return null;
  }
  
  /// Récupérer la participation existante d'un élève à un challenge
  /// Endpoint: GET /api/challenges/participation/{eleveId}/{challengeId}
  Future<Participation?> getParticipation(int eleveId, int challengeId) async {
    try {
      print('[ChallengeService] Getting participation for student $eleveId and challenge $challengeId');
      
      // Vérifier d'abord dans la liste des participations
      final participations = await getChallengesParticipes(eleveId);
      if (participations != null) {
        try {
          final participation = participations.firstWhere(
            (p) => p.challenge?.id == challengeId,
          );
          print('[ChallengeService] Found existing participation: ID=${participation.id}, Status=${participation.statut}');
          return participation;
        } catch (e) {
          // Pas de participation trouvée
          print('[ChallengeService] No existing participation found');
          return null;
        }
      }
      
      return null;
    } catch (e) {
      print('[ChallengeService] Error getting participation: $e');
      return null;
    }
  }

  /// Soumettre les réponses d'un challenge
  Future<SubmitResultResponse?> submitChallengeAnswers(int challengeId, SubmitRequest submitRequest) async {
    try {
      // Using the endpoint: POST /api/challenges/{challengeId}/submit
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _authService.dio.post(
        '/api/challenges/$challengeId/submit',
        data: standardSerializers.serializeWith(SubmitRequest.serializer, submitRequest),
      );
      
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(SubmitResultResponse.serializer, response.data) as SubmitResultResponse;
      }
    } catch (e) {
      print('Error submitting challenge answers: $e');
    }
    return null;
  }

  /// Récupérer le leaderboard d'un challenge
  /// GET /api/challenges/{challengeId}/leaderboard
  /// Retourne une liste de LeaderboardEntry triée par score décroissant
  /// Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
  Future<List<LeaderboardEntry>> getChallengeLeaderboard(int challengeId) async {
    try {
      print('[ChallengeService] Fetching leaderboard for challenge $challengeId');
      
      // Configurer le BearerAuthInterceptor avec le token actuel
      _configureBearerAuth();
      
      // Vérifier que le token est présent
      final token = _authService.getAuthToken();
      if (token == null) {
        print('[ChallengeService] ERROR: No token found for leaderboard request!');
        return [];
      }
      
      final url = '/api/challenges/$challengeId/leaderboard';
      print('[ChallengeService] Full URL will be: ${_authService.dio.options.baseUrl}$url');
      
      final response = await _authService.dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print('[ChallengeService] Leaderboard response status: ${response.statusCode}');
      print('[ChallengeService] Leaderboard response data type: ${response.data.runtimeType}');
      print('[ChallengeService] Leaderboard response data: ${response.data}');
      
      if (response.statusCode == 200) {
        // Le backend retourne directement une liste de LeaderboardEntry
        List<dynamic>? data;
        
        if (response.data is List) {
          data = response.data as List;
        } else if (response.data is Map) {
          // Si la réponse est un objet avec une clé "participations" ou "leaderboard"
          final Map<String, dynamic> mapData = response.data as Map<String, dynamic>;
          if (mapData.containsKey('participations')) {
            data = mapData['participations'] as List?;
            print('[ChallengeService] Found leaderboard in Map key "participations"');
          } else if (mapData.containsKey('leaderboard')) {
            data = mapData['leaderboard'] as List?;
            print('[ChallengeService] Found leaderboard in Map key "leaderboard"');
          } else if (mapData.containsKey('data')) {
            data = mapData['data'] as List?;
            print('[ChallengeService] Found leaderboard in Map key "data"');
          } else {
            print('[ChallengeService] ⚠️ Response is a Map but no known key found. Keys: ${mapData.keys.toList()}');
            print('[ChallengeService] Full Map data: $mapData');
          }
        }
        
        if (data == null) {
          print('[ChallengeService] ⚠️ Could not extract list from response');
          return [];
        }
        
        print('[ChallengeService] Leaderboard contains ${data.length} participants');
        
        if (data.isEmpty) {
          print('[ChallengeService] ⚠️ Leaderboard is empty. This might be normal if no one has participated yet.');
          print('[ChallengeService] 💡 Tip: Check if the challenge has any participations with status TERMINE or VALIDE');
          return [];
        }
        
        final List<LeaderboardEntry> entries = [];
        for (var i = 0; i < data.length; i++) {
          final item = data[i];
          try {
            if (item is Map) {
              print('[ChallengeService] Leaderboard entry $i: eleveId=${item['eleveId']}, nom=${item['nom']}, prenom=${item['prenom']}, points=${item['points']}, rang=${item['rang']}');
            }
            
            final entry = LeaderboardEntry.fromJson(item as Map<String, dynamic>);
            print('[ChallengeService] ✅ Successfully created LeaderboardEntry: ${entry.fullName} (ID: ${entry.eleveId}, Points: ${entry.points}, Rang: ${entry.rang})');
            entries.add(entry);
          } catch (e, stackTrace) {
            print('[ChallengeService] ❌ Error deserializing leaderboard entry $i: $e');
            print('[ChallengeService] Stack trace: $stackTrace');
            print('[ChallengeService] Item data: $item');
          }
        }
        
        print('[ChallengeService] ✅ Successfully loaded ${entries.length} leaderboard entries out of ${data.length} items');
        // Les données sont déjà triées par le backend, mais on peut les trier à nouveau pour être sûr
        entries.sort((a, b) {
          // Trier par score décroissant, puis par temps croissant en cas d'égalité
          if (a.points != b.points) {
            return b.points.compareTo(a.points);
          }
          return a.tempsPasse.compareTo(b.tempsPasse);
        });
        return entries;
      } else {
        print('[ChallengeService] ⚠️ Unexpected status code: ${response.statusCode}');
        print('[ChallengeService] Response data: ${response.data}');
      }
    } catch (e) {
      print('[ChallengeService] Error fetching challenge leaderboard: $e');
      if (e is DioException) {
        print('[ChallengeService] DioException type: ${e.type}');
        print('[ChallengeService] DioException status: ${e.response?.statusCode}');
        print('[ChallengeService] DioException data: ${e.response?.data}');
        print('[ChallengeService] DioException request path: ${e.requestOptions.uri.path}');
      }
    }
    return [];
  }

  /// Récupérer les détails d'un challenge par ID
  Future<Challenge?> getChallengeDetails(int challengeId) async {
    try {
      final response = await _lveApi.getChallengeById2(id: challengeId);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error fetching challenge details: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching challenge details: $e');
    }
    return null;
  }
}