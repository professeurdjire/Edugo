//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/classe.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/badge.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/niveau.dart';
import 'package:edugo/models/participation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'challenge.g.dart';

/// Challenge
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [description] 
/// * [dateDebut] 
/// * [dateFin] 
/// * [rewardMode] 
/// * [typeChallenge] 
/// * [niveau] 
/// * [classe] 
/// * [rewards] 
/// * [questionsChallenge] 
/// * [participations] 
@BuiltValue()
abstract class Challenge implements Built<Challenge, ChallengeBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'dateDebut')
  DateTime? get dateDebut;

  @BuiltValueField(wireName: r'dateFin')
  DateTime? get dateFin;

  @BuiltValueField(wireName: r'rewardMode')
  String? get rewardMode;

  @BuiltValueField(wireName: r'typeChallenge')
  ChallengeTypeChallengeEnum? get typeChallenge;
  // enum typeChallengeEnum {  INTERCLASSE,  INTERNIVEAU,  };

  @BuiltValueField(wireName: r'niveau')
  Niveau? get niveau;

  @BuiltValueField(wireName: r'classe')
  Classe? get classe;

  @BuiltValueField(wireName: r'rewards')
  BuiltList<Badge>? get rewards;

  @BuiltValueField(wireName: r'questionsChallenge')
  BuiltList<Question>? get questionsChallenge;

  @BuiltValueField(wireName: r'participations')
  BuiltList<Participation>? get participations;

  Challenge._();

  factory Challenge([void updates(ChallengeBuilder b)]) = _$Challenge;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChallengeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Challenge> get serializer => _$ChallengeSerializer();
}

class _$ChallengeSerializer implements PrimitiveSerializer<Challenge> {
  @override
  final Iterable<Type> types = const [Challenge, _$Challenge];

  @override
  final String wireName = r'Challenge';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Challenge object, {
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
    if (object.dateDebut != null) {
      yield r'dateDebut';
      yield serializers.serialize(
        object.dateDebut,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.dateFin != null) {
      yield r'dateFin';
      yield serializers.serialize(
        object.dateFin,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.rewardMode != null) {
      yield r'rewardMode';
      yield serializers.serialize(
        object.rewardMode,
        specifiedType: const FullType(String),
      );
    }
    if (object.typeChallenge != null) {
      yield r'typeChallenge';
      yield serializers.serialize(
        object.typeChallenge,
        specifiedType: const FullType(ChallengeTypeChallengeEnum),
      );
    }
    if (object.niveau != null) {
      yield r'niveau';
      yield serializers.serialize(
        object.niveau,
        specifiedType: const FullType(Niveau),
      );
    }
    if (object.classe != null) {
      yield r'classe';
      yield serializers.serialize(
        object.classe,
        specifiedType: const FullType(Classe),
      );
    }
    if (object.rewards != null) {
      yield r'rewards';
      yield serializers.serialize(
        object.rewards,
        specifiedType: const FullType(BuiltList, [FullType(Badge)]),
      );
    }
    if (object.questionsChallenge != null) {
      yield r'questionsChallenge';
      yield serializers.serialize(
        object.questionsChallenge,
        specifiedType: const FullType(BuiltList, [FullType(Question)]),
      );
    }
    if (object.participations != null) {
      yield r'participations';
      yield serializers.serialize(
        object.participations,
        specifiedType: const FullType(BuiltList, [FullType(Participation)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Challenge object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChallengeBuilder result,
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
        case r'dateDebut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateDebut = valueDes;
          break;
        case r'dateFin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateFin = valueDes;
          break;
        case r'rewardMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rewardMode = valueDes;
          break;
        case r'typeChallenge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChallengeTypeChallengeEnum),
          ) as ChallengeTypeChallengeEnum;
          result.typeChallenge = valueDes;
          break;
        case r'niveau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Niveau),
          ) as Niveau;
          result.niveau.replace(valueDes);
          break;
        case r'classe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Classe),
          ) as Classe;
          result.classe.replace(valueDes);
          break;
        case r'rewards':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Badge)]),
          ) as BuiltList<Badge>;
          result.rewards.replace(valueDes);
          break;
        case r'questionsChallenge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Question)]),
          ) as BuiltList<Question>;
          result.questionsChallenge.replace(valueDes);
          break;
        case r'participations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Participation)]),
          ) as BuiltList<Participation>;
          result.participations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Challenge deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChallengeBuilder();
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

class ChallengeTypeChallengeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INTERCLASSE')
  static const ChallengeTypeChallengeEnum INTERCLASSE = _$challengeTypeChallengeEnum_INTERCLASSE;
  @BuiltValueEnumConst(wireName: r'INTERNIVEAU')
  static const ChallengeTypeChallengeEnum INTERNIVEAU = _$challengeTypeChallengeEnum_INTERNIVEAU;

  static Serializer<ChallengeTypeChallengeEnum> get serializer => _$challengeTypeChallengeEnumSerializer;

  const ChallengeTypeChallengeEnum._(String name): super(name);

  static BuiltSet<ChallengeTypeChallengeEnum> get values => _$challengeTypeChallengeEnumValues;
  static ChallengeTypeChallengeEnum valueOf(String name) => _$challengeTypeChallengeEnumValueOf(name);
}

