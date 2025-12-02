import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/type_question.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

/// Service pour récupérer les questions depuis les nouveaux endpoints
/// Endpoints: /api/questions/by-quiz/{quizId}, /api/questions/by-exercices/{exerciceId}, etc.
class QuestionService {
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;

  final AuthService _authService = AuthService();
  
  // Stockage des métadonnées d'appariement par ID de réponse
  // Map<reponseId, Map<colonne, idAssocie>>
  static final Map<int, Map<String, dynamic>> _matchingMetadata = {};

  QuestionService._internal();
  
  /// Récupérer les métadonnées d'appariement pour une réponse
  static Map<String, dynamic>? getMatchingMetadata(int reponseId) {
    return _matchingMetadata[reponseId];
  }
  
  /// Nettoyer les métadonnées (utile pour libérer la mémoire)
  static void clearMatchingMetadata() {
    _matchingMetadata.clear();
  }

  /// Normaliser les données d'une question avant désérialisation
  /// Le backend retourne:
  /// - type: "VRAI_FAUX" (String) au lieu d'un objet TypeQuestion
  /// - intitule au lieu de enonce
  /// - libelle au lieu de libelleReponse dans reponsesPossibles
  Map<String, dynamic> _normalizeQuestionData(Map<String, dynamic> item) {
    final normalized = Map<String, dynamic>.from(item);
    
    print('[QuestionService] Normalizing question data: ${item['id']}, type=${item['type']}, intitule=${item['intitule']}');
    
    // Convertir intitule en enonce si présent
    if (normalized.containsKey('intitule') && !normalized.containsKey('enonce')) {
      normalized['enonce'] = normalized['intitule'];
      print('[QuestionService] Converted intitule to enonce: ${normalized['enonce']}');
    }
    
    // Convertir type (String) en objet TypeQuestion
    // Le serializer de TypeQuestion attend un Iterable<Object?> (format de liste plate)
    // Mais StandardJsonPlugin devrait convertir automatiquement un Map en format de liste plate
    if (normalized.containsKey('type')) {
      final typeValue = normalized['type'];
      if (typeValue is String) {
        // Créer un Map qui sera converti en format de liste plate par StandardJsonPlugin
        // Le format attendu est une liste plate: ['libelleType', 'VRAI_FAUX']
        // Mais StandardJsonPlugin convertit automatiquement un Map en format de liste plate
        normalized['type'] = {'libelleType': typeValue};
        print('[QuestionService] Converted type String to TypeQuestion Map: $typeValue');
      } else if (typeValue is Map) {
        // Déjà un Map, vérifier qu'il a libelleType
        final typeMap = typeValue as Map<String, dynamic>;
        if (!typeMap.containsKey('libelleType')) {
          if (typeMap.containsKey('type')) {
            typeMap['libelleType'] = typeMap['type'];
          } else {
            // Si aucun champ valide, utiliser une valeur par défaut
            typeMap['libelleType'] = typeValue.toString();
          }
        }
        normalized['type'] = typeMap;
        print('[QuestionService] Normalized type Map: ${typeMap['libelleType']}');
      } else if (typeValue is List) {
        // Déjà en format de liste plate, le laisser tel quel
        print('[QuestionService] Type already in list format: $typeValue');
      }
    }
    
    // Normaliser reponsesPossibles si présent
    if (normalized.containsKey('reponsesPossibles') && normalized['reponsesPossibles'] is List) {
      final reponses = (normalized['reponsesPossibles'] as List).map((r) {
        if (r is Map<String, dynamic>) {
          final reponse = Map<String, dynamic>.from(r);
          // Convertir libelle en libelleReponse si nécessaire
          if (reponse.containsKey('libelle') && !reponse.containsKey('libelleReponse')) {
            reponse['libelleReponse'] = reponse['libelle'];
          }
          // Préserver colonne et idAssocie pour les questions d'appariement
          // Stocker ces métadonnées dans une Map statique accessible par ID de réponse
          final reponseId = reponse['id'] as int?;
          final libelle = reponse['libelle'] ?? reponse['libelleReponse'] ?? 'Sans libellé';
          
          if (reponseId != null) {
            // Extraire colonne et idAssocie depuis les données brutes
            final colonne = reponse['colonne'] as String?;
            final idAssocie = reponse['idAssocie'] as int?;
            
            // Toujours stocker les métadonnées, même si elles sont null
            _matchingMetadata[reponseId] = {
              'colonne': colonne,
              'idAssocie': idAssocie,
            };
            
            if (colonne != null || idAssocie != null) {
              print('[QuestionService] ✅ Stored matching metadata for reponse $reponseId: colonne=$colonne, idAssocie=$idAssocie, libelle="$libelle"');
            } else {
              print('[QuestionService] ⚠️ No colonne/idAssocie for reponse $reponseId, libelle="$libelle"');
              // Afficher toutes les clés disponibles pour déboguer
              print('[QuestionService] Available keys in reponse: ${reponse.keys.toList()}');
            }
          } else {
            print('[QuestionService] ⚠️ No ID found for reponse with libelle="$libelle"');
          }
          return reponse;
        }
        return r;
      }).toList();
      normalized['reponsesPossibles'] = reponses;
      print('[QuestionService] Normalized ${reponses.length} reponsesPossibles');
    }
    
    print('[QuestionService] Normalized data: enonce=${normalized['enonce']}, type=${normalized['type']}');
    
    return normalized;
  }

  /// Récupérer les questions d'un quiz
  /// Endpoint: GET /api/questions/by-quiz/{quizId}
  /// Note: Le backend masque automatiquement estCorrecte pour les élèves
  Future<BuiltList<Question>?> getQuestionsByQuiz(int quizId) async {
    try {
      print('[QuestionService] Fetching questions for quiz: $quizId');
      final response = await _authService.dio.get('/api/questions/by-quiz/$quizId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        print('[QuestionService] Received ${data.length} questions for quiz $quizId');
        
        final List<Question> questions = [];
        for (var item in data) {
          try {
            // Normaliser les données avant désérialisation
            final normalizedItem = item is Map<String, dynamic> 
                ? _normalizeQuestionData(item)
                : item;
            
            // Désérialiser manuellement le TypeQuestion si nécessaire
            if (normalizedItem is Map<String, dynamic> && normalizedItem.containsKey('type')) {
              final typeValue = normalizedItem['type'];
              if (typeValue is Map<String, dynamic>) {
                // Désérialiser le TypeQuestion séparément
                try {
                  final typeQuestion = standardSerializers.deserializeWith(
                    TypeQuestion.serializer,
                    typeValue,
                  ) as TypeQuestion;
                  // Remplacer le Map par l'objet TypeQuestion sérialisé en format de liste plate
                  normalizedItem['type'] = standardSerializers.serializeWith(
                    TypeQuestion.serializer,
                    typeQuestion,
                  );
                  print('[QuestionService] Manually deserialized TypeQuestion: ${typeQuestion.libelleType}');
                } catch (e) {
                  print('[QuestionService] Error deserializing TypeQuestion separately: $e');
                  // Si la désérialisation échoue, essayer avec le format de liste plate
                  if (typeValue.containsKey('libelleType')) {
                    normalizedItem['type'] = ['libelleType', typeValue['libelleType']];
                  }
                }
              } else if (typeValue is String) {
                // Convertir String en format de liste plate
                normalizedItem['type'] = ['libelleType', typeValue];
              }
            }
            
            final question = standardSerializers.deserializeWith(
              Question.serializer,
              normalizedItem,
            ) as Question;
            questions.add(question);
            print('[QuestionService] Successfully deserialized question ID: ${question.id}, type: ${question.type?.libelleType}');
          } catch (e, stackTrace) {
            print('[QuestionService] Error deserializing question: $e');
            print('[QuestionService] Stack trace: $stackTrace');
            print('[QuestionService] Item data: $item');
          }
        }
        
        return BuiltList<Question>(questions);
      }
    } catch (e) {
      print('[QuestionService] Error fetching questions by quiz: $e');
    }
    return null;
  }

  /// Récupérer les questions d'un exercice
  /// Endpoint: GET /api/questions/by-exercices/{exerciceId}
  /// Note: Le backend masque automatiquement estCorrecte pour les élèves
  Future<BuiltList<Question>?> getQuestionsByExercice(int exerciceId) async {
    try {
      print('[QuestionService] Fetching questions for exercice: $exerciceId');
      final response = await _authService.dio.get('/api/questions/by-exercices/$exerciceId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        print('[QuestionService] Received ${data.length} questions for exercice $exerciceId');
        
        final List<Question> questions = [];
        for (var item in data) {
          try {
            // Normaliser les données avant désérialisation
            final normalizedItem = item is Map<String, dynamic> 
                ? _normalizeQuestionData(item)
                : item;
            
            // Désérialiser manuellement le TypeQuestion si nécessaire
            if (normalizedItem is Map<String, dynamic> && normalizedItem.containsKey('type')) {
              final typeValue = normalizedItem['type'];
              if (typeValue is Map<String, dynamic>) {
                // Désérialiser le TypeQuestion séparément
                try {
                  final typeQuestion = standardSerializers.deserializeWith(
                    TypeQuestion.serializer,
                    typeValue,
                  ) as TypeQuestion;
                  // Remplacer le Map par l'objet TypeQuestion sérialisé en format de liste plate
                  normalizedItem['type'] = standardSerializers.serializeWith(
                    TypeQuestion.serializer,
                    typeQuestion,
                  );
                  print('[QuestionService] Manually deserialized TypeQuestion: ${typeQuestion.libelleType}');
                } catch (e) {
                  print('[QuestionService] Error deserializing TypeQuestion separately: $e');
                  // Si la désérialisation échoue, essayer avec le format de liste plate
                  if (typeValue.containsKey('libelleType')) {
                    normalizedItem['type'] = ['libelleType', typeValue['libelleType']];
                  }
                }
              } else if (typeValue is String) {
                // Convertir String en format de liste plate
                normalizedItem['type'] = ['libelleType', typeValue];
              }
            }
            
            final question = standardSerializers.deserializeWith(
              Question.serializer,
              normalizedItem,
            ) as Question;
            questions.add(question);
            print('[QuestionService] Successfully deserialized question ID: ${question.id}, type: ${question.type?.libelleType}');
          } catch (e, stackTrace) {
            print('[QuestionService] Error deserializing question: $e');
            print('[QuestionService] Stack trace: $stackTrace');
            print('[QuestionService] Item data: $item');
          }
        }
        
        return BuiltList<Question>(questions);
      }
    } catch (e) {
      print('[QuestionService] Error fetching questions by exercice: $e');
    }
    return null;
  }

  /// Récupérer les questions d'un challenge
  /// Endpoint: GET /api/questions/by-challenges/{challengeId}
  /// Note: Le backend masque automatiquement estCorrecte pour les élèves
  Future<BuiltList<Question>?> getQuestionsByChallenge(int challengeId) async {
    try {
      print('[QuestionService] Fetching questions for challenge: $challengeId');
      final response = await _authService.dio.get('/api/questions/by-challenges/$challengeId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        print('[QuestionService] Received ${data.length} questions for challenge $challengeId');
        
        final List<Question> questions = [];
        for (var item in data) {
          try {
            // Normaliser les données avant désérialisation
            final normalizedItem = item is Map<String, dynamic> 
                ? _normalizeQuestionData(item)
                : item;
            
            // Désérialiser manuellement le TypeQuestion si nécessaire
            if (normalizedItem is Map<String, dynamic> && normalizedItem.containsKey('type')) {
              final typeValue = normalizedItem['type'];
              if (typeValue is Map<String, dynamic>) {
                // Désérialiser le TypeQuestion séparément
                try {
                  final typeQuestion = standardSerializers.deserializeWith(
                    TypeQuestion.serializer,
                    typeValue,
                  ) as TypeQuestion;
                  // Remplacer le Map par l'objet TypeQuestion sérialisé en format de liste plate
                  normalizedItem['type'] = standardSerializers.serializeWith(
                    TypeQuestion.serializer,
                    typeQuestion,
                  );
                  print('[QuestionService] Manually deserialized TypeQuestion: ${typeQuestion.libelleType}');
                } catch (e) {
                  print('[QuestionService] Error deserializing TypeQuestion separately: $e');
                  // Si la désérialisation échoue, essayer avec le format de liste plate
                  if (typeValue.containsKey('libelleType')) {
                    normalizedItem['type'] = ['libelleType', typeValue['libelleType']];
                  }
                }
              } else if (typeValue is String) {
                // Convertir String en format de liste plate
                normalizedItem['type'] = ['libelleType', typeValue];
              }
            }
            
            final question = standardSerializers.deserializeWith(
              Question.serializer,
              normalizedItem,
            ) as Question;
            questions.add(question);
            print('[QuestionService] Successfully deserialized question ID: ${question.id}, type: ${question.type?.libelleType}');
          } catch (e, stackTrace) {
            print('[QuestionService] Error deserializing question: $e');
            print('[QuestionService] Stack trace: $stackTrace');
            print('[QuestionService] Item data: $item');
          }
        }
        
        return BuiltList<Question>(questions);
      }
    } catch (e) {
      print('[QuestionService] Error fetching questions by challenge: $e');
    }
    return null;
  }

  /// Récupérer les questions d'un défi
  /// Endpoint: GET /api/questions/by-defis/{defiId}
  /// Note: Le backend masque automatiquement estCorrecte pour les élèves
  Future<BuiltList<Question>?> getQuestionsByDefi(int defiId) async {
    try {
      print('[QuestionService] Fetching questions for defi: $defiId');
      final response = await _authService.dio.get('/api/questions/by-defis/$defiId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        print('[QuestionService] Received ${data.length} questions for defi $defiId');
        
        final List<Question> questions = [];
        for (var item in data) {
          try {
            // Normaliser les données avant désérialisation
            final normalizedItem = item is Map<String, dynamic> 
                ? _normalizeQuestionData(item)
                : item;
            
            // Désérialiser manuellement le TypeQuestion si nécessaire
            if (normalizedItem is Map<String, dynamic> && normalizedItem.containsKey('type')) {
              final typeValue = normalizedItem['type'];
              if (typeValue is Map<String, dynamic>) {
                // Désérialiser le TypeQuestion séparément
                try {
                  final typeQuestion = standardSerializers.deserializeWith(
                    TypeQuestion.serializer,
                    typeValue,
                  ) as TypeQuestion;
                  // Remplacer le Map par l'objet TypeQuestion sérialisé en format de liste plate
                  normalizedItem['type'] = standardSerializers.serializeWith(
                    TypeQuestion.serializer,
                    typeQuestion,
                  );
                  print('[QuestionService] Manually deserialized TypeQuestion: ${typeQuestion.libelleType}');
                } catch (e) {
                  print('[QuestionService] Error deserializing TypeQuestion separately: $e');
                  // Si la désérialisation échoue, essayer avec le format de liste plate
                  if (typeValue.containsKey('libelleType')) {
                    normalizedItem['type'] = ['libelleType', typeValue['libelleType']];
                  }
                }
              } else if (typeValue is String) {
                // Convertir String en format de liste plate
                normalizedItem['type'] = ['libelleType', typeValue];
              }
            }
            
            final question = standardSerializers.deserializeWith(
              Question.serializer,
              normalizedItem,
            ) as Question;
            questions.add(question);
            print('[QuestionService] Successfully deserialized question ID: ${question.id}, type: ${question.type?.libelleType}');
          } catch (e, stackTrace) {
            print('[QuestionService] Error deserializing question: $e');
            print('[QuestionService] Stack trace: $stackTrace');
            print('[QuestionService] Item data: $item');
          }
        }
        
        return BuiltList<Question>(questions);
      }
    } catch (e) {
      print('[QuestionService] Error fetching questions by defi: $e');
    }
    return null;
  }
}

