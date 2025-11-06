//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/type_question.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/reponse_possible.dart';
import 'package:edugo/models/reponse_eleve.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/exercice.dart';
import 'package:edugo/models/challenge.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'question.g.dart';

/// Question
///
/// Properties:
/// * [id] 
/// * [enonce] 
/// * [points] 
/// * [dateCreation] 
/// * [dateModification] 
/// * [challenge] 
/// * [quiz] 
/// * [exercice] 
/// * [type] 
/// * [reponsesPossibles] 
/// * [reponsesEleves] 
@BuiltValue()
abstract class Question implements Built<Question, QuestionBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'enonce')
  String? get enonce;

  @BuiltValueField(wireName: r'points')
  int? get points;

  @BuiltValueField(wireName: r'dateCreation')
  DateTime? get dateCreation;

  @BuiltValueField(wireName: r'dateModification')
  DateTime? get dateModification;

  @BuiltValueField(wireName: r'challenge')
  Challenge? get challenge;

  @BuiltValueField(wireName: r'quiz')
  Quiz? get quiz;

  @BuiltValueField(wireName: r'exercice')
  Exercice? get exercice;

  @BuiltValueField(wireName: r'type')
  TypeQuestion? get type;

  @BuiltValueField(wireName: r'reponsesPossibles')
  BuiltList<ReponsePossible>? get reponsesPossibles;

  @BuiltValueField(wireName: r'reponsesEleves')
  BuiltList<ReponseEleve>? get reponsesEleves;

  Question._();

  factory Question([void updates(QuestionBuilder b)]) = _$Question;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QuestionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Question> get serializer => _$QuestionSerializer();
}

class _$QuestionSerializer implements PrimitiveSerializer<Question> {
  @override
  final Iterable<Type> types = const [Question, _$Question];

  @override
  final String wireName = r'Question';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Question object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.enonce != null) {
      yield r'enonce';
      yield serializers.serialize(
        object.enonce,
        specifiedType: const FullType(String),
      );
    }
    if (object.points != null) {
      yield r'points';
      yield serializers.serialize(
        object.points,
        specifiedType: const FullType(int),
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
    if (object.challenge != null) {
      yield r'challenge';
      yield serializers.serialize(
        object.challenge,
        specifiedType: const FullType(Challenge),
      );
    }
    if (object.quiz != null) {
      yield r'quiz';
      yield serializers.serialize(
        object.quiz,
        specifiedType: const FullType(Quiz),
      );
    }
    if (object.exercice != null) {
      yield r'exercice';
      yield serializers.serialize(
        object.exercice,
        specifiedType: const FullType(Exercice),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(TypeQuestion),
      );
    }
    if (object.reponsesPossibles != null) {
      yield r'reponsesPossibles';
      yield serializers.serialize(
        object.reponsesPossibles,
        specifiedType: const FullType(BuiltList, [FullType(ReponsePossible)]),
      );
    }
    if (object.reponsesEleves != null) {
      yield r'reponsesEleves';
      yield serializers.serialize(
        object.reponsesEleves,
        specifiedType: const FullType(BuiltList, [FullType(ReponseEleve)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Question object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QuestionBuilder result,
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
        case r'enonce':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enonce = valueDes;
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.points = valueDes;
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
        case r'challenge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Challenge),
          ) as Challenge;
          result.challenge.replace(valueDes);
          break;
        case r'quiz':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Quiz),
          ) as Quiz;
          result.quiz.replace(valueDes);
          break;
        case r'exercice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Exercice),
          ) as Exercice;
          result.exercice.replace(valueDes);
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TypeQuestion),
          ) as TypeQuestion;
          result.type.replace(valueDes);
          break;
        case r'reponsesPossibles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReponsePossible)]),
          ) as BuiltList<ReponsePossible>;
          result.reponsesPossibles.replace(valueDes);
          break;
        case r'reponsesEleves':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReponseEleve)]),
          ) as BuiltList<ReponseEleve>;
          result.reponsesEleves.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Question deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QuestionBuilder();
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

