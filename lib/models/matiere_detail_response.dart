//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'matiere_detail_response.g.dart';

/// MatiereDetailResponse
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [nombreLivres] 
/// * [nombreExercices] 
/// * [nombreExercicesActifs] 
/// * [statistiques] 
@BuiltValue()
abstract class MatiereDetailResponse implements Built<MatiereDetailResponse, MatiereDetailResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'nombreLivres')
  int? get nombreLivres;

  @BuiltValueField(wireName: r'nombreExercices')
  int? get nombreExercices;

  @BuiltValueField(wireName: r'nombreExercicesActifs')
  int? get nombreExercicesActifs;

  @BuiltValueField(wireName: r'statistiques')
  JsonObject? get statistiques;

  MatiereDetailResponse._();

  factory MatiereDetailResponse([void updates(MatiereDetailResponseBuilder b)]) = _$MatiereDetailResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatiereDetailResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MatiereDetailResponse> get serializer => _$MatiereDetailResponseSerializer();
}

class _$MatiereDetailResponseSerializer implements PrimitiveSerializer<MatiereDetailResponse> {
  @override
  final Iterable<Type> types = const [MatiereDetailResponse, _$MatiereDetailResponse];

  @override
  final String wireName = r'MatiereDetailResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MatiereDetailResponse object, {
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
    if (object.nombreLivres != null) {
      yield r'nombreLivres';
      yield serializers.serialize(
        object.nombreLivres,
        specifiedType: const FullType(int),
      );
    }
    if (object.nombreExercices != null) {
      yield r'nombreExercices';
      yield serializers.serialize(
        object.nombreExercices,
        specifiedType: const FullType(int),
      );
    }
    if (object.nombreExercicesActifs != null) {
      yield r'nombreExercicesActifs';
      yield serializers.serialize(
        object.nombreExercicesActifs,
        specifiedType: const FullType(int),
      );
    }
    if (object.statistiques != null) {
      yield r'statistiques';
      yield serializers.serialize(
        object.statistiques,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MatiereDetailResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatiereDetailResponseBuilder result,
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
        case r'nombreLivres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nombreLivres = valueDes;
          break;
        case r'nombreExercices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nombreExercices = valueDes;
          break;
        case r'nombreExercicesActifs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nombreExercicesActifs = valueDes;
          break;
        case r'statistiques':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.statistiques = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MatiereDetailResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatiereDetailResponseBuilder();
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

