/// Modèle pour représenter une notification
class NotificationModel {
  final int? id;
  final String? titre;
  final String? contenu;
  final String? type; // 'CHALLENGE', 'QUIZ', 'DEFI', 'DATA', etc.
  final bool? lu;
  final DateTime? dateCreation;
  final int? eleveId;
  final Map<String, dynamic>? metadata; // Données supplémentaires

  NotificationModel({
    this.id,
    this.titre,
    this.contenu,
    this.type,
    this.lu,
    this.dateCreation,
    this.eleveId,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int?,
      titre: json['titre'] as String? ?? json['title'] as String?,
      contenu: json['contenu'] as String? ?? 
               json['body'] as String? ?? 
               json['message'] as String?,
      type: json['type'] as String? ?? json['notificationType'] as String?,
      lu: json['lu'] as bool? ?? json['read'] as bool? ?? false,
      dateCreation: json['dateCreation'] != null
          ? DateTime.tryParse(json['dateCreation'].toString())
          : json['dateCreation'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
      eleveId: json['eleveId'] as int? ?? json['eleve_id'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'type': type,
      'lu': lu,
      'dateCreation': dateCreation?.toIso8601String(),
      'eleveId': eleveId,
      'metadata': metadata,
    };
  }
}

