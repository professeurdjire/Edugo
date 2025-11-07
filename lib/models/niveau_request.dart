//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'niveau_request.g.dart';

/// NiveauRequest
///
/// Properties:
/// * [nom] 
@BuiltValue()
abstract class NiveauRequest implements Built<NiveauRequest, NiveauRequestBuilder> {
  @BuiltValueField(wireName: r'nom')
  String? get nom;

  NiveauRequest._();

  factory NiveauRequest([void updates(NiveauRequestBuilder b)]) = _$NiveauRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NiveauRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NiveauRequest> get serializer => _$NiveauRequestSerializer();
}

class _$NiveauRequestSerializer implements PrimitiveSerializer<NiveauRequest> {
  @override
  final Iterable<Type> types = const [NiveauRequest, _$NiveauRequest];

  @override
  final String wireName = r'NiveauRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NiveauRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.nom != null) {
      yield r'nom';
      yield serializers.serialize(
        object.nom,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NiveauRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NiveauRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NiveauRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NiveauRequestBuilder();
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

