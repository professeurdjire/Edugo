//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'livre_detail_response.g.dart';

/// LivreDetailResponse
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [isbn] 
/// * [auteur] 
/// * [imageCouverture] 
/// * [totalPages] 
/// * [lectureAuto] 
/// * [interactif] 
/// * [anneePublication] 
/// * [editeur] 
/// * [niveauId] 
/// * [niveauNom] 
/// * [classeId] 
/// * [classeNom] 
/// * [matiereId] 
/// * [matiereNom] 
/// * [langueId] 
/// * [langueNom] 
/// * [progression] 
/// * [statistiques] 
@BuiltValue()
abstract class LivreDetailResponse implements Built<LivreDetailResponse, LivreDetailResponseBuilder> {
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

  @BuiltValueField(wireName: r'lectureAuto')
  bool? get lectureAuto;

  @BuiltValueField(wireName: r'interactif')
  bool? get interactif;

  @BuiltValueField(wireName: r'anneePublication')
  int? get anneePublication;

  @BuiltValueField(wireName: r'editeur')
  String? get editeur;

  @BuiltValueField(wireName: r'niveauId')
  int? get niveauId;

  @BuiltValueField(wireName: r'niveauNom')
  String? get niveauNom;

  @BuiltValueField(wireName: r'classeId')
  int? get classeId;

  @BuiltValueField(wireName: r'classeNom')
  String? get classeNom;

  @BuiltValueField(wireName: r'matiereId')
  int? get matiereId;

  @BuiltValueField(wireName: r'matiereNom')
  String? get matiereNom;

  @BuiltValueField(wireName: r'langueId')
  int? get langueId;

  @BuiltValueField(wireName: r'langueNom')
  String? get langueNom;

  @BuiltValueField(wireName: r'progression')
  double? get progression;

  @BuiltValueField(wireName: r'statistiques')
  JsonObject? get statistiques;

  LivreDetailResponse._();

  factory LivreDetailResponse([void updates(LivreDetailResponseBuilder b)]) = _$LivreDetailResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LivreDetailResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LivreDetailResponse> get serializer => _$LivreDetailResponseSerializer();
}

class _$LivreDetailResponseSerializer implements PrimitiveSerializer<LivreDetailResponse> {
  @override
  final Iterable<Type> types = const [LivreDetailResponse, _$LivreDetailResponse];

  @override
  final String wireName = r'LivreDetailResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LivreDetailResponse object, {
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
    if (object.niveauId != null) {
      yield r'niveauId';
      yield serializers.serialize(
        object.niveauId,
        specifiedType: const FullType(int),
      );
    }
    if (object.niveauNom != null) {
      yield r'niveauNom';
      yield serializers.serialize(
        object.niveauNom,
        specifiedType: const FullType(String),
      );
    }
    if (object.classeId != null) {
      yield r'classeId';
      yield serializers.serialize(
        object.classeId,
        specifiedType: const FullType(int),
      );
    }
    if (object.classeNom != null) {
      yield r'classeNom';
      yield serializers.serialize(
        object.classeNom,
        specifiedType: const FullType(String),
      );
    }
    if (object.matiereId != null) {
      yield r'matiereId';
      yield serializers.serialize(
        object.matiereId,
        specifiedType: const FullType(int),
      );
    }
    if (object.matiereNom != null) {
      yield r'matiereNom';
      yield serializers.serialize(
        object.matiereNom,
        specifiedType: const FullType(String),
      );
    }
    if (object.langueId != null) {
      yield r'langueId';
      yield serializers.serialize(
        object.langueId,
        specifiedType: const FullType(int),
      );
    }
    if (object.langueNom != null) {
      yield r'langueNom';
      yield serializers.serialize(
        object.langueNom,
        specifiedType: const FullType(String),
      );
    }
    if (object.progression != null) {
      yield r'progression';
      yield serializers.serialize(
        object.progression,
        specifiedType: const FullType(double),
      );
    }
    if (object.statistiques != null) {
      yield r'statistiques';
      yield serializers.serialize(
        object.statistiques,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LivreDetailResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LivreDetailResponseBuilder result,
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
        case r'niveauId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.niveauId = valueDes;
          break;
        case r'niveauNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.niveauNom = valueDes;
          break;
        case r'classeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.classeId = valueDes;
          break;
        case r'classeNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.classeNom = valueDes;
          break;
        case r'matiereId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.matiereId = valueDes;
          break;
        case r'matiereNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matiereNom = valueDes;
          break;
        case r'langueId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.langueId = valueDes;
          break;
        case r'langueNom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.langueNom = valueDes;
          break;
        case r'progression':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.progression = valueDes;
          break;
        case r'statistiques':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.statistiques = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LivreDetailResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LivreDetailResponseBuilder();
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

