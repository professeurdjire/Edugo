//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/classe.dart';
import 'package:edugo/models/livre.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/challenge.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'niveau.g.dart';

/// Niveau
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [classes] 
/// * [livres] 
/// * [challenges] 
@BuiltValue()
abstract class Niveau implements Built<Niveau, NiveauBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'classes')
  BuiltList<Classe>? get classes;

  @BuiltValueField(wireName: r'livres')
  BuiltList<Livre>? get livres;

  @BuiltValueField(wireName: r'challenges')
  BuiltList<Challenge>? get challenges;

  Niveau._();

  factory Niveau([void updates(NiveauBuilder b)]) = _$Niveau;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NiveauBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Niveau> get serializer => _$NiveauSerializer();
}

class _$NiveauSerializer implements PrimitiveSerializer<Niveau> {
  @override
  final Iterable<Type> types = const [Niveau, _$Niveau];

  @override
  final String wireName = r'Niveau';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Niveau object, {
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
    if (object.classes != null) {
      yield r'classes';
      yield serializers.serialize(
        object.classes,
        specifiedType: const FullType(BuiltList, [FullType(Classe)]),
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
    Niveau object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NiveauBuilder result,
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
        case r'classes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Classe)]),
          ) as BuiltList<Classe>;
          result.classes.replace(valueDes);
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
  Niveau deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NiveauBuilder();
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

