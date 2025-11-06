//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercice_detail_response.g.dart';

/// ExerciceDetailResponse
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [description] 
/// * [niveauDifficulte] 
/// * [tempsAlloue] 
/// * [active] 
/// * [matiereId] 
/// * [matiereNom] 
/// * [niveauId] 
/// * [niveauNom] 
/// * [livreId] 
/// * [livreTitre] 
@BuiltValue()
abstract class ExerciceDetailResponse implements Built<ExerciceDetailResponse, ExerciceDetailResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

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

  @BuiltValueField(wireName: r'matiereNom')
  String? get matiereNom;

  @BuiltValueField(wireName: r'niveauId')
  int? get niveauId;

  @BuiltValueField(wireName: r'niveauNom')
  String? get niveauNom;

  @BuiltValueField(wireName: r'livreId')
  int? get livreId;

  @BuiltValueField(wireName: r'livreTitre')
  String? get livreTitre;

  ExerciceDetailResponse._();

  factory ExerciceDetailResponse([void updates(ExerciceDetailResponseBuilder b)]) = _$ExerciceDetailResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciceDetailResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExerciceDetailResponse> get serializer => _$ExerciceDetailResponseSerializer();
}

class _$ExerciceDetailResponseSerializer implements PrimitiveSerializer<ExerciceDetailResponse> {
  @override
  final Iterable<Type> types = const [ExerciceDetailResponse, _$ExerciceDetailResponse];

  @override
  final String wireName = r'ExerciceDetailResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExerciceDetailResponse object, {
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
    if (object.matiereNom != null) {
      yield r'matiereNom';
      yield serializers.serialize(
        object.matiereNom,
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
    if (object.livreId != null) {
      yield r'livreId';
      yield serializers.serialize(
        object.livreId,
        specifiedType: const FullType(int),
      );
    }
    if (object.livreTitre != null) {
      yield r'livreTitre';
      yield serializers.serialize(
        object.livreTitre,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExerciceDetailResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciceDetailResponseBuilder result,
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
        case r'matiereNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matiereNom = valueDes;
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
        case r'livreId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.livreId = valueDes;
          break;
        case r'livreTitre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.livreTitre = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExerciceDetailResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciceDetailResponseBuilder();
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

