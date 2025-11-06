//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'faire_exercice_response.g.dart';

/// FaireExerciceResponse
///
/// Properties:
/// * [id] 
/// * [eleveId] 
/// * [eleveNom] 
/// * [exerciceId] 
/// * [exerciceTitre] 
/// * [reponse] 
/// * [note] 
/// * [commentaire] 
/// * [statut] 
/// * [dateSoumission] 
/// * [dateCorrection] 
@BuiltValue()
abstract class FaireExerciceResponse implements Built<FaireExerciceResponse, FaireExerciceResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'eleveId')
  int? get eleveId;

  @BuiltValueField(wireName: r'eleveNom')
  String? get eleveNom;

  @BuiltValueField(wireName: r'exerciceId')
  int? get exerciceId;

  @BuiltValueField(wireName: r'exerciceTitre')
  String? get exerciceTitre;

  @BuiltValueField(wireName: r'reponse')
  String? get reponse;

  @BuiltValueField(wireName: r'note')
  int? get note;

  @BuiltValueField(wireName: r'commentaire')
  String? get commentaire;

  @BuiltValueField(wireName: r'statut')
  String? get statut;

  @BuiltValueField(wireName: r'dateSoumission')
  DateTime? get dateSoumission;

  @BuiltValueField(wireName: r'dateCorrection')
  DateTime? get dateCorrection;

  FaireExerciceResponse._();

  factory FaireExerciceResponse([void updates(FaireExerciceResponseBuilder b)]) = _$FaireExerciceResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FaireExerciceResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FaireExerciceResponse> get serializer => _$FaireExerciceResponseSerializer();
}

class _$FaireExerciceResponseSerializer implements PrimitiveSerializer<FaireExerciceResponse> {
  @override
  final Iterable<Type> types = const [FaireExerciceResponse, _$FaireExerciceResponse];

  @override
  final String wireName = r'FaireExerciceResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FaireExerciceResponse object, {
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
    if (object.exerciceId != null) {
      yield r'exerciceId';
      yield serializers.serialize(
        object.exerciceId,
        specifiedType: const FullType(int),
      );
    }
    if (object.exerciceTitre != null) {
      yield r'exerciceTitre';
      yield serializers.serialize(
        object.exerciceTitre,
        specifiedType: const FullType(String),
      );
    }
    if (object.reponse != null) {
      yield r'reponse';
      yield serializers.serialize(
        object.reponse,
        specifiedType: const FullType(String),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(int),
      );
    }
    if (object.commentaire != null) {
      yield r'commentaire';
      yield serializers.serialize(
        object.commentaire,
        specifiedType: const FullType(String),
      );
    }
    if (object.statut != null) {
      yield r'statut';
      yield serializers.serialize(
        object.statut,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateSoumission != null) {
      yield r'dateSoumission';
      yield serializers.serialize(
        object.dateSoumission,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.dateCorrection != null) {
      yield r'dateCorrection';
      yield serializers.serialize(
        object.dateCorrection,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FaireExerciceResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FaireExerciceResponseBuilder result,
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
        case r'exerciceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.exerciceId = valueDes;
          break;
        case r'exerciceTitre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.exerciceTitre = valueDes;
          break;
        case r'reponse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponse = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.note = valueDes;
          break;
        case r'commentaire':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.commentaire = valueDes;
          break;
        case r'statut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statut = valueDes;
          break;
        case r'dateSoumission':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateSoumission = valueDes;
          break;
        case r'dateCorrection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateCorrection = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FaireExerciceResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FaireExerciceResponseBuilder();
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

