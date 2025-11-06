//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/classe.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/eleve_defi.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'defi.g.dart';

/// Defi
///
/// Properties:
/// * [id] 
/// * [titre] 
/// * [ennonce] 
/// * [dateAjout] 
/// * [reponseDefi] 
/// * [pointDefi] 
/// * [nbreParticipations] 
/// * [typeDefi] 
/// * [classe] 
/// * [eleveDefis] 
@BuiltValue()
abstract class Defi implements Built<Defi, DefiBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'titre')
  String? get titre;

  @BuiltValueField(wireName: r'ennonce')
  String? get ennonce;

  @BuiltValueField(wireName: r'dateAjout')
  DateTime? get dateAjout;

  @BuiltValueField(wireName: r'reponseDefi')
  String? get reponseDefi;

  @BuiltValueField(wireName: r'pointDefi')
  int? get pointDefi;

  @BuiltValueField(wireName: r'nbreParticipations')
  int? get nbreParticipations;

  @BuiltValueField(wireName: r'typeDefi')
  String? get typeDefi;

  @BuiltValueField(wireName: r'classe')
  Classe? get classe;

  @BuiltValueField(wireName: r'eleveDefis')
  BuiltList<EleveDefi>? get eleveDefis;

  Defi._();

  factory Defi([void updates(DefiBuilder b)]) = _$Defi;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DefiBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Defi> get serializer => _$DefiSerializer();
}

class _$DefiSerializer implements PrimitiveSerializer<Defi> {
  @override
  final Iterable<Type> types = const [Defi, _$Defi];

  @override
  final String wireName = r'Defi';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Defi object, {
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
    if (object.ennonce != null) {
      yield r'ennonce';
      yield serializers.serialize(
        object.ennonce,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateAjout != null) {
      yield r'dateAjout';
      yield serializers.serialize(
        object.dateAjout,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.reponseDefi != null) {
      yield r'reponseDefi';
      yield serializers.serialize(
        object.reponseDefi,
        specifiedType: const FullType(String),
      );
    }
    if (object.pointDefi != null) {
      yield r'pointDefi';
      yield serializers.serialize(
        object.pointDefi,
        specifiedType: const FullType(int),
      );
    }
    if (object.nbreParticipations != null) {
      yield r'nbreParticipations';
      yield serializers.serialize(
        object.nbreParticipations,
        specifiedType: const FullType(int),
      );
    }
    if (object.typeDefi != null) {
      yield r'typeDefi';
      yield serializers.serialize(
        object.typeDefi,
        specifiedType: const FullType(String),
      );
    }
    if (object.classe != null) {
      yield r'classe';
      yield serializers.serialize(
        object.classe,
        specifiedType: const FullType(Classe),
      );
    }
    if (object.eleveDefis != null) {
      yield r'eleveDefis';
      yield serializers.serialize(
        object.eleveDefis,
        specifiedType: const FullType(BuiltList, [FullType(EleveDefi)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Defi object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DefiBuilder result,
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
        case r'ennonce':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ennonce = valueDes;
          break;
        case r'dateAjout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateAjout = valueDes;
          break;
        case r'reponseDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reponseDefi = valueDes;
          break;
        case r'pointDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pointDefi = valueDes;
          break;
        case r'nbreParticipations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nbreParticipations = valueDes;
          break;
        case r'typeDefi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.typeDefi = valueDes;
          break;
        case r'classe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Classe),
          ) as Classe;
          result.classe.replace(valueDes);
          break;
        case r'eleveDefis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EleveDefi)]),
          ) as BuiltList<EleveDefi>;
          result.eleveDefis.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Defi deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DefiBuilder();
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

