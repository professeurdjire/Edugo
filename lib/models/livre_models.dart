// livre_models.dart
class LivreResponse {
  final int id;
  final String titre;
  final String? isbn;
  final String auteur;
  final String? imageCouverture;
  final int? totalPages;

  LivreResponse({
    required this.id,
    required this.titre,
    this.isbn,
    required this.auteur,
    this.imageCouverture,
    this.totalPages,
  });

  factory LivreResponse.fromJson(Map<String, dynamic> json) {
    return LivreResponse(
      id: json['id'],
      titre: json['titre'],
      isbn: json['isbn'],
      auteur: json['auteur'],
      imageCouverture: json['imageCouverture'],
      totalPages: json['totalPages'],
    );
  }
}

class LivreDetailResponse {
  final int id;
  final String titre;
  final String? isbn;
  final String auteur;
  final String? imageCouverture;
  final int? totalPages;
  final bool? lectureAuto;
  final bool? interactif;
  final int? anneePublication;
  final String? editeur;
  final int? niveauId;
  final String? niveauNom;
  final int? classeId;
  final String? classeNom;
  final int? matiereId;
  final String? matiereNom;
  final double? progression;
  final dynamic statistiques;

  LivreDetailResponse({
    required this.id,
    required this.titre,
    this.isbn,
    required this.auteur,
    this.imageCouverture,
    this.totalPages,
    this.lectureAuto,
    this.interactif,
    this.anneePublication,
    this.editeur,
    this.niveauId,
    this.niveauNom,
    this.classeId,
    this.classeNom,
    this.matiereId,
    this.matiereNom,
    this.progression,
    this.statistiques,
  });

  factory LivreDetailResponse.fromJson(Map<String, dynamic> json) {
    return LivreDetailResponse(
      id: json['id'],
      titre: json['titre'],
      isbn: json['isbn'],
      auteur: json['auteur'],
      imageCouverture: json['imageCouverture'],
      totalPages: json['totalPages'],
      lectureAuto: json['lectureAuto'],
      interactif: json['interactif'],
      anneePublication: json['anneePublication'],
      editeur: json['editeur'],
      niveauId: json['niveauId'],
      niveauNom: json['niveauNom'],
      classeId: json['classeId'],
      classeNom: json['classeNom'],
      matiereId: json['matiereId'],
      matiereNom: json['matiereNom'],
      progression: json['progression']?.toDouble(),
      statistiques: json['statistiques'],
    );
  }
}

class ProgressionResponse {
  final int id;
  final int? eleveId;
  final String? eleveNom;
  final int? livreId;
  final String? livreTitre;
  final int? pageActuelle;
  final int? pourcentageCompletion;
  final DateTime? dateMiseAJour;

  ProgressionResponse({
    required this.id,
    this.eleveId,
    this.eleveNom,
    this.livreId,
    this.livreTitre,
    this.pageActuelle,
    this.pourcentageCompletion,
    this.dateMiseAJour,
  });

  factory ProgressionResponse.fromJson(Map<String, dynamic> json) {
    return ProgressionResponse(
      id: json['id'],
      eleveId: json['eleveId'],
      eleveNom: json['eleveNom'],
      livreId: json['livreId'],
      livreTitre: json['livreTitre'],
      pageActuelle: json['pageActuelle'],
      pourcentageCompletion: json['pourcentageCompletion'],
      dateMiseAJour: json['dateMiseAJour'] != null
          ? DateTime.parse(json['dateMiseAJour'])
          : null,
    );
  }
}

class LivrePopulaireResponse {
  final int id;
  final String titre;
  final String auteur;
  final int nombreLectures;

  LivrePopulaireResponse({
    required this.id,
    required this.titre,
    required this.auteur,
    required this.nombreLectures,
  });

  factory LivrePopulaireResponse.fromJson(Map<String, dynamic> json) {
    return LivrePopulaireResponse(
      id: json['id'],
      titre: json['titre'],
      auteur: json['auteur'],
      nombreLectures: json['nombreLectures'],
    );
  }
}

class StatistiquesLivreResponse {
  final int livreId;
  final String titre;
  final String auteur;
  final int? totalPages;
  final int nombreLecteurs;
  final int nombreLecteursComplets;
  final double progressionMoyenne;

  StatistiquesLivreResponse({
    required this.livreId,
    required this.titre,
    required this.auteur,
    this.totalPages,
    required this.nombreLecteurs,
    required this.nombreLecteursComplets,
    required this.progressionMoyenne,
  });

  factory StatistiquesLivreResponse.fromJson(Map<String, dynamic> json) {
    return StatistiquesLivreResponse(
      livreId: json['livreId'],
      titre: json['titre'],
      auteur: json['auteur'],
      totalPages: json['totalPages'],
      nombreLecteurs: json['nombreLecteurs'],
      nombreLecteursComplets: json['nombreLecteursComplets'],
      progressionMoyenne: json['progressionMoyenne']?.toDouble() ?? 0.0,
    );
  }
}

class FichierLivreDto {
  final int id;
  final String? nom;
  final String? type;
  final int? taille;
  final String? format;
  final String? chemin;

  FichierLivreDto({
    required this.id,
    this.nom,
    this.type,
    this.taille,
    this.format,
    this.chemin,
  });

  factory FichierLivreDto.fromJson(Map<String, dynamic> json) {
    return FichierLivreDto(
      id: json['id'],
      nom: json['nom'],
      type: json['type'],
      taille: json['taille'],
      format: json['format'],
      chemin: json['chemin'],
    );
  }
}