/// Modèle pour représenter un badge avec son statut d'obtention par un élève
/// Utilisé pour l'endpoint GET /api/eleve/badges/{id}/tous
class BadgeEleveResponse {
  final int id;
  final String nom;
  final String description;
  final String type;
  final String icone;
  final bool obtenu;
  final DateTime? dateObtention;
  final int? challengeId;
  final String? challengeTitre;
  final String? source; // "CHALLENGE", "PROGRESSION", "DEFI", etc.
  final int? sourceId; // ID de la source (challengeId, null pour progression, etc.)

  BadgeEleveResponse({
    required this.id,
    required this.nom,
    required this.description,
    required this.type,
    required this.icone,
    required this.obtenu,
    this.dateObtention,
    this.challengeId,
    this.challengeTitre,
    this.source,
    this.sourceId,
  });

  factory BadgeEleveResponse.fromJson(Map<String, dynamic> json) {
    return BadgeEleveResponse(
      id: json['id'] as int,
      nom: json['nom'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      icone: json['icone'] as String? ?? '🏆',
      obtenu: json['obtenu'] as bool? ?? false,
      dateObtention: json['dateObtention'] != null
          ? DateTime.parse(json['dateObtention'] as String)
          : null,
      challengeId: json['challengeId'] as int?,
      challengeTitre: json['challengeTitre'] as String?,
      source: json['source'] as String?,
      sourceId: json['sourceId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'type': type,
      'icone': icone,
      'obtenu': obtenu,
      'dateObtention': dateObtention?.toIso8601String(),
      'challengeId': challengeId,
      'challengeTitre': challengeTitre,
      'source': source,
      'sourceId': sourceId,
    };
  }
}
