// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserRoleEnum _$userRoleEnum_ADMIN = const UserRoleEnum._('ADMIN');
const UserRoleEnum _$userRoleEnum_ELEVE = const UserRoleEnum._('ELEVE');

UserRoleEnum _$userRoleEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$userRoleEnum_ADMIN;
    case 'ELEVE':
      return _$userRoleEnum_ELEVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserRoleEnum> _$userRoleEnumValues = BuiltSet<UserRoleEnum>(
  const <UserRoleEnum>[_$userRoleEnum_ADMIN, _$userRoleEnum_ELEVE],
);

Serializer<UserRoleEnum> _$userRoleEnumSerializer = _$UserRoleEnumSerializer();

class _$UserRoleEnumSerializer implements PrimitiveSerializer<UserRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN': 'ADMIN',
    'ELEVE': 'ELEVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN': 'ADMIN',
    'ELEVE': 'ELEVE',
  };

  @override
  final Iterable<Type> types = const <Type>[UserRoleEnum];
  @override
  final String wireName = 'UserRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    UserRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  UserRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => UserRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$User extends User {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final String? prenom;
  @override
  final String? email;
  @override
  final String? motDePasse;
  @override
  final UserRoleEnum? role;
  @override
  final DateTime? dateCreation;
  @override
  final DateTime? dateModification;
  @override
  final bool? estActive;
  @override
  final String? photoProfil;
  @override
  final bool? enabled;
  @override
  final BuiltList<GrantedAuthority>? authorities;
  @override
  final String? password;
  @override
  final String? username;
  @override
  final bool? credentialsNonExpired;
  @override
  final bool? accountNonExpired;
  @override
  final bool? accountNonLocked;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (UserBuilder()..update(updates))._build();

  _$User._({
    this.id,
    this.nom,
    this.prenom,
    this.email,
    this.motDePasse,
    this.role,
    this.dateCreation,
    this.dateModification,
    this.estActive,
    this.photoProfil,
    this.enabled,
    this.authorities,
    this.password,
    this.username,
    this.credentialsNonExpired,
    this.accountNonExpired,
    this.accountNonLocked,
  }) : super._();
  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        nom == other.nom &&
        prenom == other.prenom &&
        email == other.email &&
        motDePasse == other.motDePasse &&
        role == other.role &&
        dateCreation == other.dateCreation &&
        dateModification == other.dateModification &&
        estActive == other.estActive &&
        photoProfil == other.photoProfil &&
        enabled == other.enabled &&
        authorities == other.authorities &&
        password == other.password &&
        username == other.username &&
        credentialsNonExpired == other.credentialsNonExpired &&
        accountNonExpired == other.accountNonExpired &&
        accountNonLocked == other.accountNonLocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, prenom.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, motDePasse.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, dateCreation.hashCode);
    _$hash = $jc(_$hash, dateModification.hashCode);
    _$hash = $jc(_$hash, estActive.hashCode);
    _$hash = $jc(_$hash, photoProfil.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, authorities.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, credentialsNonExpired.hashCode);
    _$hash = $jc(_$hash, accountNonExpired.hashCode);
    _$hash = $jc(_$hash, accountNonLocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'User')
          ..add('id', id)
          ..add('nom', nom)
          ..add('prenom', prenom)
          ..add('email', email)
          ..add('motDePasse', motDePasse)
          ..add('role', role)
          ..add('dateCreation', dateCreation)
          ..add('dateModification', dateModification)
          ..add('estActive', estActive)
          ..add('photoProfil', photoProfil)
          ..add('enabled', enabled)
          ..add('authorities', authorities)
          ..add('password', password)
          ..add('username', username)
          ..add('credentialsNonExpired', credentialsNonExpired)
          ..add('accountNonExpired', accountNonExpired)
          ..add('accountNonLocked', accountNonLocked))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _prenom;
  String? get prenom => _$this._prenom;
  set prenom(String? prenom) => _$this._prenom = prenom;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _motDePasse;
  String? get motDePasse => _$this._motDePasse;
  set motDePasse(String? motDePasse) => _$this._motDePasse = motDePasse;

  UserRoleEnum? _role;
  UserRoleEnum? get role => _$this._role;
  set role(UserRoleEnum? role) => _$this._role = role;

  DateTime? _dateCreation;
  DateTime? get dateCreation => _$this._dateCreation;
  set dateCreation(DateTime? dateCreation) =>
      _$this._dateCreation = dateCreation;

  DateTime? _dateModification;
  DateTime? get dateModification => _$this._dateModification;
  set dateModification(DateTime? dateModification) =>
      _$this._dateModification = dateModification;

  bool? _estActive;
  bool? get estActive => _$this._estActive;
  set estActive(bool? estActive) => _$this._estActive = estActive;

  String? _photoProfil;
  String? get photoProfil => _$this._photoProfil;
  set photoProfil(String? photoProfil) => _$this._photoProfil = photoProfil;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ListBuilder<GrantedAuthority>? _authorities;
  ListBuilder<GrantedAuthority> get authorities =>
      _$this._authorities ??= ListBuilder<GrantedAuthority>();
  set authorities(ListBuilder<GrantedAuthority>? authorities) =>
      _$this._authorities = authorities;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  bool? _credentialsNonExpired;
  bool? get credentialsNonExpired => _$this._credentialsNonExpired;
  set credentialsNonExpired(bool? credentialsNonExpired) =>
      _$this._credentialsNonExpired = credentialsNonExpired;

  bool? _accountNonExpired;
  bool? get accountNonExpired => _$this._accountNonExpired;
  set accountNonExpired(bool? accountNonExpired) =>
      _$this._accountNonExpired = accountNonExpired;

  bool? _accountNonLocked;
  bool? get accountNonLocked => _$this._accountNonLocked;
  set accountNonLocked(bool? accountNonLocked) =>
      _$this._accountNonLocked = accountNonLocked;

  UserBuilder() {
    User._defaults(this);
  }

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _prenom = $v.prenom;
      _email = $v.email;
      _motDePasse = $v.motDePasse;
      _role = $v.role;
      _dateCreation = $v.dateCreation;
      _dateModification = $v.dateModification;
      _estActive = $v.estActive;
      _photoProfil = $v.photoProfil;
      _enabled = $v.enabled;
      _authorities = $v.authorities?.toBuilder();
      _password = $v.password;
      _username = $v.username;
      _credentialsNonExpired = $v.credentialsNonExpired;
      _accountNonExpired = $v.accountNonExpired;
      _accountNonLocked = $v.accountNonLocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  User build() => _build();

  _$User _build() {
    _$User _$result;
    try {
      _$result =
          _$v ??
          _$User._(
            id: id,
            nom: nom,
            prenom: prenom,
            email: email,
            motDePasse: motDePasse,
            role: role,
            dateCreation: dateCreation,
            dateModification: dateModification,
            estActive: estActive,
            photoProfil: photoProfil,
            enabled: enabled,
            authorities: _authorities?.build(),
            password: password,
            username: username,
            credentialsNonExpired: credentialsNonExpired,
            accountNonExpired: accountNonExpired,
            accountNonLocked: accountNonLocked,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'authorities';
        _authorities?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
