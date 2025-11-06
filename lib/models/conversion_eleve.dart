//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/options_conversion.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conversion_eleve.g.dart';

/// ConversionEleve
///
/// Properties:
/// * [id] 
/// * [option] 
/// * [eleve] 
/// * [dateConversion] 
@BuiltValue()
abstract class ConversionEleve implements Built<ConversionEleve, ConversionEleveBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'option')
  OptionsConversion? get option;

  @BuiltValueField(wireName: r'eleve')
  Eleve? get eleve;

  @BuiltValueField(wireName: r'dateConversion')
  DateTime? get dateConversion;

  ConversionEleve._();

  factory ConversionEleve([void updates(ConversionEleveBuilder b)]) = _$ConversionEleve;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConversionEleveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConversionEleve> get serializer => _$ConversionEleveSerializer();
}

class _$ConversionEleveSerializer implements PrimitiveSerializer<ConversionEleve> {
  @override
  final Iterable<Type> types = const [ConversionEleve, _$ConversionEleve];

  @override
  final String wireName = r'ConversionEleve';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConversionEleve object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.option != null) {
      yield r'option';
      yield serializers.serialize(
        object.option,
        specifiedType: const FullType(OptionsConversion),
      );
    }
    if (object.eleve != null) {
      yield r'eleve';
      yield serializers.serialize(
        object.eleve,
        specifiedType: const FullType(Eleve),
      );
    }
    if (object.dateConversion != null) {
      yield r'dateConversion';
      yield serializers.serialize(
        object.dateConversion,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ConversionEleve object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConversionEleveBuilder result,
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
        case r'option':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OptionsConversion),
          ) as OptionsConversion;
          result.option.replace(valueDes);
          break;
        case r'eleve':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Eleve),
          ) as Eleve;
          result.eleve.replace(valueDes);
          break;
        case r'dateConversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateConversion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConversionEleve deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConversionEleveBuilder();
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

