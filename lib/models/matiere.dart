//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/exercice.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'matiere.g.dart';

/// Matiere
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [exercice] 
@BuiltValue()
abstract class Matiere implements Built<Matiere, MatiereBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'exercice')
  BuiltList<Exercice>? get exercice;

  Matiere._();

  factory Matiere([void updates(MatiereBuilder b)]) = _$Matiere;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatiereBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Matiere> get serializer => _$MatiereSerializer();
}

class _$MatiereSerializer implements PrimitiveSerializer<Matiere> {
  @override
  final Iterable<Type> types = const [Matiere, _$Matiere];

  @override
  final String wireName = r'Matiere';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Matiere object, {
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
    if (object.exercice != null) {
      yield r'exercice';
      yield serializers.serialize(
        object.exercice,
        specifiedType: const FullType(BuiltList, [FullType(Exercice)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Matiere object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatiereBuilder result,
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
        case r'exercice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Exercice)]),
          ) as BuiltList<Exercice>;
          result.exercice.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Matiere deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatiereBuilder();
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

