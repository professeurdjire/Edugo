//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/participation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'badge.g.dart';

/// Badge
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [description] 
/// * [type] 
/// * [icone] 
/// * [participations] 
@BuiltValue()
abstract class Badge implements Built<Badge, BadgeBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'type')
  BadgeTypeEnum? get type;
  // enum typeEnum {  OR,  ARGENT,  BRONZE,  SPECIAL,  };

  @BuiltValueField(wireName: r'icone')
  String? get icone;

  @BuiltValueField(wireName: r'participations')
  BuiltList<Participation>? get participations;

  Badge._();

  factory Badge([void updates(BadgeBuilder b)]) = _$Badge;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BadgeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Badge> get serializer => _$BadgeSerializer();
}

class _$BadgeSerializer implements PrimitiveSerializer<Badge> {
  @override
  final Iterable<Type> types = const [Badge, _$Badge];

  @override
  final String wireName = r'Badge';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Badge object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.nom != null) {
      yield r'nom';
      yield serializers.serialize(
        object.nom,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(BadgeTypeEnum),
      );
    }
    if (object.icone != null) {
      yield r'icone';
      yield serializers.serialize(
        object.icone,
        specifiedType: const FullType(String),
      );
    }
    if (object.participations != null) {
      yield r'participations';
      yield serializers.serialize(
        object.participations,
        specifiedType: const FullType(BuiltList, [FullType(Participation)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Badge object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BadgeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'nom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nom = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BadgeTypeEnum),
          ) as BadgeTypeEnum;
          result.type = valueDes;
          break;
        case r'icone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.icone = valueDes;
          break;
        case r'participations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Participation)]),
          ) as BuiltList<Participation>;
          result.participations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Badge deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BadgeBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class BadgeTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OR')
  static const BadgeTypeEnum OR = _$badgeTypeEnum_OR;
  @BuiltValueEnumConst(wireName: r'ARGENT')
  static const BadgeTypeEnum ARGENT = _$badgeTypeEnum_ARGENT;
  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const BadgeTypeEnum BRONZE = _$badgeTypeEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SPECIAL')
  static const BadgeTypeEnum SPECIAL = _$badgeTypeEnum_SPECIAL;

  static Serializer<BadgeTypeEnum> get serializer => _$badgeTypeEnumSerializer;

  const BadgeTypeEnum._(String name): super(name);

  static BuiltSet<BadgeTypeEnum> get values => _$badgeTypeEnumValues;
  static BadgeTypeEnum valueOf(String name) => _$badgeTypeEnumValueOf(name);
}

