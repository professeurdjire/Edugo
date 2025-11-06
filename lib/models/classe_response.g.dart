// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classe_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClasseResponse extends ClasseResponse {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final int? niveauId;
  @override
  final String? niveauNom;

  factory _$ClasseResponse([void Function(ClasseResponseBuilder)? updates]) =>
      (ClasseResponseBuilder()..update(updates))._build();

  _$ClasseResponse._({this.id, this.nom, this.niveauId, this.niveauNom})
    : super._();
  @override
  ClasseResponse rebuild(void Function(ClasseResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClasseResponseBuilder toBuilder() => ClasseResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClasseResponse &&
        id == other.id &&
        nom == other.nom &&
        niveauId == other.niveauId &&
        niveauNom == other.niveauNom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, niveauId.hashCode);
    _$hash = $jc(_$hash, niveauNom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClasseResponse')
          ..add('id', id)
          ..add('nom', nom)
          ..add('niveauId', niveauId)
          ..add('niveauNom', niveauNom))
        .toString();
  }
}

class ClasseResponseBuilder
    implements Builder<ClasseResponse, ClasseResponseBuilder> {
  _$ClasseResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  int? _niveauId;
  int? get niveauId => _$this._niveauId;
  set niveauId(int? niveauId) => _$this._niveauId = niveauId;

  String? _niveauNom;
  String? get niveauNom => _$this._niveauNom;
  set niveauNom(String? niveauNom) => _$this._niveauNom = niveauNom;

  ClasseResponseBuilder() {
    ClasseResponse._defaults(this);
  }

  ClasseResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _niveauId = $v.niveauId;
      _niveauNom = $v.niveauNom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClasseResponse other) {
    _$v = other as _$ClasseResponse;
  }

  @override
  void update(void Function(ClasseResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClasseResponse build() => _build();

  _$ClasseResponse _build() {
    final _$result =
        _$v ??
        _$ClasseResponse._(
          id: id,
          nom: nom,
          niveauId: niveauId,
          niveauNom: niveauNom,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
