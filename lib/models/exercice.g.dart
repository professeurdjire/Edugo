// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Exercice extends Exercice {
  @override
  final int? id;
  @override
  final String? titre;
  @override
  final String? description;
  @override
  final int? niveauDifficulte;
  @override
  final int? tempsAlloue;
  @override
  final bool? active;
  @override
  final DateTime? dateCreation;
  @override
  final DateTime? dateModification;
  @override
  final Matiere? matiere;
  @override
  final Niveau? niveauScolaire;
  @override
  final Livre? livre;
  @override
  final BuiltList<Question>? questionsExercice;
  @override
  final BuiltList<FaireExercice>? faireExercices;

  factory _$Exercice([void Function(ExerciceBuilder)? updates]) =>
      (ExerciceBuilder()..update(updates))._build();

  _$Exercice._({
    this.id,
    this.titre,
    this.description,
    this.niveauDifficulte,
    this.tempsAlloue,
    this.active,
    this.dateCreation,
    this.dateModification,
    this.matiere,
    this.niveauScolaire,
    this.livre,
    this.questionsExercice,
    this.faireExercices,
  }) : super._();
  @override
  Exercice rebuild(void Function(ExerciceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciceBuilder toBuilder() => ExerciceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exercice &&
        id == other.id &&
        titre == other.titre &&
        description == other.description &&
        niveauDifficulte == other.niveauDifficulte &&
        tempsAlloue == other.tempsAlloue &&
        active == other.active &&
        dateCreation == other.dateCreation &&
        dateModification == other.dateModification &&
        matiere == other.matiere &&
        niveauScolaire == other.niveauScolaire &&
        livre == other.livre &&
        questionsExercice == other.questionsExercice &&
        faireExercices == other.faireExercices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, niveauDifficulte.hashCode);
    _$hash = $jc(_$hash, tempsAlloue.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, dateCreation.hashCode);
    _$hash = $jc(_$hash, dateModification.hashCode);
    _$hash = $jc(_$hash, matiere.hashCode);
    _$hash = $jc(_$hash, niveauScolaire.hashCode);
    _$hash = $jc(_$hash, livre.hashCode);
    _$hash = $jc(_$hash, questionsExercice.hashCode);
    _$hash = $jc(_$hash, faireExercices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Exercice')
          ..add('id', id)
          ..add('titre', titre)
          ..add('description', description)
          ..add('niveauDifficulte', niveauDifficulte)
          ..add('tempsAlloue', tempsAlloue)
          ..add('active', active)
          ..add('dateCreation', dateCreation)
          ..add('dateModification', dateModification)
          ..add('matiere', matiere)
          ..add('niveauScolaire', niveauScolaire)
          ..add('livre', livre)
          ..add('questionsExercice', questionsExercice)
          ..add('faireExercices', faireExercices))
        .toString();
  }
}

class ExerciceBuilder implements Builder<Exercice, ExerciceBuilder> {
  _$Exercice? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _niveauDifficulte;
  int? get niveauDifficulte => _$this._niveauDifficulte;
  set niveauDifficulte(int? niveauDifficulte) =>
      _$this._niveauDifficulte = niveauDifficulte;

  int? _tempsAlloue;
  int? get tempsAlloue => _$this._tempsAlloue;
  set tempsAlloue(int? tempsAlloue) => _$this._tempsAlloue = tempsAlloue;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DateTime? _dateCreation;
  DateTime? get dateCreation => _$this._dateCreation;
  set dateCreation(DateTime? dateCreation) =>
      _$this._dateCreation = dateCreation;

  DateTime? _dateModification;
  DateTime? get dateModification => _$this._dateModification;
  set dateModification(DateTime? dateModification) =>
      _$this._dateModification = dateModification;

  MatiereBuilder? _matiere;
  MatiereBuilder get matiere => _$this._matiere ??= MatiereBuilder();
  set matiere(MatiereBuilder? matiere) => _$this._matiere = matiere;

  NiveauBuilder? _niveauScolaire;
  NiveauBuilder get niveauScolaire =>
      _$this._niveauScolaire ??= NiveauBuilder();
  set niveauScolaire(NiveauBuilder? niveauScolaire) =>
      _$this._niveauScolaire = niveauScolaire;

  LivreBuilder? _livre;
  LivreBuilder get livre => _$this._livre ??= LivreBuilder();
  set livre(LivreBuilder? livre) => _$this._livre = livre;

  ListBuilder<Question>? _questionsExercice;
  ListBuilder<Question> get questionsExercice =>
      _$this._questionsExercice ??= ListBuilder<Question>();
  set questionsExercice(ListBuilder<Question>? questionsExercice) =>
      _$this._questionsExercice = questionsExercice;

  ListBuilder<FaireExercice>? _faireExercices;
  ListBuilder<FaireExercice> get faireExercices =>
      _$this._faireExercices ??= ListBuilder<FaireExercice>();
  set faireExercices(ListBuilder<FaireExercice>? faireExercices) =>
      _$this._faireExercices = faireExercices;

  ExerciceBuilder() {
    Exercice._defaults(this);
  }

  ExerciceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _description = $v.description;
      _niveauDifficulte = $v.niveauDifficulte;
      _tempsAlloue = $v.tempsAlloue;
      _active = $v.active;
      _dateCreation = $v.dateCreation;
      _dateModification = $v.dateModification;
      _matiere = $v.matiere?.toBuilder();
      _niveauScolaire = $v.niveauScolaire?.toBuilder();
      _livre = $v.livre?.toBuilder();
      _questionsExercice = $v.questionsExercice?.toBuilder();
      _faireExercices = $v.faireExercices?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Exercice other) {
    _$v = other as _$Exercice;
  }

  @override
  void update(void Function(ExerciceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Exercice build() => _build();

  _$Exercice _build() {
    _$Exercice _$result;
    try {
      _$result =
          _$v ??
          _$Exercice._(
            id: id,
            titre: titre,
            description: description,
            niveauDifficulte: niveauDifficulte,
            tempsAlloue: tempsAlloue,
            active: active,
            dateCreation: dateCreation,
            dateModification: dateModification,
            matiere: _matiere?.build(),
            niveauScolaire: _niveauScolaire?.build(),
            livre: _livre?.build(),
            questionsExercice: _questionsExercice?.build(),
            faireExercices: _faireExercices?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'matiere';
        _matiere?.build();
        _$failedField = 'niveauScolaire';
        _niveauScolaire?.build();
        _$failedField = 'livre';
        _livre?.build();
        _$failedField = 'questionsExercice';
        _questionsExercice?.build();
        _$failedField = 'faireExercices';
        _faireExercices?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Exercice',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
