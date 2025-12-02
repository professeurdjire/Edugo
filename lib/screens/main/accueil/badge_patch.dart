// This is a patch file containing the key changes needed for the badge system

// 1. Add import for BadgeEleveResponse
import 'package:edugo/models/badge_eleve_response.dart' as BadgeEleveModel;

// 2. Add state variable in the class
List<BadgeEleveModel.BadgeEleveResponse>? _allBadgesWithStatus; // Tous les badges avec statut d'obtention

// 3. Update _loadBadges method to fetch badges with status
Future<void> _loadBadges() async {
  if (_currentEleveId == null) return;
  setState(() {
    _isLoadingBadges = true;
  });

  try {
    // Charger les badges obtenus, tous les badges disponibles et tous les badges avec statut en parallèle
    final results = await Future.wait([
      _badgeService.getBadges(_currentEleveId!),
      _badgeService.getAllBadges(),
      _badgeService.getAllBadgesWithStatus(_currentEleveId!), // Nouveau endpoint
    ]);
    
    final earnedBadges = results[0] as BuiltList<BadgeModel.Badge>?;
    final allBadgesResponse = results[1] as BuiltList<BadgeResponse>?;
    final allBadgesWithStatus = results[2] as List<BadgeEleveModel.BadgeEleveResponse>?;
    
    if (mounted) {
      setState(() {
        _badges = earnedBadges;
        // Convertir BadgeResponse en Badge pour l'affichage
        if (allBadgesResponse != null) {
          final convertedBadges = allBadgesResponse
              .map((br) => _badgeService.convertBadgeResponseToBadge(br))
              .whereType<BadgeModel.Badge>()
              .toList();
          _allBadges = BuiltList<BadgeModel.Badge>(convertedBadges);
        }
        // Stocker les badges avec statut
        _allBadgesWithStatus = allBadgesWithStatus;
      });
    }
  } catch (e) {
    print('Error loading badges: $e');
  } finally {
    if (mounted) {
      setState(() {
        _isLoadingBadges = false;
      });
    }
  }
}

// 4. Update _buildBadgeItems method to use badges with status
List<Widget> _buildBadgeItems(Color primaryColor) {
  // Utiliser les nouveaux badges avec statut si disponibles
  if (_allBadgesWithStatus != null && _allBadgesWithStatus!.isNotEmpty) {
    // Afficher les 3 premiers badges avec leur statut
    return _allBadgesWithStatus!.take(3).map((BadgeEleveModel.BadgeEleveResponse badge) {
      Color color;
      switch (badge.type.toUpperCase()) {
        case 'OR':
          color = _colorGold;
          break;
        case 'ARGENT':
          color = _colorSilver;
          break;
        case 'BRONZE':
          color = _colorBronze;
          break;
        default:
          color = primaryColor;
      }
      return _BadgeItem(
        iconColor: color,
        label: badge.nom,
        isUnlocked: badge.obtenu,
      );
    }).toList();
  }
  
  // Si on a tous les badges disponibles, les afficher avec ceux obtenus débloqués
  if (_allBadges != null && _allBadges!.isNotEmpty) {
    final earnedBadgeIds = _badges?.map((b) => b.id).toSet() ?? <int>{};
    
    return _allBadges!.take(3).map((BadgeModel.Badge badge) {
      final isUnlocked = earnedBadgeIds.contains(badge.id);
      Color color;
      switch (badge.type) {
        case BadgeModel.BadgeTypeEnum.OR:
          color = _colorGold;
          break;
        case BadgeModel.BadgeTypeEnum.ARGENT:
          color = _colorSilver;
          break;
        case BadgeModel.BadgeTypeEnum.BRONZE:
          color = _colorBronze;
          break;
        default:
          color = primaryColor;
      }
      return _BadgeItem(
        iconColor: color,
        label: badge.nom ?? 'Badge',
        isUnlocked: isUnlocked,
      );
    }).toList();
  }
  
  // Sinon, afficher les badges obtenus + des badges par défaut verrouillés
  final items = <Widget>[];
  
  if (_badges != null && _badges!.isNotEmpty) {
    items.addAll(_badges!.take(3).map((BadgeModel.Badge badge) {
      Color color;
      switch (badge.type) {
        case BadgeModel.BadgeTypeEnum.OR:
          color = _colorGold;
          break;
        case BadgeModel.BadgeTypeEnum.ARGENT:
          color = _colorSilver;
          break;
        case BadgeModel.BadgeTypeEnum.BRONZE:
          color = _colorBronze;
          break;
        default:
          color = primaryColor;
      }
      return _BadgeItem(
        iconColor: color,
        label: badge.nom ?? 'Badge',
        isUnlocked: true,
      );
    }));
  }
  
  // Ajouter des badges verrouillés pour compléter jusqu'à 3
  final remaining = 3 - items.length;
  if (remaining > 0) {
    final defaultBadges = [
      {'color': _colorGold, 'label': 'Génie math'},
      {'color': _colorBronze, 'label': '20 question/10min'},
      {'color': _colorSilver, 'label': 'Calcul mental'},
    ];
    for (int i = 0; i < remaining; i++) {
      final badge = defaultBadges[i % defaultBadges.length];
      items.add(_BadgeItem(
        iconColor: badge['color'] as Color,
        label: badge['label'] as String,
        isUnlocked: false,
      ));
    }
  }
  
  return items;
}