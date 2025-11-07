//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/classe.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/progression.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/niveau.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/models/tag.dart';
import 'package:edugo/models/matiere.dart';
import 'package:edugo/models/langue.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'livre.g.dart';

/// Livre
///
/// Properties:
/// * [id] 
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
/// * [niveau] 
/// * [classe] 
/// * [matiere] 
/// * [langue] 
/// * [fichiers] 
/// * [quiz] 
/// * [progressions] 
/// * [tags] 
@BuiltValue()
abstract class Livre implements Built<Livre, LivreBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

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

  @BuiltValueField(wireName: r'niveau')
  Niveau? get niveau;

  @BuiltValueField(wireName: r'classe')
  Classe? get classe;

  @BuiltValueField(wireName: r'matiere')
  Matiere? get matiere;

  @BuiltValueField(wireName: r'langue')
  Langue? get langue;

  @BuiltValueField(wireName: r'fichiers')
  BuiltList<FichierLivre>? get fichiers;

  @BuiltValueField(wireName: r'quiz')
  Quiz? get quiz;

  @BuiltValueField(wireName: r'progressions')
  BuiltList<Progression>? get progressions;

  @BuiltValueField(wireName: r'tags')
  BuiltList<Tag>? get tags;

  Livre._();

  factory Livre([void updates(LivreBuilder b)]) = _$Livre;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LivreBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Livre> get serializer => _$LivreSerializer();
}

class _$LivreSerializer implements PrimitiveSerializer<Livre> {
  @override
  final Iterable<Type> types = const [Livre, _$Livre];

  @override
  final String wireName = r'Livre';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Livre object, {
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
    if (object.niveau != null) {
      yield r'niveau';
      yield serializers.serialize(
        object.niveau,
        specifiedType: const FullType(Niveau),
      );
    }
    if (object.classe != null) {
      yield r'classe';
      yield serializers.serialize(
        object.classe,
        specifiedType: const FullType(Classe),
      );
    }
    if (object.matiere != null) {
      yield r'matiere';
      yield serializers.serialize(
        object.matiere,
        specifiedType: const FullType(Matiere),
      );
    }
    if (object.langue != null) {
      yield r'langue';
      yield serializers.serialize(
        object.langue,
        specifiedType: const FullType(Langue),
      );
    }
    if (object.fichiers != null) {
      yield r'fichiers';
      yield serializers.serialize(
        object.fichiers,
        specifiedType: const FullType(BuiltList, [FullType(FichierLivre)]),
      );
    }
    if (object.quiz != null) {
      yield r'quiz';
      yield serializers.serialize(
        object.quiz,
        specifiedType: const FullType(Quiz),
      );
    }
    if (object.progressions != null) {
      yield r'progressions';
      yield serializers.serialize(
        object.progressions,
        specifiedType: const FullType(BuiltList, [FullType(Progression)]),
      );
    }
    if (object.tags != null) {
      yield r'tags';
      yield serializers.serialize(
        object.tags,
        specifiedType: const FullType(BuiltList, [FullType(Tag)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Livre object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LivreBuilder result,
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
        case r'niveau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Niveau),
          ) as Niveau;
          result.niveau.replace(valueDes);
          break;
        case r'classe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Classe),
          ) as Classe;
          result.classe.replace(valueDes);
          break;
        case r'matiere':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Matiere),
          ) as Matiere;
          result.matiere.replace(valueDes);
          break;
        case r'langue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Langue),
          ) as Langue;
          result.langue.replace(valueDes);
          break;
        case r'fichiers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FichierLivre)]),
          ) as BuiltList<FichierLivre>;
          result.fichiers.replace(valueDes);
          break;
        case r'quiz':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Quiz),
          ) as Quiz;
          result.quiz.replace(valueDes);
          break;
        case r'progressions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Progression)]),
          ) as BuiltList<Progression>;
          result.progressions.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Tag)]),
          ) as BuiltList<Tag>;
          result.tags.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Livre deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LivreBuilder();
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

