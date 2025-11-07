//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/eleve_lite_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'defi_detail_response.g.dart';

/// DefiDetailResponse
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [ennonce] 
/// * [pointDefi] 
/// * [dateAjout] 
/// * [nbreParticipations] 
/// * [classeId] 
/// * [classeNom] 
/// * [typeDefi] 
/// * [reponseDefi] 
/// * [participants] 
@BuiltValue()
abstract class DefiDetailResponse implements Built<DefiDetailResponse, DefiDetailResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'ennonce')
  String? get ennonce;

  @BuiltValueField(wireName: r'pointDefi')
  int? get pointDefi;

  @BuiltValueField(wireName: r'dateAjout')
  DateTime? get dateAjout;

  @BuiltValueField(wireName: r'nbreParticipations')
  int? get nbreParticipations;

  @BuiltValueField(wireName: r'classeId')
  int? get classeId;

  @BuiltValueField(wireName: r'classeNom')
  String? get classeNom;

  @BuiltValueField(wireName: r'typeDefi')
  String? get typeDefi;

  @BuiltValueField(wireName: r'reponseDefi')
  String? get reponseDefi;

  @BuiltValueField(wireName: r'participants')
  BuiltList<EleveLiteResponse>? get participants;

  DefiDetailResponse._();

  factory DefiDetailResponse([void updates(DefiDetailResponseBuilder b)]) = _$DefiDetailResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DefiDetailResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DefiDetailResponse> get serializer => _$DefiDetailResponseSerializer();
}

class _$DefiDetailResponseSerializer implements PrimitiveSerializer<DefiDetailResponse> {
  @override
  final Iterable<Type> types = const [DefiDetailResponse, _$DefiDetailResponse];

  @override
  final String wireName = r'DefiDetailResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DefiDetailResponse object, {
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
    if (object.ennonce != null) {
      yield r'ennonce';
      yield serializers.serialize(
        object.ennonce,
        specifiedType: const FullType(String),
      );
    }
    if (object.pointDefi != null) {
      yield r'pointDefi';
      yield serializers.serialize(
        object.pointDefi,
        specifiedType: const FullType(int),
      );
    }
    if (object.dateAjout != null) {
      yield r'dateAjout';
      yield serializers.serialize(
        object.dateAjout,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.nbreParticipations != null) {
      yield r'nbreParticipations';
      yield serializers.serialize(
        object.nbreParticipations,
        specifiedType: const FullType(int),
      );
    }
    if (object.classeId != null) {
      yield r'classeId';
      yield serializers.serialize(
        object.classeId,
        specifiedType: const FullType(int),
      );
    }
    if (object.classeNom != null) {
      yield r'classeNom';
      yield serializers.serialize(
        object.classeNom,
        specifiedType: const FullType(String),
      );
    }
    if (object.typeDefi != null) {
      yield r'typeDefi';
      yield serializers.serialize(
        object.typeDefi,
        specifiedType: const FullType(String),
      );
    }
    if (object.reponseDefi != null) {
      yield r'reponseDefi';
      yield serializers.serialize(
        object.reponseDefi,
        specifiedType: const FullType(String),
      );
    }
    if (object.participants != null) {
      yield r'participants';
      yield serializers.serialize(
        object.participants,
        specifiedType: const FullType(BuiltList, [FullType(EleveLiteResponse)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DefiDetailResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DefiDetailResponseBuilder result,
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
        case r'ennonce':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ennonce = valueDes;
          break;
        case r'pointDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pointDefi = valueDes;
          break;
        case r'dateAjout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateAjout = valueDes;
          break;
        case r'nbreParticipations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nbreParticipations = valueDes;
          break;
        case r'classeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.classeId = valueDes;
          break;
        case r'classeNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.classeNom = valueDes;
          break;
        case r'typeDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.typeDefi = valueDes;
          break;
        case r'reponseDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponseDefi = valueDes;
          break;
        case r'participants':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EleveLiteResponse)]),
          ) as BuiltList<EleveLiteResponse>;
          result.participants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DefiDetailResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DefiDetailResponseBuilder();
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

