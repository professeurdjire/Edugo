//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/livre.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fichier_livre.g.dart';

/// FichierLivre
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [cheminFichier] 
/// * [type] 
/// * [taille] 
/// * [format] 
/// * [livre] 
/// * [tailleFormattee] 
@BuiltValue()
abstract class FichierLivre implements Built<FichierLivre, FichierLivreBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'cheminFichier')
  String? get cheminFichier;

  @BuiltValueField(wireName: r'type')
  FichierLivreTypeEnum? get type;
  // enum typeEnum {  PDF,  EPUB,  IMAGE,  VIDEO,  AUDIO,  };

  @BuiltValueField(wireName: r'taille')
  int? get taille;

  @BuiltValueField(wireName: r'format')
  String? get format;

  @BuiltValueField(wireName: r'livre')
  Livre? get livre;

  @BuiltValueField(wireName: r'tailleFormattee')
  String? get tailleFormattee;

  FichierLivre._();

  factory FichierLivre([void updates(FichierLivreBuilder b)]) = _$FichierLivre;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FichierLivreBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FichierLivre> get serializer => _$FichierLivreSerializer();
}

class _$FichierLivreSerializer implements PrimitiveSerializer<FichierLivre> {
  @override
  final Iterable<Type> types = const [FichierLivre, _$FichierLivre];

  @override
  final String wireName = r'FichierLivre';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FichierLivre object, {
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
    if (object.cheminFichier != null) {
      yield r'cheminFichier';
      yield serializers.serialize(
        object.cheminFichier,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(FichierLivreTypeEnum),
      );
    }
    if (object.taille != null) {
      yield r'taille';
      yield serializers.serialize(
        object.taille,
        specifiedType: const FullType(int),
      );
    }
    if (object.format != null) {
      yield r'format';
      yield serializers.serialize(
        object.format,
        specifiedType: const FullType(String),
      );
    }
    if (object.livre != null) {
      yield r'livre';
      yield serializers.serialize(
        object.livre,
        specifiedType: const FullType(Livre),
      );
    }
    if (object.tailleFormattee != null) {
      yield r'tailleFormattee';
      yield serializers.serialize(
        object.tailleFormattee,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FichierLivre object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FichierLivreBuilder result,
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
        case r'cheminFichier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cheminFichier = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FichierLivreTypeEnum),
          ) as FichierLivreTypeEnum;
          result.type = valueDes;
          break;
        case r'taille':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taille = valueDes;
          break;
        case r'format':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.format = valueDes;
          break;
        case r'livre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Livre),
          ) as Livre;
          result.livre.replace(valueDes);
          break;
        case r'tailleFormattee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tailleFormattee = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FichierLivre deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FichierLivreBuilder();
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

class FichierLivreTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PDF')
  static const FichierLivreTypeEnum PDF = _$fichierLivreTypeEnum_PDF;
  @BuiltValueEnumConst(wireName: r'EPUB')
  static const FichierLivreTypeEnum EPUB = _$fichierLivreTypeEnum_EPUB;
  @BuiltValueEnumConst(wireName: r'IMAGE')
  static const FichierLivreTypeEnum IMAGE = _$fichierLivreTypeEnum_IMAGE;
  @BuiltValueEnumConst(wireName: r'VIDEO')
  static const FichierLivreTypeEnum VIDEO = _$fichierLivreTypeEnum_VIDEO;
  @BuiltValueEnumConst(wireName: r'AUDIO')
  static const FichierLivreTypeEnum AUDIO = _$fichierLivreTypeEnum_AUDIO;

  static Serializer<FichierLivreTypeEnum> get serializer => _$fichierLivreTypeEnumSerializer;

  const FichierLivreTypeEnum._(String name): super(name);

  static BuiltSet<FichierLivreTypeEnum> get values => _$fichierLivreTypeEnumValues;
  static FichierLivreTypeEnum valueOf(String name) => _$fichierLivreTypeEnumValueOf(name);
}

