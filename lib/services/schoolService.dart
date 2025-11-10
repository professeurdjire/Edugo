import 'package:dio/dio.dart';

class SchoolService {
  static final SchoolService _instance = SchoolService._internal();
  late Dio _dio;

  factory SchoolService() => _instance;

  SchoolService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8089'; // Remplace par ton URL API
    _dio.options.contentType = 'application/json';
  }

  /// Récupérer la liste des niveaux scolaires
  Future<List<Map<String, dynamic>>> getNiveaux() async {
    try {
      final response = await _dio.get('/api/niveaux'); // Endpoint à adapter
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur getNiveaux: $e');
      return [];
    }
  }

  /// Récupérer les classes d’un niveau spécifique
  Future<List<Map<String, dynamic>>> getClasses(int niveauId) async {
    try {
      final response = await _dio.get('/api/niveaux/$niveauId/classes'); // Endpoint à adapter
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur getClasses: $e');
      return [];
    }
  }
}
