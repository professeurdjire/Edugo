// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleve.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EleveRoleEnum _$eleveRoleEnum_ADMIN = const EleveRoleEnum._('ADMIN');
const EleveRoleEnum _$eleveRoleEnum_ELEVE = const EleveRoleEnum._('ELEVE');

EleveRoleEnum _$eleveRoleEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$eleveRoleEnum_ADMIN;
    case 'ELEVE':
      return _$eleveRoleEnum_ELEVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EleveRoleEnum> _$eleveRoleEnumValues = BuiltSet<EleveRoleEnum>(
  const <EleveRoleEnum>[_$eleveRoleEnum_ADMIN, _$eleveRoleEnum_ELEVE],
);

Serializer<EleveRoleEnum> _$eleveRoleEnumSerializer =
    _$EleveRoleEnumSerializer();

class _$EleveRoleEnumSerializer implements PrimitiveSerializer<EleveRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN': 'ADMIN',
    'ELEVE': 'ELEVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN': 'ADMIN',
    'ELEVE': 'ELEVE',
  };

  @override
  final Iterable<Type> types = const <Type>[EleveRoleEnum];
  @override
  final String wireName = 'EleveRoleEnum';

  @override
  Object serialize(
    Serializers serializers,
    EleveRoleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  EleveRoleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => EleveRoleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Eleve extends Eleve {
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
  final EleveRoleEnum? role;
  @override
  final DateTime? dateCreation;
  @override
  final DateTime? dateModification;
  @override
  final bool? estActive;
  @override
  final String? photoProfil;
  @override
  final String? dateNaissance;
  @override
  final Classe? classe;
  @override
  final int? pointAccumule;
  @override
  final BuiltList<Participation>? participations;
  @override
  final BuiltList<Progression>? progressions;
  @override
  final BuiltList<EleveDefi>? eleveDefis;
  @override
  final BuiltList<FaireExercice>? faireExercices;
  @override
  final BuiltList<ReponseEleve>? reponsesUtilisateurs;
  @override
  final BuiltList<ConversionEleve>? conversions;
  @override
  final BuiltList<Suggestion>? suggestions;
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

  factory _$Eleve([void Function(EleveBuilder)? updates]) =>
      (EleveBuilder()..update(updates))._build();

  _$Eleve._({
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
    this.dateNaissance,
    this.classe,
    this.pointAccumule,
    this.participations,
    this.progressions,
    this.eleveDefis,
    this.faireExercices,
    this.reponsesUtilisateurs,
    this.conversions,
    this.suggestions,
    this.enabled,
    this.authorities,
    this.password,
    this.username,
    this.credentialsNonExpired,
    this.accountNonExpired,
    this.accountNonLocked,
  }) : super._();
  @override
  Eleve rebuild(void Function(EleveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EleveBuilder toBuilder() => EleveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Eleve &&
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
        dateNaissance == other.dateNaissance &&
        classe == other.classe &&
        pointAccumule == other.pointAccumule &&
        participations == other.participations &&
        progressions == other.progressions &&
        eleveDefis == other.eleveDefis &&
        faireExercices == other.faireExercices &&
        reponsesUtilisateurs == other.reponsesUtilisateurs &&
        conversions == other.conversions &&
        suggestions == other.suggestions &&
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
    _$hash = $jc(_$hash, dateNaissance.hashCode);
    _$hash = $jc(_$hash, classe.hashCode);
    _$hash = $jc(_$hash, pointAccumule.hashCode);
    _$hash = $jc(_$hash, participations.hashCode);
    _$hash = $jc(_$hash, progressions.hashCode);
    _$hash = $jc(_$hash, eleveDefis.hashCode);
    _$hash = $jc(_$hash, faireExercices.hashCode);
    _$hash = $jc(_$hash, reponsesUtilisateurs.hashCode);
    _$hash = $jc(_$hash, conversions.hashCode);
    _$hash = $jc(_$hash, suggestions.hashCode);
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
    return (newBuiltValueToStringHelper(r'Eleve')
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
          ..add('dateNaissance', dateNaissance)
          ..add('classe', classe)
          ..add('pointAccumule', pointAccumule)
          ..add('participations', participations)
          ..add('progressions', progressions)
          ..add('eleveDefis', eleveDefis)
          ..add('faireExercices', faireExercices)
          ..add('reponsesUtilisateurs', reponsesUtilisateurs)
          ..add('conversions', conversions)
          ..add('suggestions', suggestions)
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

class EleveBuilder implements Builder<Eleve, EleveBuilder> {
  _$Eleve? _$v;

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

  EleveRoleEnum? _role;
  EleveRoleEnum? get role => _$this._role;
  set role(EleveRoleEnum? role) => _$this._role = role;

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

  String? _dateNaissance;
  String? get dateNaissance => _$this._dateNaissance;
  set dateNaissance(String? dateNaissance) =>
      _$this._dateNaissance = dateNaissance;

  ClasseBuilder? _classe;
  ClasseBuilder get classe => _$this._classe ??= ClasseBuilder();
  set classe(ClasseBuilder? classe) => _$this._classe = classe;

  int? _pointAccumule;
  int? get pointAccumule => _$this._pointAccumule;
  set pointAccumule(int? pointAccumule) =>
      _$this._pointAccumule = pointAccumule;

  ListBuilder<Participation>? _participations;
  ListBuilder<Participation> get participations =>
      _$this._participations ??= ListBuilder<Participation>();
  set participations(ListBuilder<Participation>? participations) =>
      _$this._participations = participations;

  ListBuilder<Progression>? _progressions;
  ListBuilder<Progression> get progressions =>
      _$this._progressions ??= ListBuilder<Progression>();
  set progressions(ListBuilder<Progression>? progressions) =>
      _$this._progressions = progressions;

  ListBuilder<EleveDefi>? _eleveDefis;
  ListBuilder<EleveDefi> get eleveDefis =>
      _$this._eleveDefis ??= ListBuilder<EleveDefi>();
  set eleveDefis(ListBuilder<EleveDefi>? eleveDefis) =>
      _$this._eleveDefis = eleveDefis;

  ListBuilder<FaireExercice>? _faireExercices;
  ListBuilder<FaireExercice> get faireExercices =>
      _$this._faireExercices ??= ListBuilder<FaireExercice>();
  set faireExercices(ListBuilder<FaireExercice>? faireExercices) =>
      _$this._faireExercices = faireExercices;

  ListBuilder<ReponseEleve>? _reponsesUtilisateurs;
  ListBuilder<ReponseEleve> get reponsesUtilisateurs =>
      _$this._reponsesUtilisateurs ??= ListBuilder<ReponseEleve>();
  set reponsesUtilisateurs(ListBuilder<ReponseEleve>? reponsesUtilisateurs) =>
      _$this._reponsesUtilisateurs = reponsesUtilisateurs;

  ListBuilder<ConversionEleve>? _conversions;
  ListBuilder<ConversionEleve> get conversions =>
      _$this._conversions ??= ListBuilder<ConversionEleve>();
  set conversions(ListBuilder<ConversionEleve>? conversions) =>
      _$this._conversions = conversions;

  ListBuilder<Suggestion>? _suggestions;
  ListBuilder<Suggestion> get suggestions =>
      _$this._suggestions ??= ListBuilder<Suggestion>();
  set suggestions(ListBuilder<Suggestion>? suggestions) =>
      _$this._suggestions = suggestions;

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

  EleveBuilder() {
    Eleve._defaults(this);
  }

  EleveBuilder get _$this {
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
      _dateNaissance = $v.dateNaissance;
      _classe = $v.classe?.toBuilder();
      _pointAccumule = $v.pointAccumule;
      _participations = $v.participations?.toBuilder();
      _progressions = $v.progressions?.toBuilder();
      _eleveDefis = $v.eleveDefis?.toBuilder();
      _faireExercices = $v.faireExercices?.toBuilder();
      _reponsesUtilisateurs = $v.reponsesUtilisateurs?.toBuilder();
      _conversions = $v.conversions?.toBuilder();
      _suggestions = $v.suggestions?.toBuilder();
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
  void replace(Eleve other) {
    _$v = other as _$Eleve;
  }

  @override
  void update(void Function(EleveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Eleve build() => _build();

  _$Eleve _build() {
    _$Eleve _$result;
    try {
      _$result =
          _$v ??
          _$Eleve._(
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
            dateNaissance: dateNaissance,
            classe: _classe?.build(),
            pointAccumule: pointAccumule,
            participations: _participations?.build(),
            progressions: _progressions?.build(),
            eleveDefis: _eleveDefis?.build(),
            faireExercices: _faireExercices?.build(),
            reponsesUtilisateurs: _reponsesUtilisateurs?.build(),
            conversions: _conversions?.build(),
            suggestions: _suggestions?.build(),
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
        _$failedField = 'classe';
        _classe?.build();

        _$failedField = 'participations';
        _participations?.build();
        _$failedField = 'progressions';
        _progressions?.build();
        _$failedField = 'eleveDefis';
        _eleveDefis?.build();
        _$failedField = 'faireExercices';
        _faireExercices?.build();
        _$failedField = 'reponsesUtilisateurs';
        _reponsesUtilisateurs?.build();
        _$failedField = 'conversions';
        _conversions?.build();
        _$failedField = 'suggestions';
        _suggestions?.build();

        _$failedField = 'authorities';
        _authorities?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Eleve', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
