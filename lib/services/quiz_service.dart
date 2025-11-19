import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:built_collection/built_collection.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  factory QuizService() => _instance;

  final AuthService _authService = AuthService();
  late LveApi _lveApi;

  QuizService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
  }

  /// Récupérer les quiz disponibles pour un élève
  Future<BuiltList<Quiz>?> getQuizzesForEleve(int eleveId) async {
    try {
      // Using the endpoint: GET /eleves/{eleveId}/quizzes
      final response = await _authService.dio.get('/api/eleves/$eleveId/quizzes');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        final List<Quiz> quizzes = data.map((item) {
          return standardSerializers.deserializeWith(Quiz.serializer, item) as Quiz;
        }).toList();
        
        return BuiltList<Quiz>(quizzes);
      }
    } catch (e) {
      print('Error fetching quizzes for student: $e');
    }
    return null;
  }

  /// Récupérer un quiz par ID avec tous les détails
  Future<Quiz?> getQuizById(int quizId) async {
    try {
      // Using the endpoint: GET /quizzes/{quizId}
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
      // Using the endpoint: POST /quizzes/{quizId}/submit
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