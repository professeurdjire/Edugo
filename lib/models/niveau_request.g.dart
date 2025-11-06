// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'niveau_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NiveauRequest extends NiveauRequest {
  @override
  final String? nom;

  factory _$NiveauRequest([void Function(NiveauRequestBuilder)? updates]) =>
      (NiveauRequestBuilder()..update(updates))._build();

  _$NiveauRequest._({this.nom}) : super._();
  @override
  NiveauRequest rebuild(void Function(NiveauRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NiveauRequestBuilder toBuilder() => NiveauRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NiveauRequest && nom == other.nom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'NiveauRequest',
    )..add('nom', nom)).toString();
  }
}

class NiveauRequestBuilder
    implements Builder<NiveauRequest, NiveauRequestBuilder> {
  _$NiveauRequest? _$v;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  NiveauRequestBuilder() {
    NiveauRequest._defaults(this);
  }

  NiveauRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nom = $v.nom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NiveauRequest other) {
    _$v = other as _$NiveauRequest;
  }

  @override
  void update(void Function(NiveauRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NiveauRequest build() => _build();

  _$NiveauRequest _build() {
    final _$result = _$v ?? _$NiveauRequest._(nom: nom);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
