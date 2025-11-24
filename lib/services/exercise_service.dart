import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/exercices_api.dart';
import 'package:edugo/services/offline_cache_service.dart';
import 'package:edugo/services/connectivity_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:edugo/models/exercice_detail_response.dart';
import 'package:edugo/models/exercice.dart';
import 'package:edugo/models/faire_exercice_response.dart';
import 'package:edugo/models/exercice_submission_request.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

class ExerciseService {
  static final ExerciseService _instance = ExerciseService._internal();
  factory ExerciseService() => _instance;

  final AuthService _authService = AuthService();
  final OfflineCacheService _cacheService = OfflineCacheService();
  final ConnectivityService _connectivityService = ConnectivityService();
  late LveApi _lveApi;
  late ExercicesApi _exercicesApi;

  ExerciseService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
    _exercicesApi = ExercicesApi(_authService.dio, standardSerializers);
  }

  /// Récupérer les exercices disponibles pour un élève (avec support hors ligne)
  /// Endpoint: GET /api/eleve/exercices/disponibles/{eleveId}
  Future<BuiltList<ExerciceResponse>?> getExercicesDisponibles(int eleveId) async {
    // Vérifier la connectivité
    final isConnected = await _connectivityService.isConnected();
    
    // Si hors ligne, récupérer depuis le cache
    if (!isConnected) {
      print('[ExerciseService] Mode hors ligne - Récupération depuis le cache');
      final cachedExercises = await _cacheService.getCachedExercises(eleveId);
      if (cachedExercises != null && cachedExercises.isNotEmpty) {
        print('[ExerciseService] ✅ ${cachedExercises.length} exercices récupérés du cache');
        return cachedExercises;
      }
      print('[ExerciseService] ⚠️ Aucun exercice en cache disponible');
      return BuiltList<ExerciceResponse>([]);
    }
    
    // Si en ligne, récupérer depuis l'API et mettre en cache
    try {
      // Utiliser directement l'endpoint /api/eleve/exercices/disponibles/{eleveId}
      print('[ExerciseService] Fetching exercises for student: $eleveId');
      final response = await _authService.dio.get(
        '/api/eleve/exercices/disponibles/$eleveId',
      );
      
      print('[ExerciseService] Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        print('[ExerciseService] Response data type: ${data.runtimeType}');
        if (data != null) {
          final exercises = standardSerializers.deserialize(
            data,
            specifiedType: const FullType(BuiltList, [FullType(ExerciceResponse)]),
          ) as BuiltList<ExerciceResponse>?;
          
          // Mettre en cache pour usage hors ligne
          if (exercises != null && exercises.isNotEmpty) {
            await _cacheService.cacheExercises(exercises, eleveId);
          }
          
          return exercises;
        }
      } else {
        print('[ExerciseService] Unexpected status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('[ExerciseService] Error fetching available exercises: $e');
      print('[ExerciseService] Stack trace: $stackTrace');
      // En cas d'erreur, essayer de récupérer depuis le cache
      final cachedExercises = await _cacheService.getCachedExercises(eleveId);
      if (cachedExercises != null && cachedExercises.isNotEmpty) {
        print('[ExerciseService] ✅ Récupération depuis le cache après erreur');
        return cachedExercises;
      }
      // Return empty list instead of null to prevent crashes
      return BuiltList<ExerciceResponse>([]);
    }
    return BuiltList<ExerciceResponse>([]);
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

  /// Récupérer les exercices par matière pour un élève spécifique
  Future<BuiltList<ExerciceResponse>?> getExercicesByMatiereForEleve(int eleveId, int matiereId) async {
    try {
      // Get all available exercises for the student
      final allExercises = await getExercicesDisponibles(eleveId);
      
      if (allExercises != null) {
        // Filter exercises to only include those for the specified subject
        final filteredExercises = allExercises.where((exercice) {
          return exercice.matiereId == matiereId;
        }).toList();
        
        return BuiltList<ExerciceResponse>(filteredExercises);
      }
    } catch (e) {
      print('Error fetching exercises by subject for student: $e');
    }
    return null;
  }

  /// Récupérer l'historique des exercices d'un élève
  /// Endpoint: GET /api/eleve/exercices/historique/{eleveId}
  Future<BuiltList<FaireExerciceResponse>?> getHistoriqueExercices(int eleveId) async {
    try {
      // Utiliser directement l'endpoint /api/eleve/exercices/historique/{eleveId}
      final response = await _authService.dio.get(
        '/api/eleve/exercices/historique/$eleveId',
      );
      
      if (response.statusCode == 200) {
        // Gérer le cas où la réponse est null ou une liste vide
        if (response.data == null) {
          return BuiltList<FaireExerciceResponse>([]);
        }
        
        // Si c'est une liste, la désérialiser
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          if (data.isEmpty) {
            return BuiltList<FaireExerciceResponse>([]);
          }
          
          // Désérialiser chaque élément individuellement
          final List<FaireExerciceResponse> historique = [];
          for (var item in data) {
            try {
              final faireExercice = standardSerializers.deserializeWith(
                FaireExerciceResponse.serializer,
                item,
              ) as FaireExerciceResponse;
              historique.add(faireExercice);
            } catch (e) {
              print('[ExerciseService] Error deserializing exercise history item: $e');
            }
          }
          
          return BuiltList<FaireExerciceResponse>(historique);
        } else {
          // Essayer de désérialiser comme BuiltList
          try {
            return standardSerializers.deserialize(
              response.data,
              specifiedType: const FullType(BuiltList, [FullType(FaireExerciceResponse)]),
            ) as BuiltList<FaireExerciceResponse>?;
          } catch (e) {
            print('[ExerciseService] Error deserializing exercise history as BuiltList: $e');
            return BuiltList<FaireExerciceResponse>([]);
          }
        }
      }
    } catch (e) {
      print('Error fetching exercise history: $e');
    }
    return null;
  }

  /// Récupérer un exercice par ID avec tous les détails
  /// Endpoint: GET /api/eleve/exercices/{exerciceId}
  Future<ExerciceDetailResponse?> getExerciceById(int exerciceId) async {
    try {
      // Utiliser directement l'endpoint /api/eleve/exercices/{exerciceId}
      final response = await _authService.dio.get(
        '/api/eleve/exercices/$exerciceId',
      );
      
      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(
          ExerciceDetailResponse.serializer,
          response.data,
        );
      }
    } catch (e) {
      print('Error fetching exercise by ID: $e');
    }
    return null;
  }

  /// Récupérer un exercice complet avec ses questions
  /// Endpoint: GET /api/exercices/{exerciceId} (retourne Exercice avec questionsExercice)
  Future<Exercice?> getExerciceWithQuestions(int exerciceId) async {
    try {
      // Essayer de récupérer l'exercice complet avec questions
      // Note: Cet endpoint peut retourner un Exercice complet au lieu d'ExerciceDetailResponse
      final response = await _authService.dio.get(
        '/api/exercices/$exerciceId',
      );
      
      if (response.statusCode == 200) {
        // Essayer de désérialiser comme Exercice (qui contient questionsExercice)
        try {
          return standardSerializers.deserializeWith(
            Exercice.serializer,
            response.data,
          ) as Exercice;
        } catch (e) {
          print('[ExerciseService] Response is not an Exercice, trying ExerciceDetailResponse: $e');
          // Si ça échoue, retourner null (l'endpoint retourne peut-être ExerciceDetailResponse)
          return null;
        }
      }
    } catch (e) {
      print('[ExerciseService] Error fetching exercise with questions: $e');
    }
    return null;
  }

  /// Soumettre les réponses d'un exercice
  /// Endpoint: POST /api/eleve/exercices/soumettre/{eleveId}/{exerciceId}
  /// Body: ExerciceSubmissionRequest { "reponse": "ma réponse" }
  Future<FaireExerciceResponse?> submitExerciceAnswers(int eleveId, int exerciceId, ExerciceSubmissionRequest submissionRequest) async {
    try {
      // Utiliser directement l'endpoint /api/eleve/exercices/soumettre/{eleveId}/{exerciceId}
      // Pour les exercices texte libre uniquement
      final response = await _authService.dio.post(
        '/api/eleve/exercices/soumettre/$eleveId/$exerciceId',
        data: standardSerializers.serialize(submissionRequest),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return standardSerializers.deserializeWith(
          FaireExerciceResponse.serializer,
          response.data,
        );
      }
    } catch (e) {
      print('Error submitting exercise answers: $e');
    }
    return null;
  }
  
  /// Soumettre les réponses d'un exercice avec une réponse simple (String)
  /// Endpoint: POST /api/eleve/exercices/soumettre/{eleveId}/{exerciceId}
  /// Body: { "reponse": "ma réponse" }
  Future<FaireExerciceResponse?> submitExerciceAnswer(int eleveId, int exerciceId, String reponse) async {
    try {
      // Créer la requête de soumission
      final submissionRequest = ExerciceSubmissionRequest((b) => b
        ..reponse = reponse
      );
      
      return await submitExerciceAnswers(eleveId, exerciceId, submissionRequest);
    } catch (e) {
      print('Error submitting exercise answer: $e');
      return null;
    }
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

  /// Récupérer les exercices par niveau de difficulté
  /// Endpoint: GET /api/exercices/difficulte/{niveauDifficulte}
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
  /// Endpoint: GET /api/exercices/livre/{livreId}
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
}