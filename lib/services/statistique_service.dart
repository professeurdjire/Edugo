import 'package:built_value/json_object.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';

class StatistiqueService {
  static final StatistiqueService _instance = StatistiqueService._internal();
  factory StatistiqueService() => _instance;

  final AuthService _authService = AuthService();
  late LveApi _lveApi;

  StatistiqueService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
  }

  /// Récupérer les statistiques d'un élève
  /// GET /api/eleve/statistiques/{eleveId}
  /// Retourne un JsonObject contenant les statistiques (lectures, exercices, etc.)
  Future<JsonObject?> getStatistiques(int eleveId) async {
    try {
      final response = await _lveApi.getStatistiques(id: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching statistics: $e');
    }
    return null;
  }

  /// Helper pour extraire une valeur spécifique des statistiques
  int? getStatistiqueValue(JsonObject? stats, String key) {
    if (stats == null) return null;
    try {
      final valueMap = stats.value as Map<String, dynamic>?;
      if (valueMap == null) return null;
      final value = valueMap[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Helper pour extraire une valeur double des statistiques
  double? getStatistiqueDoubleValue(JsonObject? stats, String key) {
    if (stats == null) return null;
    try {
      final valueMap = stats.value as Map<String, dynamic>?;
      if (valueMap == null) return null;
      final value = valueMap[key];
      if (value is double) return value;
      if (value is num) return value.toDouble();
      return null;
    } catch (e) {
      return null;
    }
  }
}

