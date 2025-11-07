//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'defi_response.g.dart';

/// DefiResponse
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [pointDefi] 
/// * [dateAjout] 
/// * [nbreParticipations] 
/// * [classeId] 
/// * [classeNom] 
/// * [typeDefi] 
@BuiltValue()
abstract class DefiResponse implements Built<DefiResponse, DefiResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

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

  DefiResponse._();

  factory DefiResponse([void updates(DefiResponseBuilder b)]) = _$DefiResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DefiResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DefiResponse> get serializer => _$DefiResponseSerializer();
}

class _$DefiResponseSerializer implements PrimitiveSerializer<DefiResponse> {
  @override
  final Iterable<Type> types = const [DefiResponse, _$DefiResponse];

  @override
  final String wireName = r'DefiResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DefiResponse object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DefiResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DefiResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DefiResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DefiResponseBuilder();
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

