import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/exercices_api.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:edugo/models/exercice_detail_response.dart';
import 'package:edugo/models/faire_exercice_response.dart';
import 'package:built_collection/built_collection.dart';

class ExerciceService {
  static final ExerciceService _instance = ExerciceService._internal();
  factory ExerciceService() => _instance;

  final AuthService _authService = AuthService();
  late ExercicesApi _exercicesApi;

  ExerciceService._internal() {
    _exercicesApi = ExercicesApi(_authService.dio, standardSerializers);
  }

  /// Récupérer tous les exercices
  Future<BuiltList<ExerciceResponse>?> getAllExercices() async {
    try {
      final response = await _exercicesApi.getAllExercices();
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching all exercises: $e');
    }
    return null;
  }

  /// Récupérer un exercice par ID avec tous les détails
  Future<ExerciceDetailResponse?> getExerciceById(int id) async {
    try {
      final response = await _exercicesApi.getExerciceById(id: id);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching exercise by ID: $e');
    }
    return null;
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

  /// Récupérer les exercices par niveau de difficulté
  Future<BuiltList<ExerciceResponse>?> getExercicesByDifficulte(int niveauDifficulte) async {
    try {
      final response = await _exercicesApi.getExercicesByDifficulte(niveauDifficulte: niveauDifficulte);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching exercises by difficulty: $e');
    }
    return null;
  }

  /// Récupérer les exercices d'un livre
  Future<BuiltList<ExerciceResponse>?> getExercicesByLivre(int livreId) async {
    try {
      final response = await _exercicesApi.getExercicesByLivre(livreId: livreId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching exercises by book: $e');
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

  /// Récupérer un exercice réalisé
  Future<FaireExerciceResponse?> getExerciceRealise(int eleveId, int exerciceId) async {
    try {
      final response = await _exercicesApi.getExerciceRealise(eleveId: eleveId, exerciceId: exerciceId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching completed exercise: $e');
    }
    return null;
  }

  /// Soumettre un exercice
  Future<FaireExerciceResponse?> soumettreExercice(int eleveId, int exerciceId, Map<String, dynamic> answers) async {
    try {
      // Create an ExerciceSubmissionRequest from the answers
      // This is a simplified implementation - in a real app, you would need to create
      // a proper ExerciceSubmissionRequest object with the correct structure
      print('Submitting exercise $exerciceId for student $eleveId with answers: $answers');
      
      // For now, we'll return null as we don't have the complete data structure
      return null;
    } catch (e) {
      print('Error submitting exercise: $e');
      return null;
    }
  }

  /// Rechercher des exercices par titre
  Future<BuiltList<ExerciceResponse>?> searchExercicesByTitre(String titre) async {
    try {
      final response = await _exercicesApi.searchExercicesByTitre(titre: titre);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error searching exercises by title: $e');
    }
    return null;
  }
  
  /// Récupérer les détails d'un exercice par ID
  Future<ExerciceDetailResponse?> getExerciceDetails(int exerciceId) async {
    try {
      final response = await _exercicesApi.getExerciceById(id: exerciceId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching exercise details: $e');
    }
    return null;
  }
}
