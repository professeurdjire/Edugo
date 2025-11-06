//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/question.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reponse_possible.g.dart';

/// ReponsePossible
///
/// Properties:
/// * [id] 
/// * [libelleReponse] 
/// * [estCorrecte] 
/// * [question] 
@BuiltValue()
abstract class ReponsePossible implements Built<ReponsePossible, ReponsePossibleBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'libelleReponse')
  String? get libelleReponse;

  @BuiltValueField(wireName: r'estCorrecte')
  bool? get estCorrecte;

  @BuiltValueField(wireName: r'question')
  Question? get question;

  ReponsePossible._();

  factory ReponsePossible([void updates(ReponsePossibleBuilder b)]) = _$ReponsePossible;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReponsePossibleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReponsePossible> get serializer => _$ReponsePossibleSerializer();
}

class _$ReponsePossibleSerializer implements PrimitiveSerializer<ReponsePossible> {
  @override
  final Iterable<Type> types = const [ReponsePossible, _$ReponsePossible];

  @override
  final String wireName = r'ReponsePossible';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReponsePossible object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.libelleReponse != null) {
      yield r'libelleReponse';
      yield serializers.serialize(
        object.libelleReponse,
        specifiedType: const FullType(String),
      );
    }
    if (object.estCorrecte != null) {
      yield r'estCorrecte';
      yield serializers.serialize(
        object.estCorrecte,
        specifiedType: const FullType(bool),
      );
    }
    if (object.question != null) {
      yield r'question';
      yield serializers.serialize(
        object.question,
        specifiedType: const FullType(Question),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReponsePossible object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReponsePossibleBuilder result,
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
        case r'libelleReponse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libelleReponse = valueDes;
          break;
        case r'estCorrecte':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.estCorrecte = valueDes;
          break;
        case r'question':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Question),
          ) as Question;
          result.question.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReponsePossible deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReponsePossibleBuilder();
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

