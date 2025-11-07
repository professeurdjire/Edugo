//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/livre.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'progression.g.dart';

/// Progression
///
/// Properties:
/// * [id] 
/// * [pourcentageCompletion] 
/// * [tempsLecture] 
/// * [pageActuelle] 
/// * [dateDerniereLecture] 
/// * [eleve] 
/// * [livre] 
/// * [dateMiseAJour] 
@BuiltValue()
abstract class Progression implements Built<Progression, ProgressionBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'pourcentageCompletion')
  int? get pourcentageCompletion;

  @BuiltValueField(wireName: r'tempsLecture')
  int? get tempsLecture;

  @BuiltValueField(wireName: r'pageActuelle')
  int? get pageActuelle;

  @BuiltValueField(wireName: r'dateDerniereLecture')
  DateTime? get dateDerniereLecture;

  @BuiltValueField(wireName: r'eleve')
  Eleve? get eleve;

  @BuiltValueField(wireName: r'livre')
  Livre? get livre;

  @BuiltValueField(wireName: r'dateMiseAJour')
  DateTime? get dateMiseAJour;

  Progression._();

  factory Progression([void updates(ProgressionBuilder b)]) = _$Progression;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProgressionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Progression> get serializer => _$ProgressionSerializer();
}

class _$ProgressionSerializer implements PrimitiveSerializer<Progression> {
  @override
  final Iterable<Type> types = const [Progression, _$Progression];

  @override
  final String wireName = r'Progression';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Progression object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.pourcentageCompletion != null) {
      yield r'pourcentageCompletion';
      yield serializers.serialize(
        object.pourcentageCompletion,
        specifiedType: const FullType(int),
      );
    }
    if (object.tempsLecture != null) {
      yield r'tempsLecture';
      yield serializers.serialize(
        object.tempsLecture,
        specifiedType: const FullType(int),
      );
    }
    if (object.pageActuelle != null) {
      yield r'pageActuelle';
      yield serializers.serialize(
        object.pageActuelle,
        specifiedType: const FullType(int),
      );
    }
    if (object.dateDerniereLecture != null) {
      yield r'dateDerniereLecture';
      yield serializers.serialize(
        object.dateDerniereLecture,
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
    if (object.livre != null) {
      yield r'livre';
      yield serializers.serialize(
        object.livre,
        specifiedType: const FullType(Livre),
      );
    }
    if (object.dateMiseAJour != null) {
      yield r'dateMiseAJour';
      yield serializers.serialize(
        object.dateMiseAJour,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Progression object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProgressionBuilder result,
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
        case r'pourcentageCompletion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pourcentageCompletion = valueDes;
          break;
        case r'tempsLecture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tempsLecture = valueDes;
          break;
        case r'pageActuelle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pageActuelle = valueDes;
          break;
        case r'dateDerniereLecture':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateDerniereLecture = valueDes;
          break;
        case r'eleve':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Eleve),
          ) as Eleve;
          result.eleve.replace(valueDes);
          break;
        case r'livre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Livre),
          ) as Livre;
          result.livre.replace(valueDes);
          break;
        case r'dateMiseAJour':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateMiseAJour = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Progression deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProgressionBuilder();
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

