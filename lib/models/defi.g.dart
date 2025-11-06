// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Defi extends Defi {
  @override
  final int? id;
  @override
  final String? titre;
  @override
  final String? ennonce;
  @override
  final DateTime? dateAjout;
  @override
  final String? reponseDefi;
  @override
  final int? pointDefi;
  @override
  final int? nbreParticipations;
  @override
  final String? typeDefi;
  @override
  final Classe? classe;
  @override
  final BuiltList<EleveDefi>? eleveDefis;

  factory _$Defi([void Function(DefiBuilder)? updates]) =>
      (DefiBuilder()..update(updates))._build();

  _$Defi._({
    this.id,
    this.titre,
    this.ennonce,
    this.dateAjout,
    this.reponseDefi,
    this.pointDefi,
    this.nbreParticipations,
    this.typeDefi,
    this.classe,
    this.eleveDefis,
  }) : super._();
  @override
  Defi rebuild(void Function(DefiBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DefiBuilder toBuilder() => DefiBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Defi &&
        id == other.id &&
        titre == other.titre &&
        ennonce == other.ennonce &&
        dateAjout == other.dateAjout &&
        reponseDefi == other.reponseDefi &&
        pointDefi == other.pointDefi &&
        nbreParticipations == other.nbreParticipations &&
        typeDefi == other.typeDefi &&
        classe == other.classe &&
        eleveDefis == other.eleveDefis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, ennonce.hashCode);
    _$hash = $jc(_$hash, dateAjout.hashCode);
    _$hash = $jc(_$hash, reponseDefi.hashCode);
    _$hash = $jc(_$hash, pointDefi.hashCode);
    _$hash = $jc(_$hash, nbreParticipations.hashCode);
    _$hash = $jc(_$hash, typeDefi.hashCode);
    _$hash = $jc(_$hash, classe.hashCode);
    _$hash = $jc(_$hash, eleveDefis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Defi')
          ..add('id', id)
          ..add('titre', titre)
          ..add('ennonce', ennonce)
          ..add('dateAjout', dateAjout)
          ..add('reponseDefi', reponseDefi)
          ..add('pointDefi', pointDefi)
          ..add('nbreParticipations', nbreParticipations)
          ..add('typeDefi', typeDefi)
          ..add('classe', classe)
          ..add('eleveDefis', eleveDefis))
        .toString();
  }
}

class DefiBuilder implements Builder<Defi, DefiBuilder> {
  _$Defi? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _ennonce;
  String? get ennonce => _$this._ennonce;
  set ennonce(String? ennonce) => _$this._ennonce = ennonce;

  DateTime? _dateAjout;
  DateTime? get dateAjout => _$this._dateAjout;
  set dateAjout(DateTime? dateAjout) => _$this._dateAjout = dateAjout;

  String? _reponseDefi;
  String? get reponseDefi => _$this._reponseDefi;
  set reponseDefi(String? reponseDefi) => _$this._reponseDefi = reponseDefi;

  int? _pointDefi;
  int? get pointDefi => _$this._pointDefi;
  set pointDefi(int? pointDefi) => _$this._pointDefi = pointDefi;

  int? _nbreParticipations;
  int? get nbreParticipations => _$this._nbreParticipations;
  set nbreParticipations(int? nbreParticipations) =>
      _$this._nbreParticipations = nbreParticipations;

  String? _typeDefi;
  String? get typeDefi => _$this._typeDefi;
  set typeDefi(String? typeDefi) => _$this._typeDefi = typeDefi;

  ClasseBuilder? _classe;
  ClasseBuilder get classe => _$this._classe ??= ClasseBuilder();
  set classe(ClasseBuilder? classe) => _$this._classe = classe;

  ListBuilder<EleveDefi>? _eleveDefis;
  ListBuilder<EleveDefi> get eleveDefis =>
      _$this._eleveDefis ??= ListBuilder<EleveDefi>();
  set eleveDefis(ListBuilder<EleveDefi>? eleveDefis) =>
      _$this._eleveDefis = eleveDefis;

  DefiBuilder() {
    Defi._defaults(this);
  }

  DefiBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _ennonce = $v.ennonce;
      _dateAjout = $v.dateAjout;
      _reponseDefi = $v.reponseDefi;
      _pointDefi = $v.pointDefi;
      _nbreParticipations = $v.nbreParticipations;
      _typeDefi = $v.typeDefi;
      _classe = $v.classe?.toBuilder();
      _eleveDefis = $v.eleveDefis?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Defi other) {
    _$v = other as _$Defi;
  }

  @override
  void update(void Function(DefiBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Defi build() => _build();

  _$Defi _build() {
    _$Defi _$result;
    try {
      _$result =
          _$v ??
          _$Defi._(
            id: id,
            titre: titre,
            ennonce: ennonce,
            dateAjout: dateAjout,
            reponseDefi: reponseDefi,
            pointDefi: pointDefi,
            nbreParticipations: nbreParticipations,
            typeDefi: typeDefi,
            classe: _classe?.build(),
            eleveDefis: _eleveDefis?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'classe';
        _classe?.build();
        _$failedField = 'eleveDefis';
        _eleveDefis?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Defi', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
