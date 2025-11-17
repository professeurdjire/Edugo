import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';

class SchoolService {
  static final SchoolService _instance = SchoolService._internal();
  factory SchoolService() => _instance;

  late Dio _dio;

  SchoolService._internal() {
    // Use the shared Dio instance from AuthService to ensure consistent base URL and headers
    _dio = AuthService().dio;
    
    // Add interceptors for debugging
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  /// Récupérer la liste des niveaux scolaires
  Future<List<Map<String, dynamic>>> getNiveaux() async {
    try {
      print('Appel API: GET /api/niveaux');
      final response = await _dio.get('/api/niveaux');
      print('Réponse niveaux: ${response.statusCode}');
      print('Données niveaux: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          print('Format de données invalide pour niveaux');
          return [];
        }
      } else {
        print('Erreur HTTP niveaux: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur getNiveaux: $e');
      if (e is DioException) {
        print('Détails Dio: ${e.response?.statusCode} - ${e.response?.data}');
        print('URL complète: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      }
      return [];
    }
  }

  /// Récupérer les classes d'un niveau spécifique
  Future<List<Map<String, dynamic>>> getClasses(int niveauId) async {
    try {
      print('Appel API: GET /api/classes/niveau/$niveauId');
      final response = await _dio.get('/api/classes/niveau/$niveauId');
      print('Réponse classes: ${response.statusCode}');
      print('Données classes: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          print('Format de données invalide pour classes');
          return [];
        }
      } else {
        print('Erreur HTTP classes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur getClasses: $e');
      if (e is DioException) {
        print(' Détails Dio: ${e.response?.statusCode} - ${e.response?.data}');
        print(' URL complète: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      }
      return [];
    }
  }

}