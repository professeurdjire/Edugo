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
    // Parser la date (supporte plusieurs formats)
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        return DateTime.tryParse(dateValue);
      }
      return null;
    }
    
    // Extraire les métadonnées depuis différentes sources
    Map<String, dynamic>? extractMetadata(Map<String, dynamic> json) {
      // Si metadata existe directement, l'utiliser
      if (json['metadata'] != null && json['metadata'] is Map) {
        return Map<String, dynamic>.from(json['metadata'] as Map);
      }
      
      // Sinon, extraire les métadonnées depuis les champs supplémentaires
      // qui peuvent être dans les données OneSignal ou dans le JSON
      final metadata = <String, dynamic>{};
      
      // Extraire les IDs selon le type de notification
      final type = (json['type'] as String? ?? 
                    json['notificationType'] as String? ??
                    json['typeNotification'] as String? ?? '').toUpperCase();
      
      // Extraire les IDs communs
      if (json['quizId'] != null) metadata['quizId'] = json['quizId'];
      if (json['challengeId'] != null) metadata['challengeId'] = json['challengeId'];
      if (json['defiId'] != null) metadata['defiId'] = json['defiId'];
      if (json['exerciceId'] != null) metadata['exerciceId'] = json['exerciceId'];
      if (json['livreId'] != null) metadata['livreId'] = json['livreId'];
      if (json['suggestionId'] != null) metadata['suggestionId'] = json['suggestionId'];
      if (json['badgeId'] != null) metadata['badgeId'] = json['badgeId'];
      if (json['entityId'] != null) metadata['entityId'] = json['entityId'];
      if (json['entityType'] != null) metadata['entityType'] = json['entityType'];
      
      // Extraire les données spécifiques selon le type
      if (type == 'QUIZ_TERMINE') {
        if (json['score'] != null) metadata['score'] = json['score'];
        if (json['totalPoints'] != null) metadata['totalPoints'] = json['totalPoints'];
        if (json['pointsGagnes'] != null) metadata['pointsGagnes'] = json['pointsGagnes'];
      } else if (type == 'CHALLENGE_TERMINE') {
        if (json['score'] != null) metadata['score'] = json['score'];
        if (json['totalPoints'] != null) metadata['totalPoints'] = json['totalPoints'];
        if (json['rang'] != null) metadata['rang'] = json['rang'];
        if (json['badgeObtenu'] != null) metadata['badgeObtenu'] = json['badgeObtenu'];
        if (json['pointsGagnes'] != null) metadata['pointsGagnes'] = json['pointsGagnes'];
      } else if (type == 'DEFI_TERMINE') {
        if (json['score'] != null) metadata['score'] = json['score'];
        if (json['totalPoints'] != null) metadata['totalPoints'] = json['totalPoints'];
        if (json['pointsGagnes'] != null) metadata['pointsGagnes'] = json['pointsGagnes'];
      } else if (type == 'EXERCICE_CORRIGE') {
        if (json['note'] != null) metadata['note'] = json['note'];
        if (json['pointsGagnes'] != null) metadata['pointsGagnes'] = json['pointsGagnes'];
      } else if (type == 'RAPPEL_DEADLINE') {
        if (json['joursRestants'] != null) metadata['joursRestants'] = json['joursRestants'];
      } else if (type == 'BADGE_OBTENU') {
        if (json['badgeNom'] != null) metadata['badgeNom'] = json['badgeNom'];
        if (json['badgeDescription'] != null) metadata['badgeDescription'] = json['badgeDescription'];
        if (json['badgeIcone'] != null) metadata['badgeIcone'] = json['badgeIcone'];
        if (json['badgeId'] != null) metadata['badgeId'] = json['badgeId'];
        if (json['challengeId'] != null) metadata['challengeId'] = json['challengeId'];
        if (json['challengeTitre'] != null) metadata['challengeTitre'] = json['challengeTitre'];
        if (json['score'] != null) metadata['score'] = json['score'];
        if (json['totalPoints'] != null) metadata['totalPoints'] = json['totalPoints'];
        if (json['pourcentage'] != null) metadata['pourcentage'] = json['pourcentage'];
        if (json['scoreParfait'] != null) metadata['scoreParfait'] = json['scoreParfait'];
      } else if (type == 'BADGE_PROGRESSION') {
        // Notification pour badge de progression obtenu
        if (json['badgeId'] != null) metadata['badgeId'] = json['badgeId'];
        if (json['badgeNom'] != null) metadata['badgeNom'] = json['badgeNom'];
        if (json['badgeIcone'] != null) metadata['badgeIcone'] = json['badgeIcone'];
        if (json['points'] != null) metadata['points'] = json['points'];
        if (json['seuil'] != null) metadata['seuil'] = json['seuil'];
      } else if (type == 'CLASSEMENT_AMELIORE' || type == 'AMELIORATION_CLASSEMENT') {
        if (json['ancienRang'] != null) metadata['ancienRang'] = json['ancienRang'];
        if (json['nouveauRang'] != null) metadata['nouveauRang'] = json['nouveauRang'];
        if (json['challengeTitre'] != null) metadata['challengeTitre'] = json['challengeTitre'];
        if (json['challengeId'] != null) metadata['challengeId'] = json['challengeId'];
      }
      
      return metadata.isEmpty ? null : metadata;
    }
    
    return NotificationModel(
      id: json['id'] as int?,
      titre: json['titre'] as String? ?? json['title'] as String?,
      contenu: json['contenu'] as String? ?? 
               json['body'] as String? ?? 
               json['message'] as String?, // Format backend: "message"
      type: json['type'] as String? ?? 
            json['notificationType'] as String? ??
            json['typeNotification'] as String?,
      lu: json['lu'] as bool? ?? 
          json['read'] as bool? ?? 
          false,
      dateCreation: parseDate(json['dateCreation']) ??
                    parseDate(json['dateEnvoi']) ?? // Format backend: "dateEnvoi"
                    parseDate(json['createdAt']),
      eleveId: json['eleveId'] as int? ?? 
               json['eleve_id'] as int? ??
               json['utilisateurId'] as int? ?? // Format backend: "utilisateurId"
               json['utilisateur_id'] as int?,
      metadata: extractMetadata(json),
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

