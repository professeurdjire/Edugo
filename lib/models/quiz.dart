//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/question.dart';
import 'package:edugo/models/livre.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'quiz.g.dart';

/// Quiz
///
/// Properties:
/// * [id] 
/// * [statut] 
/// * [createdAt] 
/// * [livre] 
/// * [questionsQuiz] 
/// * [nombreQuestions] 
@BuiltValue()
abstract class Quiz implements Built<Quiz, QuizBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'statut')
  QuizStatutEnum? get statut;
  // enum statutEnum {  ACTIF,  INACTIF,  BROUILLON,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'livre')
  Livre? get livre;

  @BuiltValueField(wireName: r'questionsQuiz')
  BuiltList<Question>? get questionsQuiz;

  @BuiltValueField(wireName: r'nombreQuestions')
  int? get nombreQuestions;

  Quiz._();

  factory Quiz([void updates(QuizBuilder b)]) = _$Quiz;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(QuizBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Quiz> get serializer => _$QuizSerializer();
}

class _$QuizSerializer implements PrimitiveSerializer<Quiz> {
  @override
  final Iterable<Type> types = const [Quiz, _$Quiz];

  @override
  final String wireName = r'Quiz';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Quiz object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.statut != null) {
      yield r'statut';
      yield serializers.serialize(
        object.statut,
        specifiedType: const FullType(QuizStatutEnum),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.livre != null) {
      yield r'livre';
      yield serializers.serialize(
        object.livre,
        specifiedType: const FullType(Livre),
      );
    }
    if (object.questionsQuiz != null) {
      yield r'questionsQuiz';
      yield serializers.serialize(
        object.questionsQuiz,
        specifiedType: const FullType(BuiltList, [FullType(Question)]),
      );
    }
    if (object.nombreQuestions != null) {
      yield r'nombreQuestions';
      yield serializers.serialize(
        object.nombreQuestions,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Quiz object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required QuizBuilder result,
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
        case r'statut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(QuizStatutEnum),
          ) as QuizStatutEnum;
          result.statut = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'livre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Livre),
          ) as Livre;
          result.livre.replace(valueDes);
          break;
        case r'questionsQuiz':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Question)]),
          ) as BuiltList<Question>;
          result.questionsQuiz.replace(valueDes);
          break;
        case r'nombreQuestions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nombreQuestions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Quiz deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = QuizBuilder();
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

class QuizStatutEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIF')
  static const QuizStatutEnum ACTIF = _$quizStatutEnum_ACTIF;
  @BuiltValueEnumConst(wireName: r'INACTIF')
  static const QuizStatutEnum INACTIF = _$quizStatutEnum_INACTIF;
  @BuiltValueEnumConst(wireName: r'BROUILLON')
  static const QuizStatutEnum BROUILLON = _$quizStatutEnum_BROUILLON;

  static Serializer<QuizStatutEnum> get serializer => _$quizStatutEnumSerializer;

  const QuizStatutEnum._(String name): super(name);

  static BuiltSet<QuizStatutEnum> get values => _$quizStatutEnumValues;
  static QuizStatutEnum valueOf(String name) => _$quizStatutEnumValueOf(name);
}

