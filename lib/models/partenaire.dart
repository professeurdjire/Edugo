//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'partenaire.g.dart';

/// Partenaire
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [description] 
/// * [logoUrl] 
/// * [siteWeb] 
/// * [domaine] 
/// * [type] 
/// * [email] 
/// * [telephone] 
/// * [pays] 
/// * [statut] 
/// * [dateAjout] 
/// * [newsletter] 
/// * [dateCreation] 
/// * [dateModification] 
/// * [actif] 
@BuiltValue()
abstract class Partenaire implements Built<Partenaire, PartenaireBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'siteWeb')
  String? get siteWeb;

  @BuiltValueField(wireName: r'domaine')
  String? get domaine;

  @BuiltValueField(wireName: r'type')
  String? get type;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'telephone')
  String? get telephone;

  @BuiltValueField(wireName: r'pays')
  String? get pays;

  @BuiltValueField(wireName: r'statut')
  String? get statut;

  @BuiltValueField(wireName: r'dateAjout')
  DateTime? get dateAjout;

  @BuiltValueField(wireName: r'newsletter')
  bool? get newsletter;

  @BuiltValueField(wireName: r'dateCreation')
  DateTime? get dateCreation;

  @BuiltValueField(wireName: r'dateModification')
  DateTime? get dateModification;

  @BuiltValueField(wireName: r'actif')
  bool? get actif;

  Partenaire._();

  factory Partenaire([void updates(PartenaireBuilder b)]) = _$Partenaire;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PartenaireBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Partenaire> get serializer => _$PartenaireSerializer();
}

class _$PartenaireSerializer implements StructuredSerializer<Partenaire> {
  @override
  final Iterable<Type> types = const [Partenaire, _$Partenaire];

  @override
  final String wireName = r'Partenaire';

  @override
  Iterable<Object?> serialize(Serializers serializers, Partenaire object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    if (object.id != null) {
      result
        ..add(r'id')
        ..add(serializers.serialize(object.id, specifiedType: const FullType(int)));
    }
    if (object.nom != null) {
      result
        ..add(r'nom')
        ..add(serializers.serialize(object.nom, specifiedType: const FullType(String)));
    }
    if (object.description != null) {
      result
        ..add(r'description')
        ..add(serializers.serialize(object.description, specifiedType: const FullType(String)));
    }
    if (object.logoUrl != null) {
      result
        ..add(r'logoUrl')
        ..add(serializers.serialize(object.logoUrl, specifiedType: const FullType(String)));
    }
    if (object.siteWeb != null) {
      result
        ..add(r'siteWeb')
        ..add(serializers.serialize(object.siteWeb, specifiedType: const FullType(String)));
    }
    if (object.domaine != null) {
      result
        ..add(r'domaine')
        ..add(serializers.serialize(object.domaine, specifiedType: const FullType(String)));
    }
    if (object.type != null) {
      result
        ..add(r'type')
        ..add(serializers.serialize(object.type, specifiedType: const FullType(String)));
    }
    if (object.email != null) {
      result
        ..add(r'email')
        ..add(serializers.serialize(object.email, specifiedType: const FullType(String)));
    }
    if (object.telephone != null) {
      result
        ..add(r'telephone')
        ..add(serializers.serialize(object.telephone, specifiedType: const FullType(String)));
    }
    if (object.pays != null) {
      result
        ..add(r'pays')
        ..add(serializers.serialize(object.pays, specifiedType: const FullType(String)));
    }
    if (object.statut != null) {
      result
        ..add(r'statut')
        ..add(serializers.serialize(object.statut, specifiedType: const FullType(String)));
    }
    if (object.dateAjout != null) {
      result
        ..add(r'dateAjout')
        ..add(serializers.serialize(object.dateAjout, specifiedType: const FullType(DateTime)));
    }
    if (object.newsletter != null) {
      result
        ..add(r'newsletter')
        ..add(serializers.serialize(object.newsletter, specifiedType: const FullType(bool)));
    }
    if (object.dateCreation != null) {
      result
        ..add(r'dateCreation')
        ..add(serializers.serialize(object.dateCreation, specifiedType: const FullType(DateTime)));
    }
    if (object.dateModification != null) {
      result
        ..add(r'dateModification')
        ..add(serializers.serialize(object.dateModification, specifiedType: const FullType(DateTime)));
    }
    if (object.actif != null) {
      result
        ..add(r'actif')
        ..add(serializers.serialize(object.actif, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Partenaire deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PartenaireBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case r'id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case r'nom':
          result.nom = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'logoUrl':
          result.logoUrl = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'siteWeb':
          result.siteWeb = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'domaine':
          result.domaine = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'type':
          result.type = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'email':
          result.email = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'telephone':
          result.telephone = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'pays':
          result.pays = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'statut':
          result.statut = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case r'dateAjout':
          result.dateAjout = serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case r'newsletter':
          result.newsletter = serializers.deserialize(value, specifiedType: const FullType(bool)) as bool?;
          break;
        case r'dateCreation':
          result.dateCreation = serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case r'dateModification':
          result.dateModification = serializers.deserialize(value, specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case r'actif':
          result.actif = serializers.deserialize(value, specifiedType: const FullType(bool)) as bool?;
          break;
      }
    }
    return result.build();
  }
}

