// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BadgeTypeEnum _$badgeTypeEnum_OR = const BadgeTypeEnum._('OR');
const BadgeTypeEnum _$badgeTypeEnum_ARGENT = const BadgeTypeEnum._('ARGENT');
const BadgeTypeEnum _$badgeTypeEnum_BRONZE = const BadgeTypeEnum._('BRONZE');
const BadgeTypeEnum _$badgeTypeEnum_SPECIAL = const BadgeTypeEnum._('SPECIAL');

BadgeTypeEnum _$badgeTypeEnumValueOf(String name) {
  switch (name) {
    case 'OR':
      return _$badgeTypeEnum_OR;
    case 'ARGENT':
      return _$badgeTypeEnum_ARGENT;
    case 'BRONZE':
      return _$badgeTypeEnum_BRONZE;
    case 'SPECIAL':
      return _$badgeTypeEnum_SPECIAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BadgeTypeEnum> _$badgeTypeEnumValues =
    BuiltSet<BadgeTypeEnum>(const <BadgeTypeEnum>[
      _$badgeTypeEnum_OR,
      _$badgeTypeEnum_ARGENT,
      _$badgeTypeEnum_BRONZE,
      _$badgeTypeEnum_SPECIAL,
    ]);

Serializer<BadgeTypeEnum> _$badgeTypeEnumSerializer =
    _$BadgeTypeEnumSerializer();

class _$BadgeTypeEnumSerializer implements PrimitiveSerializer<BadgeTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OR': 'OR',
    'ARGENT': 'ARGENT',
    'BRONZE': 'BRONZE',
    'SPECIAL': 'SPECIAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OR': 'OR',
    'ARGENT': 'ARGENT',
    'BRONZE': 'BRONZE',
    'SPECIAL': 'SPECIAL',
  };

  @override
  final Iterable<Type> types = const <Type>[BadgeTypeEnum];
  @override
  final String wireName = 'BadgeTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    BadgeTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  BadgeTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => BadgeTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Badge extends Badge {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final String? description;
  @override
  final BadgeTypeEnum? type;
  @override
  final String? icone;
  @override
  final BuiltList<Participation>? participations;

  factory _$Badge([void Function(BadgeBuilder)? updates]) =>
      (BadgeBuilder()..update(updates))._build();

  _$Badge._({
    this.id,
    this.nom,
    this.description,
    this.type,
    this.icone,
    this.participations,
  }) : super._();
  @override
  Badge rebuild(void Function(BadgeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BadgeBuilder toBuilder() => BadgeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Badge &&
        id == other.id &&
        nom == other.nom &&
        description == other.description &&
        type == other.type &&
        icone == other.icone &&
        participations == other.participations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, icone.hashCode);
    _$hash = $jc(_$hash, participations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Badge')
          ..add('id', id)
          ..add('nom', nom)
          ..add('description', description)
          ..add('type', type)
          ..add('icone', icone)
          ..add('participations', participations))
        .toString();
  }
}

class BadgeBuilder implements Builder<Badge, BadgeBuilder> {
  _$Badge? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  BadgeTypeEnum? _type;
  BadgeTypeEnum? get type => _$this._type;
  set type(BadgeTypeEnum? type) => _$this._type = type;

  String? _icone;
  String? get icone => _$this._icone;
  set icone(String? icone) => _$this._icone = icone;

  ListBuilder<Participation>? _participations;
  ListBuilder<Participation> get participations =>
      _$this._participations ??= ListBuilder<Participation>();
  set participations(ListBuilder<Participation>? participations) =>
      _$this._participations = participations;

  BadgeBuilder() {
    Badge._defaults(this);
  }

  BadgeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _description = $v.description;
      _type = $v.type;
      _icone = $v.icone;
      _participations = $v.participations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Badge other) {
    _$v = other as _$Badge;
  }

  @override
  void update(void Function(BadgeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Badge build() => _build();

  _$Badge _build() {
    _$Badge _$result;
    try {
      _$result =
          _$v ??
          _$Badge._(
            id: id,
            nom: nom,
            description: description,
            type: type,
            icone: icone,
            participations: _participations?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'participations';
        _participations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Badge', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
