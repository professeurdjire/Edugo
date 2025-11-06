//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/question.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'type_question.g.dart';

/// TypeQuestion
///
/// Properties:
/// * [id] 
/// * [libelleType] 
/// * [questions] 
@BuiltValue()
abstract class TypeQuestion implements Built<TypeQuestion, TypeQuestionBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'libelleType')
  String? get libelleType;

  @BuiltValueField(wireName: r'questions')
  BuiltList<Question>? get questions;

  TypeQuestion._();

  factory TypeQuestion([void updates(TypeQuestionBuilder b)]) = _$TypeQuestion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TypeQuestionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TypeQuestion> get serializer => _$TypeQuestionSerializer();
}

class _$TypeQuestionSerializer implements PrimitiveSerializer<TypeQuestion> {
  @override
  final Iterable<Type> types = const [TypeQuestion, _$TypeQuestion];

  @override
  final String wireName = r'TypeQuestion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TypeQuestion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.libelleType != null) {
      yield r'libelleType';
      yield serializers.serialize(
        object.libelleType,
        specifiedType: const FullType(String),
      );
    }
    if (object.questions != null) {
      yield r'questions';
      yield serializers.serialize(
        object.questions,
        specifiedType: const FullType(BuiltList, [FullType(Question)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TypeQuestion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TypeQuestionBuilder result,
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
        case r'libelleType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libelleType = valueDes;
          break;
        case r'questions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Question)]),
          ) as BuiltList<Question>;
          result.questions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TypeQuestion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TypeQuestionBuilder();
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

