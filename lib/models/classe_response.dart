//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'classe_response.g.dart';

/// ClasseResponse
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [niveauId] 
/// * [niveauNom] 
@BuiltValue()
abstract class ClasseResponse implements Built<ClasseResponse, ClasseResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'niveauId')
  int? get niveauId;

  @BuiltValueField(wireName: r'niveauNom')
  String? get niveauNom;

  ClasseResponse._();

  factory ClasseResponse([void updates(ClasseResponseBuilder b)]) = _$ClasseResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClasseResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClasseResponse> get serializer => _$ClasseResponseSerializer();
}

class _$ClasseResponseSerializer implements PrimitiveSerializer<ClasseResponse> {
  @override
  final Iterable<Type> types = const [ClasseResponse, _$ClasseResponse];

  @override
  final String wireName = r'ClasseResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClasseResponse object, {
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
    if (object.niveauId != null) {
      yield r'niveauId';
      yield serializers.serialize(
        object.niveauId,
        specifiedType: const FullType(int),
      );
    }
    if (object.niveauNom != null) {
      yield r'niveauNom';
      yield serializers.serialize(
        object.niveauNom,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClasseResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClasseResponseBuilder result,
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
        case r'niveauId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.niveauId = valueDes;
          break;
        case r'niveauNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.niveauNom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClasseResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClasseResponseBuilder();
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

