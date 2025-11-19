import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/challenges_api.dart';
import 'package:edugo/services/serializers.dart';
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
}