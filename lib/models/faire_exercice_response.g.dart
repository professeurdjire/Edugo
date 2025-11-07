// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faire_exercice_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FaireExerciceResponse extends FaireExerciceResponse {
  @override
  final int? id;
  @override
  final int? eleveId;
  @override
  final String? eleveNom;
  @override
  final int? exerciceId;
  @override
  final String? exerciceTitre;
  @override
  final String? reponse;
  @override
  final int? note;
  @override
  final String? commentaire;
  @override
  final String? statut;
  @override
  final DateTime? dateSoumission;
  @override
  final DateTime? dateCorrection;

  factory _$FaireExerciceResponse([
    void Function(FaireExerciceResponseBuilder)? updates,
  ]) => (FaireExerciceResponseBuilder()..update(updates))._build();

  _$FaireExerciceResponse._({
    this.id,
    this.eleveId,
    this.eleveNom,
    this.exerciceId,
    this.exerciceTitre,
    this.reponse,
    this.note,
    this.commentaire,
    this.statut,
    this.dateSoumission,
    this.dateCorrection,
  }) : super._();
  @override
  FaireExerciceResponse rebuild(
    void Function(FaireExerciceResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FaireExerciceResponseBuilder toBuilder() =>
      FaireExerciceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FaireExerciceResponse &&
        id == other.id &&
        eleveId == other.eleveId &&
        eleveNom == other.eleveNom &&
        exerciceId == other.exerciceId &&
        exerciceTitre == other.exerciceTitre &&
        reponse == other.reponse &&
        note == other.note &&
        commentaire == other.commentaire &&
        statut == other.statut &&
        dateSoumission == other.dateSoumission &&
        dateCorrection == other.dateCorrection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, eleveId.hashCode);
    _$hash = $jc(_$hash, eleveNom.hashCode);
    _$hash = $jc(_$hash, exerciceId.hashCode);
    _$hash = $jc(_$hash, exerciceTitre.hashCode);
    _$hash = $jc(_$hash, reponse.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, commentaire.hashCode);
    _$hash = $jc(_$hash, statut.hashCode);
    _$hash = $jc(_$hash, dateSoumission.hashCode);
    _$hash = $jc(_$hash, dateCorrection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FaireExerciceResponse')
          ..add('id', id)
          ..add('eleveId', eleveId)
          ..add('eleveNom', eleveNom)
          ..add('exerciceId', exerciceId)
          ..add('exerciceTitre', exerciceTitre)
          ..add('reponse', reponse)
          ..add('note', note)
          ..add('commentaire', commentaire)
          ..add('statut', statut)
          ..add('dateSoumission', dateSoumission)
          ..add('dateCorrection', dateCorrection))
        .toString();
  }
}

class FaireExerciceResponseBuilder
    implements Builder<FaireExerciceResponse, FaireExerciceResponseBuilder> {
  _$FaireExerciceResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _eleveId;
  int? get eleveId => _$this._eleveId;
  set eleveId(int? eleveId) => _$this._eleveId = eleveId;

  String? _eleveNom;
  String? get eleveNom => _$this._eleveNom;
  set eleveNom(String? eleveNom) => _$this._eleveNom = eleveNom;

  int? _exerciceId;
  int? get exerciceId => _$this._exerciceId;
  set exerciceId(int? exerciceId) => _$this._exerciceId = exerciceId;

  String? _exerciceTitre;
  String? get exerciceTitre => _$this._exerciceTitre;
  set exerciceTitre(String? exerciceTitre) =>
      _$this._exerciceTitre = exerciceTitre;

  String? _reponse;
  String? get reponse => _$this._reponse;
  set reponse(String? reponse) => _$this._reponse = reponse;

  int? _note;
  int? get note => _$this._note;
  set note(int? note) => _$this._note = note;

  String? _commentaire;
  String? get commentaire => _$this._commentaire;
  set commentaire(String? commentaire) => _$this._commentaire = commentaire;

  String? _statut;
  String? get statut => _$this._statut;
  set statut(String? statut) => _$this._statut = statut;

  DateTime? _dateSoumission;
  DateTime? get dateSoumission => _$this._dateSoumission;
  set dateSoumission(DateTime? dateSoumission) =>
      _$this._dateSoumission = dateSoumission;

  DateTime? _dateCorrection;
  DateTime? get dateCorrection => _$this._dateCorrection;
  set dateCorrection(DateTime? dateCorrection) =>
      _$this._dateCorrection = dateCorrection;

  FaireExerciceResponseBuilder() {
    FaireExerciceResponse._defaults(this);
  }

  FaireExerciceResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _eleveId = $v.eleveId;
      _eleveNom = $v.eleveNom;
      _exerciceId = $v.exerciceId;
      _exerciceTitre = $v.exerciceTitre;
      _reponse = $v.reponse;
      _note = $v.note;
      _commentaire = $v.commentaire;
      _statut = $v.statut;
      _dateSoumission = $v.dateSoumission;
      _dateCorrection = $v.dateCorrection;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FaireExerciceResponse other) {
    _$v = other as _$FaireExerciceResponse;
  }

  @override
  void update(void Function(FaireExerciceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FaireExerciceResponse build() => _build();

  _$FaireExerciceResponse _build() {
    final _$result =
        _$v ??
        _$FaireExerciceResponse._(
          id: id,
          eleveId: eleveId,
          eleveNom: eleveNom,
          exerciceId: exerciceId,
          exerciceTitre: exerciceTitre,
          reponse: reponse,
          note: note,
          commentaire: commentaire,
          statut: statut,
          dateSoumission: dateSoumission,
          dateCorrection: dateCorrection,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
