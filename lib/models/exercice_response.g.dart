// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercice_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExerciceResponse extends ExerciceResponse {
  @override
  final int? id;
  @override
  final String? titre;
  @override
  final bool? active;
  @override
  final int? niveauDifficulte;
  @override
  final int? tempsAlloue;
  @override
  final int? matiereId;
  @override
  final String? matiereNom;

  factory _$ExerciceResponse([
    void Function(ExerciceResponseBuilder)? updates,
  ]) => (ExerciceResponseBuilder()..update(updates))._build();

  _$ExerciceResponse._({
    this.id,
    this.titre,
    this.active,
    this.niveauDifficulte,
    this.tempsAlloue,
    this.matiereId,
    this.matiereNom,
  }) : super._();
  @override
  ExerciceResponse rebuild(void Function(ExerciceResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciceResponseBuilder toBuilder() =>
      ExerciceResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciceResponse &&
        id == other.id &&
        titre == other.titre &&
        active == other.active &&
        niveauDifficulte == other.niveauDifficulte &&
        tempsAlloue == other.tempsAlloue &&
        matiereId == other.matiereId &&
        matiereNom == other.matiereNom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, niveauDifficulte.hashCode);
    _$hash = $jc(_$hash, tempsAlloue.hashCode);
    _$hash = $jc(_$hash, matiereId.hashCode);
    _$hash = $jc(_$hash, matiereNom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExerciceResponse')
          ..add('id', id)
          ..add('titre', titre)
          ..add('active', active)
          ..add('niveauDifficulte', niveauDifficulte)
          ..add('tempsAlloue', tempsAlloue)
          ..add('matiereId', matiereId)
          ..add('matiereNom', matiereNom))
        .toString();
  }
}

class ExerciceResponseBuilder
    implements Builder<ExerciceResponse, ExerciceResponseBuilder> {
  _$ExerciceResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  int? _niveauDifficulte;
  int? get niveauDifficulte => _$this._niveauDifficulte;
  set niveauDifficulte(int? niveauDifficulte) =>
      _$this._niveauDifficulte = niveauDifficulte;

  int? _tempsAlloue;
  int? get tempsAlloue => _$this._tempsAlloue;
  set tempsAlloue(int? tempsAlloue) => _$this._tempsAlloue = tempsAlloue;

  int? _matiereId;
  int? get matiereId => _$this._matiereId;
  set matiereId(int? matiereId) => _$this._matiereId = matiereId;

  String? _matiereNom;
  String? get matiereNom => _$this._matiereNom;
  set matiereNom(String? matiereNom) => _$this._matiereNom = matiereNom;

  ExerciceResponseBuilder() {
    ExerciceResponse._defaults(this);
  }

  ExerciceResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _active = $v.active;
      _niveauDifficulte = $v.niveauDifficulte;
      _tempsAlloue = $v.tempsAlloue;
      _matiereId = $v.matiereId;
      _matiereNom = $v.matiereNom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExerciceResponse other) {
    _$v = other as _$ExerciceResponse;
  }

  @override
  void update(void Function(ExerciceResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExerciceResponse build() => _build();

  _$ExerciceResponse _build() {
    final _$result =
        _$v ??
        _$ExerciceResponse._(
          id: id,
          titre: titre,
          active: active,
          niveauDifficulte: niveauDifficulte,
          tempsAlloue: tempsAlloue,
          matiereId: matiereId,
          matiereNom: matiereNom,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
