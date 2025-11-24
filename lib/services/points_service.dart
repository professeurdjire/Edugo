import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:dio/dio.dart';

/// Service pour gérer les points de l'élève
/// Gère l'ajout automatique de points après quiz/exercice/challenge
class PointsService {
  static final PointsService _instance = PointsService._internal();
  factory PointsService() => _instance;

  final AuthService _authService = AuthService();

  PointsService._internal();

  /// Récupérer les points actuels d'un élève
  /// Endpoint: GET /api/eleve/points/{eleveId}
  Future<int?> getPoints(int eleveId) async {
    try {
      final response = await _authService.dio.get('/api/eleve/points/$eleveId');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['points'] as int?;
      }
    } catch (e) {
      print('[PointsService] Error fetching points: $e');
    }
    return null;
  }

  /// Ajouter des points à un élève
  /// Endpoint: POST /api/eleve/ajouter-points/{eleveId}
  /// Body: { "points": 25 }
  /// ⚠️ IMPORTANT: Cette méthode doit être appelée après chaque soumission réussie
  /// car le backend ne crédite pas automatiquement les points
  Future<bool> addPoints(int eleveId, int points) async {
    try {
      print('[PointsService] Adding $points points to student $eleveId');
      final response = await _authService.dio.post(
        '/api/eleve/ajouter-points/$eleveId',
        data: {'points': points},
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('[PointsService] Successfully added $points points to student $eleveId');
        return true;
      } else {
        print('[PointsService] Unexpected status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('[PointsService] Error adding points: $e');
      return false;
    }
  }

  /// Rafraîchir les points après soumission (récupère le nouveau total)
  /// Note: Cette méthode récupère juste le total, elle n'ajoute pas de points
  Future<int?> refreshPoints(int eleveId) async {
    return await getPoints(eleveId);
  }

  /// Vérifier si un élève a gagné assez de points pour un badge
  /// Cette logique peut être utilisée côté client pour afficher des notifications
  Future<bool> checkBadgeEligibility(int eleveId, int requiredPoints) async {
    final currentPoints = await getPoints(eleveId);
    if (currentPoints == null) return false;
    return currentPoints >= requiredPoints;
  }
}

