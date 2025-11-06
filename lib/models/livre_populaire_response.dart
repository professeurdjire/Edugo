//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'livre_populaire_response.g.dart';

/// LivrePopulaireResponse
///
/// Properties:
/// * [livreId] 
/// * [titre] 
/// * [auteur] 
/// * [nombreLecteurs] 
@BuiltValue()
abstract class LivrePopulaireResponse implements Built<LivrePopulaireResponse, LivrePopulaireResponseBuilder> {
  @BuiltValueField(wireName: r'livreId')
  int? get livreId;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'auteur')
  String? get auteur;

  @BuiltValueField(wireName: r'nombreLecteurs')
  int? get nombreLecteurs;

  LivrePopulaireResponse._();

  factory LivrePopulaireResponse([void updates(LivrePopulaireResponseBuilder b)]) = _$LivrePopulaireResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LivrePopulaireResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LivrePopulaireResponse> get serializer => _$LivrePopulaireResponseSerializer();
}

class _$LivrePopulaireResponseSerializer implements PrimitiveSerializer<LivrePopulaireResponse> {
  @override
  final Iterable<Type> types = const [LivrePopulaireResponse, _$LivrePopulaireResponse];

  @override
  final String wireName = r'LivrePopulaireResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LivrePopulaireResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.livreId != null) {
      yield r'livreId';
      yield serializers.serialize(
        object.livreId,
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
    if (object.auteur != null) {
      yield r'auteur';
      yield serializers.serialize(
        object.auteur,
        specifiedType: const FullType(String),
      );
    }
    if (object.nombreLecteurs != null) {
      yield r'nombreLecteurs';
      yield serializers.serialize(
        object.nombreLecteurs,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LivrePopulaireResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LivrePopulaireResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'livreId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.livreId = valueDes;
          break;
        case r'titre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titre = valueDes;
          break;
        case r'auteur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.auteur = valueDes;
          break;
        case r'nombreLecteurs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nombreLecteurs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LivrePopulaireResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LivrePopulaireResponseBuilder();
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

