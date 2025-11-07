// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BadgeRequestTypeEnum _$badgeRequestTypeEnum_OR =
    const BadgeRequestTypeEnum._('OR');
const BadgeRequestTypeEnum _$badgeRequestTypeEnum_ARGENT =
    const BadgeRequestTypeEnum._('ARGENT');
const BadgeRequestTypeEnum _$badgeRequestTypeEnum_BRONZE =
    const BadgeRequestTypeEnum._('BRONZE');
const BadgeRequestTypeEnum _$badgeRequestTypeEnum_SPECIAL =
    const BadgeRequestTypeEnum._('SPECIAL');

BadgeRequestTypeEnum _$badgeRequestTypeEnumValueOf(String name) {
  switch (name) {
    case 'OR':
      return _$badgeRequestTypeEnum_OR;
    case 'ARGENT':
      return _$badgeRequestTypeEnum_ARGENT;
    case 'BRONZE':
      return _$badgeRequestTypeEnum_BRONZE;
    case 'SPECIAL':
      return _$badgeRequestTypeEnum_SPECIAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BadgeRequestTypeEnum> _$badgeRequestTypeEnumValues =
    BuiltSet<BadgeRequestTypeEnum>(const <BadgeRequestTypeEnum>[
      _$badgeRequestTypeEnum_OR,
      _$badgeRequestTypeEnum_ARGENT,
      _$badgeRequestTypeEnum_BRONZE,
      _$badgeRequestTypeEnum_SPECIAL,
    ]);

Serializer<BadgeRequestTypeEnum> _$badgeRequestTypeEnumSerializer =
    _$BadgeRequestTypeEnumSerializer();

class _$BadgeRequestTypeEnumSerializer
    implements PrimitiveSerializer<BadgeRequestTypeEnum> {
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
  final Iterable<Type> types = const <Type>[BadgeRequestTypeEnum];
  @override
  final String wireName = 'BadgeRequestTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    BadgeRequestTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  BadgeRequestTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => BadgeRequestTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$BadgeRequest extends BadgeRequest {
  @override
  final int? id;
  @override
  final String nom;
  @override
  final String description;
  @override
  final BadgeRequestTypeEnum type;
  @override
  final String icone;

  factory _$BadgeRequest([void Function(BadgeRequestBuilder)? updates]) =>
      (BadgeRequestBuilder()..update(updates))._build();

  _$BadgeRequest._({
    this.id,
    required this.nom,
    required this.description,
    required this.type,
    required this.icone,
  }) : super._();
  @override
  BadgeRequest rebuild(void Function(BadgeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BadgeRequestBuilder toBuilder() => BadgeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BadgeRequest &&
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
    return (newBuiltValueToStringHelper(r'BadgeRequest')
          ..add('id', id)
          ..add('nom', nom)
          ..add('description', description)
          ..add('type', type)
          ..add('icone', icone))
        .toString();
  }
}

class BadgeRequestBuilder
    implements Builder<BadgeRequest, BadgeRequestBuilder> {
  _$BadgeRequest? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  BadgeRequestTypeEnum? _type;
  BadgeRequestTypeEnum? get type => _$this._type;
  set type(BadgeRequestTypeEnum? type) => _$this._type = type;

  String? _icone;
  String? get icone => _$this._icone;
  set icone(String? icone) => _$this._icone = icone;

  BadgeRequestBuilder() {
    BadgeRequest._defaults(this);
  }

  BadgeRequestBuilder get _$this {
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
  void replace(BadgeRequest other) {
    _$v = other as _$BadgeRequest;
  }

  @override
  void update(void Function(BadgeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BadgeRequest build() => _build();

  _$BadgeRequest _build() {
    final _$result =
        _$v ??
        _$BadgeRequest._(
          id: id,
          nom: BuiltValueNullFieldError.checkNotNull(
            nom,
            r'BadgeRequest',
            'nom',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'BadgeRequest',
            'description',
          ),
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'BadgeRequest',
            'type',
          ),
          icone: BuiltValueNullFieldError.checkNotNull(
            icone,
            r'BadgeRequest',
            'icone',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
