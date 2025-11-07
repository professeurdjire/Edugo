// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressionResponse extends ProgressionResponse {
  @override
  final int? id;
  @override
  final int? eleveId;
  @override
  final String? eleveNom;
  @override
  final int? livreId;
  @override
  final String? livreTitre;
  @override
  final int? pageActuelle;
  @override
  final int? pourcentageCompletion;
  @override
  final DateTime? dateMiseAJour;

  factory _$ProgressionResponse([
    void Function(ProgressionResponseBuilder)? updates,
  ]) => (ProgressionResponseBuilder()..update(updates))._build();

  _$ProgressionResponse._({
    this.id,
    this.eleveId,
    this.eleveNom,
    this.livreId,
    this.livreTitre,
    this.pageActuelle,
    this.pourcentageCompletion,
    this.dateMiseAJour,
  }) : super._();
  @override
  ProgressionResponse rebuild(
    void Function(ProgressionResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProgressionResponseBuilder toBuilder() =>
      ProgressionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressionResponse &&
        id == other.id &&
        eleveId == other.eleveId &&
        eleveNom == other.eleveNom &&
        livreId == other.livreId &&
        livreTitre == other.livreTitre &&
        pageActuelle == other.pageActuelle &&
        pourcentageCompletion == other.pourcentageCompletion &&
        dateMiseAJour == other.dateMiseAJour;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, eleveId.hashCode);
    _$hash = $jc(_$hash, eleveNom.hashCode);
    _$hash = $jc(_$hash, livreId.hashCode);
    _$hash = $jc(_$hash, livreTitre.hashCode);
    _$hash = $jc(_$hash, pageActuelle.hashCode);
    _$hash = $jc(_$hash, pourcentageCompletion.hashCode);
    _$hash = $jc(_$hash, dateMiseAJour.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressionResponse')
          ..add('id', id)
          ..add('eleveId', eleveId)
          ..add('eleveNom', eleveNom)
          ..add('livreId', livreId)
          ..add('livreTitre', livreTitre)
          ..add('pageActuelle', pageActuelle)
          ..add('pourcentageCompletion', pourcentageCompletion)
          ..add('dateMiseAJour', dateMiseAJour))
        .toString();
  }
}

class ProgressionResponseBuilder
    implements Builder<ProgressionResponse, ProgressionResponseBuilder> {
  _$ProgressionResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _eleveId;
  int? get eleveId => _$this._eleveId;
  set eleveId(int? eleveId) => _$this._eleveId = eleveId;

  String? _eleveNom;
  String? get eleveNom => _$this._eleveNom;
  set eleveNom(String? eleveNom) => _$this._eleveNom = eleveNom;

  int? _livreId;
  int? get livreId => _$this._livreId;
  set livreId(int? livreId) => _$this._livreId = livreId;

  String? _livreTitre;
  String? get livreTitre => _$this._livreTitre;
  set livreTitre(String? livreTitre) => _$this._livreTitre = livreTitre;

  int? _pageActuelle;
  int? get pageActuelle => _$this._pageActuelle;
  set pageActuelle(int? pageActuelle) => _$this._pageActuelle = pageActuelle;

  int? _pourcentageCompletion;
  int? get pourcentageCompletion => _$this._pourcentageCompletion;
  set pourcentageCompletion(int? pourcentageCompletion) =>
      _$this._pourcentageCompletion = pourcentageCompletion;

  DateTime? _dateMiseAJour;
  DateTime? get dateMiseAJour => _$this._dateMiseAJour;
  set dateMiseAJour(DateTime? dateMiseAJour) =>
      _$this._dateMiseAJour = dateMiseAJour;

  ProgressionResponseBuilder() {
    ProgressionResponse._defaults(this);
  }

  ProgressionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _eleveId = $v.eleveId;
      _eleveNom = $v.eleveNom;
      _livreId = $v.livreId;
      _livreTitre = $v.livreTitre;
      _pageActuelle = $v.pageActuelle;
      _pourcentageCompletion = $v.pourcentageCompletion;
      _dateMiseAJour = $v.dateMiseAJour;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressionResponse other) {
    _$v = other as _$ProgressionResponse;
  }

  @override
  void update(void Function(ProgressionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressionResponse build() => _build();

  _$ProgressionResponse _build() {
    final _$result =
        _$v ??
        _$ProgressionResponse._(
          id: id,
          eleveId: eleveId,
          eleveNom: eleveNom,
          livreId: livreId,
          livreTitre: livreTitre,
          pageActuelle: pageActuelle,
          pourcentageCompletion: pourcentageCompletion,
          dateMiseAJour: dateMiseAJour,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
