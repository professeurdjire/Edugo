 // Modèles de données
  class ObjectifRequest {
    final String typeObjectif;
    final int nbreLivre;
    final String dateEnvoie;

    ObjectifRequest({
      required this.typeObjectif,
      required this.nbreLivre,
      required this.dateEnvoie,
    });

    Map<String, dynamic> toJson() {
      return {
        'typeObjectif': typeObjectif,
        'nbreLivre': nbreLivre,
        'dateEnvoie': dateEnvoie,
      };
    }
  }