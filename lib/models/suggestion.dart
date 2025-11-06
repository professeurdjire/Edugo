//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/eleve.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'suggestion.g.dart';

/// Suggestion
///
/// Properties:
/// * [id] 
/// * [contenu] 
/// * [dateEnvoie] 
/// * [eleve] 
@BuiltValue()
abstract class Suggestion implements Built<Suggestion, SuggestionBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'contenu')
  String? get contenu;

  @BuiltValueField(wireName: r'dateEnvoie')
  DateTime? get dateEnvoie;

  @BuiltValueField(wireName: r'eleve')
  Eleve? get eleve;

  Suggestion._();

  factory Suggestion([void updates(SuggestionBuilder b)]) = _$Suggestion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SuggestionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Suggestion> get serializer => _$SuggestionSerializer();
}

class _$SuggestionSerializer implements PrimitiveSerializer<Suggestion> {
  @override
  final Iterable<Type> types = const [Suggestion, _$Suggestion];

  @override
  final String wireName = r'Suggestion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Suggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.contenu != null) {
      yield r'contenu';
      yield serializers.serialize(
        object.contenu,
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
    if (object.eleve != null) {
      yield r'eleve';
      yield serializers.serialize(
        object.eleve,
        specifiedType: const FullType(Eleve),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Suggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SuggestionBuilder result,
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
        case r'contenu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contenu = valueDes;
          break;
        case r'dateEnvoie':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateEnvoie = valueDes;
          break;
        case r'eleve':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Eleve),
          ) as Eleve;
          result.eleve.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Suggestion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SuggestionBuilder();
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

