import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/services/points_service.dart';
import 'package:edugo/services/badge_service.dart';
import 'package:edugo/models/submit_request.dart';
import 'package:edugo/models/submit_result_response.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_eleve.dart';
import 'package:built_collection/built_collection.dart';

/// Service unifié pour gérer les soumissions de quiz, exercices et challenges
/// Gère automatiquement les points et badges après soumission
class SubmissionService {
  static final SubmissionService _instance = SubmissionService._internal();
  factory SubmissionService() => _instance;

  final AuthService _authService = AuthService();
  final PointsService _pointsService = PointsService();
  final BadgeService _badgeService = BadgeService();

  SubmissionService._internal();

  /// Helper pour désérialiser SubmitResultResponse de manière robuste
  /// Gère les différents formats de réponse du backend
  SubmitResultResponse _deserializeSubmitResultResponse(dynamic responseData) {
    try {
      // Log pour debug
      print('[SubmissionService] Deserializing SubmitResultResponse...');
      print('[SubmissionService] Response data type: ${responseData.runtimeType}');
      print('[SubmissionService] Response data: $responseData');
      
      // Normaliser les données
      Map<String, dynamic> normalizedData;
      
      if (responseData is Map<String, dynamic>) {
        normalizedData = responseData;
      } else if (responseData is Map) {
        // Convertir Map<dynamic, dynamic> en Map<String, dynamic>
        normalizedData = Map<String, dynamic>.from(responseData);
      } else {
        print('[SubmissionService] ⚠️ Type inattendu: ${responseData.runtimeType}');
        throw Exception('Format de réponse inattendu: ${responseData.runtimeType}');
      }
      
      // S'assurer que les champs requis sont présents
      if (!normalizedData.containsKey('score')) {
        print('[SubmissionService] ⚠️ Champ "score" manquant dans la réponse');
        normalizedData['score'] = 0;
      }
      if (!normalizedData.containsKey('totalPoints')) {
        print('[SubmissionService] ⚠️ Champ "totalPoints" manquant dans la réponse');
        normalizedData['totalPoints'] = 0;
      }
      if (!normalizedData.containsKey('eleveId')) {
        print('[SubmissionService] ⚠️ Champ "eleveId" manquant dans la réponse');
      }
      if (!normalizedData.containsKey('details')) {
        print('[SubmissionService] ⚠️ Champ "details" manquant, initialisation avec liste vide');
        normalizedData['details'] = [];
      } else if (normalizedData['details'] is! List) {
        print('[SubmissionService] ⚠️ Champ "details" n\'est pas une liste, conversion...');
        normalizedData['details'] = [];
      }
      
      // Normaliser les détails si présents
      if (normalizedData['details'] is List) {
        final detailsList = normalizedData['details'] as List;
        normalizedData['details'] = detailsList.map((detail) {
          if (detail is Map<String, dynamic>) {
            return detail;
          } else if (detail is Map) {
            return Map<String, dynamic>.from(detail);
          } else {
            print('[SubmissionService] ⚠️ Détail invalide: $detail');
            return <String, dynamic>{};
          }
        }).toList();
      }
      
      // Désérialiser avec le sérialiseur
      final result = standardSerializers.deserializeWith(
        SubmitResultResponse.serializer,
        normalizedData,
      ) as SubmitResultResponse;
      
      print('[SubmissionService] ✅ Désérialisation réussie: score=${result.score}, totalPoints=${result.totalPoints}');
      return result;
    } catch (e, stackTrace) {
      print('[SubmissionService] ❌ Erreur lors de la désérialisation: $e');
      print('[SubmissionService] Stack trace: $stackTrace');
      print('[SubmissionService] Données reçues: $responseData');
      rethrow;
    }
  }

  /// Formater une réponse selon son type pour la soumission
  String _formatAnswerForSubmission(dynamic answer) {
    if (answer == null) return '';
    
    if (answer is List<int>) {
      // QCM: liste des IDs séparés par des virgules
      return answer.join(',');
    } else if (answer is int) {
      // Vrai/Faux: ID unique
      return answer.toString();
    } else if (answer is String) {
      // Réponse courte: texte direct
      return answer;
    } else if (answer is Map<int, int>) {
      // Appariement: format "leftId1:rightId1,leftId2:rightId2"
      return answer.entries.map((e) => '${e.key}:${e.value}').join(',');
    }
    
    return answer.toString();
  }

  /// Créer une SubmitRequest à partir des réponses sélectionnées
  SubmitRequest createSubmitRequest({
    required int eleveId,
    required Map<int, dynamic> selectedAnswers, // questionId -> answer
    required List<Question> questions,
  }) {
    final List<ReponseEleve> reponses = [];
    
    for (var entry in selectedAnswers.entries) {
      final questionId = entry.key;
      final answer = entry.value;
      
      // Formater la réponse selon son type
      final responseText = _formatAnswerForSubmission(answer);
      
      // Trouver la question correspondante
      final question = questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () => Question((b) => b..id = questionId),
      );
      
      reponses.add(
        ReponseEleve((b) => b
          ..question.replace(question)
          ..reponse = responseText
        )
      );
    }
    
    return SubmitRequest((b) => b
      ..eleveId = eleveId
      ..reponses.replace(BuiltList<ReponseEleve>(reponses))
    );
  }

  /// Créer le payload JSON selon le format attendu par le backend
  /// Format: { "eleveId": 7, "reponses": [{"questionId": 1, "reponseIds": [10]}] }
  /// Pour les réponses courtes, utiliser le format avec "reponse" (String)
  Map<String, dynamic> _createSubmissionPayload({
    required int eleveId,
    required Map<int, dynamic> selectedAnswers,
    required List<Question> questions,
  }) {
    final List<Map<String, dynamic>> reponses = [];
    
    for (var entry in selectedAnswers.entries) {
      final questionId = entry.key;
      final answer = entry.value;
      
      // Trouver la question pour déterminer son type
      final question = questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () => Question((b) => b..id = questionId),
      );
      
      final questionType = question.type?.libelleType?.toUpperCase() ?? '';
      final isReponseCourte = questionType.contains('COURT') || 
                              questionType.contains('TEXT') || 
                              questionType.contains('LIBRE');
      final isAppariement = questionType.contains('APPARIEMENT') || 
                           questionType.contains('MATCHING');
      
      if (isReponseCourte && answer is String) {
        // Pour les réponses courtes, utiliser le format avec "reponse" (String)
        reponses.add({
          'questionId': questionId,
          'reponse': answer,
        });
      } else if (isAppariement && answer is Map<int, int>) {
        // Pour les appariements, utiliser le format avec "appariements"
        final List<Map<String, int>> appariements = answer.entries.map((e) => {
          'leftId': e.key,
          'rightId': e.value,
        }).toList();
        reponses.add({
          'questionId': questionId,
          'appariements': appariements,
        });
      } else {
        // Pour QCM, QCU, VRAI_FAUX: utiliser reponseIds
        List<int> reponseIds = [];
        
        if (answer is List<int>) {
          // Déjà une liste d'IDs (QCM)
          reponseIds = answer;
        } else if (answer is int) {
          // Un seul ID (QCU/VRAI_FAUX)
          reponseIds = [answer];
        } else if (answer is List && answer.isNotEmpty) {
          // Liste d'autres types, convertir en int
          reponseIds = answer.map((e) => e as int).toList();
        } else if (answer is String) {
          // Si c'est une String mais pas une réponse courte, essayer de la parser
          try {
            reponseIds = [int.parse(answer)];
          } catch (e) {
            print('[SubmissionService] Warning: Cannot parse String answer "$answer" as int for question $questionId');
            continue;
          }
        } else {
          print('[SubmissionService] Warning: Unknown answer type for question $questionId: ${answer.runtimeType}');
          continue;
        }
        
        reponses.add({
          'questionId': questionId,
          'reponseIds': reponseIds,
        });
      }
    }
    
    print('[SubmissionService] Created submission payload with ${reponses.length} responses');
    
    return {
      'eleveId': eleveId,
      'reponses': reponses,
    };
  }

  /// Soumettre un quiz et mettre à jour les points/badges
  /// Endpoint: POST /api/quizzes/{quizId}/submit
  /// ⚠️ IMPORTANT: Les points doivent être ajoutés manuellement après soumission
  Future<SubmitResultResponse?> submitQuiz({
    required int quizId,
    required int eleveId,
    required Map<int, dynamic> selectedAnswers,
    required List<Question> questions,
  }) async {
    // Créer le payload selon le format attendu par le backend
    final payload = _createSubmissionPayload(
      eleveId: eleveId,
      selectedAnswers: selectedAnswers,
      questions: questions,
    );

    // Vérifier et s'assurer que le token est présent
    var token = _authService.getAuthToken();
    var authHeader = _authService.dio.options.headers['Authorization'];

    try {
      print('[SubmissionService] Submitting quiz $quizId with payload: $payload');
      
      // Si le token n'est pas présent, c'est une erreur critique
      if (token == null || token.isEmpty) {
        print('[SubmissionService] ❌ ERREUR CRITIQUE: No token found! User may not be logged in.');
        print('[SubmissionService] Headers globaux: ${_authService.dio.options.headers.keys}');
        throw Exception('Vous devez être connecté pour soumettre un quiz. Veuillez vous reconnecter.');
      }
      
      // S'assurer que le token est dans les headers globaux
      if (authHeader == null || authHeader.toString().isEmpty || !authHeader.toString().startsWith('Bearer ')) {
        _authService.setAuthToken(token);
        authHeader = _authService.dio.options.headers['Authorization'];
        print('[SubmissionService] Token ajouté aux headers globaux de Dio');
      }
      
      final url = '/api/quizzes/$quizId/submit';
      final fullUrl = '${_authService.dio.options.baseUrl}$url';
      print('[SubmissionService] ========== SOUMISSION QUIZ ==========');
      print('[SubmissionService] Endpoint: POST $url');
      print('[SubmissionService] Full URL: $fullUrl');
      print('[SubmissionService] Token présent: ${token != null ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "MISSING"}');
      print('[SubmissionService] Authorization header: ${authHeader != null ? "Present" : "MISSING"}');
      print('[SubmissionService] Payload: $payload');
      
      // S'assurer que le token est bien dans les headers avant la requête
      final currentToken = _authService.getAuthToken();
      if (currentToken != null && currentToken.isNotEmpty) {
        _authService.setAuthToken(currentToken);
      }
      
      // ⚠️ IMPORTANT: Ajouter explicitement le token dans les headers de la requête
      // L'intercepteur devrait le faire, mais on s'assure qu'il est présent
      final headers = <String, dynamic>{
        'Content-Type': 'application/json',
      };
      
      // Ajouter explicitement le token dans les headers
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        print('[SubmissionService] ✅ Token ajouté explicitement dans les headers de la requête');
      }
      
      final response = await _authService.dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Utiliser la fonction helper pour désérialiser de manière robuste
        final result = _deserializeSubmitResultResponse(response.data);

        print('[SubmissionService] ✅ Quiz soumis avec succès!');
        print('[SubmissionService] Score: ${result.score}/${result.totalPoints}');
        
        // ⚠️ IMPORTANT: Ajouter les points manuellement (le backend ne le fait pas automatiquement)
        if (result.score > 0) {
          final pointsAdded = await _pointsService.addPoints(eleveId, result.score);
          if (pointsAdded) {
            print('[SubmissionService] Successfully added ${result.score} points to student $eleveId');
          } else {
            print('[SubmissionService] Failed to add points to student $eleveId');
          }
        }
        
        // Rafraîchir les points pour obtenir le nouveau total
        await _pointsService.refreshPoints(eleveId);
        
        // Vérifier les badges
        await _badgeService.getBadges(eleveId);

        return result;
      } else {
        print('[SubmissionService] Unexpected status code: ${response.statusCode}');
        print('[SubmissionService] Response data: ${response.data}');
      }
    } catch (e) {
      print('[SubmissionService] Error submitting quiz: $e');
      if (e is DioException) {
        print('[SubmissionService] DioException type: ${e.type}');
        print('[SubmissionService] DioException status: ${e.response?.statusCode}');
        print('[SubmissionService] DioException data: ${e.response?.data}');
        print('[SubmissionService] DioException headers: ${e.response?.headers}');
        print('[SubmissionService] Request headers: ${e.requestOptions.headers}');
        print('[SubmissionService] Request URL: ${e.requestOptions.uri}');
        print('[SubmissionService] Request payload: $payload');
        
        // Analyser l'erreur pour fournir un message plus clair
        final errorData = e.response?.data;
        final statusCode = e.response?.statusCode;
        
        if (statusCode == 403) {
          print('[SubmissionService] ⚠️ 403 Forbidden - Analyse détaillée:');
          print('   URL: ${e.requestOptions.uri}');
          print('   Method: ${e.requestOptions.method}');
          print('   Headers envoyés: ${e.requestOptions.headers}');
          print('   Payload: $payload');
          print('   Réponse du serveur: ${errorData ?? "Aucune donnée"}');
          print('   Token présent: ${token != null ? "Oui" : "Non"}');
          print('   Token dans headers globaux: ${_authService.dio.options.headers.containsKey("Authorization") ? "Oui" : "Non"}');
          
          // Vérifier si c'est un problème de token ou de permissions
          final errorString = errorData?.toString().toLowerCase() ?? '';
          if (errorString.contains('token') || errorString.contains('expired') || errorString.contains('invalid')) {
            throw Exception('Token invalide ou expiré. Veuillez vous reconnecter.');
          } else if (errorString.contains('permission') || errorString.contains('forbidden') || errorString.contains('access denied')) {
            throw Exception('Accès refusé. Vous n\'avez pas les permissions nécessaires pour cette action.');
          } else {
            throw Exception('Accès refusé (403). Vérifiez que vous êtes connecté et que vous avez les permissions nécessaires.');
          }
        } else if (statusCode == 401) {
          print('[SubmissionService] ⚠️ 401 Unauthorized - Token invalide ou expiré');
          print('   Token présent: ${token != null ? "Oui" : "Non"}');
          throw Exception('Session expirée. Veuillez vous reconnecter.');
        } else if (errorData != null) {
          final errorString = errorData.toString().toLowerCase();
          print('[SubmissionService] Error message: $errorString');
          
          if (statusCode == 400) {
            print('[SubmissionService] ⚠️ 400 Bad Request - Format de données invalide');
            print('   Payload envoyé: $payload');
            throw Exception('Format de données invalide. Vérifiez vos réponses.');
          } else if (statusCode == 404) {
            print('[SubmissionService] ⚠️ 404 Not Found - Quiz introuvable');
            throw Exception('Quiz introuvable.');
          } else {
            throw Exception('Erreur ${statusCode}: ${errorString.length > 100 ? errorString.substring(0, 100) : errorString}');
          }
        } else {
          // Pas de données d'erreur, utiliser le message générique
          if (statusCode == 401) {
            throw Exception('Non autorisé. Veuillez vous reconnecter.');
          } else {
            throw Exception('Erreur lors de la soumission: ${e.message}');
          }
        }
      } else {
        throw Exception('Erreur inattendue: $e');
      }
    }
  }

  /// Soumettre un exercice avec questions structurées
  /// Endpoint: POST /api/exercices/{exerciceId}/submit
  /// ⚠️ IMPORTANT: Les points doivent être ajoutés manuellement après soumission
  Future<SubmitResultResponse?> submitExercise({
    required int exerciceId,
    required int eleveId,
    required Map<int, dynamic> selectedAnswers,
    required List<Question> questions,
  }) async {
    // Créer le payload selon le format attendu par le backend
    final payload = _createSubmissionPayload(
      eleveId: eleveId,
      selectedAnswers: selectedAnswers,
      questions: questions,
    );

    // Vérifier et s'assurer que le token est présent
    var token = _authService.getAuthToken();
    var authHeader = _authService.dio.options.headers['Authorization'];

    try {
      print('[SubmissionService] Submitting exercise $exerciceId with payload: $payload');
      
      // Si le token n'est pas présent, c'est une erreur critique
      if (token == null || token.isEmpty) {
        print('[SubmissionService] ❌ ERREUR CRITIQUE: No token found! User may not be logged in.');
        print('[SubmissionService] Headers globaux: ${_authService.dio.options.headers.keys}');
        throw Exception('Vous devez être connecté pour soumettre un exercice. Veuillez vous reconnecter.');
      }
      
      // S'assurer que le token est dans les headers globaux
      if (authHeader == null || authHeader.toString().isEmpty || !authHeader.toString().startsWith('Bearer ')) {
        _authService.setAuthToken(token);
        authHeader = _authService.dio.options.headers['Authorization'];
        print('[SubmissionService] Token ajouté aux headers globaux de Dio');
      }
      
      // S'assurer que le token est bien présent avant la requête
      final currentToken = _authService.getAuthToken();
      if (currentToken != null && currentToken.isNotEmpty) {
        _authService.setAuthToken(currentToken);
      }
      
      // Utiliser l'endpoint correct pour les exercices avec questions
      // POST /api/exercices/{exerciceId}/submit avec SubmitRequest
      final url = '/api/exercices/$exerciceId/submit';
      final fullUrl = '${_authService.dio.options.baseUrl}$url';
      print('[SubmissionService] ========== SOUMISSION EXERCICE ==========');
      print('[SubmissionService] Endpoint: POST $url');
      print('[SubmissionService] Full URL: $fullUrl');
      print('[SubmissionService] Token présent: ${token != null ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "MISSING"}');
      print('[SubmissionService] Authorization header: ${authHeader != null ? "Present" : "MISSING"}');
      print('[SubmissionService] Payload: $payload');
      
      // ⚠️ IMPORTANT: Ajouter explicitement le token dans les headers de la requête
      final headers = <String, dynamic>{
        'Content-Type': 'application/json',
      };
      
      // Ajouter explicitement le token dans les headers
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        print('[SubmissionService] ✅ Token ajouté explicitement dans les headers de la requête');
      }
      
      final response = await _authService.dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Utiliser la fonction helper pour désérialiser de manière robuste
        final result = _deserializeSubmitResultResponse(response.data);

        print('[SubmissionService] ✅ Exercice soumis avec succès!');
        print('[SubmissionService] Score: ${result.score}/${result.totalPoints}');
        
        // ⚠️ IMPORTANT: Ajouter les points manuellement (le backend ne le fait pas automatiquement)
        if (result.score > 0) {
          final pointsAdded = await _pointsService.addPoints(eleveId, result.score);
          if (pointsAdded) {
            print('[SubmissionService] Successfully added ${result.score} points to student $eleveId');
          } else {
            print('[SubmissionService] Failed to add points to student $eleveId');
          }
        }
        
        // Rafraîchir les points pour obtenir le nouveau total
        await _pointsService.refreshPoints(eleveId);
        
        // Vérifier les badges
        await _badgeService.getBadges(eleveId);

        return result;
      } else {
        print('[SubmissionService] Unexpected status code: ${response.statusCode}');
        print('[SubmissionService] Response data: ${response.data}');
      }
    } catch (e) {
      print('[SubmissionService] Error submitting exercise: $e');
      if (e is DioException) {
        print('[SubmissionService] DioException type: ${e.type}');
        print('[SubmissionService] DioException status: ${e.response?.statusCode}');
        print('[SubmissionService] DioException data: ${e.response?.data}');
        print('[SubmissionService] DioException headers: ${e.response?.headers}');
        print('[SubmissionService] Request headers: ${e.requestOptions.headers}');
        print('[SubmissionService] Request URL: ${e.requestOptions.uri}');
        print('[SubmissionService] Request payload: $payload');
        
        // Analyser l'erreur pour fournir un message plus clair
        final errorData = e.response?.data;
        if (errorData != null) {
          final errorString = errorData.toString().toLowerCase();
          print('[SubmissionService] Error message: $errorString');
          
          // Si c'est une erreur 403, essayer de rafraîchir le token
          if (e.response?.statusCode == 403) {
            print('[SubmissionService] ⚠️ 403 Forbidden - Tentative de rafraîchissement du token...');
            throw Exception('Accès refusé. Veuillez vous reconnecter et réessayer.');
          } else if (e.response?.statusCode == 401) {
            print('[SubmissionService] ⚠️ 401 Unauthorized - Token invalide ou expiré');
            throw Exception('Session expirée. Veuillez vous reconnecter.');
          } else if (e.response?.statusCode == 400) {
            print('[SubmissionService] ⚠️ 400 Bad Request - Format de données invalide');
            throw Exception('Format de données invalide. Vérifiez vos réponses.');
          } else if (e.response?.statusCode == 404) {
            print('[SubmissionService] ⚠️ 404 Not Found - Exercice introuvable');
            throw Exception('Exercice introuvable.');
          } else {
            throw Exception('Erreur ${e.response?.statusCode}: ${errorString.length > 100 ? errorString.substring(0, 100) : errorString}');
          }
        } else {
          // Pas de données d'erreur, utiliser le message générique
          if (e.response?.statusCode == 403) {
            throw Exception('Accès refusé. Vérifiez vos permissions.');
          } else if (e.response?.statusCode == 401) {
            throw Exception('Non autorisé. Veuillez vous reconnecter.');
          } else {
            throw Exception('Erreur lors de la soumission: ${e.message}');
          }
        }
      } else {
        throw Exception('Erreur inattendue: $e');
      }
    }
  }

  /// Soumettre un challenge
  /// Endpoint: POST /api/challenges/{challengeId}/submit
  /// ⚠️ IMPORTANT: Les points doivent être ajoutés manuellement après soumission
  Future<SubmitResultResponse?> submitChallenge({
    required int challengeId,
    required int eleveId,
    required Map<int, dynamic> selectedAnswers,
    required List<Question> questions,
  }) async {
    // Créer le payload selon le format attendu par le backend
    final payload = _createSubmissionPayload(
      eleveId: eleveId,
      selectedAnswers: selectedAnswers,
      questions: questions,
    );

    // Vérifier et s'assurer que le token est présent
    var token = _authService.getAuthToken();
    var authHeader = _authService.dio.options.headers['Authorization'];

    try {
      print('[SubmissionService] Submitting challenge $challengeId with payload: $payload');
      
      // Si le token n'est pas présent, c'est une erreur critique
      if (token == null || token.isEmpty) {
        print('[SubmissionService] ❌ ERREUR CRITIQUE: No token found! User may not be logged in.');
        print('[SubmissionService] Headers globaux: ${_authService.dio.options.headers.keys}');
        throw Exception('Vous devez être connecté pour soumettre un challenge. Veuillez vous reconnecter.');
      }
      
      // S'assurer que le token est dans les headers globaux
      if (authHeader == null || authHeader.toString().isEmpty || !authHeader.toString().startsWith('Bearer ')) {
        _authService.setAuthToken(token);
        authHeader = _authService.dio.options.headers['Authorization'];
        print('[SubmissionService] Token ajouté aux headers globaux de Dio');
      }
      
      // S'assurer que le token est bien présent avant la requête
      final currentToken = _authService.getAuthToken();
      if (currentToken != null && currentToken.isNotEmpty) {
        _authService.setAuthToken(currentToken);
      }
      
      final url = '/api/challenges/$challengeId/submit';
      final fullUrl = '${_authService.dio.options.baseUrl}$url';
      print('[SubmissionService] ========== SOUMISSION CHALLENGE ==========');
      print('[SubmissionService] Endpoint: POST $url');
      print('[SubmissionService] Full URL: $fullUrl');
      print('[SubmissionService] Token présent: ${token != null ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "MISSING"}');
      print('[SubmissionService] Authorization header: ${authHeader != null ? "Present" : "MISSING"}');
      print('[SubmissionService] Payload: $payload');
      
      // ⚠️ IMPORTANT: Ajouter explicitement le token dans les headers de la requête
      final headers = <String, dynamic>{
        'Content-Type': 'application/json',
      };
      
      // Ajouter explicitement le token dans les headers
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        print('[SubmissionService] ✅ Token ajouté explicitement dans les headers de la requête');
      }
      
      final response = await _authService.dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Utiliser la fonction helper pour désérialiser de manière robuste
        final result = _deserializeSubmitResultResponse(response.data);

        print('[SubmissionService] ✅ Challenge soumis avec succès!');
        print('[SubmissionService] Score: ${result.score}/${result.totalPoints}');
        
        // ⚠️ IMPORTANT: Pour les challenges, le backend ajoute automatiquement les points
        // Le calcul des points dépend du pourcentage de réussite ET du classement (rang)
        // Points de base selon le pourcentage:
        // - 90%+ : 100% des points du challenge
        // - 80-89% : 80% des points du challenge
        // - 70-79% : 60% des points du challenge
        // - 50-69% : 40% des points du challenge
        // - <50% : 0 points
        // Bonus de classement (Top 3):
        // - 1er : +50% des points du challenge
        // - 2ème : +33% des points du challenge
        // - 3ème : +25% des points du challenge
        // Les points sont ajoutés automatiquement, pas besoin d'appeler addPoints manuellement
        
        // Rafraîchir les points pour obtenir le nouveau total
        await _pointsService.refreshPoints(eleveId);
        
        // Vérifier les badges (attribués automatiquement si pourcentage >= 80%)
        await _badgeService.getBadges(eleveId);

        return result;
      } else {
        print('[SubmissionService] Unexpected status code: ${response.statusCode}');
        print('[SubmissionService] Response data: ${response.data}');
      }
    } catch (e) {
      print('[SubmissionService] Error submitting challenge: $e');
      if (e is DioException) {
        print('[SubmissionService] DioException type: ${e.type}');
        print('[SubmissionService] DioException status: ${e.response?.statusCode}');
        print('[SubmissionService] DioException data: ${e.response?.data}');
        print('[SubmissionService] DioException headers: ${e.response?.headers}');
        print('[SubmissionService] Request headers: ${e.requestOptions.headers}');
        print('[SubmissionService] Request URL: ${e.requestOptions.uri}');
        
        // Analyser l'erreur pour fournir un message plus clair
        final errorData = e.response?.data;
        final statusCode = e.response?.statusCode;
        
        if (statusCode == 403) {
          print('[SubmissionService] ⚠️ 403 Forbidden - Analyse détaillée:');
          print('   URL: ${e.requestOptions.uri}');
          print('   Method: ${e.requestOptions.method}');
          print('   Headers envoyés: ${e.requestOptions.headers}');
          print('   Payload: $payload');
          print('   Réponse du serveur: ${errorData ?? "Aucune donnée"}');
          print('   Token présent: ${token != null ? "Oui" : "Non"}');
          print('   Token dans headers globaux: ${_authService.dio.options.headers.containsKey("Authorization") ? "Oui" : "Non"}');
          print('[SubmissionService] Vérifiez:');
          print('   1. Le token JWT est valide et non expiré');
          print('   2. L\'utilisateur a les permissions nécessaires (rôle ELEVE)');
          print('   3. Le backend autorise ces endpoints pour les élèves');
          print('   4. L\'élève a bien participé au challenge avant de soumettre');
          
          final errorString = errorData?.toString().toLowerCase() ?? '';
          if (errorString.contains('token') || errorString.contains('expired') || errorString.contains('invalid')) {
            throw Exception('Token invalide ou expiré. Veuillez vous reconnecter.');
          } else if (errorString.contains('permission') || errorString.contains('forbidden') || errorString.contains('access denied')) {
            throw Exception('Accès refusé. Vous n\'avez pas les permissions nécessaires pour cette action.');
          } else {
            throw Exception('Accès refusé (403). Vérifiez que vous êtes connecté et que vous avez les permissions nécessaires.');
          }
        } else if (statusCode == 401) {
          print('[SubmissionService] ⚠️ 401 Unauthorized - Token invalide ou expiré');
          throw Exception('Session expirée. Veuillez vous reconnecter.');
        } else if (errorData != null) {
          final errorString = errorData.toString().toLowerCase();
          if (statusCode == 400) {
            throw Exception('Format de données invalide. Vérifiez vos réponses.');
          } else if (statusCode == 404) {
            throw Exception('Challenge introuvable.');
          } else {
            throw Exception('Erreur ${statusCode}: ${errorString.length > 100 ? errorString.substring(0, 100) : errorString}');
          }
        } else {
          throw Exception('Erreur lors de la soumission du challenge: ${e.message}');
        }
      } else {
        throw Exception('Erreur inattendue: $e');
      }
    }
    return null;
  }

  /// Soumettre les réponses d'un défi
  /// Endpoint: POST /api/defis/{defiId}/submit (ou similaire)
  Future<SubmitResultResponse?> submitDefi({
    required int defiId,
    required int eleveId,
    required Map<int, dynamic> selectedAnswers,
    required List<Question> questions,
  }) async {
    // Créer le payload selon le format attendu par le backend
    final payload = _createSubmissionPayload(
      eleveId: eleveId,
      selectedAnswers: selectedAnswers,
      questions: questions,
    );

    // Vérifier et s'assurer que le token est présent
    var token = _authService.getAuthToken();
    var authHeader = _authService.dio.options.headers['Authorization'];

    try {
      print('[SubmissionService] Submitting defi $defiId with payload: $payload');
      
      // Si le token n'est pas présent, c'est une erreur critique
      if (token == null || token.isEmpty) {
        print('[SubmissionService] ❌ ERREUR CRITIQUE: No token found! User may not be logged in.');
        print('[SubmissionService] Headers globaux: ${_authService.dio.options.headers.keys}');
        throw Exception('Vous devez être connecté pour soumettre un défi. Veuillez vous reconnecter.');
      }
      
      // S'assurer que le token est dans les headers globaux
      if (authHeader == null || authHeader.toString().isEmpty || !authHeader.toString().startsWith('Bearer ')) {
        _authService.setAuthToken(token);
        authHeader = _authService.dio.options.headers['Authorization'];
        print('[SubmissionService] Token ajouté aux headers globaux de Dio');
      }
      
      // Essayer plusieurs endpoints possibles pour la soumission de défis
      final urls = [
        '/api/defis/$defiId/submit',
        '/api/eleve/defis/$defiId/submit',
        '/api/defis/soumettre/$eleveId/$defiId',
      ];
      
      SubmitResultResponse? result;
      Object? lastError;
      
      for (final url in urls) {
        try {
          print('[SubmissionService] Trying endpoint: ${_authService.dio.options.baseUrl}$url');
          print('[SubmissionService] Token présent: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
          print('[SubmissionService] Authorization header: ${authHeader != null ? "Present" : "MISSING"}');
          
          final response = await _authService.dio.post(
            url,
            data: payload,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                // Le token sera ajouté automatiquement par l'intercepteur
              },
            ),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Utiliser la fonction helper pour désérialiser de manière robuste
            result = _deserializeSubmitResultResponse(response.data);

            print('[SubmissionService] Defi submitted successfully. Score: ${result.score}/${result.totalPoints}');
            
            // Pour les défis, le backend peut ajouter automatiquement les points
            // Rafraîchir les points pour obtenir le nouveau total
            await _pointsService.refreshPoints(eleveId);
            
            // Vérifier les badges
            await _badgeService.getBadges(eleveId);

            return result;
          }
        } catch (e) {
          print('[SubmissionService] Endpoint $url failed: $e');
          if (e is DioException) {
            final statusCode = e.response?.statusCode;
            print('[SubmissionService] Endpoint $url returned status: $statusCode');
            
            // Si c'est une 403, vérifier le token et essayer de le rafraîchir
            if (statusCode == 403) {
              print('[SubmissionService] ⚠️ 403 Forbidden pour endpoint $url');
              print('[SubmissionService] Vérification du token...');
              
              // Vérifier que le token est toujours présent
              final currentToken = _authService.getAuthToken();
              if (currentToken == null || currentToken.isEmpty) {
                print('[SubmissionService] ❌ Token manquant! Impossible de continuer.');
                lastError = e;
                break; // Pas de token, arrêter
              }
              
              // Réessayer avec le token rafraîchi
              _authService.setAuthToken(currentToken);
              print('[SubmissionService] Token rafraîchi, mais 403 persiste. Vérifiez les permissions backend.');
              lastError = e;
              // Ne pas break, continuer avec les autres endpoints
            } else if (statusCode != 404) {
              // Pour les autres erreurs (sauf 404), arrêter
              lastError = e;
              break;
            } else {
              // 404, continuer avec le prochain endpoint
              lastError = e;
            }
          } else {
            lastError = e;
          }
        }
      }
      
      // Si tous les endpoints ont échoué
      if (lastError != null) {
        throw lastError;
      }
    } catch (e) {
      print('[SubmissionService] Error submitting defi: $e');
      if (e is DioException) {
        print('[SubmissionService] DioException type: ${e.type}');
        print('[SubmissionService] DioException status: ${e.response?.statusCode}');
        print('[SubmissionService] DioException data: ${e.response?.data}');
        print('[SubmissionService] Request headers: ${e.requestOptions.headers}');
        print('[SubmissionService] Request URL: ${e.requestOptions.uri}');
        
        final errorData = e.response?.data;
        final statusCode = e.response?.statusCode;
        
        if (statusCode == 403) {
          print('[SubmissionService] ⚠️ 403 Forbidden');
          if (errorData != null) {
            print('[SubmissionService] Error data: $errorData');
          }
          throw Exception('Accès refusé (403). Vérifiez que vous êtes connecté et que vous avez les permissions nécessaires.');
        } else if (statusCode == 401) {
          throw Exception('Session expirée. Veuillez vous reconnecter.');
        } else if (statusCode == 404) {
          throw Exception('Endpoint de soumission de défi introuvable. Veuillez contacter le support.');
        } else {
          throw Exception('Erreur lors de la soumission du défi: ${e.message}');
        }
      } else if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Erreur inattendue: $e');
      }
    }
    return null;
  }

  /// Valider les réponses avant soumission
  /// Vérifie que toutes les questions obligatoires ont été répondues
  bool validateAnswers({
    required List<Question> questions,
    required Map<int, dynamic> selectedAnswers,
  }) {
    for (var question in questions) {
      if (question.id == null) continue;
      
      // Vérifier si la question a une réponse
      if (!selectedAnswers.containsKey(question.id!)) {
        return false; // Question non répondue
      }
      
      final answer = selectedAnswers[question.id!];
      
      // Vérifier que la réponse n'est pas vide
      if (answer == null) return false;
      if (answer is String && answer.trim().isEmpty) return false;
      if (answer is List && answer.isEmpty) return false;
      if (answer is Map && answer.isEmpty) return false;
    }
    
    return true;
  }
}

