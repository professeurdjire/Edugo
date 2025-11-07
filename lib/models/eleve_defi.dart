//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/defi.dart';
import 'package:edugo/models/eleve.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'eleve_defi.g.dart';

/// EleveDefi
///
/// Properties:
/// * [id] 
/// * [reponseUtilisateur] 
/// * [dateEnvoie] 
/// * [dateParticipation] 
/// * [statut] 
/// * [eleve] 
/// * [defi] 
@BuiltValue()
abstract class EleveDefi implements Built<EleveDefi, EleveDefiBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'reponseUtilisateur')
  String? get reponseUtilisateur;

  @BuiltValueField(wireName: r'dateEnvoie')
  DateTime? get dateEnvoie;

  @BuiltValueField(wireName: r'dateParticipation')
  DateTime? get dateParticipation;

  @BuiltValueField(wireName: r'statut')
  String? get statut;

  @BuiltValueField(wireName: r'eleve')
  Eleve? get eleve;

  @BuiltValueField(wireName: r'defi')
  Defi? get defi;

  EleveDefi._();

  factory EleveDefi([void updates(EleveDefiBuilder b)]) = _$EleveDefi;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EleveDefiBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EleveDefi> get serializer => _$EleveDefiSerializer();
}

class _$EleveDefiSerializer implements PrimitiveSerializer<EleveDefi> {
  @override
  final Iterable<Type> types = const [EleveDefi, _$EleveDefi];

  @override
  final String wireName = r'EleveDefi';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EleveDefi object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.reponseUtilisateur != null) {
      yield r'reponseUtilisateur';
      yield serializers.serialize(
        object.reponseUtilisateur,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateEnvoie != null) {
      yield r'dateEnvoie';
      yield serializers.serialize(
        object.dateEnvoie,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.dateParticipation != null) {
      yield r'dateParticipation';
      yield serializers.serialize(
        object.dateParticipation,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.statut != null) {
      yield r'statut';
      yield serializers.serialize(
        object.statut,
        specifiedType: const FullType(String),
      );
    }
    if (object.eleve != null) {
      yield r'eleve';
      yield serializers.serialize(
        object.eleve,
        specifiedType: const FullType(Eleve),
      );
    }
    if (object.defi != null) {
      yield r'defi';
      yield serializers.serialize(
        object.defi,
        specifiedType: const FullType(Defi),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EleveDefi object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EleveDefiBuilder result,
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
        case r'reponseUtilisateur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponseUtilisateur = valueDes;
          break;
        case r'dateEnvoie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateEnvoie = valueDes;
          break;
        case r'dateParticipation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateParticipation = valueDes;
          break;
        case r'statut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.statut = valueDes;
          break;
        case r'eleve':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Eleve),
          ) as Eleve;
          result.eleve.replace(valueDes);
          break;
        case r'defi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Defi),
          ) as Defi;
          result.defi.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EleveDefi deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EleveDefiBuilder();
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

