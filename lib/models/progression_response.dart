//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progression_response.g.dart';

/// ProgressionResponse
///
/// Properties:
/// * [id] 
/// * [eleveId] 
/// * [eleveNom] 
/// * [livreId] 
/// * [livreTitre] 
/// * [pageActuelle] 
/// * [pourcentageCompletion] 
/// * [dateMiseAJour] 
@BuiltValue()
abstract class ProgressionResponse implements Built<ProgressionResponse, ProgressionResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'eleveId')
  int? get eleveId;

  @BuiltValueField(wireName: r'eleveNom')
  String? get eleveNom;

  @BuiltValueField(wireName: r'livreId')
  int? get livreId;

  @BuiltValueField(wireName: r'livreTitre')
  String? get livreTitre;

  @BuiltValueField(wireName: r'pageActuelle')
  int? get pageActuelle;

  @BuiltValueField(wireName: r'pourcentageCompletion')
  int? get pourcentageCompletion;

  @BuiltValueField(wireName: r'dateMiseAJour')
  DateTime? get dateMiseAJour;

  ProgressionResponse._();

  factory ProgressionResponse([void updates(ProgressionResponseBuilder b)]) = _$ProgressionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProgressionResponse> get serializer => _$ProgressionResponseSerializer();
}

class _$ProgressionResponseSerializer implements PrimitiveSerializer<ProgressionResponse> {
  @override
  final Iterable<Type> types = const [ProgressionResponse, _$ProgressionResponse];

  @override
  final String wireName = r'ProgressionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProgressionResponse object, {
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
    if (object.eleveNom != null) {
      yield r'eleveNom';
      yield serializers.serialize(
        object.eleveNom,
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
    if (object.pageActuelle != null) {
      yield r'pageActuelle';
      yield serializers.serialize(
        object.pageActuelle,
        specifiedType: const FullType(int),
      );
    }
    if (object.pourcentageCompletion != null) {
      yield r'pourcentageCompletion';
      yield serializers.serialize(
        object.pourcentageCompletion,
        specifiedType: const FullType(int),
      );
    }
    if (object.dateMiseAJour != null) {
      yield r'dateMiseAJour';
      yield serializers.serialize(
        object.dateMiseAJour,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProgressionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressionResponseBuilder result,
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
        case r'eleveNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eleveNom = valueDes;
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
        case r'pageActuelle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pageActuelle = valueDes;
          break;
        case r'pourcentageCompletion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pourcentageCompletion = valueDes;
          break;
        case r'dateMiseAJour':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateMiseAJour = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProgressionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressionResponseBuilder();
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

