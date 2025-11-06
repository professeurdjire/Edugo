// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercice_detail_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExerciceDetailResponse extends ExerciceDetailResponse {
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
  final int? matiereId;
  @override
  final String? matiereNom;
  @override
  final int? niveauId;
  @override
  final String? niveauNom;
  @override
  final int? livreId;
  @override
  final String? livreTitre;

  factory _$ExerciceDetailResponse([
    void Function(ExerciceDetailResponseBuilder)? updates,
  ]) => (ExerciceDetailResponseBuilder()..update(updates))._build();

  _$ExerciceDetailResponse._({
    this.id,
    this.titre,
    this.description,
    this.niveauDifficulte,
    this.tempsAlloue,
    this.active,
    this.matiereId,
    this.matiereNom,
    this.niveauId,
    this.niveauNom,
    this.livreId,
    this.livreTitre,
  }) : super._();
  @override
  ExerciceDetailResponse rebuild(
    void Function(ExerciceDetailResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ExerciceDetailResponseBuilder toBuilder() =>
      ExerciceDetailResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciceDetailResponse &&
        id == other.id &&
        titre == other.titre &&
        description == other.description &&
        niveauDifficulte == other.niveauDifficulte &&
        tempsAlloue == other.tempsAlloue &&
        active == other.active &&
        matiereId == other.matiereId &&
        matiereNom == other.matiereNom &&
        niveauId == other.niveauId &&
        niveauNom == other.niveauNom &&
        livreId == other.livreId &&
        livreTitre == other.livreTitre;
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
    _$hash = $jc(_$hash, matiereId.hashCode);
    _$hash = $jc(_$hash, matiereNom.hashCode);
    _$hash = $jc(_$hash, niveauId.hashCode);
    _$hash = $jc(_$hash, niveauNom.hashCode);
    _$hash = $jc(_$hash, livreId.hashCode);
    _$hash = $jc(_$hash, livreTitre.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExerciceDetailResponse')
          ..add('id', id)
          ..add('titre', titre)
          ..add('description', description)
          ..add('niveauDifficulte', niveauDifficulte)
          ..add('tempsAlloue', tempsAlloue)
          ..add('active', active)
          ..add('matiereId', matiereId)
          ..add('matiereNom', matiereNom)
          ..add('niveauId', niveauId)
          ..add('niveauNom', niveauNom)
          ..add('livreId', livreId)
          ..add('livreTitre', livreTitre))
        .toString();
  }
}

class ExerciceDetailResponseBuilder
    implements Builder<ExerciceDetailResponse, ExerciceDetailResponseBuilder> {
  _$ExerciceDetailResponse? _$v;

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

  int? _matiereId;
  int? get matiereId => _$this._matiereId;
  set matiereId(int? matiereId) => _$this._matiereId = matiereId;

  String? _matiereNom;
  String? get matiereNom => _$this._matiereNom;
  set matiereNom(String? matiereNom) => _$this._matiereNom = matiereNom;

  int? _niveauId;
  int? get niveauId => _$this._niveauId;
  set niveauId(int? niveauId) => _$this._niveauId = niveauId;

  String? _niveauNom;
  String? get niveauNom => _$this._niveauNom;
  set niveauNom(String? niveauNom) => _$this._niveauNom = niveauNom;

  int? _livreId;
  int? get livreId => _$this._livreId;
  set livreId(int? livreId) => _$this._livreId = livreId;

  String? _livreTitre;
  String? get livreTitre => _$this._livreTitre;
  set livreTitre(String? livreTitre) => _$this._livreTitre = livreTitre;

  ExerciceDetailResponseBuilder() {
    ExerciceDetailResponse._defaults(this);
  }

  ExerciceDetailResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _description = $v.description;
      _niveauDifficulte = $v.niveauDifficulte;
      _tempsAlloue = $v.tempsAlloue;
      _active = $v.active;
      _matiereId = $v.matiereId;
      _matiereNom = $v.matiereNom;
      _niveauId = $v.niveauId;
      _niveauNom = $v.niveauNom;
      _livreId = $v.livreId;
      _livreTitre = $v.livreTitre;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExerciceDetailResponse other) {
    _$v = other as _$ExerciceDetailResponse;
  }

  @override
  void update(void Function(ExerciceDetailResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExerciceDetailResponse build() => _build();

  _$ExerciceDetailResponse _build() {
    final _$result =
        _$v ??
        _$ExerciceDetailResponse._(
          id: id,
          titre: titre,
          description: description,
          niveauDifficulte: niveauDifficulte,
          tempsAlloue: tempsAlloue,
          active: active,
          matiereId: matiereId,
          matiereNom: matiereNom,
          niveauId: niveauId,
          niveauNom: niveauNom,
          livreId: livreId,
          livreTitre: livreTitre,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
