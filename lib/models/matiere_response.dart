//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'matiere_response.g.dart';

/// MatiereResponse
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [dateCreation] 
/// * [dateModification] 
@BuiltValue()
abstract class MatiereResponse implements Built<MatiereResponse, MatiereResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'dateCreation')
  DateTime? get dateCreation;

  @BuiltValueField(wireName: r'dateModification')
  DateTime? get dateModification;

  MatiereResponse._();

  factory MatiereResponse([void updates(MatiereResponseBuilder b)]) = _$MatiereResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatiereResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MatiereResponse> get serializer => _$MatiereResponseSerializer();
}

class _$MatiereResponseSerializer implements PrimitiveSerializer<MatiereResponse> {
  @override
  final Iterable<Type> types = const [MatiereResponse, _$MatiereResponse];

  @override
  final String wireName = r'MatiereResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MatiereResponse object, {
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
    if (object.dateCreation != null) {
      yield r'dateCreation';
      yield serializers.serialize(
        object.dateCreation,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.dateModification != null) {
      yield r'dateModification';
      yield serializers.serialize(
        object.dateModification,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MatiereResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatiereResponseBuilder result,
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
        case r'dateCreation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateCreation = valueDes;
          break;
        case r'dateModification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateModification = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MatiereResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatiereResponseBuilder();
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

