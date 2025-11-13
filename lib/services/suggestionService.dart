import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';

class SuggestionService {
  static final SuggestionService _instance = SuggestionService._internal();
  factory SuggestionService() => _instance;

  late Dio _dio;

  SuggestionService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8089/api/api/suggestions';
    _dio.options.contentType = 'application/json';

    // Ajout automatique du token si l'élève est connecté
    final token = AuthService().dio.options.headers['Authorization'];
    if (token != null) {
      _dio.options.headers['Authorization'] = token;
    }
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
