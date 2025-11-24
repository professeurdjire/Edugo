import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/suggestion.dart';
import 'package:built_collection/built_collection.dart';

class SuggestionService {
  static final SuggestionService _instance = SuggestionService._internal();
  factory SuggestionService() => _instance;

  late Dio _dio;

  SuggestionService._internal() {
    // Use the shared Dio instance from AuthService to ensure consistent base URL and headers
    _dio = AuthService().dio;
  }

  /// Envoyer une suggestion
  Future<Suggestion?> envoyerSuggestion(String contenu, int eleveId) async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.post(
        '/api/suggestions',
        data: {
          'contenu': contenu,
          'eleveId': eleveId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return standardSerializers.deserializeWith(
          Suggestion.serializer,
          response.data,
        );
      }
      return null;
    } catch (e) {
      print('Erreur en envoyant la suggestion: $e');
      return null;
    }
  }

  /// Récupérer toutes les suggestions d'un élève
  Future<BuiltList<Suggestion>?> getSuggestionsByEleve(int eleveId) async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/suggestions/eleve/$eleveId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  Suggestion.serializer,
                  json,
                ))
            .whereType<Suggestion>()
            .toList()
            .toBuiltList();
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des suggestions: $e');
      return null;
    }
  }
}