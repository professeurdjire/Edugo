//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'correction_request.g.dart';

/// CorrectionRequest
///
/// Properties:
/// * [note] 
/// * [commentaire] 
@BuiltValue()
abstract class CorrectionRequest implements Built<CorrectionRequest, CorrectionRequestBuilder> {
  @BuiltValueField(wireName: r'note')
  int? get note;

  @BuiltValueField(wireName: r'commentaire')
  String? get commentaire;

  CorrectionRequest._();

  factory CorrectionRequest([void updates(CorrectionRequestBuilder b)]) = _$CorrectionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CorrectionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CorrectionRequest> get serializer => _$CorrectionRequestSerializer();
}

class _$CorrectionRequestSerializer implements PrimitiveSerializer<CorrectionRequest> {
  @override
  final Iterable<Type> types = const [CorrectionRequest, _$CorrectionRequest];

  @override
  final String wireName = r'CorrectionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CorrectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(int),
      );
    }
    if (object.commentaire != null) {
      yield r'commentaire';
      yield serializers.serialize(
        object.commentaire,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CorrectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CorrectionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.note = valueDes;
          break;
        case r'commentaire':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.commentaire = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CorrectionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CorrectionRequestBuilder();
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

