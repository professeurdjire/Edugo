//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'badge_request.g.dart';

/// BadgeRequest
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [description] 
/// * [type] 
/// * [icone] 
@BuiltValue()
abstract class BadgeRequest implements Built<BadgeRequest, BadgeRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String get nom;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'type')
  BadgeRequestTypeEnum get type;
  // enum typeEnum {  OR,  ARGENT,  BRONZE,  SPECIAL,  };

  @BuiltValueField(wireName: r'icone')
  String get icone;

  BadgeRequest._();

  factory BadgeRequest([void updates(BadgeRequestBuilder b)]) = _$BadgeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BadgeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BadgeRequest> get serializer => _$BadgeRequestSerializer();
}

class _$BadgeRequestSerializer implements PrimitiveSerializer<BadgeRequest> {
  @override
  final Iterable<Type> types = const [BadgeRequest, _$BadgeRequest];

  @override
  final String wireName = r'BadgeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BadgeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    yield r'nom';
    yield serializers.serialize(
      object.nom,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(BadgeRequestTypeEnum),
    );
    yield r'icone';
    yield serializers.serialize(
      object.icone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BadgeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BadgeRequestBuilder result,
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
            specifiedType: const FullType(BadgeRequestTypeEnum),
          ) as BadgeRequestTypeEnum;
          result.type = valueDes;
          break;
        case r'icone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.icone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BadgeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BadgeRequestBuilder();
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

class BadgeRequestTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OR')
  static const BadgeRequestTypeEnum OR = _$badgeRequestTypeEnum_OR;
  @BuiltValueEnumConst(wireName: r'ARGENT')
  static const BadgeRequestTypeEnum ARGENT = _$badgeRequestTypeEnum_ARGENT;
  @BuiltValueEnumConst(wireName: r'BRONZE')
  static const BadgeRequestTypeEnum BRONZE = _$badgeRequestTypeEnum_BRONZE;
  @BuiltValueEnumConst(wireName: r'SPECIAL')
  static const BadgeRequestTypeEnum SPECIAL = _$badgeRequestTypeEnum_SPECIAL;

  static Serializer<BadgeRequestTypeEnum> get serializer => _$badgeRequestTypeEnumSerializer;

  const BadgeRequestTypeEnum._(String name): super(name);

  static BuiltSet<BadgeRequestTypeEnum> get values => _$badgeRequestTypeEnumValues;
  static BadgeRequestTypeEnum valueOf(String name) => _$badgeRequestTypeEnumValueOf(name);
}

