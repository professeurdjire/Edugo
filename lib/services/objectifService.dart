import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/objectifRequest.dart';
import 'package:edugo/models/objectifResponse.dart';

class ObjectifService {
  static final ObjectifService _instance = ObjectifService._internal();
  factory ObjectifService() => _instance;

  late Dio _dio;

  ObjectifService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8089/api/api/objectifs';
    _dio.options.contentType = 'application/json';

    // Ajout automatique du token si l'élève est connecté
    final token = AuthService().dio.options.headers['Authorization'];
    if (token != null) {
      _dio.options.headers['Authorization'] = token;
    }
  }

  /// Créer un nouvel objectif
  Future<ObjectifResponse?> createObjectif({
    required int eleveId,
    required String typeObjectif,
    required int nbreLivre,
    required String dateEnvoie,
  }) async {
    try {
      final request = ObjectifRequest(
        typeObjectif: typeObjectif,
        nbreLivre: nbreLivre,
        dateEnvoie: dateEnvoie,
      );

      final response = await _dio.post(
        '/eleve/$eleveId',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ObjectifResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la création de l\'objectif: $e');
      return null;
    }
  }

  /// Récupérer l'objectif en cours d'un élève
  Future<ObjectifResponse?> getObjectifEnCours(int eleveId) async {
    try {
      final response = await _dio.get('/eleve/$eleveId/en-cours');

      if (response.statusCode == 200) {
        return ObjectifResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'objectif en cours: $e');
      return null;
    }
  }

  /// Récupérer tous les objectifs d'un élève
  Future<List<ObjectifResponse>?> getObjectifsByEleve(int eleveId) async {
    try {
      final response = await _dio.get('/eleve/$eleveId/tous');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ObjectifResponse.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération des objectifs: $e');
      return null;
    }
  }

  /// Récupérer un objectif spécifique par ID
  Future<ObjectifResponse?> getObjectifById(int id, int eleveId) async {
    try {
      final response = await _dio.get('/$id/eleve/$eleveId');

      if (response.statusCode == 200) {
        return ObjectifResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'objectif: $e');
      return null;
    }
  }

  /// Récupérer l'historique des objectifs
  Future<List<ObjectifResponse>?> getHistoriqueObjectifs(int eleveId) async {
    try {
      final response = await _dio.get('/eleve/$eleveId/historique');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ObjectifResponse.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique: $e');
      return null;
    }
  }

  /// Supprimer un objectif
  Future<bool> deleteObjectif(int id, int eleveId) async {
    try {
      final response = await _dio.delete('/$id/eleve/$eleveId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Erreur lors de la suppression de l\'objectif: $e');
      return false;
    }
  }
}