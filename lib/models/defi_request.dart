//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'defi_request.g.dart';

/// DefiRequest
///
/// Properties:
/// * [titre] 
/// * [ennonce] 
/// * [pointDefi] 
/// * [classeId] 
/// * [typeDefi] 
/// * [reponseDefi] 
@BuiltValue()
abstract class DefiRequest implements Built<DefiRequest, DefiRequestBuilder> {
  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'ennonce')
  String? get ennonce;

  @BuiltValueField(wireName: r'pointDefi')
  int? get pointDefi;

  @BuiltValueField(wireName: r'classeId')
  int? get classeId;

  @BuiltValueField(wireName: r'typeDefi')
  String? get typeDefi;

  @BuiltValueField(wireName: r'reponseDefi')
  String? get reponseDefi;

  DefiRequest._();

  factory DefiRequest([void updates(DefiRequestBuilder b)]) = _$DefiRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DefiRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DefiRequest> get serializer => _$DefiRequestSerializer();
}

class _$DefiRequestSerializer implements PrimitiveSerializer<DefiRequest> {
  @override
  final Iterable<Type> types = const [DefiRequest, _$DefiRequest];

  @override
  final String wireName = r'DefiRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DefiRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.titre != null) {
      yield r'titre';
      yield serializers.serialize(
        object.titre,
        specifiedType: const FullType(String),
      );
    }
    if (object.ennonce != null) {
      yield r'ennonce';
      yield serializers.serialize(
        object.ennonce,
        specifiedType: const FullType(String),
      );
    }
    if (object.pointDefi != null) {
      yield r'pointDefi';
      yield serializers.serialize(
        object.pointDefi,
        specifiedType: const FullType(int),
      );
    }
    if (object.classeId != null) {
      yield r'classeId';
      yield serializers.serialize(
        object.classeId,
        specifiedType: const FullType(int),
      );
    }
    if (object.typeDefi != null) {
      yield r'typeDefi';
      yield serializers.serialize(
        object.typeDefi,
        specifiedType: const FullType(String),
      );
    }
    if (object.reponseDefi != null) {
      yield r'reponseDefi';
      yield serializers.serialize(
        object.reponseDefi,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DefiRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DefiRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'titre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titre = valueDes;
          break;
        case r'ennonce':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ennonce = valueDes;
          break;
        case r'pointDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pointDefi = valueDes;
          break;
        case r'classeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.classeId = valueDes;
          break;
        case r'typeDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.typeDefi = valueDes;
          break;
        case r'reponseDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponseDefi = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DefiRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DefiRequestBuilder();
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

