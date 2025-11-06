//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/granted_authority.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user.g.dart';

/// User
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [prenom] 
/// * [email] 
/// * [motDePasse] 
/// * [role] 
/// * [dateCreation] 
/// * [dateModification] 
/// * [estActive] 
/// * [photoProfil] 
/// * [enabled] 
/// * [authorities] 
/// * [password] 
/// * [username] 
/// * [credentialsNonExpired] 
/// * [accountNonExpired] 
/// * [accountNonLocked] 
@BuiltValue()
abstract class User implements Built<User, UserBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'prenom')
  String? get prenom;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'motDePasse')
  String? get motDePasse;

  @BuiltValueField(wireName: r'role')
  UserRoleEnum? get role;
  // enum roleEnum {  ADMIN,  ELEVE,  };

  @BuiltValueField(wireName: r'dateCreation')
  DateTime? get dateCreation;

  @BuiltValueField(wireName: r'dateModification')
  DateTime? get dateModification;

  @BuiltValueField(wireName: r'estActive')
  bool? get estActive;

  @BuiltValueField(wireName: r'photoProfil')
  String? get photoProfil;

  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  @BuiltValueField(wireName: r'authorities')
  BuiltList<GrantedAuthority>? get authorities;

  @BuiltValueField(wireName: r'password')
  String? get password;

  @BuiltValueField(wireName: r'username')
  String? get username;

  @BuiltValueField(wireName: r'credentialsNonExpired')
  bool? get credentialsNonExpired;

  @BuiltValueField(wireName: r'accountNonExpired')
  bool? get accountNonExpired;

  @BuiltValueField(wireName: r'accountNonLocked')
  bool? get accountNonLocked;

  User._();

  factory User([void updates(UserBuilder b)]) = _$User;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<User> get serializer => _$UserSerializer();
}

class _$UserSerializer implements PrimitiveSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];

  @override
  final String wireName = r'User';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    User object, {
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
    if (object.prenom != null) {
      yield r'prenom';
      yield serializers.serialize(
        object.prenom,
        specifiedType: const FullType(String),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
    if (object.motDePasse != null) {
      yield r'motDePasse';
      yield serializers.serialize(
        object.motDePasse,
        specifiedType: const FullType(String),
      );
    }
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(UserRoleEnum),
      );
    }
    if (object.dateCreation != null) {
      yield r'dateCreation';
      yield serializers.serialize(
        object.dateCreation,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.dateModification != null) {
      yield r'dateModification';
      yield serializers.serialize(
        object.dateModification,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.estActive != null) {
      yield r'estActive';
      yield serializers.serialize(
        object.estActive,
        specifiedType: const FullType(bool),
      );
    }
    if (object.photoProfil != null) {
      yield r'photoProfil';
      yield serializers.serialize(
        object.photoProfil,
        specifiedType: const FullType(String),
      );
    }
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.authorities != null) {
      yield r'authorities';
      yield serializers.serialize(
        object.authorities,
        specifiedType: const FullType(BuiltList, [FullType(GrantedAuthority)]),
      );
    }
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      );
    }
    if (object.username != null) {
      yield r'username';
      yield serializers.serialize(
        object.username,
        specifiedType: const FullType(String),
      );
    }
    if (object.credentialsNonExpired != null) {
      yield r'credentialsNonExpired';
      yield serializers.serialize(
        object.credentialsNonExpired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.accountNonExpired != null) {
      yield r'accountNonExpired';
      yield serializers.serialize(
        object.accountNonExpired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.accountNonLocked != null) {
      yield r'accountNonLocked';
      yield serializers.serialize(
        object.accountNonLocked,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    User object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserBuilder result,
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
        case r'prenom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prenom = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'motDePasse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.motDePasse = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserRoleEnum),
          ) as UserRoleEnum;
          result.role = valueDes;
          break;
        case r'dateCreation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateCreation = valueDes;
          break;
        case r'dateModification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateModification = valueDes;
          break;
        case r'estActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.estActive = valueDes;
          break;
        case r'photoProfil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.photoProfil = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'authorities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GrantedAuthority)]),
          ) as BuiltList<GrantedAuthority>;
          result.authorities.replace(valueDes);
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'credentialsNonExpired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.credentialsNonExpired = valueDes;
          break;
        case r'accountNonExpired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accountNonExpired = valueDes;
          break;
        case r'accountNonLocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accountNonLocked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  User deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserBuilder();
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

class UserRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const UserRoleEnum ADMIN = _$userRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'ELEVE')
  static const UserRoleEnum ELEVE = _$userRoleEnum_ELEVE;

  static Serializer<UserRoleEnum> get serializer => _$userRoleEnumSerializer;

  const UserRoleEnum._(String name): super(name);

  static BuiltSet<UserRoleEnum> get values => _$userRoleEnumValues;
  static UserRoleEnum valueOf(String name) => _$userRoleEnumValueOf(name);
}

