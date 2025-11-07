//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progression_update_request.g.dart';

/// ProgressionUpdateRequest
///
/// Properties:
/// * [pageActuelle] 
@BuiltValue()
abstract class ProgressionUpdateRequest implements Built<ProgressionUpdateRequest, ProgressionUpdateRequestBuilder> {
  @BuiltValueField(wireName: r'pageActuelle')
  int? get pageActuelle;

  ProgressionUpdateRequest._();

  factory ProgressionUpdateRequest([void updates(ProgressionUpdateRequestBuilder b)]) = _$ProgressionUpdateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressionUpdateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressionUpdateRequest> get serializer => _$ProgressionUpdateRequestSerializer();
}

class _$ProgressionUpdateRequestSerializer implements PrimitiveSerializer<ProgressionUpdateRequest> {
  @override
  final Iterable<Type> types = const [ProgressionUpdateRequest, _$ProgressionUpdateRequest];

  @override
  final String wireName = r'ProgressionUpdateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressionUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pageActuelle != null) {
      yield r'pageActuelle';
      yield serializers.serialize(
        object.pageActuelle,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressionUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressionUpdateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pageActuelle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pageActuelle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressionUpdateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressionUpdateRequestBuilder();
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

