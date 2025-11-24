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
import 'package:built_collection/built_collection.dart';

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

  /// Récupérer les challenges disponibles pour un élève
  Future<BuiltList<Challenge>?> getChallengesDisponibles(int eleveId) async {
    try {
      print('Fetching challenges for student ID: $eleveId');
      final response = await _lveApi.getChallengesDisponibles(id: eleveId);
      print('API response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Successfully fetched challenges. Data length: ${response.data?.length ?? 0}');
        return response.data;
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
  Future<BuiltList<Participation>?> getChallengesParticipes(int eleveId) async {
    try {
      final response = await _lveApi.getChallengesParticipes(id: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error fetching participated challenges: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching participated challenges: $e');
    }
    return null;
  }

  /// Récupérer un challenge par ID avec tous les détails
  Future<Challenge?> getChallengeById(int challengeId) async {
    try {
      final response = await _lveApi.getChallengeById2(id: challengeId);
      if (response.statusCode == 200) {
        return response.data;
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
          if (errorString.contains('déjà participé') || errorString.contains('already participated')) {
            print('[ChallengeService] User has already participated in this challenge');
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
  /// Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
  Future<BuiltList<Participation>?> getChallengeLeaderboard(int challengeId) async {
    try {
      print('[ChallengeService] Fetching leaderboard for challenge $challengeId');
      
      // Configurer le BearerAuthInterceptor avec le token actuel
      _configureBearerAuth();
      
      // Vérifier que le token est présent
      final token = _authService.getAuthToken();
      if (token == null) {
        print('[ChallengeService] ERROR: No token found for leaderboard request!');
        return null;
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
      
      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          print('[ChallengeService] Leaderboard contains ${data.length} participants');
          
          final List<Participation> participations = [];
          for (var item in data) {
            try {
              // Log pour déboguer la structure des données
              if (item is Map) {
                print('[ChallengeService] Participation item keys: ${item.keys.toList()}');
                if (item.containsKey('eleve')) {
                  print('[ChallengeService] Eleve data: ${item['eleve']}');
                }
              }
              
              final participation = standardSerializers.deserializeWith(
                Participation.serializer, 
                item
              ) as Participation;
              
              // Vérifier que les données de l'élève sont présentes
              if (participation.eleve != null) {
                print('[ChallengeService] Participant: ${participation.eleve!.prenom} ${participation.eleve!.nom}, Score: ${participation.score}');
              } else {
                print('[ChallengeService] WARNING: Participation without eleve data: ID=${participation.id}');
              }
              
              participations.add(participation);
            } catch (e) {
              print('[ChallengeService] Error deserializing participation: $e');
              print('[ChallengeService] Item data: $item');
            }
          }
          
          print('[ChallengeService] Successfully loaded ${participations.length} participations');
          return BuiltList<Participation>(participations);
        } else {
          print('[ChallengeService] Unexpected response data type: ${response.data.runtimeType}');
        }
      } else {
        print('[ChallengeService] Unexpected status code: ${response.statusCode}');
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
    return null;
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