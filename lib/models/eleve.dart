/// Modèle d'un élève, aligné sur les champs du formulaire d'inscription
/// (RegistrationStepperScreen) et de la modification de profil.
class Eleve {
  final String nom;
  final String prenom;
  final String telephone;
  final String ville;
  final String email;
  final String niveauScolaire; // 'Primaire' ou 'Secondaire'
  final String classe;
  final String? avatar; // chemin de l'asset choisi (assets/images/avatarX.png)

  const Eleve({
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.ville,
    required this.email,
    required this.niveauScolaire,
    required this.classe,
    this.avatar,
  });

  factory Eleve.fromJson(Map<String, dynamic> json) {
    return Eleve(
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
      telephone: json['telephone'] as String? ?? '',
      ville: json['ville'] as String? ?? '',
      email: json['email'] as String? ?? '',
      niveauScolaire: json['niveauScolaire'] as String? ?? '',
      classe: json['classe'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'ville': ville,
      'email': email,
      'niveauScolaire': niveauScolaire,
      'classe': classe,
      if (avatar != null) 'avatar': avatar,
    };
  }

  Eleve copyWith({
    String? nom,
    String? prenom,
    String? telephone,
    String? ville,
    String? email,
    String? niveauScolaire,
    String? classe,
    String? avatar,
  }) {
    return Eleve(
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      ville: ville ?? this.ville,
      email: email ?? this.email,
      niveauScolaire: niveauScolaire ?? this.niveauScolaire,
      classe: classe ?? this.classe,
      avatar: avatar ?? this.avatar,
    );
  }
}
