class ObjectifResponse {
    final int idObjectif;
    final String typeObjectif;
    final int nbreLivre;
    final String dateEnvoie;
    final String dateFin;
    final double progression;
    final int joursRestants;
    final int livresLus;
    final String statut;

    ObjectifResponse({
      required this.idObjectif,
      required this.typeObjectif,
      required this.nbreLivre,
      required this.dateEnvoie,
      required this.dateFin,
      required this.progression,
      required this.joursRestants,
      required this.livresLus,
      required this.statut,
    });

    factory ObjectifResponse.fromJson(Map<String, dynamic> json) {
      return ObjectifResponse(
        idObjectif: json['idObjectif'] ?? 0,
        typeObjectif: json['typeObjectif'] ?? '',
        nbreLivre: json['nbreLivre'] ?? 0,
        dateEnvoie: json['dateEnvoie'] ?? '',
        dateFin: json['dateFin'] ?? '',
        progression: (json['progression'] ?? 0.0).toDouble(),
        joursRestants: json['joursRestants'] ?? 0,
        livresLus: json['livresLus'] ?? 0,
        statut: json['statut'] ?? '',
      );
    }
  }
