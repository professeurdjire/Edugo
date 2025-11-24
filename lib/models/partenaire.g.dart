// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partenaire.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Partenaire extends Partenaire {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? siteWeb;
  @override
  final String? domaine;
  @override
  final String? type;
  @override
  final String? email;
  @override
  final String? telephone;
  @override
  final String? pays;
  @override
  final String? statut;
  @override
  final DateTime? dateAjout;
  @override
  final bool? newsletter;
  @override
  final DateTime? dateCreation;
  @override
  final DateTime? dateModification;
  @override
  final bool? actif;

  factory _$Partenaire([void Function(PartenaireBuilder)? updates]) =>
      (PartenaireBuilder()..update(updates))._build();

  _$Partenaire._({
    this.id,
    this.nom,
    this.description,
    this.logoUrl,
    this.siteWeb,
    this.domaine,
    this.type,
    this.email,
    this.telephone,
    this.pays,
    this.statut,
    this.dateAjout,
    this.newsletter,
    this.dateCreation,
    this.dateModification,
    this.actif,
  }) : super._();
  @override
  Partenaire rebuild(void Function(PartenaireBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PartenaireBuilder toBuilder() => PartenaireBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Partenaire &&
        id == other.id &&
        nom == other.nom &&
        description == other.description &&
        logoUrl == other.logoUrl &&
        siteWeb == other.siteWeb &&
        domaine == other.domaine &&
        type == other.type &&
        email == other.email &&
        telephone == other.telephone &&
        pays == other.pays &&
        statut == other.statut &&
        dateAjout == other.dateAjout &&
        newsletter == other.newsletter &&
        dateCreation == other.dateCreation &&
        dateModification == other.dateModification &&
        actif == other.actif;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, siteWeb.hashCode);
    _$hash = $jc(_$hash, domaine.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, telephone.hashCode);
    _$hash = $jc(_$hash, pays.hashCode);
    _$hash = $jc(_$hash, statut.hashCode);
    _$hash = $jc(_$hash, dateAjout.hashCode);
    _$hash = $jc(_$hash, newsletter.hashCode);
    _$hash = $jc(_$hash, dateCreation.hashCode);
    _$hash = $jc(_$hash, dateModification.hashCode);
    _$hash = $jc(_$hash, actif.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Partenaire')
          ..add('id', id)
          ..add('nom', nom)
          ..add('description', description)
          ..add('logoUrl', logoUrl)
          ..add('siteWeb', siteWeb)
          ..add('domaine', domaine)
          ..add('type', type)
          ..add('email', email)
          ..add('telephone', telephone)
          ..add('pays', pays)
          ..add('statut', statut)
          ..add('dateAjout', dateAjout)
          ..add('newsletter', newsletter)
          ..add('dateCreation', dateCreation)
          ..add('dateModification', dateModification)
          ..add('actif', actif))
        .toString();
  }
}

class PartenaireBuilder implements Builder<Partenaire, PartenaireBuilder> {
  _$Partenaire? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _siteWeb;
  String? get siteWeb => _$this._siteWeb;
  set siteWeb(String? siteWeb) => _$this._siteWeb = siteWeb;

  String? _domaine;
  String? get domaine => _$this._domaine;
  set domaine(String? domaine) => _$this._domaine = domaine;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _telephone;
  String? get telephone => _$this._telephone;
  set telephone(String? telephone) => _$this._telephone = telephone;

  String? _pays;
  String? get pays => _$this._pays;
  set pays(String? pays) => _$this._pays = pays;

  String? _statut;
  String? get statut => _$this._statut;
  set statut(String? statut) => _$this._statut = statut;

  DateTime? _dateAjout;
  DateTime? get dateAjout => _$this._dateAjout;
  set dateAjout(DateTime? dateAjout) => _$this._dateAjout = dateAjout;

  bool? _newsletter;
  bool? get newsletter => _$this._newsletter;
  set newsletter(bool? newsletter) => _$this._newsletter = newsletter;

  DateTime? _dateCreation;
  DateTime? get dateCreation => _$this._dateCreation;
  set dateCreation(DateTime? dateCreation) =>
      _$this._dateCreation = dateCreation;

  DateTime? _dateModification;
  DateTime? get dateModification => _$this._dateModification;
  set dateModification(DateTime? dateModification) =>
      _$this._dateModification = dateModification;

  bool? _actif;
  bool? get actif => _$this._actif;
  set actif(bool? actif) => _$this._actif = actif;

  PartenaireBuilder() {
    Partenaire._defaults(this);
  }

  PartenaireBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _description = $v.description;
      _logoUrl = $v.logoUrl;
      _siteWeb = $v.siteWeb;
      _domaine = $v.domaine;
      _type = $v.type;
      _email = $v.email;
      _telephone = $v.telephone;
      _pays = $v.pays;
      _statut = $v.statut;
      _dateAjout = $v.dateAjout;
      _newsletter = $v.newsletter;
      _dateCreation = $v.dateCreation;
      _dateModification = $v.dateModification;
      _actif = $v.actif;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Partenaire other) {
    _$v = other as _$Partenaire;
  }

  @override
  void update(void Function(PartenaireBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Partenaire build() => _build();

  _$Partenaire _build() {
    final _$result =
        _$v ??
        _$Partenaire._(
          id: id,
          nom: nom,
          description: description,
          logoUrl: logoUrl,
          siteWeb: siteWeb,
          domaine: domaine,
          type: type,
          email: email,
          telephone: telephone,
          pays: pays,
          statut: statut,
          dateAjout: dateAjout,
          newsletter: newsletter,
          dateCreation: dateCreation,
          dateModification: dateModification,
          actif: actif,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
