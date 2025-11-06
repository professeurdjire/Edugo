// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercice_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExerciceRequest extends ExerciceRequest {
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
  final int? niveauId;
  @override
  final int? livreId;

  factory _$ExerciceRequest([void Function(ExerciceRequestBuilder)? updates]) =>
      (ExerciceRequestBuilder()..update(updates))._build();

  _$ExerciceRequest._({
    this.titre,
    this.description,
    this.niveauDifficulte,
    this.tempsAlloue,
    this.active,
    this.matiereId,
    this.niveauId,
    this.livreId,
  }) : super._();
  @override
  ExerciceRequest rebuild(void Function(ExerciceRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciceRequestBuilder toBuilder() => ExerciceRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciceRequest &&
        titre == other.titre &&
        description == other.description &&
        niveauDifficulte == other.niveauDifficulte &&
        tempsAlloue == other.tempsAlloue &&
        active == other.active &&
        matiereId == other.matiereId &&
        niveauId == other.niveauId &&
        livreId == other.livreId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, niveauDifficulte.hashCode);
    _$hash = $jc(_$hash, tempsAlloue.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, matiereId.hashCode);
    _$hash = $jc(_$hash, niveauId.hashCode);
    _$hash = $jc(_$hash, livreId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExerciceRequest')
          ..add('titre', titre)
          ..add('description', description)
          ..add('niveauDifficulte', niveauDifficulte)
          ..add('tempsAlloue', tempsAlloue)
          ..add('active', active)
          ..add('matiereId', matiereId)
          ..add('niveauId', niveauId)
          ..add('livreId', livreId))
        .toString();
  }
}

class ExerciceRequestBuilder
    implements Builder<ExerciceRequest, ExerciceRequestBuilder> {
  _$ExerciceRequest? _$v;

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

  int? _niveauId;
  int? get niveauId => _$this._niveauId;
  set niveauId(int? niveauId) => _$this._niveauId = niveauId;

  int? _livreId;
  int? get livreId => _$this._livreId;
  set livreId(int? livreId) => _$this._livreId = livreId;

  ExerciceRequestBuilder() {
    ExerciceRequest._defaults(this);
  }

  ExerciceRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _titre = $v.titre;
      _description = $v.description;
      _niveauDifficulte = $v.niveauDifficulte;
      _tempsAlloue = $v.tempsAlloue;
      _active = $v.active;
      _matiereId = $v.matiereId;
      _niveauId = $v.niveauId;
      _livreId = $v.livreId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExerciceRequest other) {
    _$v = other as _$ExerciceRequest;
  }

  @override
  void update(void Function(ExerciceRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExerciceRequest build() => _build();

  _$ExerciceRequest _build() {
    final _$result =
        _$v ??
        _$ExerciceRequest._(
          titre: titre,
          description: description,
          niveauDifficulte: niveauDifficulte,
          tempsAlloue: tempsAlloue,
          active: active,
          matiereId: matiereId,
          niveauId: niveauId,
          livreId: livreId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
