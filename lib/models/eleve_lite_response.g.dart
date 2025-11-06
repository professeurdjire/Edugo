// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleve_lite_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EleveLiteResponse extends EleveLiteResponse {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final String? prenom;

  factory _$EleveLiteResponse([
    void Function(EleveLiteResponseBuilder)? updates,
  ]) => (EleveLiteResponseBuilder()..update(updates))._build();

  _$EleveLiteResponse._({this.id, this.nom, this.prenom}) : super._();
  @override
  EleveLiteResponse rebuild(void Function(EleveLiteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EleveLiteResponseBuilder toBuilder() =>
      EleveLiteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EleveLiteResponse &&
        id == other.id &&
        nom == other.nom &&
        prenom == other.prenom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, prenom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EleveLiteResponse')
          ..add('id', id)
          ..add('nom', nom)
          ..add('prenom', prenom))
        .toString();
  }
}

class EleveLiteResponseBuilder
    implements Builder<EleveLiteResponse, EleveLiteResponseBuilder> {
  _$EleveLiteResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _prenom;
  String? get prenom => _$this._prenom;
  set prenom(String? prenom) => _$this._prenom = prenom;

  EleveLiteResponseBuilder() {
    EleveLiteResponse._defaults(this);
  }

  EleveLiteResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _prenom = $v.prenom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EleveLiteResponse other) {
    _$v = other as _$EleveLiteResponse;
  }

  @override
  void update(void Function(EleveLiteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EleveLiteResponse build() => _build();

  _$EleveLiteResponse _build() {
    final _$result =
        _$v ?? _$EleveLiteResponse._(id: id, nom: nom, prenom: prenom);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
