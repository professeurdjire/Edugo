import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/offline_cache_service.dart';
import 'package:edugo/services/connectivity_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:built_collection/built_collection.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  factory QuizService() => _instance;

  final AuthService _authService = AuthService();
  final OfflineCacheService _cacheService = OfflineCacheService();
  final ConnectivityService _connectivityService = ConnectivityService();
  late LveApi _lveApi;

  QuizService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
  }

  /// Récupérer les quiz disponibles pour un élève (avec support hors ligne)
  /// Endpoint: GET /api/eleves/{eleveId}/quizzes
  /// Note: baseUrl contains /api, so we need to add /api again for double /api
  /// 
  /// Note: The backend returns livreId directly, not a livre object.
  /// We need to create a minimal Livre object with just the ID for proper filtering.
  Future<BuiltList<Quiz>?> getQuizzesForEleve(int eleveId) async {
    // Vérifier la connectivité
    final isConnected = await _connectivityService.isConnected();
    
    // Si hors ligne, récupérer depuis le cache
    if (!isConnected) {
      print('[QuizService] Mode hors ligne - Récupération depuis le cache');
      final cachedQuizzes = await _cacheService.getCachedQuizzes(eleveId);
      if (cachedQuizzes != null && cachedQuizzes.isNotEmpty) {
        print('[QuizService] ✅ ${cachedQuizzes.length} quiz récupérés du cache');
        return cachedQuizzes;
      }
      print('[QuizService] ⚠️ Aucun quiz en cache disponible');
      return BuiltList<Quiz>([]);
    }
    
    // Si en ligne, récupérer depuis l'API et mettre en cache
    try {
      print('[QuizService] Fetching quizzes for student: $eleveId');
      print('[QuizService] Full URL will be: ${_authService.dio.options.baseUrl}/api/eleves/$eleveId/quizzes');
      // Using the endpoint: GET /api/eleves/{eleveId}/quizzes
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _authService.dio.get('/api/eleves/$eleveId/quizzes');
      
      print('[QuizService] Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        print('[QuizService] Received ${data.length} quizzes');
        
        final List<Quiz> quizzes = [];
        for (var item in data) {
          try {
            // The backend returns a simplified quiz structure with livreId directly
            // We need to create a minimal Livre object if livreId is present
            final livreId = item['livreId'] as int?;
            
            // Create a modified item with a livre object if livreId exists
            Map<String, dynamic> modifiedItem = Map<String, dynamic>.from(item);
            if (livreId != null) {
              // Create a minimal Livre object with just the ID
              modifiedItem['livre'] = {'id': livreId};
            }
            
            // The Quiz model will deserialize what it can and ignore the rest
            final quiz = standardSerializers.deserializeWith(Quiz.serializer, modifiedItem) as Quiz;
            quizzes.add(quiz);
            print('[QuizService] Successfully deserialized quiz ID: ${quiz.id}, livreId: ${livreId}, livre?.id: ${quiz.livre?.id}');
          } catch (e, stackTrace) {
            print('[QuizService] Error deserializing quiz item: $e');
            print('[QuizService] Stack trace: $stackTrace');
            print('[QuizService] Item data: $item');
            // Continue with next item
          }
        }
        
        final quizzesList = BuiltList<Quiz>(quizzes);
        
        // Mettre en cache pour usage hors ligne
        if (quizzes.isNotEmpty) {
          await _cacheService.cacheQuizzes(quizzesList, eleveId);
        }
        
        print('[QuizService] Successfully fetched ${quizzes.length} quizzes');
        return quizzesList;
      } else {
        print('[QuizService] Unexpected status code: ${response.statusCode}');
        print('[QuizService] Response data: ${response.data}');
      }
    } catch (e, stackTrace) {
      print('[QuizService] Error fetching quizzes for student: $e');
      print('[QuizService] Stack trace: $stackTrace');
      // En cas d'erreur, essayer de récupérer depuis le cache
      final cachedQuizzes = await _cacheService.getCachedQuizzes(eleveId);
      if (cachedQuizzes != null && cachedQuizzes.isNotEmpty) {
        print('[QuizService] ✅ Récupération depuis le cache après erreur');
        return cachedQuizzes;
      }
      if (e is DioException) {
        print('[QuizService] DioException type: ${e.type}');
        print('[QuizService] DioException response: ${e.response?.data}');
        print('[QuizService] DioException status code: ${e.response?.statusCode}');
        print('[QuizService] DioException request path: ${e.requestOptions.uri.path}');
        print('[QuizService] DioException request headers: ${e.requestOptions.headers}');
      } else {
        print('[QuizService] Error type: ${e.runtimeType}');
      }
    }
    return BuiltList<Quiz>([]);
  }

  /// Récupérer un quiz par ID avec tous les détails
  Future<Quiz?> getQuizById(int quizId) async {
    try {
      // Using the endpoint: GET /api/quizzes/{quizId}
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _authService.dio.get('/api/quizzes/$quizId');
      
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(Quiz.serializer, response.data) as Quiz;
      }
    } catch (e) {
      print('Error fetching quiz by ID: $e');
    }
    return null;
  }

  /// Soumettre les réponses d'un quiz
  Future<SubmitResultResponse?> submitQuizAnswers(int quizId, SubmitRequest submitRequest) async {
    try {
      // Using the endpoint: POST /api/quizzes/{quizId}/submit
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _authService.dio.post(
        '/api/quizzes/$quizId/submit',
        data: standardSerializers.serializeWith(SubmitRequest.serializer, submitRequest),
      );
      
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(SubmitResultResponse.serializer, response.data) as SubmitResultResponse;
      }
    } catch (e) {
      print('Error submitting quiz answers: $e');
    }
    return null;
  }
}