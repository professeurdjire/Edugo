// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BadgeResponse extends BadgeResponse {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final String? description;
  @override
  final String? type;
  @override
  final String? icone;

  factory _$BadgeResponse([void Function(BadgeResponseBuilder)? updates]) =>
      (BadgeResponseBuilder()..update(updates))._build();

  _$BadgeResponse._({
    this.id,
    this.nom,
    this.description,
    this.type,
    this.icone,
  }) : super._();
  @override
  BadgeResponse rebuild(void Function(BadgeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BadgeResponseBuilder toBuilder() => BadgeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BadgeResponse &&
        id == other.id &&
        nom == other.nom &&
        description == other.description &&
        type == other.type &&
        icone == other.icone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, icone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BadgeResponse')
          ..add('id', id)
          ..add('nom', nom)
          ..add('description', description)
          ..add('type', type)
          ..add('icone', icone))
        .toString();
  }
}

class BadgeResponseBuilder
    implements Builder<BadgeResponse, BadgeResponseBuilder> {
  _$BadgeResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _icone;
  String? get icone => _$this._icone;
  set icone(String? icone) => _$this._icone = icone;

  BadgeResponseBuilder() {
    BadgeResponse._defaults(this);
  }

  BadgeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _description = $v.description;
      _type = $v.type;
      _icone = $v.icone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BadgeResponse other) {
    _$v = other as _$BadgeResponse;
  }

  @override
  void update(void Function(BadgeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BadgeResponse build() => _build();

  _$BadgeResponse _build() {
    final _$result =
        _$v ??
        _$BadgeResponse._(
          id: id,
          nom: nom,
          description: description,
          type: type,
          icone: icone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
