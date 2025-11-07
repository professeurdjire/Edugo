//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'classe_request.g.dart';

/// ClasseRequest
///
/// Properties:
/// * [nom] 
/// * [niveauId] 
@BuiltValue()
abstract class ClasseRequest implements Built<ClasseRequest, ClasseRequestBuilder> {
  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'niveauId')
  int? get niveauId;

  ClasseRequest._();

  factory ClasseRequest([void updates(ClasseRequestBuilder b)]) = _$ClasseRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClasseRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClasseRequest> get serializer => _$ClasseRequestSerializer();
}

class _$ClasseRequestSerializer implements PrimitiveSerializer<ClasseRequest> {
  @override
  final Iterable<Type> types = const [ClasseRequest, _$ClasseRequest];

  @override
  final String wireName = r'ClasseRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClasseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.nom != null) {
      yield r'nom';
      yield serializers.serialize(
        object.nom,
        specifiedType: const FullType(String),
      );
    }
    if (object.niveauId != null) {
      yield r'niveauId';
      yield serializers.serialize(
        object.niveauId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClasseRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClasseRequestBuilder result,
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
        case r'niveauId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.niveauId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClasseRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClasseRequestBuilder();
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

