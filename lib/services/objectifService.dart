import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/objectifRequest.dart';
import 'package:edugo/models/objectifResponse.dart';

class ObjectifService {
  static final ObjectifService _instance = ObjectifService._internal();
  factory ObjectifService() => _instance;

  late Dio _dio;

  ObjectifService._internal() {
    // Use the shared Dio instance from AuthService to ensure consistent base URL and headers
    _dio = AuthService().dio;
  }

  /// Créer un nouvel objectif
  Future<ObjectifResponse?> createObjectif({
    required int eleveId,
    required String typeObjectif,
    required int nbreLivre,
    required String dateEnvoie,
  }) async {
    try {
      print('🔄 Création d\'objectif pour élève $eleveId');

      final request = ObjectifRequest(
        typeObjectif: typeObjectif,
        nbreLivre: nbreLivre,
        dateEnvoie: dateEnvoie,
      );

      // Utiliser le même schéma que les autres endpoints: /api/eleve/{eleveId}/objectifs
      final response = await _dio.post(
        // Note: baseUrl already contains /api, et les autres méthodes utilisent /api/eleve/...
        '/api/eleve/$eleveId/objectifs',

        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print('✅ Réponse création objectif: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ObjectifResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la création de l\'objectif: $e');
      if (e is DioException) {
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Status: ${e.response?.statusCode}');
        print('   Data: ${e.response?.data}');
        print('   URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      }
      return null;
    }
  }

  /// Récupérer l'objectif en cours d'un élève
  Future<ObjectifResponse?> getObjectifEnCours(int eleveId) async {
    try {
      print('🔄 Récupération de l\'objectif en cours pour élève $eleveId');
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/eleve/$eleveId/objectifs/en-cours');

      print('✅ Réponse objectif en cours: ${response.statusCode}');
      if (response.statusCode == 200) {
        return ObjectifResponse.fromJson(response.data);
      }
      // For 404 or 500, return null (no current objective)
      if (response.statusCode == 404 || response.statusCode == 500) {
        print('ℹ️ Aucun objectif en cours trouvé pour cet élève');
        return null;
      }
      return null;
    } catch (e) {
      // Don't log as error for 500/404, just return null
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 404 || statusCode == 500) {
          print('ℹ️ Aucun objectif en cours trouvé pour cet élève');
        } else {
          print('❌ Erreur lors de la récupération de l\'objectif en cours: $e');
          print('   Status: $statusCode');
          print('   Data: ${e.response?.data}');
        }
      } else {
        print('❌ Erreur lors de la récupération de l\'objectif en cours: $e');
      }
      return null;
    }
  }

  /// Récupérer tous les objectifs d'un élève
  Future<List<ObjectifResponse>?> getObjectifsByEleve(int eleveId) async {
    try {
      print('🔄 Récupération de tous les objectifs pour élève $eleveId');
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/eleve/$eleveId/objectifs');

      print('✅ Réponse objectifs: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ObjectifResponse.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération des objectifs: $e');
      if (e is DioException) {
        print('   Status: ${e.response?.statusCode}');
        print('   Data: ${e.response?.data}');
      }
      return null;
    }
  }

  /// Récupérer un objectif spécifique par ID
  Future<ObjectifResponse?> getObjectifById(int id, int eleveId) async {
    try {
      print('🔄 Récupération de l\'objectif $id pour élève $eleveId');
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/eleve/$eleveId/objectifs/$id');

      if (response.statusCode == 200) {
        return ObjectifResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'objectif: $e');
      if (e is DioException) {
        print('   Status: ${e.response?.statusCode}');
      }
      return null;
    }
  }

  /// Récupérer l'historique des objectifs
  Future<List<ObjectifResponse>?> getHistoriqueObjectifs(int eleveId) async {
    try {
      print('🔄 Récupération de l\'historique des objectifs pour élève $eleveId');
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/eleve/$eleveId/objectifs/historique');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ObjectifResponse.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'historique: $e');
      if (e is DioException) {
        print('   Status: ${e.response?.statusCode}');
      }
      return null;
    }
  }

  /// Supprimer un objectif
  Future<bool> deleteObjectif(int id, int eleveId) async {
    try {
      print('🔄 Suppression de l\'objectif $id pour élève $eleveId');
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.delete('/api/eleve/$eleveId/objectifs/$id');
      final success = response.statusCode == 200 || response.statusCode == 204;
      if (success) {
        print('✅ Objectif supprimé avec succès');
      }
      return success;
    } catch (e) {
      print('❌ Erreur lors de la suppression de l\'objectif: $e');
      if (e is DioException) {
        print('   Status: ${e.response?.statusCode}');
      }
      return false;
    }
  }
}