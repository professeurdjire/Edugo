import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/exercices_api.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:edugo/models/exercice_detail_response.dart';
import 'package:edugo/models/faire_exercice_response.dart';
import 'package:edugo/models/exercice_submission_request.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:built_collection/built_collection.dart';

class ExerciseService {
  static final ExerciseService _instance = ExerciseService._internal();
  factory ExerciseService() => _instance;

  final AuthService _authService = AuthService();
  late LveApi _lveApi;
  late ExercicesApi _exercicesApi;

  ExerciseService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
    _exercicesApi = ExercicesApi(_authService.dio, standardSerializers);
  }

  /// Récupérer les exercices disponibles pour un élève
  Future<BuiltList<ExerciceResponse>?> getExercicesDisponibles(int eleveId) async {
    try {
      final response = await _exercicesApi.getExercicesDisponibles(eleveId: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching available exercises: $e');
    }
    return null;
  }

  /// Récupérer les exercices par matière
  Future<BuiltList<ExerciceResponse>?> getExercicesByMatiere(int matiereId) async {
    try {
      final response = await _exercicesApi.getExercicesByMatiere1(matiereId: matiereId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching exercises by subject: $e');
    }
    return null;
  }

  /// Récupérer l'historique des exercices d'un élève
  Future<BuiltList<FaireExerciceResponse>?> getHistoriqueExercices(int eleveId) async {
    try {
      final response = await _exercicesApi.getHistoriqueExercices(eleveId: eleveId);
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
      final response = await _exercicesApi.getExerciceById(id: exerciceId);
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
      final response = await _exercicesApi.soumettreExercice(
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
      // Note: This would need to be implemented in the backend API
      // For now, we'll use a placeholder
      print('Method not implemented yet for submitting exercise answers (generic version)');
      return null;
    } catch (e) {
      print('Error submitting exercise answers (generic version): $e');
    }
    return null;
  }
}