// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleve_defi_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EleveDefiResponse extends EleveDefiResponse {
  @override
  final int? id;
  @override
  final int? eleveId;
  @override
  final String? nom;
  @override
  final String? prenom;
  @override
  final int? defiId;
  @override
  final String? defiTitre;
  @override
  final DateTime? dateEnvoie;
  @override
  final String? statut;

  factory _$EleveDefiResponse([
    void Function(EleveDefiResponseBuilder)? updates,
  ]) => (EleveDefiResponseBuilder()..update(updates))._build();

  _$EleveDefiResponse._({
    this.id,
    this.eleveId,
    this.nom,
    this.prenom,
    this.defiId,
    this.defiTitre,
    this.dateEnvoie,
    this.statut,
  }) : super._();
  @override
  EleveDefiResponse rebuild(void Function(EleveDefiResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EleveDefiResponseBuilder toBuilder() =>
      EleveDefiResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EleveDefiResponse &&
        id == other.id &&
        eleveId == other.eleveId &&
        nom == other.nom &&
        prenom == other.prenom &&
        defiId == other.defiId &&
        defiTitre == other.defiTitre &&
        dateEnvoie == other.dateEnvoie &&
        statut == other.statut;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, eleveId.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, prenom.hashCode);
    _$hash = $jc(_$hash, defiId.hashCode);
    _$hash = $jc(_$hash, defiTitre.hashCode);
    _$hash = $jc(_$hash, dateEnvoie.hashCode);
    _$hash = $jc(_$hash, statut.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EleveDefiResponse')
          ..add('id', id)
          ..add('eleveId', eleveId)
          ..add('nom', nom)
          ..add('prenom', prenom)
          ..add('defiId', defiId)
          ..add('defiTitre', defiTitre)
          ..add('dateEnvoie', dateEnvoie)
          ..add('statut', statut))
        .toString();
  }
}

class EleveDefiResponseBuilder
    implements Builder<EleveDefiResponse, EleveDefiResponseBuilder> {
  _$EleveDefiResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _eleveId;
  int? get eleveId => _$this._eleveId;
  set eleveId(int? eleveId) => _$this._eleveId = eleveId;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _prenom;
  String? get prenom => _$this._prenom;
  set prenom(String? prenom) => _$this._prenom = prenom;

  int? _defiId;
  int? get defiId => _$this._defiId;
  set defiId(int? defiId) => _$this._defiId = defiId;

  String? _defiTitre;
  String? get defiTitre => _$this._defiTitre;
  set defiTitre(String? defiTitre) => _$this._defiTitre = defiTitre;

  DateTime? _dateEnvoie;
  DateTime? get dateEnvoie => _$this._dateEnvoie;
  set dateEnvoie(DateTime? dateEnvoie) => _$this._dateEnvoie = dateEnvoie;

  String? _statut;
  String? get statut => _$this._statut;
  set statut(String? statut) => _$this._statut = statut;

  EleveDefiResponseBuilder() {
    EleveDefiResponse._defaults(this);
  }

  EleveDefiResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _eleveId = $v.eleveId;
      _nom = $v.nom;
      _prenom = $v.prenom;
      _defiId = $v.defiId;
      _defiTitre = $v.defiTitre;
      _dateEnvoie = $v.dateEnvoie;
      _statut = $v.statut;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EleveDefiResponse other) {
    _$v = other as _$EleveDefiResponse;
  }

  @override
  void update(void Function(EleveDefiResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EleveDefiResponse build() => _build();

  _$EleveDefiResponse _build() {
    final _$result =
        _$v ??
        _$EleveDefiResponse._(
          id: id,
          eleveId: eleveId,
          nom: nom,
          prenom: prenom,
          defiId: defiId,
          defiTitre: defiTitre,
          dateEnvoie: dateEnvoie,
          statut: statut,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
