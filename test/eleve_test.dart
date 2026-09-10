// Tests unitaires du modèle Eleve.

import 'package:flutter_test/flutter_test.dart';

import 'package:edugo/models/eleve.dart';

void main() {
  const Eleve eleve = Eleve(
    nom: 'Haïdara',
    prenom: 'Haoua',
    telephone: '70000000',
    ville: 'Bamako',
    email: 'haoua@example.com',
    niveauScolaire: 'Primaire',
    classe: 'CM2',
    avatar: 'assets/images/avatar1.png',
  );

  test('toJson puis fromJson restitue le même élève', () {
    final Eleve restored = Eleve.fromJson(eleve.toJson());

    expect(restored.nom, eleve.nom);
    expect(restored.prenom, eleve.prenom);
    expect(restored.telephone, eleve.telephone);
    expect(restored.ville, eleve.ville);
    expect(restored.email, eleve.email);
    expect(restored.niveauScolaire, eleve.niveauScolaire);
    expect(restored.classe, eleve.classe);
    expect(restored.avatar, eleve.avatar);
  });

  test('toJson omet l\'avatar quand il est absent', () {
    const Eleve sansAvatar = Eleve(
      nom: 'Haïdara',
      prenom: 'Haoua',
      telephone: '70000000',
      ville: 'Bamako',
      email: 'haoua@example.com',
      niveauScolaire: 'Primaire',
      classe: 'CM2',
    );

    expect(sansAvatar.toJson().containsKey('avatar'), isFalse);
  });

  test('fromJson tolère les champs manquants', () {
    final Eleve partiel = Eleve.fromJson(const {'nom': 'Haïdara'});

    expect(partiel.nom, 'Haïdara');
    expect(partiel.prenom, '');
    expect(partiel.avatar, isNull);
  });

  test('copyWith ne change que les champs fournis', () {
    final Eleve modifie = eleve.copyWith(ville: 'Ségou');

    expect(modifie.ville, 'Ségou');
    expect(modifie.nom, eleve.nom);
    expect(modifie.avatar, eleve.avatar);
  });
}
