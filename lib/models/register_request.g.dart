// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RegisterRequest> _$registerRequestSerializer =
    _$RegisterRequestSerializer();

class _$RegisterRequestSerializer
    implements StructuredSerializer<RegisterRequest> {
  @override
  final Iterable<Type> types = const [RegisterRequest, _$RegisterRequest];
  @override
  final String wireName = 'RegisterRequest';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    RegisterRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'email',
      serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      ),
      'motDePasse',
      serializers.serialize(
        object.motDePasse,
        specifiedType: const FullType(String),
      ),
      'nom',
      serializers.serialize(object.nom, specifiedType: const FullType(String)),
      'prenom',
      serializers.serialize(
        object.prenom,
        specifiedType: const FullType(String),
      ),
      'ville',
      serializers.serialize(
        object.ville,
        specifiedType: const FullType(String),
      ),
      'classeId',
      serializers.serialize(
        object.classeId,
        specifiedType: const FullType(int),
      ),
      'telephone',
      serializers.serialize(
        object.telephone,
        specifiedType: const FullType(int),
      ),
      'niveauId',
      serializers.serialize(
        object.niveauId,
        specifiedType: const FullType(int),
      ),
    ];
    Object? value;
    value = object.photoProfil;
    if (value != null) {
      result
        ..add('photoProfil')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  RegisterRequest deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterRequestBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'email':
          result.email =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'motDePasse':
          result.motDePasse =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'nom':
          result.nom =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'prenom':
          result.prenom =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'ville':
          result.ville =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'photoProfil':
          result.photoProfil =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'classeId':
          result.classeId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'telephone':
          result.telephone =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'niveauId':
          result.niveauId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
      }
    }

    return result.build();
  }
}

class _$RegisterRequest extends RegisterRequest {
  @override
  final String email;
  @override
  final String motDePasse;
  @override
  final String nom;
  @override
  final String prenom;
  @override
  final String ville;
  @override
  final String? photoProfil;
  @override
  final int classeId;
  @override
  final int telephone;
  @override
  final int niveauId;

  factory _$RegisterRequest([void Function(RegisterRequestBuilder)? updates]) =>
      (RegisterRequestBuilder()..update(updates))._build();

  _$RegisterRequest._({
    required this.email,
    required this.motDePasse,
    required this.nom,
    required this.prenom,
    required this.ville,
    this.photoProfil,
    required this.classeId,
    required this.telephone,
    required this.niveauId,
  }) : super._();
  @override
  RegisterRequest rebuild(void Function(RegisterRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterRequestBuilder toBuilder() => RegisterRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterRequest &&
        email == other.email &&
        motDePasse == other.motDePasse &&
        nom == other.nom &&
        prenom == other.prenom &&
        ville == other.ville &&
        photoProfil == other.photoProfil &&
        classeId == other.classeId &&
        telephone == other.telephone &&
        niveauId == other.niveauId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, motDePasse.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, prenom.hashCode);
    _$hash = $jc(_$hash, ville.hashCode);
    _$hash = $jc(_$hash, photoProfil.hashCode);
    _$hash = $jc(_$hash, classeId.hashCode);
    _$hash = $jc(_$hash, telephone.hashCode);
    _$hash = $jc(_$hash, niveauId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterRequest')
          ..add('email', email)
          ..add('motDePasse', motDePasse)
          ..add('nom', nom)
          ..add('prenom', prenom)
          ..add('ville', ville)
          ..add('photoProfil', photoProfil)
          ..add('classeId', classeId)
          ..add('telephone', telephone)
          ..add('niveauId', niveauId))
        .toString();
  }
}

class RegisterRequestBuilder
    implements Builder<RegisterRequest, RegisterRequestBuilder> {
  _$RegisterRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _motDePasse;
  String? get motDePasse => _$this._motDePasse;
  set motDePasse(String? motDePasse) => _$this._motDePasse = motDePasse;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _prenom;
  String? get prenom => _$this._prenom;
  set prenom(String? prenom) => _$this._prenom = prenom;

  String? _ville;
  String? get ville => _$this._ville;
  set ville(String? ville) => _$this._ville = ville;

  String? _photoProfil;
  String? get photoProfil => _$this._photoProfil;
  set photoProfil(String? photoProfil) => _$this._photoProfil = photoProfil;

  int? _classeId;
  int? get classeId => _$this._classeId;
  set classeId(int? classeId) => _$this._classeId = classeId;

  int? _telephone;
  int? get telephone => _$this._telephone;
  set telephone(int? telephone) => _$this._telephone = telephone;

  int? _niveauId;
  int? get niveauId => _$this._niveauId;
  set niveauId(int? niveauId) => _$this._niveauId = niveauId;

  RegisterRequestBuilder();

  RegisterRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _motDePasse = $v.motDePasse;
      _nom = $v.nom;
      _prenom = $v.prenom;
      _ville = $v.ville;
      _photoProfil = $v.photoProfil;
      _classeId = $v.classeId;
      _telephone = $v.telephone;
      _niveauId = $v.niveauId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterRequest other) {
    _$v = other as _$RegisterRequest;
  }

  @override
  void update(void Function(RegisterRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterRequest build() => _build();

  _$RegisterRequest _build() {
    final _$result =
        _$v ??
        _$RegisterRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'RegisterRequest',
            'email',
          ),
          motDePasse: BuiltValueNullFieldError.checkNotNull(
            motDePasse,
            r'RegisterRequest',
            'motDePasse',
          ),
          nom: BuiltValueNullFieldError.checkNotNull(
            nom,
            r'RegisterRequest',
            'nom',
          ),
          prenom: BuiltValueNullFieldError.checkNotNull(
            prenom,
            r'RegisterRequest',
            'prenom',
          ),
          ville: BuiltValueNullFieldError.checkNotNull(
            ville,
            r'RegisterRequest',
            'ville',
          ),
          photoProfil: photoProfil,
          classeId: BuiltValueNullFieldError.checkNotNull(
            classeId,
            r'RegisterRequest',
            'classeId',
          ),
          telephone: BuiltValueNullFieldError.checkNotNull(
            telephone,
            r'RegisterRequest',
            'telephone',
          ),
          niveauId: BuiltValueNullFieldError.checkNotNull(
            niveauId,
            r'RegisterRequest',
            'niveauId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
