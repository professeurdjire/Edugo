/// Livre du catalogue EDUGO, aligné sur la réponse du backend
/// (`GET /livres` — voir backend/src/db.js, livreVersJson).
class Livre {
  final int? id;
  final String titre;
  final String auteur;
  final String description;
  final String niveauScolaire;
  final String matiere;
  final String classe;

  /// Chemin d'asset local ou URL de couverture ; null si absent.
  final String? image;

  const Livre({
    this.id,
    required this.titre,
    this.auteur = '',
    this.description = '',
    this.niveauScolaire = '',
    this.matiere = '',
    this.classe = '',
    this.image,
  });

  factory Livre.fromJson(Map<String, dynamic> json) {
    return Livre(
      id: json['id'] as int?,
      titre: json['titre'] as String? ?? '',
      auteur: json['auteur'] as String? ?? '',
      description: json['description'] as String? ?? '',
      niveauScolaire: json['niveauScolaire'] as String? ?? '',
      matiere: json['matiere'] as String? ?? '',
      classe: json['classe'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}
