//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercice_request.g.dart';

/// ExerciceRequest
///
/// Properties:
/// * [titre] 
/// * [description] 
/// * [niveauDifficulte] 
/// * [tempsAlloue] 
/// * [active] 
/// * [matiereId] 
/// * [niveauId] 
/// * [livreId] 
@BuiltValue()
abstract class ExerciceRequest implements Built<ExerciceRequest, ExerciceRequestBuilder> {
  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'niveauDifficulte')
  int? get niveauDifficulte;

  @BuiltValueField(wireName: r'tempsAlloue')
  int? get tempsAlloue;

  @BuiltValueField(wireName: r'active')
  bool? get active;

  @BuiltValueField(wireName: r'matiereId')
  int? get matiereId;

  @BuiltValueField(wireName: r'niveauId')
  int? get niveauId;

  @BuiltValueField(wireName: r'livreId')
  int? get livreId;

  ExerciceRequest._();

  factory ExerciceRequest([void updates(ExerciceRequestBuilder b)]) = _$ExerciceRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciceRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExerciceRequest> get serializer => _$ExerciceRequestSerializer();
}

class _$ExerciceRequestSerializer implements PrimitiveSerializer<ExerciceRequest> {
  @override
  final Iterable<Type> types = const [ExerciceRequest, _$ExerciceRequest];

  @override
  final String wireName = r'ExerciceRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExerciceRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.titre != null) {
      yield r'titre';
      yield serializers.serialize(
        object.titre,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
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
    if (object.active != null) {
      yield r'active';
      yield serializers.serialize(
        object.active,
        specifiedType: const FullType(bool),
      );
    }
    if (object.matiereId != null) {
      yield r'matiereId';
      yield serializers.serialize(
        object.matiereId,
        specifiedType: const FullType(int),
      );
    }
    if (object.niveauId != null) {
      yield r'niveauId';
      yield serializers.serialize(
        object.niveauId,
        specifiedType: const FullType(int),
      );
    }
    if (object.livreId != null) {
      yield r'livreId';
      yield serializers.serialize(
        object.livreId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExerciceRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciceRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'titre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titre = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
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
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.active = valueDes;
          break;
        case r'matiereId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.matiereId = valueDes;
          break;
        case r'niveauId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.niveauId = valueDes;
          break;
        case r'livreId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.livreId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExerciceRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciceRequestBuilder();
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

