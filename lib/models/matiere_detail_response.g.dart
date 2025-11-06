// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matiere_detail_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MatiereDetailResponse extends MatiereDetailResponse {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final int? nombreLivres;
  @override
  final int? nombreExercices;
  @override
  final int? nombreExercicesActifs;
  @override
  final JsonObject? statistiques;

  factory _$MatiereDetailResponse([
    void Function(MatiereDetailResponseBuilder)? updates,
  ]) => (MatiereDetailResponseBuilder()..update(updates))._build();

  _$MatiereDetailResponse._({
    this.id,
    this.nom,
    this.nombreLivres,
    this.nombreExercices,
    this.nombreExercicesActifs,
    this.statistiques,
  }) : super._();
  @override
  MatiereDetailResponse rebuild(
    void Function(MatiereDetailResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MatiereDetailResponseBuilder toBuilder() =>
      MatiereDetailResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MatiereDetailResponse &&
        id == other.id &&
        nom == other.nom &&
        nombreLivres == other.nombreLivres &&
        nombreExercices == other.nombreExercices &&
        nombreExercicesActifs == other.nombreExercicesActifs &&
        statistiques == other.statistiques;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, nombreLivres.hashCode);
    _$hash = $jc(_$hash, nombreExercices.hashCode);
    _$hash = $jc(_$hash, nombreExercicesActifs.hashCode);
    _$hash = $jc(_$hash, statistiques.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MatiereDetailResponse')
          ..add('id', id)
          ..add('nom', nom)
          ..add('nombreLivres', nombreLivres)
          ..add('nombreExercices', nombreExercices)
          ..add('nombreExercicesActifs', nombreExercicesActifs)
          ..add('statistiques', statistiques))
        .toString();
  }
}

class MatiereDetailResponseBuilder
    implements Builder<MatiereDetailResponse, MatiereDetailResponseBuilder> {
  _$MatiereDetailResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  int? _nombreLivres;
  int? get nombreLivres => _$this._nombreLivres;
  set nombreLivres(int? nombreLivres) => _$this._nombreLivres = nombreLivres;

  int? _nombreExercices;
  int? get nombreExercices => _$this._nombreExercices;
  set nombreExercices(int? nombreExercices) =>
      _$this._nombreExercices = nombreExercices;

  int? _nombreExercicesActifs;
  int? get nombreExercicesActifs => _$this._nombreExercicesActifs;
  set nombreExercicesActifs(int? nombreExercicesActifs) =>
      _$this._nombreExercicesActifs = nombreExercicesActifs;

  JsonObject? _statistiques;
  JsonObject? get statistiques => _$this._statistiques;
  set statistiques(JsonObject? statistiques) =>
      _$this._statistiques = statistiques;

  MatiereDetailResponseBuilder() {
    MatiereDetailResponse._defaults(this);
  }

  MatiereDetailResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _nombreLivres = $v.nombreLivres;
      _nombreExercices = $v.nombreExercices;
      _nombreExercicesActifs = $v.nombreExercicesActifs;
      _statistiques = $v.statistiques;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MatiereDetailResponse other) {
    _$v = other as _$MatiereDetailResponse;
  }

  @override
  void update(void Function(MatiereDetailResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MatiereDetailResponse build() => _build();

  _$MatiereDetailResponse _build() {
    final _$result =
        _$v ??
        _$MatiereDetailResponse._(
          id: id,
          nom: nom,
          nombreLivres: nombreLivres,
          nombreExercices: nombreExercices,
          nombreExercicesActifs: nombreExercicesActifs,
          statistiques: statistiques,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
