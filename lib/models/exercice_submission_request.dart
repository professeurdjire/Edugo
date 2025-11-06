//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercice_submission_request.g.dart';

/// ExerciceSubmissionRequest
///
/// Properties:
/// * [reponse] 
@BuiltValue()
abstract class ExerciceSubmissionRequest implements Built<ExerciceSubmissionRequest, ExerciceSubmissionRequestBuilder> {
  @BuiltValueField(wireName: r'reponse')
  String? get reponse;

  ExerciceSubmissionRequest._();

  factory ExerciceSubmissionRequest([void updates(ExerciceSubmissionRequestBuilder b)]) = _$ExerciceSubmissionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciceSubmissionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExerciceSubmissionRequest> get serializer => _$ExerciceSubmissionRequestSerializer();
}

class _$ExerciceSubmissionRequestSerializer implements PrimitiveSerializer<ExerciceSubmissionRequest> {
  @override
  final Iterable<Type> types = const [ExerciceSubmissionRequest, _$ExerciceSubmissionRequest];

  @override
  final String wireName = r'ExerciceSubmissionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExerciceSubmissionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.reponse != null) {
      yield r'reponse';
      yield serializers.serialize(
        object.reponse,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExerciceSubmissionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciceSubmissionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reponse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponse = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExerciceSubmissionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciceSubmissionRequestBuilder();
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

