//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

/// Encodes a query parameter value.
String encodeQueryParameter(Serializers serializers, dynamic value, FullType specifiedType) {
  final serialized = serializers.serialize(value, specifiedType: specifiedType);
  if (serialized is String) {
    return serialized;
  } else if (serialized is num || serialized is bool) {
    return serialized.toString();
  } else {
    // For complex types, you might want to use JSON encoding
    // But for simple types like int, this should suffice
    return serialized.toString();
  }
}

/// Format the given form parameter object into something that Dio can handle.
/// Returns primitive or String.
/// Returns List/Map if the value is BuildList/BuiltMap.
dynamic encodeFormParameter(Serializers serializers, dynamic value, FullType type) {
  if (value == null) {
    return '';
  }
  if (value is String || value is num || value is bool) {
    return value;
  }
  final serialized = serializers.serialize(
    value as Object,
    specifiedType: type,
  );
  if (serialized is String) {
    return serialized;
  }
  if (value is BuiltList || value is BuiltSet || value is BuiltMap) {
    return serialized;
  }
  return json.encode(serialized);
}

ListParam<Object?> encodeCollectionQueryParameter<T>(
  Serializers serializers,
  dynamic value,
  FullType type, {
  ListFormat format = ListFormat.multi,
}) {
  final serialized = serializers.serialize(
    value as Object,
    specifiedType: type,
  );
  if (value is BuiltList<T> || value is BuiltSet<T>) {
    return ListParam(List.of((serialized as Iterable<Object?>).cast()), format);
  }
  throw ArgumentError('Invalid value passed to encodeCollectionQueryParameter');
}
