//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'eleve_lite_response.g.dart';

/// EleveLiteResponse
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [prenom] 
@BuiltValue()
abstract class EleveLiteResponse implements Built<EleveLiteResponse, EleveLiteResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'prenom')
  String? get prenom;

  EleveLiteResponse._();

  factory EleveLiteResponse([void updates(EleveLiteResponseBuilder b)]) = _$EleveLiteResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EleveLiteResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EleveLiteResponse> get serializer => _$EleveLiteResponseSerializer();
}

class _$EleveLiteResponseSerializer implements PrimitiveSerializer<EleveLiteResponse> {
  @override
  final Iterable<Type> types = const [EleveLiteResponse, _$EleveLiteResponse];

  @override
  final String wireName = r'EleveLiteResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EleveLiteResponse object, {
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
    if (object.prenom != null) {
      yield r'prenom';
      yield serializers.serialize(
        object.prenom,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EleveLiteResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EleveLiteResponseBuilder result,
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
        case r'prenom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prenom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EleveLiteResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EleveLiteResponseBuilder();
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

