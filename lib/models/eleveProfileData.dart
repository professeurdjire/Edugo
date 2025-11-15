// lib/models/eleve_profile_data.dart
class EleveProfileData {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String? photoProfil;
  final String? telephone;
  final String? ville;
  final int? classeId;
  final String? classeNom;
  final int? niveauId;
  final String? niveauNom;
  final int pointAccumule;
  final String role;

  EleveProfileData({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.photoProfil,
    this.telephone,
    this.ville,
    this.classeId,
    this.classeNom,
    this.niveauId,
    this.niveauNom,
    required this.pointAccumule,
    required this.role,
  });

  factory EleveProfileData.fromJson(Map<String, dynamic> json) {
    return EleveProfileData(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      photoProfil: json['photoProfil'] as String?,
      telephone: _parseTelephone(json['telephone']),
      ville: json['ville'] as String?,
      classeId: json['classeId'] as int?,
      classeNom: json['classeNom'] as String?,
      niveauId: json['niveauId'] as int?,
      niveauNom: json['niveauNom'] as String?,
      pointAccumule: json['pointAccumule'] as int,
      role: json['role'] as String,
    );
  }

  static String? _parseTelephone(dynamic telephone) {
    if (telephone == null) return null;
    if (telephone is String) return telephone;
    if (telephone is int) return telephone.toString();
    return telephone.toString();
  }
}