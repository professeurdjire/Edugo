import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';

class SuggestionService {
  static final SuggestionService _instance = SuggestionService._internal();
  factory SuggestionService() => _instance;

  late Dio _dio;

  SuggestionService._internal() {
    // Use the shared Dio instance from AuthService to ensure consistent base URL and headers
    _dio = AuthService().dio;
  }

  /// Envoyer une suggestion
  Future<bool> envoyerSuggestion(String contenu) async {
    try {
      final response = await _dio.post(
        '',
        data: {'contenu': contenu},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erreur en envoyant la suggestion: $e');
      return false;
    }
  }
}