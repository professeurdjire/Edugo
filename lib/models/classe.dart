//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/livre.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/niveau.dart';
import 'package:edugo/models/challenge.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'classe.g.dart';

/// Classe
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [niveau] 
/// * [eleves] 
/// * [livres] 
/// * [challenges] 
@BuiltValue()
abstract class Classe implements Built<Classe, ClasseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'niveau')
  Niveau? get niveau;

  @BuiltValueField(wireName: r'eleves')
  BuiltList<Eleve>? get eleves;

  @BuiltValueField(wireName: r'livres')
  BuiltList<Livre>? get livres;

  @BuiltValueField(wireName: r'challenges')
  BuiltList<Challenge>? get challenges;

  Classe._();

  factory Classe([void updates(ClasseBuilder b)]) = _$Classe;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClasseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Classe> get serializer => _$ClasseSerializer();
}

class _$ClasseSerializer implements PrimitiveSerializer<Classe> {
  @override
  final Iterable<Type> types = const [Classe, _$Classe];

  @override
  final String wireName = r'Classe';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Classe object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.nom != null) {
      yield r'nom';
      yield serializers.serialize(
        object.nom,
        specifiedType: const FullType(String),
      );
    }
    if (object.niveau != null) {
      yield r'niveau';
      yield serializers.serialize(
        object.niveau,
        specifiedType: const FullType(Niveau),
      );
    }
    if (object.eleves != null) {
      yield r'eleves';
      yield serializers.serialize(
        object.eleves,
        specifiedType: const FullType(BuiltList, [FullType(Eleve)]),
      );
    }
    if (object.livres != null) {
      yield r'livres';
      yield serializers.serialize(
        object.livres,
        specifiedType: const FullType(BuiltList, [FullType(Livre)]),
      );
    }
    if (object.challenges != null) {
      yield r'challenges';
      yield serializers.serialize(
        object.challenges,
        specifiedType: const FullType(BuiltList, [FullType(Challenge)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Classe object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClasseBuilder result,
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
        case r'nom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nom = valueDes;
          break;
        case r'niveau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Niveau),
          ) as Niveau;
          result.niveau.replace(valueDes);
          break;
        case r'eleves':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Eleve)]),
          ) as BuiltList<Eleve>;
          result.eleves.replace(valueDes);
          break;
        case r'livres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Livre)]),
          ) as BuiltList<Livre>;
          result.livres.replace(valueDes);
          break;
        case r'challenges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Challenge)]),
          ) as BuiltList<Challenge>;
          result.challenges.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Classe deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClasseBuilder();
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

