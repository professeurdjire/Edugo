import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/badge.dart';
import 'package:edugo/models/badge_response.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/badges_api.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';

class BadgeService {
  static final BadgeService _instance = BadgeService._internal();
  factory BadgeService() => _instance;

  final AuthService _authService = AuthService();
  late LveApi _lveApi;
  late BadgesApi _badgesApi;

  BadgeService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
    _badgesApi = BadgesApi(_authService.dio, standardSerializers);
  }

  /// Récupérer les badges d'un élève (badges obtenus)
  /// GET /api/eleve/badges/{eleveId}
  Future<BuiltList<Badge>?> getBadges(int eleveId) async {
    try {
      final response = await _lveApi.getBadges(id: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching badges: $e');
    }
    return null;
  }

  /// Récupérer tous les badges disponibles
  /// GET /api/badges
  Future<BuiltList<BadgeResponse>?> getAllBadges() async {
    try {
      final response = await _badgesApi.getAllBadges();
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching all badges: $e');
    }
    return null;
  }
  
  /// Convertir BadgeResponse en Badge pour l'affichage
  Badge? convertBadgeResponseToBadge(BadgeResponse badgeResponse) {
    try {
      // Convertir le type String en BadgeTypeEnum
      BadgeTypeEnum? badgeType;
      if (badgeResponse.type != null) {
        switch (badgeResponse.type!.toUpperCase()) {
          case 'OR':
            badgeType = BadgeTypeEnum.OR;
            break;
          case 'ARGENT':
            badgeType = BadgeTypeEnum.ARGENT;
            break;
          case 'BRONZE':
            badgeType = BadgeTypeEnum.BRONZE;
            break;
          case 'SPECIAL':
            badgeType = BadgeTypeEnum.SPECIAL;
            break;
          default:
            badgeType = null;
        }
      }
      
      return Badge((b) => b
        ..id = badgeResponse.id
        ..nom = badgeResponse.nom
        ..description = badgeResponse.description
        ..type = badgeType
        ..icone = badgeResponse.icone
      );
    } catch (e) {
      print('Error converting BadgeResponse to Badge: $e');
      return null;
    }
  }
}

