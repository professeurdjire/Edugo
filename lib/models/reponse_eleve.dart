//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/question.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reponse_eleve.g.dart';

/// ReponseEleve
///
/// Properties:
/// * [id] 
/// * [eleve] 
/// * [question] 
/// * [reponse] 
/// * [pointsAttribues] 
/// * [dateReponse] 
@BuiltValue()
abstract class ReponseEleve implements Built<ReponseEleve, ReponseEleveBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'eleve')
  Eleve? get eleve;

  @BuiltValueField(wireName: r'question')
  Question? get question;

  @BuiltValueField(wireName: r'reponse')
  String? get reponse;

  @BuiltValueField(wireName: r'pointsAttribues')
  double? get pointsAttribues;

  @BuiltValueField(wireName: r'dateReponse')
  DateTime? get dateReponse;

  ReponseEleve._();

  factory ReponseEleve([void updates(ReponseEleveBuilder b)]) = _$ReponseEleve;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReponseEleveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReponseEleve> get serializer => _$ReponseEleveSerializer();
}

class _$ReponseEleveSerializer implements PrimitiveSerializer<ReponseEleve> {
  @override
  final Iterable<Type> types = const [ReponseEleve, _$ReponseEleve];

  @override
  final String wireName = r'ReponseEleve';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReponseEleve object, {
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
    if (object.question != null) {
      yield r'question';
      yield serializers.serialize(
        object.question,
        specifiedType: const FullType(Question),
      );
    }
    if (object.reponse != null) {
      yield r'reponse';
      yield serializers.serialize(
        object.reponse,
        specifiedType: const FullType(String),
      );
    }
    if (object.pointsAttribues != null) {
      yield r'pointsAttribues';
      yield serializers.serialize(
        object.pointsAttribues,
        specifiedType: const FullType(double),
      );
    }
    if (object.dateReponse != null) {
      yield r'dateReponse';
      yield serializers.serialize(
        object.dateReponse,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReponseEleve object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReponseEleveBuilder result,
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
        case r'question':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Question),
          ) as Question;
          result.question.replace(valueDes);
          break;
        case r'reponse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponse = valueDes;
          break;
        case r'pointsAttribues':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.pointsAttribues = valueDes;
          break;
        case r'dateReponse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateReponse = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReponseEleve deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReponseEleveBuilder();
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

