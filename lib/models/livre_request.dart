//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'livre_request.g.dart';

/// LivreRequest
///
/// Properties:
/// * [titre] 
/// * [isbn] 
/// * [description] 
/// * [anneePublication] 
/// * [editeur] 
/// * [auteur] 
/// * [totalPages] 
/// * [imageCouverture] 
/// * [lectureAuto] 
/// * [interactif] 
/// * [niveauId] 
/// * [classeId] 
/// * [matiereId] 
/// * [langueId] 
@BuiltValue()
abstract class LivreRequest implements Built<LivreRequest, LivreRequestBuilder> {
  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'isbn')
  String? get isbn;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'anneePublication')
  int? get anneePublication;

  @BuiltValueField(wireName: r'editeur')
  String? get editeur;

  @BuiltValueField(wireName: r'auteur')
  String? get auteur;

  @BuiltValueField(wireName: r'totalPages')
  int? get totalPages;

  @BuiltValueField(wireName: r'imageCouverture')
  String? get imageCouverture;

  @BuiltValueField(wireName: r'lectureAuto')
  bool? get lectureAuto;

  @BuiltValueField(wireName: r'interactif')
  bool? get interactif;

  @BuiltValueField(wireName: r'niveauId')
  int? get niveauId;

  @BuiltValueField(wireName: r'classeId')
  int? get classeId;

  @BuiltValueField(wireName: r'matiereId')
  int? get matiereId;

  @BuiltValueField(wireName: r'langueId')
  int? get langueId;

  LivreRequest._();

  factory LivreRequest([void updates(LivreRequestBuilder b)]) = _$LivreRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LivreRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LivreRequest> get serializer => _$LivreRequestSerializer();
}

class _$LivreRequestSerializer implements PrimitiveSerializer<LivreRequest> {
  @override
  final Iterable<Type> types = const [LivreRequest, _$LivreRequest];

  @override
  final String wireName = r'LivreRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LivreRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.anneePublication != null) {
      yield r'anneePublication';
      yield serializers.serialize(
        object.anneePublication,
        specifiedType: const FullType(int),
      );
    }
    if (object.editeur != null) {
      yield r'editeur';
      yield serializers.serialize(
        object.editeur,
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
    if (object.totalPages != null) {
      yield r'totalPages';
      yield serializers.serialize(
        object.totalPages,
        specifiedType: const FullType(int),
      );
    }
    if (object.imageCouverture != null) {
      yield r'imageCouverture';
      yield serializers.serialize(
        object.imageCouverture,
        specifiedType: const FullType(String),
      );
    }
    if (object.lectureAuto != null) {
      yield r'lectureAuto';
      yield serializers.serialize(
        object.lectureAuto,
        specifiedType: const FullType(bool),
      );
    }
    if (object.interactif != null) {
      yield r'interactif';
      yield serializers.serialize(
        object.interactif,
        specifiedType: const FullType(bool),
      );
    }
    if (object.niveauId != null) {
      yield r'niveauId';
      yield serializers.serialize(
        object.niveauId,
        specifiedType: const FullType(int),
      );
    }
    if (object.classeId != null) {
      yield r'classeId';
      yield serializers.serialize(
        object.classeId,
        specifiedType: const FullType(int),
      );
    }
    if (object.matiereId != null) {
      yield r'matiereId';
      yield serializers.serialize(
        object.matiereId,
        specifiedType: const FullType(int),
      );
    }
    if (object.langueId != null) {
      yield r'langueId';
      yield serializers.serialize(
        object.langueId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LivreRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LivreRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'anneePublication':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.anneePublication = valueDes;
          break;
        case r'editeur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.editeur = valueDes;
          break;
        case r'auteur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.auteur = valueDes;
          break;
        case r'totalPages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalPages = valueDes;
          break;
        case r'imageCouverture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imageCouverture = valueDes;
          break;
        case r'lectureAuto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.lectureAuto = valueDes;
          break;
        case r'interactif':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.interactif = valueDes;
          break;
        case r'niveauId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.niveauId = valueDes;
          break;
        case r'classeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.classeId = valueDes;
          break;
        case r'matiereId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.matiereId = valueDes;
          break;
        case r'langueId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.langueId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LivreRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LivreRequestBuilder();
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

