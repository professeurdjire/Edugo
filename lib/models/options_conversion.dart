//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/conversion_eleve.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'options_conversion.g.dart';

/// OptionsConversion
///
/// Properties:
/// * [id] 
/// * [libelle] 
/// * [etat] 
/// * [nbrePoint] 
/// * [dateAjout] 
/// * [conversions] 
@BuiltValue()
abstract class OptionsConversion implements Built<OptionsConversion, OptionsConversionBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'libelle')
  String? get libelle;

  @BuiltValueField(wireName: r'etat')
  bool? get etat;

  @BuiltValueField(wireName: r'nbrePoint')
  int? get nbrePoint;

  @BuiltValueField(wireName: r'dateAjout')
  DateTime? get dateAjout;

  @BuiltValueField(wireName: r'conversions')
  BuiltList<ConversionEleve>? get conversions;

  OptionsConversion._();

  factory OptionsConversion([void updates(OptionsConversionBuilder b)]) = _$OptionsConversion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OptionsConversionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OptionsConversion> get serializer => _$OptionsConversionSerializer();
}

class _$OptionsConversionSerializer implements PrimitiveSerializer<OptionsConversion> {
  @override
  final Iterable<Type> types = const [OptionsConversion, _$OptionsConversion];

  @override
  final String wireName = r'OptionsConversion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OptionsConversion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.libelle != null) {
      yield r'libelle';
      yield serializers.serialize(
        object.libelle,
        specifiedType: const FullType(String),
      );
    }
    if (object.etat != null) {
      yield r'etat';
      yield serializers.serialize(
        object.etat,
        specifiedType: const FullType(bool),
      );
    }
    if (object.nbrePoint != null) {
      yield r'nbrePoint';
      yield serializers.serialize(
        object.nbrePoint,
        specifiedType: const FullType(int),
      );
    }
    if (object.dateAjout != null) {
      yield r'dateAjout';
      yield serializers.serialize(
        object.dateAjout,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.conversions != null) {
      yield r'conversions';
      yield serializers.serialize(
        object.conversions,
        specifiedType: const FullType(BuiltList, [FullType(ConversionEleve)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OptionsConversion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OptionsConversionBuilder result,
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
        case r'libelle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.libelle = valueDes;
          break;
        case r'etat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.etat = valueDes;
          break;
        case r'nbrePoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nbrePoint = valueDes;
          break;
        case r'dateAjout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateAjout = valueDes;
          break;
        case r'conversions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ConversionEleve)]),
          ) as BuiltList<ConversionEleve>;
          result.conversions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OptionsConversion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OptionsConversionBuilder();
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

