
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/api/dfis_api.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/defi_response.dart';
import 'package:edugo/models/defi_detail_response.dart';
import 'package:edugo/models/eleve_defi_response.dart';
import 'package:built_collection/built_collection.dart';

class DefiService {
  static final DefiService _instance = DefiService._internal();
  factory DefiService() => _instance;

  final AuthService _authService = AuthService();
  late DfisApi _dfisApi;

  DefiService._internal() {
    _dfisApi = DfisApi(_authService.dio, standardSerializers);
  }

  /// Récupérer tous les défis disponibles pour un élève
  Future<BuiltList<DefiResponse>?> getDefisDisponibles(int eleveId) async {
    try {
      final response = await _dfisApi.getDefisDisponibles1(eleveId: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching available challenges: $e');
    }
    return null;
  }

  /// Récupérer les défis auxquels un élève a participé
  Future<BuiltList<EleveDefiResponse>?> getDefisParticipes(int eleveId) async {
    try {
      final response = await _dfisApi.getDefisParticipes1(eleveId: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching participated challenges: $e');
    }
    return null;
  }

  /// Récupérer un défi par ID avec tous les détails
  Future<DefiDetailResponse?> getDefiById(int id) async {
    try {
      final response = await _dfisApi.getDefiById(id: id);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching challenge by ID: $e');
    }
    return null;
  }

  /// Participer à un défi
  Future<EleveDefiResponse?> participerDefi(int eleveId, int defiId) async {
    try {
      final response = await _dfisApi.participerDefi1(eleveId: eleveId, defiId: defiId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error participating in challenge: $e');
    }
    return null;
  }

  /// Récupérer tous les défis (pour les administrateurs)
  Future<BuiltList<DefiResponse>?> getAllDefis() async {
    try {
      final response = await _dfisApi.getAllDefis();
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching all challenges: $e');
    }
    return null;
  }
  
  /// Récupérer le classement d'un défi
  Future<List<Map<String, dynamic>>?> getClassementDefi(int defiId) async {
    try {
      // Since the API doesn't have a specific leaderboard endpoint,
      // we'll use the getDefisParticipes method and sort by score
      // In a real implementation, there would be a specific leaderboard API endpoint
      print('Fetching leaderboard for challenge $defiId');
      return null; // Placeholder implementation
    } catch (e) {
      print('Error fetching challenge leaderboard: $e');
      return null;
    }
  }
}