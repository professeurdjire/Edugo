//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercice_response.g.dart';

/// ExerciceResponse
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [active] 
/// * [niveauDifficulte] 
/// * [tempsAlloue] 
/// * [matiereId] 
/// * [matiereNom] 
@BuiltValue()
abstract class ExerciceResponse implements Built<ExerciceResponse, ExerciceResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'active')
  bool? get active;

  @BuiltValueField(wireName: r'niveauDifficulte')
  int? get niveauDifficulte;

  @BuiltValueField(wireName: r'tempsAlloue')
  int? get tempsAlloue;

  @BuiltValueField(wireName: r'matiereId')
  int? get matiereId;

  @BuiltValueField(wireName: r'matiereNom')
  String? get matiereNom;

  ExerciceResponse._();

  factory ExerciceResponse([void updates(ExerciceResponseBuilder b)]) = _$ExerciceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciceResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExerciceResponse> get serializer => _$ExerciceResponseSerializer();
}

class _$ExerciceResponseSerializer implements PrimitiveSerializer<ExerciceResponse> {
  @override
  final Iterable<Type> types = const [ExerciceResponse, _$ExerciceResponse];

  @override
  final String wireName = r'ExerciceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExerciceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.titre != null) {
      yield r'titre';
      yield serializers.serialize(
        object.titre,
        specifiedType: const FullType(String),
      );
    }
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
    if (object.niveauDifficulte != null) {
      yield r'niveauDifficulte';
      yield serializers.serialize(
        object.niveauDifficulte,
        specifiedType: const FullType(int),
      );
    }
    if (object.tempsAlloue != null) {
      yield r'tempsAlloue';
      yield serializers.serialize(
        object.tempsAlloue,
        specifiedType: const FullType(int),
      );
    }
    if (object.matiereId != null) {
      yield r'matiereId';
      yield serializers.serialize(
        object.matiereId,
        specifiedType: const FullType(int),
      );
    }
    if (object.matiereNom != null) {
      yield r'matiereNom';
      yield serializers.serialize(
        object.matiereNom,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExerciceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciceResponseBuilder result,
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
        case r'titre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titre = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.active = valueDes;
          break;
        case r'niveauDifficulte':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.niveauDifficulte = valueDes;
          break;
        case r'tempsAlloue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tempsAlloue = valueDes;
          break;
        case r'matiereId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.matiereId = valueDes;
          break;
        case r'matiereNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matiereNom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExerciceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciceResponseBuilder();
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

