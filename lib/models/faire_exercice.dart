//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/eleve.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/exercice.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'faire_exercice.g.dart';

/// FaireExercice
///
/// Properties:
/// * [id] 
/// * [eleve] 
/// * [exercice] 
/// * [pointExercice] 
/// * [statut] 
/// * [dateExercice] 
/// * [reponse] 
/// * [dateSoumission] 
/// * [note] 
/// * [commentaire] 
/// * [dateCorrection] 
@BuiltValue()
abstract class FaireExercice implements Built<FaireExercice, FaireExerciceBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'eleve')
  Eleve? get eleve;

  @BuiltValueField(wireName: r'exercice')
  Exercice? get exercice;

  @BuiltValueField(wireName: r'pointExercice')
  int? get pointExercice;

  @BuiltValueField(wireName: r'statut')
  FaireExerciceStatutEnum? get statut;
  // enum statutEnum {  PAS_DEBUTE,  ENCOURS,  TERMINE,  SOUMIS,  CORRIGE,  };

  @BuiltValueField(wireName: r'dateExercice')
  DateTime? get dateExercice;

  @BuiltValueField(wireName: r'reponse')
  String? get reponse;

  @BuiltValueField(wireName: r'dateSoumission')
  DateTime? get dateSoumission;

  @BuiltValueField(wireName: r'note')
  int? get note;

  @BuiltValueField(wireName: r'commentaire')
  String? get commentaire;

  @BuiltValueField(wireName: r'dateCorrection')
  DateTime? get dateCorrection;

  FaireExercice._();

  factory FaireExercice([void updates(FaireExerciceBuilder b)]) = _$FaireExercice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FaireExerciceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FaireExercice> get serializer => _$FaireExerciceSerializer();
}

class _$FaireExerciceSerializer implements PrimitiveSerializer<FaireExercice> {
  @override
  final Iterable<Type> types = const [FaireExercice, _$FaireExercice];

  @override
  final String wireName = r'FaireExercice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FaireExercice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.eleve != null) {
      yield r'eleve';
      yield serializers.serialize(
        object.eleve,
        specifiedType: const FullType(Eleve),
      );
    }
    if (object.exercice != null) {
      yield r'exercice';
      yield serializers.serialize(
        object.exercice,
        specifiedType: const FullType(Exercice),
      );
    }
    if (object.pointExercice != null) {
      yield r'pointExercice';
      yield serializers.serialize(
        object.pointExercice,
        specifiedType: const FullType(int),
      );
    }
    if (object.statut != null) {
      yield r'statut';
      yield serializers.serialize(
        object.statut,
        specifiedType: const FullType(FaireExerciceStatutEnum),
      );
    }
    if (object.dateExercice != null) {
      yield r'dateExercice';
      yield serializers.serialize(
        object.dateExercice,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.reponse != null) {
      yield r'reponse';
      yield serializers.serialize(
        object.reponse,
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
    FaireExercice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FaireExerciceBuilder result,
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
        case r'eleve':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Eleve),
          ) as Eleve;
          result.eleve.replace(valueDes);
          break;
        case r'exercice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Exercice),
          ) as Exercice;
          result.exercice.replace(valueDes);
          break;
        case r'pointExercice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pointExercice = valueDes;
          break;
        case r'statut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FaireExerciceStatutEnum),
          ) as FaireExerciceStatutEnum;
          result.statut = valueDes;
          break;
        case r'dateExercice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateExercice = valueDes;
          break;
        case r'reponse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponse = valueDes;
          break;
        case r'dateSoumission':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateSoumission = valueDes;
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
  FaireExercice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FaireExerciceBuilder();
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

class FaireExerciceStatutEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PAS_DEBUTE')
  static const FaireExerciceStatutEnum PAS_DEBUTE = _$faireExerciceStatutEnum_PAS_DEBUTE;
  @BuiltValueEnumConst(wireName: r'ENCOURS')
  static const FaireExerciceStatutEnum ENCOURS = _$faireExerciceStatutEnum_ENCOURS;
  @BuiltValueEnumConst(wireName: r'TERMINE')
  static const FaireExerciceStatutEnum TERMINE = _$faireExerciceStatutEnum_TERMINE;
  @BuiltValueEnumConst(wireName: r'SOUMIS')
  static const FaireExerciceStatutEnum SOUMIS = _$faireExerciceStatutEnum_SOUMIS;
  @BuiltValueEnumConst(wireName: r'CORRIGE')
  static const FaireExerciceStatutEnum CORRIGE = _$faireExerciceStatutEnum_CORRIGE;

  static Serializer<FaireExerciceStatutEnum> get serializer => _$faireExerciceStatutEnumSerializer;

  const FaireExerciceStatutEnum._(String name): super(name);

  static BuiltSet<FaireExerciceStatutEnum> get values => _$faireExerciceStatutEnumValues;
  static FaireExerciceStatutEnum valueOf(String name) => _$faireExerciceStatutEnumValueOf(name);
}

