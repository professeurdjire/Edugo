//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'eleve_defi_response.g.dart';

/// EleveDefiResponse
///
/// Properties:
/// * [id] 
/// * [eleveId] 
/// * [nom] 
/// * [prenom] 
/// * [defiId] 
/// * [defiTitre] 
/// * [dateEnvoie] 
/// * [statut] 
@BuiltValue()
abstract class EleveDefiResponse implements Built<EleveDefiResponse, EleveDefiResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'eleveId')
  int? get eleveId;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'prenom')
  String? get prenom;

  @BuiltValueField(wireName: r'defiId')
  int? get defiId;

  @BuiltValueField(wireName: r'defiTitre')
  String? get defiTitre;

  @BuiltValueField(wireName: r'dateEnvoie')
  DateTime? get dateEnvoie;

  @BuiltValueField(wireName: r'statut')
  String? get statut;

  EleveDefiResponse._();

  factory EleveDefiResponse([void updates(EleveDefiResponseBuilder b)]) = _$EleveDefiResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EleveDefiResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EleveDefiResponse> get serializer => _$EleveDefiResponseSerializer();
}

class _$EleveDefiResponseSerializer implements PrimitiveSerializer<EleveDefiResponse> {
  @override
  final Iterable<Type> types = const [EleveDefiResponse, _$EleveDefiResponse];

  @override
  final String wireName = r'EleveDefiResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EleveDefiResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.eleveId != null) {
      yield r'eleveId';
      yield serializers.serialize(
        object.eleveId,
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
    if (object.prenom != null) {
      yield r'prenom';
      yield serializers.serialize(
        object.prenom,
        specifiedType: const FullType(String),
      );
    }
    if (object.defiId != null) {
      yield r'defiId';
      yield serializers.serialize(
        object.defiId,
        specifiedType: const FullType(int),
      );
    }
    if (object.defiTitre != null) {
      yield r'defiTitre';
      yield serializers.serialize(
        object.defiTitre,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateEnvoie != null) {
      yield r'dateEnvoie';
      yield serializers.serialize(
        object.dateEnvoie,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.statut != null) {
      yield r'statut';
      yield serializers.serialize(
        object.statut,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EleveDefiResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EleveDefiResponseBuilder result,
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
        case r'eleveId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.eleveId = valueDes;
          break;
        case r'nom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nom = valueDes;
          break;
        case r'prenom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prenom = valueDes;
          break;
        case r'defiId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.defiId = valueDes;
          break;
        case r'defiTitre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.defiTitre = valueDes;
          break;
        case r'dateEnvoie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateEnvoie = valueDes;
          break;
        case r'statut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statut = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EleveDefiResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EleveDefiResponseBuilder();
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

