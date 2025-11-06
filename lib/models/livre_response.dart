//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'livre_response.g.dart';

/// LivreResponse
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [isbn] 
/// * [auteur] 
/// * [imageCouverture] 
/// * [totalPages] 
@BuiltValue()
abstract class LivreResponse implements Built<LivreResponse, LivreResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'isbn')
  String? get isbn;

  @BuiltValueField(wireName: r'auteur')
  String? get auteur;

  @BuiltValueField(wireName: r'imageCouverture')
  String? get imageCouverture;

  @BuiltValueField(wireName: r'totalPages')
  int? get totalPages;

  LivreResponse._();

  factory LivreResponse([void updates(LivreResponseBuilder b)]) = _$LivreResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LivreResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LivreResponse> get serializer => _$LivreResponseSerializer();
}

class _$LivreResponseSerializer implements PrimitiveSerializer<LivreResponse> {
  @override
  final Iterable<Type> types = const [LivreResponse, _$LivreResponse];

  @override
  final String wireName = r'LivreResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LivreResponse object, {
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
    if (object.isbn != null) {
      yield r'isbn';
      yield serializers.serialize(
        object.isbn,
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
    if (object.imageCouverture != null) {
      yield r'imageCouverture';
      yield serializers.serialize(
        object.imageCouverture,
        specifiedType: const FullType(String),
      );
    }
    if (object.totalPages != null) {
      yield r'totalPages';
      yield serializers.serialize(
        object.totalPages,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LivreResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LivreResponseBuilder result,
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
        case r'isbn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.isbn = valueDes;
          break;
        case r'auteur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.auteur = valueDes;
          break;
        case r'imageCouverture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imageCouverture = valueDes;
          break;
        case r'totalPages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalPages = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LivreResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LivreResponseBuilder();
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

