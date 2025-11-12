import 'package:dio/dio.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/services/serializers.dart';

class EleveService {
  static final EleveService _instance = EleveService._internal();

  late Dio _dio;

  factory EleveService() {
    return _instance;
  }

  EleveService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8089';
    _dio.options.contentType = 'application/json';
  }

  // Récupérer le profil d'un élève par ID
  Future<Eleve?> getEleveProfile(int eleveId) async {
    try {
      final response = await _dio.get('/api/api/eleve/profil/$eleveId');

      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(Eleve.serializer, response.data);
      }
    } catch (e) {
      print('Erreur lors de la récupération du profil élève: $e');
    }
    return null;
  }

  // Mettre à jour le profil élève
  Future<Eleve?> updateEleveProfile(int eleveId, Eleve eleve) async {
    try {
      final serialized = standardSerializers.serialize(eleve);
      final response = await _dio.put('/api/api/eleve/profil/$eleveId', data: serialized);

      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(Eleve.serializer, response.data);
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du profil élève: $e');
    }
    return null;
  }

  // Récupérer les points de l'élève
  Future<int?> getElevePoints(int eleveId) async {
    try {
      final response = await _dio.get('/api/api/eleve/points/$eleveId');

      if (response.statusCode == 200) {
        return response.data['points'];
      }
    } catch (e) {
      print('Erreur lors de la récupération des points: $e');
    }
    return null;
  }

  // Définir le token d'authentification
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}