//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'matiere_request.g.dart';

/// MatiereRequest
///
/// Properties:
/// * [nom] 
@BuiltValue()
abstract class MatiereRequest implements Built<MatiereRequest, MatiereRequestBuilder> {
  @BuiltValueField(wireName: r'nom')
  String get nom;

  MatiereRequest._();

  factory MatiereRequest([void updates(MatiereRequestBuilder b)]) = _$MatiereRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatiereRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MatiereRequest> get serializer => _$MatiereRequestSerializer();
}

class _$MatiereRequestSerializer implements PrimitiveSerializer<MatiereRequest> {
  @override
  final Iterable<Type> types = const [MatiereRequest, _$MatiereRequest];

  @override
  final String wireName = r'MatiereRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MatiereRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nom';
    yield serializers.serialize(
      object.nom,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MatiereRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatiereRequestBuilder result,
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
  MatiereRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatiereRequestBuilder();
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

