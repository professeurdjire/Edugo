// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'niveau_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NiveauResponse extends NiveauResponse {
  @override
  final int? id;
  @override
  final String? nom;

  factory _$NiveauResponse([void Function(NiveauResponseBuilder)? updates]) =>
      (NiveauResponseBuilder()..update(updates))._build();

  _$NiveauResponse._({this.id, this.nom}) : super._();
  @override
  NiveauResponse rebuild(void Function(NiveauResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NiveauResponseBuilder toBuilder() => NiveauResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NiveauResponse && id == other.id && nom == other.nom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NiveauResponse')
          ..add('id', id)
          ..add('nom', nom))
        .toString();
  }
}

class NiveauResponseBuilder
    implements Builder<NiveauResponse, NiveauResponseBuilder> {
  _$NiveauResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  NiveauResponseBuilder() {
    NiveauResponse._defaults(this);
  }

  NiveauResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NiveauResponse other) {
    _$v = other as _$NiveauResponse;
  }

  @override
  void update(void Function(NiveauResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NiveauResponse build() => _build();

  _$NiveauResponse _build() {
    final _$result = _$v ?? _$NiveauResponse._(id: id, nom: nom);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
