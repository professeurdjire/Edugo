//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/badge.dart';
import 'package:edugo/models/challenge.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'participation.g.dart';

/// Participation
///
/// Properties:
/// * [id] 
/// * [score] 
/// * [rang] 
/// * [tempsPasse] 
/// * [statut] 
/// * [dateParticipation] 
/// * [isaParticiper] 
/// * [eleve] 
/// * [challenge] 
/// * [badge] 
@BuiltValue()
abstract class Participation implements Built<Participation, ParticipationBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'score')
  int? get score;

  @BuiltValueField(wireName: r'rang')
  int? get rang;

  @BuiltValueField(wireName: r'tempsPasse')
  int? get tempsPasse;

  @BuiltValueField(wireName: r'statut')
  String? get statut;

  @BuiltValueField(wireName: r'dateParticipation')
  DateTime? get dateParticipation;

  @BuiltValueField(wireName: r'isaParticiper')
  bool? get isaParticiper;

  @BuiltValueField(wireName: r'eleve')
  Eleve? get eleve;

  @BuiltValueField(wireName: r'challenge')
  Challenge? get challenge;

  @BuiltValueField(wireName: r'badge')
  Badge? get badge;

  Participation._();

  factory Participation([void updates(ParticipationBuilder b)]) = _$Participation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ParticipationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Participation> get serializer => _$ParticipationSerializer();
}

class _$ParticipationSerializer implements PrimitiveSerializer<Participation> {
  @override
  final Iterable<Type> types = const [Participation, _$Participation];

  @override
  final String wireName = r'Participation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Participation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.score != null) {
      yield r'score';
      yield serializers.serialize(
        object.score,
        specifiedType: const FullType(int),
      );
    }
    if (object.rang != null) {
      yield r'rang';
      yield serializers.serialize(
        object.rang,
        specifiedType: const FullType(int),
      );
    }
    if (object.tempsPasse != null) {
      yield r'tempsPasse';
      yield serializers.serialize(
        object.tempsPasse,
        specifiedType: const FullType(int),
      );
    }
    if (object.statut != null) {
      yield r'statut';
      yield serializers.serialize(
        object.statut,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateParticipation != null) {
      yield r'dateParticipation';
      yield serializers.serialize(
        object.dateParticipation,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.isaParticiper != null) {
      yield r'isaParticiper';
      yield serializers.serialize(
        object.isaParticiper,
        specifiedType: const FullType(bool),
      );
    }
    if (object.eleve != null) {
      yield r'eleve';
      yield serializers.serialize(
        object.eleve,
        specifiedType: const FullType(Eleve),
      );
    }
    if (object.challenge != null) {
      yield r'challenge';
      yield serializers.serialize(
        object.challenge,
        specifiedType: const FullType(Challenge),
      );
    }
    if (object.badge != null) {
      yield r'badge';
      yield serializers.serialize(
        object.badge,
        specifiedType: const FullType(Badge),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Participation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ParticipationBuilder result,
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
        case r'score':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.score = valueDes;
          break;
        case r'rang':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rang = valueDes;
          break;
        case r'tempsPasse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tempsPasse = valueDes;
          break;
        case r'statut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statut = valueDes;
          break;
        case r'dateParticipation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateParticipation = valueDes;
          break;
        case r'isaParticiper':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isaParticiper = valueDes;
          break;
        case r'eleve':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Eleve),
          ) as Eleve;
          result.eleve.replace(valueDes);
          break;
        case r'challenge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Challenge),
          ) as Challenge;
          result.challenge.replace(valueDes);
          break;
        case r'badge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Badge),
          ) as Badge;
          result.badge.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Participation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParticipationBuilder();
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

