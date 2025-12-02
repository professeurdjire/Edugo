/// Modèle pour représenter une entrée du leaderboard d'un challenge
/// Utilisé pour l'endpoint GET /api/challenges/{challengeId}/leaderboard
class LeaderboardEntry {
  final int eleveId;
  final String nom;
  final String prenom;
  final DateTime dateParticipation;
  final int points;
  final int tempsPasse; // en secondes
  final int rang;

  LeaderboardEntry({
    required this.eleveId,
    required this.nom,
    required this.prenom,
    required this.dateParticipation,
    required this.points,
    required this.tempsPasse,
    required this.rang,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      eleveId: json['eleveId'] as int,
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      dateParticipation: DateTime.parse(json['dateParticipation'] as String),
      points: json['points'] as int? ?? 0,
      tempsPasse: json['tempsPasse'] as int? ?? 0,
      rang: json['rang'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eleveId': eleveId,
      'nom': nom,
      'prenom': prenom,
      'dateParticipation': dateParticipation.toIso8601String(),
      'points': points,
      'tempsPasse': tempsPasse,
      'rang': rang,
    };
  }

  String get fullName => '$prenom $nom'.trim();
}

