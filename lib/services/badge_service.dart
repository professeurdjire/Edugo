import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:edugo/models/badge.dart';
import 'package:edugo/models/badge_response.dart';
import 'package:edugo/models/badge_eleve_response.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/badges_api.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:edugo/services/eleveService.dart';

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
  /// ⚠️ IMPORTANT: Récupère tous les badges attribués, y compris ceux attribués automatiquement via les challenges
  Future<BuiltList<Badge>?> getBadges(int eleveId) async {
    try {
      print('[BadgeService] Fetching badges for student $eleveId');
      final response = await _lveApi.getBadges(id: eleveId);
      if (response.statusCode == 200) {
        final badges = response.data;
        print('[BadgeService] Successfully fetched ${badges?.length ?? 0} badges from endpoint');
        
        // Récupérer aussi les badges depuis les participations aux challenges
        // pour s'assurer qu'on a tous les badges attribués automatiquement
        final badgesFromParticipations = await _getBadgesFromParticipations(eleveId);
        
        if (badgesFromParticipations != null && badgesFromParticipations.isNotEmpty) {
          print('[BadgeService] Found ${badgesFromParticipations.length} badges from participations');
          
          // Fusionner les deux listes en évitant les doublons
          final Map<int, Badge> allBadgesMap = {};
          
          // Ajouter les badges de l'endpoint principal
          if (badges != null) {
            for (var badge in badges) {
              if (badge.id != null) {
                allBadgesMap[badge.id!] = badge;
              }
            }
          }
          
          // Ajouter les badges des participations (écrase si doublon, mais normalement ils devraient être identiques)
          for (var badge in badgesFromParticipations) {
            if (badge.id != null) {
              allBadgesMap[badge.id!] = badge;
            }
          }
          
          final allBadges = BuiltList<Badge>(allBadgesMap.values.toList());
          print('[BadgeService] Total unique badges: ${allBadges.length}');
          return allBadges;
        }
        
        return badges;
      } else {
        print('[BadgeService] Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('[BadgeService] Error fetching badges: $e');
    }
    return null;
  }
  
  /// Récupérer les badges depuis les participations aux challenges
  /// Les badges attribués automatiquement via les challenges sont stockés dans les participations
  /// ⚠️ IMPORTANT: Seules les participations avec statut "GAGNANT" ont des badges attribués automatiquement
  Future<List<Badge>> _getBadgesFromParticipations(int eleveId) async {
    try {
      print('[BadgeService] Fetching badges from participations for student $eleveId');
      final challengeService = ChallengeService();
      final participations = await challengeService.getChallengesParticipes(eleveId);
      
      if (participations == null || participations.isEmpty) {
        print('[BadgeService] No participations found for student $eleveId');
        return [];
      }
      
      print('[BadgeService] Found ${participations.length} participations, checking for badges...');
      final List<Badge> badges = [];
      int gagnantCount = 0;
      
      for (var participation in participations) {
        // Vérifier si la participation a un statut "GAGNANT" (badges attribués automatiquement)
        final statut = participation.statut?.toUpperCase();
        if (statut == 'GAGNANT' || statut == 'VALIDE') {
          gagnantCount++;
          // Vérifier si la participation a un badge attribué
          if (participation.badge != null) {
            badges.add(participation.badge!);
            print('[BadgeService] ✅ Found badge ${participation.badge!.id} (${participation.badge!.nom}) from participation ${participation.id} (statut: $statut)');
          } else {
            print('[BadgeService] ⚠️ Participation ${participation.id} has statut GAGNANT but no badge assigned');
          }
        }
      }
      
      print('[BadgeService] Found $gagnantCount participations with GAGNANT status, ${badges.length} badges extracted');
      return badges;
    } catch (e) {
      print('[BadgeService] ❌ Error fetching badges from participations: $e');
      return [];
    }
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
  
  /// Récupérer tous les badges avec leur statut d'obtention
  /// GET /api/eleve/badges/{eleveId}/tous
  /// Retourne tous les badges disponibles avec indication si l'élève les a obtenus ou non
  Future<List<BadgeEleveResponse>?> getAllBadgesWithStatus(int eleveId) async {
    try {
      print('[BadgeService] 🔍 Fetching all badges with status for student $eleveId');
      final response = await _authService.dio.get('/api/eleve/badges/$eleveId/tous');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        print('[BadgeService] 📊 Raw response contains ${data.length} badges');
        
        final badges = data
            .map((json) {
              try {
                final badge = BadgeEleveResponse.fromJson(json as Map<String, dynamic>);
                print('[BadgeService]   - Badge: ${badge.nom} (ID: ${badge.id}, Type: ${badge.type}, Source: ${badge.source}, Obtenu: ${badge.obtenu})');
                return badge;
              } catch (e) {
                print('[BadgeService] ⚠️ Error deserializing badge: $e');
                print('[BadgeService]   JSON: $json');
                return null;
              }
            })
            .where((badge) => badge != null)
            .cast<BadgeEleveResponse>()
            .toList();
        
        // Compter les badges par type
        final progressionCount = badges.where((b) => 
          b.type?.toUpperCase() == 'PROGRESSION' || b.source?.toUpperCase() == 'PROGRESSION'
        ).length;
        final challengeCount = badges.where((b) => 
          b.source?.toUpperCase() == 'CHALLENGE' || b.challengeId != null
        ).length;
        final obtainedCount = badges.where((b) => b.obtenu == true).length;
        
        print('[BadgeService] ✅ Successfully fetched ${badges.length} badges with status');
        print('[BadgeService] 📊 Breakdown:');
        print('[BadgeService]   - Badges de progression: $progressionCount');
        print('[BadgeService]   - Badges de challenge: $challengeCount');
        print('[BadgeService]   - Badges obtenus: $obtainedCount');
        
        return badges;
      } else {
        print('[BadgeService] ❌ Error: Status code ${response.statusCode}');
        print('[BadgeService] Response data: ${response.data}');
      }
    } catch (e) {
      print('[BadgeService] ❌ Error fetching all badges with status: $e');
      if (e is DioException) {
        print('[BadgeService] DioException status: ${e.response?.statusCode}');
        print('[BadgeService] DioException data: ${e.response?.data}');
      }
    }
    return null;
  }

  /// Récupérer les seuils de badges de progression
  /// GET /api/badges/progression/seuils
  Future<Map<int, String>?> getProgressionBadgeThresholds() async {
    try {
      print('[BadgeService] Fetching progression badge thresholds');
      final response = await _authService.dio.get('/api/badges/progression/seuils');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final Map<int, String> thresholds = {};
        
        // Convertir les clés String en int et extraire les seuils
        data.forEach((key, value) {
          if (key is String && value is String) {
            final threshold = int.tryParse(key);
            if (threshold != null) {
              thresholds[threshold] = value;
            }
          }
        });
        
        print('[BadgeService] Successfully fetched ${thresholds.length} progression badge thresholds');
        return thresholds;
      } else {
        print('[BadgeService] Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('[BadgeService] Error fetching progression badge thresholds: $e');
    }
    return null;
  }

  /// Récupérer les badges de progression d'un élève
  /// Filtre les badges avec source = "PROGRESSION" ou type = "PROGRESSION"
  Future<List<BadgeEleveResponse>?> getProgressionBadges(int eleveId) async {
    try {
      print('[BadgeService] 🔍 Fetching progression badges for student $eleveId');
      final allBadges = await getAllBadgesWithStatus(eleveId);
      
      if (allBadges == null) {
        print('[BadgeService] ⚠️ getAllBadgesWithStatus returned null');
        return null;
      }
      
      print('[BadgeService] 📊 Total badges retrieved: ${allBadges.length}');
      
      // Filtrer les badges de progression
      final progressionBadges = allBadges.where((badge) {
        final isProgressionType = badge.type?.toUpperCase() == 'PROGRESSION';
        final isProgressionSource = badge.source?.toUpperCase() == 'PROGRESSION';
        final matches = isProgressionType || isProgressionSource;
        
        if (matches) {
          print('[BadgeService]   ✅ Found progression badge: ${badge.nom} (ID: ${badge.id}, Obtenu: ${badge.obtenu})');
        }
        
        return matches;
      }).toList();
      
      final obtainedProgression = progressionBadges.where((b) => b.obtenu == true).length;
      print('[BadgeService] ✅ Found ${progressionBadges.length} progression badges (${obtainedProgression} obtenus)');
      
      return progressionBadges;
    } catch (e) {
      print('[BadgeService] ❌ Error fetching progression badges: $e');
      return null;
    }
  }

  /// Récupérer les badges de challenges d'un élève
  /// Filtre les badges avec source = "CHALLENGE" ou challengeId != null
  Future<List<BadgeEleveResponse>?> getChallengeBadges(int eleveId) async {
    try {
      print('[BadgeService] Fetching challenge badges for student $eleveId');
      final allBadges = await getAllBadgesWithStatus(eleveId);
      
      if (allBadges == null) {
        return null;
      }
      
      // Filtrer les badges de challenges
      final challengeBadges = allBadges.where((badge) {
        final isChallengeSource = badge.source?.toUpperCase() == 'CHALLENGE';
        final hasChallengeId = badge.challengeId != null;
        final isNotProgression = badge.type?.toUpperCase() != 'PROGRESSION';
        return (isChallengeSource || hasChallengeId) && isNotProgression;
      }).toList();
      
      print('[BadgeService] Found ${challengeBadges.length} challenge badges');
      return challengeBadges;
    } catch (e) {
      print('[BadgeService] Error fetching challenge badges: $e');
      return null;
    }
  }

  /// Initialiser les badges de progression dans la base de données (endpoint admin)
  /// POST /api/badges/progression/initialiser
  Future<bool> initialiserBadgesProgression() async {
    try {
      print('[BadgeService] 🔄 Initialisation des badges de progression...');
      final response = await _authService.dio.post('/api/badges/progression/initialiser');
      
      if (response.statusCode == 200) {
        print('[BadgeService] ✅ Badges de progression initialisés avec succès');
        return true;
      } else {
        print('[BadgeService] ⚠️ Échec de l\'initialisation: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('[BadgeService] ⚠️ Erreur lors de l\'initialisation des badges: $e');
      // Ne pas échouer si l'endpoint n'existe pas ou nécessite des droits admin
      return false;
    }
  }

  /// Déclencher la vérification et l'attribution rétroactive des badges de progression
  /// Cette méthode vérifie les points actuels de l'élève et attribue les badges manquants
  /// Elle essaie plusieurs endpoints backend pour forcer l'attribution
  Future<bool> verifierEtAttribuerBadgesProgressionRetroactifs(int eleveId) async {
    try {
      print('[BadgeService] 🔄 Déclenchement de la vérification rétroactive des badges de progression pour l\'élève $eleveId');
      
      // 1. S'assurer que les badges de progression existent dans la base de données
      print('[BadgeService] 🔄 Étape 1: Initialisation des badges de progression...');
      await initialiserBadgesProgression();
      await Future.delayed(const Duration(milliseconds: 300));
      
      // 2. Récupérer les points actuels de l'élève
      print('[BadgeService] 🔄 Étape 2: Récupération des points de l\'élève...');
      final eleveService = EleveService();
      final pointsActuels = await eleveService.getElevePoints(eleveId);
      
      if (pointsActuels == null) {
        print('[BadgeService] ❌ Impossible de récupérer les points de l\'élève');
        return false;
      }
      
      print('[BadgeService] 📊 Points actuels de l\'élève: $pointsActuels');
      
      // Vérifier d'abord quels badges de progression l'élève devrait avoir
      final seuils = await getProgressionBadgeThresholds();
      if (seuils != null && seuils.isNotEmpty) {
        print('[BadgeService] 📋 Seuils de badges de progression disponibles:');
        seuils.forEach((seuil, nom) {
          final devraitAvoir = pointsActuels >= seuil;
          print('[BadgeService]   - $nom ($seuil points): ${devraitAvoir ? "✅ Devrait avoir" : "❌ Pas encore"}');
        });
      }
      
      // Vérifier les badges de progression actuels de l'élève
      final badgesProgressionActuels = await getProgressionBadges(eleveId);
      print('[BadgeService] 📊 Badges de progression actuels: ${badgesProgressionActuels?.length ?? 0}');
      if (badgesProgressionActuels != null && badgesProgressionActuels.isNotEmpty) {
        for (var badge in badgesProgressionActuels) {
          print('[BadgeService]   - ${badge.nom} (ID: ${badge.id}, Obtenu: ${badge.obtenu})');
        }
      }
      
      // Si l'élève a moins de 100 points, aucun badge de progression ne peut être attribué
      if (pointsActuels < 100) {
        print('[BadgeService] ℹ️ L\'élève a $pointsActuels points, ce qui est inférieur au seuil minimum de 100 points');
        return false;
      }
      
      // Endpoint unique et correct : /api/eleve/badges-progression/verifier/{id}
      // Note: Le backend récupère les points directement, pas besoin de les envoyer dans le body
      // L'ID est passé comme paramètre de chemin À LA FIN, pas au milieu
      try {
        print('[BadgeService] 🔍 Appel de l\'endpoint: POST /api/eleve/badges-progression/verifier/$eleveId');
        final response = await _authService.dio.post(
          '/api/eleve/badges-progression/verifier/$eleveId',
        );
        
        if (response.statusCode == 200) {
          print('[BadgeService] ✅ Vérification rétroactive réussie');
          print('[BadgeService] 📄 Réponse complète: ${response.data}');
          
          // Vérifier si un badge a été attribué
          if (response.data is Map<String, dynamic>) {
            final data = response.data as Map<String, dynamic>;
            final badgeAttribue = data['badgeAttribue'] as bool? ?? false;
            final message = data['message'] as String? ?? '';
            final pointsActuels = data['pointsActuels'] as int?;
            
            print('[BadgeService] 📊 Résultat de la vérification:');
            print('[BadgeService]   - Badge attribué: $badgeAttribue');
            print('[BadgeService]   - Message: $message');
            if (pointsActuels != null) {
              print('[BadgeService]   - Points actuels: $pointsActuels');
            }
            
            if (badgeAttribue) {
              print('[BadgeService] 🎉 Un nouveau badge de progression a été attribué !');
              print('[BadgeService] 💡 Les badges seront visibles après rechargement de la liste');
            } else {
              print('[BadgeService] ℹ️ Aucun nouveau badge à attribuer');
              print('[BadgeService]    (L\'élève a déjà tous les badges qu\'il mérite avec $pointsActuels points)');
            }
          }
          
          return true;
        } else {
          print('[BadgeService] ⚠️ Réponse inattendue: Status ${response.statusCode}');
          print('[BadgeService]   Data: ${response.data}');
        }
      } catch (e) {
        print('[BadgeService] ❌ Erreur lors de l\'appel à l\'endpoint: $e');
        if (e is DioException) {
          print('[BadgeService]   Status: ${e.response?.statusCode}');
          print('[BadgeService]   Data: ${e.response?.data}');
          
          if (e.response?.statusCode == 403) {
            print('[BadgeService]   ⚠️ Accès refusé (403). Vérifiez que le token est valide et que l\'utilisateur a le rôle ELEVE.');
          } else if (e.response?.statusCode == 404) {
            print('[BadgeService]   ⚠️ Endpoint non trouvé (404). Vérifiez que le backend est à jour avec l\'endpoint /api/eleve/badges-progression/verifier/{id}');
          } else if (e.response?.statusCode == 500) {
            print('[BadgeService]   ⚠️ Erreur serveur (500). Vérifiez les logs du backend.');
          }
        }
      }
      
      print('[BadgeService] ❌ La vérification rétroactive a échoué');
      print('[BadgeService] 💡 Endpoint attendu: POST /api/eleve/badges-progression/verifier/{id}');
      print('[BadgeService]    (dans EleveController, accessible aux ELEVE)');
      
      return false;
    } catch (e) {
      print('[BadgeService] ❌ Erreur lors de la vérification rétroactive: $e');
      return false;
    }
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
          case 'PROGRESSION':
            badgeType = BadgeTypeEnum.PROGRESSION;
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

