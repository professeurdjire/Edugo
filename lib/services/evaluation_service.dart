import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/challenges_api.dart';
import 'package:edugo/services/api/exercices_api.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:edugo/models/exercice_detail_response.dart';
import 'package:edugo/models/participation.dart';
import 'package:edugo/models/faire_exercice_response.dart';
import 'package:edugo/models/exercice_submission_request.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';

class EvaluationService {
  static final EvaluationService _instance = EvaluationService._internal();
  factory EvaluationService() => _instance;

  final AuthService _authService = AuthService();
  late LveApi _lveApi;
  late ChallengesApi _challengesApi;
  late ExercicesApi _exercicesApi;

  EvaluationService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
    _challengesApi = ChallengesApi(_authService.dio, standardSerializers);
    _exercicesApi = ExercicesApi(_authService.dio, standardSerializers);
  }

  // === QUIZ METHODS ===
  
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

  // === CHALLENGE METHODS ===
  
  /// Récupérer les challenges disponibles pour un élève
  Future<BuiltList<Challenge>?> getChallengesDisponibles(int eleveId) async {
    try {
      final response = await _lveApi.getChallengesDisponibles(id: eleveId);
      if (response.statusCode == 200) {
        return response.data;
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
      }
    } catch (e) {
      print('Error fetching challenge by ID: $e');
    }
    return null;
  }

  /// Participer à un challenge
  Future<Participation?> participerChallenge(int eleveId, int challengeId) async {
    try {
      final response = await _challengesApi.participerChallenge1(
        eleveId: eleveId,
        challengeId: challengeId,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error participating in challenge: $e');
    }
    return null;
  }

  /// Soumettre les réponses d'un challenge
  Future<SubmitResultResponse?> submitChallengeAnswers(int challengeId, SubmitRequest submitRequest) async {
    try {
      // Using the endpoint: POST /challenges/{challengeId}/submit
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
  Future<BuiltList<Participation>?> getChallengeLeaderboard(int challengeId) async {
    try {
      // Using the endpoint: GET /challenges/{challengeId}/leaderboard
      final response = await _authService.dio.get('/api/challenges/$challengeId/leaderboard');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        final List<Participation> participations = data.map((item) {
          return standardSerializers.deserializeWith(Participation.serializer, item) as Participation;
        }).toList();
        
        return BuiltList<Participation>(participations);
      }
    } catch (e) {
      print('Error fetching challenge leaderboard: $e');
    }
    return null;
  }

  // === EXERCISE METHODS ===
  
  /// Récupérer les exercices disponibles pour un élève
  Future<BuiltList<ExerciceResponse>?> getExercicesDisponibles(int eleveId) async {
    try {
      final response = await _lveApi.getExercicesDisponibles1(id: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching available exercises: $e');
    }
    return null;
  }

  /// Récupérer l'historique des exercices d'un élève
  Future<BuiltList<FaireExerciceResponse>?> getHistoriqueExercices(int eleveId) async {
    try {
      final response = await _lveApi.getHistoriqueExercices1(id: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching exercise history: $e');
    }
    return null;
  }

  /// Récupérer un exercice par ID avec tous les détails
  Future<ExerciceDetailResponse?> getExerciceById(int exerciceId) async {
    try {
      final response = await _lveApi.getExerciceById2(id: exerciceId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching exercise by ID: $e');
    }
    return null;
  }

  /// Soumettre les réponses d'un exercice
  Future<FaireExerciceResponse?> submitExerciceAnswers(int eleveId, int exerciceId, ExerciceSubmissionRequest submissionRequest) async {
    try {
      final response = await _lveApi.soumettreExercice1(
        eleveId: eleveId,
        exerciceId: exerciceId,
        exerciceSubmissionRequest: submissionRequest,
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error submitting exercise answers: $e');
    }
    return null;
  }

  /// Soumettre les réponses d'un exercice (version générique)
  Future<SubmitResultResponse?> submitExerciceAnswersGeneric(int exerciceId, SubmitRequest submitRequest) async {
    try {
      // Using the endpoint: POST /exercices/{exerciceId}/submit
      final response = await _authService.dio.post(
        '/api/exercices/$exerciceId/submit',
        data: standardSerializers.serializeWith(SubmitRequest.serializer, submitRequest),
      );
      
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(SubmitResultResponse.serializer, response.data) as SubmitResultResponse;
      }
    } catch (e) {
      print('Error submitting exercise answers (generic version): $e');
    }
    return null;
  }
}