//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'statistiques_livre_response.g.dart';

/// StatistiquesLivreResponse
///
/// Properties:
/// * [livreId] 
/// * [titre] 
/// * [auteur] 
/// * [totalPages] 
/// * [nombreLecteurs] 
/// * [nombreLecteursComplets] 
/// * [progressionMoyenne] 
@BuiltValue()
abstract class StatistiquesLivreResponse implements Built<StatistiquesLivreResponse, StatistiquesLivreResponseBuilder> {
  @BuiltValueField(wireName: r'livreId')
  int? get livreId;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'auteur')
  String? get auteur;

  @BuiltValueField(wireName: r'totalPages')
  int? get totalPages;

  @BuiltValueField(wireName: r'nombreLecteurs')
  int? get nombreLecteurs;

  @BuiltValueField(wireName: r'nombreLecteursComplets')
  int? get nombreLecteursComplets;

  @BuiltValueField(wireName: r'progressionMoyenne')
  double? get progressionMoyenne;

  StatistiquesLivreResponse._();

  factory StatistiquesLivreResponse([void updates(StatistiquesLivreResponseBuilder b)]) = _$StatistiquesLivreResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StatistiquesLivreResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StatistiquesLivreResponse> get serializer => _$StatistiquesLivreResponseSerializer();
}

class _$StatistiquesLivreResponseSerializer implements PrimitiveSerializer<StatistiquesLivreResponse> {
  @override
  final Iterable<Type> types = const [StatistiquesLivreResponse, _$StatistiquesLivreResponse];

  @override
  final String wireName = r'StatistiquesLivreResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StatistiquesLivreResponse object, {
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
    if (object.totalPages != null) {
      yield r'totalPages';
      yield serializers.serialize(
        object.totalPages,
        specifiedType: const FullType(int),
      );
    }
    if (object.nombreLecteurs != null) {
      yield r'nombreLecteurs';
      yield serializers.serialize(
        object.nombreLecteurs,
        specifiedType: const FullType(int),
      );
    }
    if (object.nombreLecteursComplets != null) {
      yield r'nombreLecteursComplets';
      yield serializers.serialize(
        object.nombreLecteursComplets,
        specifiedType: const FullType(int),
      );
    }
    if (object.progressionMoyenne != null) {
      yield r'progressionMoyenne';
      yield serializers.serialize(
        object.progressionMoyenne,
        specifiedType: const FullType(double),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StatistiquesLivreResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StatistiquesLivreResponseBuilder result,
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
        case r'totalPages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalPages = valueDes;
          break;
        case r'nombreLecteurs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nombreLecteurs = valueDes;
          break;
        case r'nombreLecteursComplets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nombreLecteursComplets = valueDes;
          break;
        case r'progressionMoyenne':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.progressionMoyenne = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StatistiquesLivreResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StatistiquesLivreResponseBuilder();
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

