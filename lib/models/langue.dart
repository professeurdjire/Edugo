//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/livre.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'langue.g.dart';

/// Langue
///
/// Properties:
/// * [id] 
/// * [codeIso] 
/// * [livres] 
/// * [nom] 
@BuiltValue()
abstract class Langue implements Built<Langue, LangueBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'codeIso')
  String? get codeIso;

  @BuiltValueField(wireName: r'livres')
  BuiltList<Livre>? get livres;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  Langue._();

  factory Langue([void updates(LangueBuilder b)]) = _$Langue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LangueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Langue> get serializer => _$LangueSerializer();
}

class _$LangueSerializer implements PrimitiveSerializer<Langue> {
  @override
  final Iterable<Type> types = const [Langue, _$Langue];

  @override
  final String wireName = r'Langue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Langue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.codeIso != null) {
      yield r'codeIso';
      yield serializers.serialize(
        object.codeIso,
        specifiedType: const FullType(String),
      );
    }
    if (object.livres != null) {
      yield r'livres';
      yield serializers.serialize(
        object.livres,
        specifiedType: const FullType(BuiltList, [FullType(Livre)]),
      );
    }
    if (object.nom != null) {
      yield r'nom';
      yield serializers.serialize(
        object.nom,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Langue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LangueBuilder result,
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
        case r'codeIso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codeIso = valueDes;
          break;
        case r'livres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Livre)]),
          ) as BuiltList<Livre>;
          result.livres.replace(valueDes);
          break;
        case r'nom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Langue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LangueBuilder();
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

