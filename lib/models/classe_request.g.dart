// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classe_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClasseRequest extends ClasseRequest {
  @override
  final String? nom;
  @override
  final int? niveauId;

  factory _$ClasseRequest([void Function(ClasseRequestBuilder)? updates]) =>
      (ClasseRequestBuilder()..update(updates))._build();

  _$ClasseRequest._({this.nom, this.niveauId}) : super._();
  @override
  ClasseRequest rebuild(void Function(ClasseRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClasseRequestBuilder toBuilder() => ClasseRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClasseRequest &&
        nom == other.nom &&
        niveauId == other.niveauId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, niveauId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClasseRequest')
          ..add('nom', nom)
          ..add('niveauId', niveauId))
        .toString();
  }
}

class ClasseRequestBuilder
    implements Builder<ClasseRequest, ClasseRequestBuilder> {
  _$ClasseRequest? _$v;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  int? _niveauId;
  int? get niveauId => _$this._niveauId;
  set niveauId(int? niveauId) => _$this._niveauId = niveauId;

  ClasseRequestBuilder() {
    ClasseRequest._defaults(this);
  }

  ClasseRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nom = $v.nom;
      _niveauId = $v.niveauId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClasseRequest other) {
    _$v = other as _$ClasseRequest;
  }

  @override
  void update(void Function(ClasseRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClasseRequest build() => _build();

  _$ClasseRequest _build() {
    final _$result = _$v ?? _$ClasseRequest._(nom: nom, niveauId: niveauId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
