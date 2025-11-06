//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/question.dart';
import 'package:edugo/models/livre.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/niveau.dart';
import 'package:edugo/models/matiere.dart';
import 'package:edugo/models/faire_exercice.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'exercice.g.dart';

/// Exercice
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [description] 
/// * [niveauDifficulte] 
/// * [tempsAlloue] 
/// * [active] 
/// * [dateCreation] 
/// * [dateModification] 
/// * [matiere] 
/// * [niveauScolaire] 
/// * [livre] 
/// * [questionsExercice] 
/// * [faireExercices] 
@BuiltValue()
abstract class Exercice implements Built<Exercice, ExerciceBuilder> {
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

  @BuiltValueField(wireName: r'dateCreation')
  DateTime? get dateCreation;

  @BuiltValueField(wireName: r'dateModification')
  DateTime? get dateModification;

  @BuiltValueField(wireName: r'matiere')
  Matiere? get matiere;

  @BuiltValueField(wireName: r'niveauScolaire')
  Niveau? get niveauScolaire;

  @BuiltValueField(wireName: r'livre')
  Livre? get livre;

  @BuiltValueField(wireName: r'questionsExercice')
  BuiltList<Question>? get questionsExercice;

  @BuiltValueField(wireName: r'faireExercices')
  BuiltList<FaireExercice>? get faireExercices;

  Exercice._();

  factory Exercice([void updates(ExerciceBuilder b)]) = _$Exercice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExerciceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Exercice> get serializer => _$ExerciceSerializer();
}

class _$ExerciceSerializer implements PrimitiveSerializer<Exercice> {
  @override
  final Iterable<Type> types = const [Exercice, _$Exercice];

  @override
  final String wireName = r'Exercice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Exercice object, {
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
    if (object.dateCreation != null) {
      yield r'dateCreation';
      yield serializers.serialize(
        object.dateCreation,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.dateModification != null) {
      yield r'dateModification';
      yield serializers.serialize(
        object.dateModification,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.matiere != null) {
      yield r'matiere';
      yield serializers.serialize(
        object.matiere,
        specifiedType: const FullType(Matiere),
      );
    }
    if (object.niveauScolaire != null) {
      yield r'niveauScolaire';
      yield serializers.serialize(
        object.niveauScolaire,
        specifiedType: const FullType(Niveau),
      );
    }
    if (object.livre != null) {
      yield r'livre';
      yield serializers.serialize(
        object.livre,
        specifiedType: const FullType(Livre),
      );
    }
    if (object.questionsExercice != null) {
      yield r'questionsExercice';
      yield serializers.serialize(
        object.questionsExercice,
        specifiedType: const FullType(BuiltList, [FullType(Question)]),
      );
    }
    if (object.faireExercices != null) {
      yield r'faireExercices';
      yield serializers.serialize(
        object.faireExercices,
        specifiedType: const FullType(BuiltList, [FullType(FaireExercice)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Exercice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExerciceBuilder result,
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
        case r'dateCreation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateCreation = valueDes;
          break;
        case r'dateModification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateModification = valueDes;
          break;
        case r'matiere':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Matiere),
          ) as Matiere;
          result.matiere.replace(valueDes);
          break;
        case r'niveauScolaire':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Niveau),
          ) as Niveau;
          result.niveauScolaire.replace(valueDes);
          break;
        case r'livre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Livre),
          ) as Livre;
          result.livre.replace(valueDes);
          break;
        case r'questionsExercice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Question)]),
          ) as BuiltList<Question>;
          result.questionsExercice.replace(valueDes);
          break;
        case r'faireExercices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FaireExercice)]),
          ) as BuiltList<FaireExercice>;
          result.faireExercices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Exercice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExerciceBuilder();
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

