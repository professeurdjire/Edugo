// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleve_defi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EleveDefi extends EleveDefi {
  @override
  final int? id;
  @override
  final String? reponseUtilisateur;
  @override
  final DateTime? dateEnvoie;
  @override
  final DateTime? dateParticipation;
  @override
  final String? statut;
  @override
  final Eleve? eleve;
  @override
  final Defi? defi;

  factory _$EleveDefi([void Function(EleveDefiBuilder)? updates]) =>
      (EleveDefiBuilder()..update(updates))._build();

  _$EleveDefi._({
    this.id,
    this.reponseUtilisateur,
    this.dateEnvoie,
    this.dateParticipation,
    this.statut,
    this.eleve,
    this.defi,
  }) : super._();
  @override
  EleveDefi rebuild(void Function(EleveDefiBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EleveDefiBuilder toBuilder() => EleveDefiBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EleveDefi &&
        id == other.id &&
        reponseUtilisateur == other.reponseUtilisateur &&
        dateEnvoie == other.dateEnvoie &&
        dateParticipation == other.dateParticipation &&
        statut == other.statut &&
        eleve == other.eleve &&
        defi == other.defi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reponseUtilisateur.hashCode);
    _$hash = $jc(_$hash, dateEnvoie.hashCode);
    _$hash = $jc(_$hash, dateParticipation.hashCode);
    _$hash = $jc(_$hash, statut.hashCode);
    _$hash = $jc(_$hash, eleve.hashCode);
    _$hash = $jc(_$hash, defi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EleveDefi')
          ..add('id', id)
          ..add('reponseUtilisateur', reponseUtilisateur)
          ..add('dateEnvoie', dateEnvoie)
          ..add('dateParticipation', dateParticipation)
          ..add('statut', statut)
          ..add('eleve', eleve)
          ..add('defi', defi))
        .toString();
  }
}

class EleveDefiBuilder implements Builder<EleveDefi, EleveDefiBuilder> {
  _$EleveDefi? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _reponseUtilisateur;
  String? get reponseUtilisateur => _$this._reponseUtilisateur;
  set reponseUtilisateur(String? reponseUtilisateur) =>
      _$this._reponseUtilisateur = reponseUtilisateur;

  DateTime? _dateEnvoie;
  DateTime? get dateEnvoie => _$this._dateEnvoie;
  set dateEnvoie(DateTime? dateEnvoie) => _$this._dateEnvoie = dateEnvoie;

  DateTime? _dateParticipation;
  DateTime? get dateParticipation => _$this._dateParticipation;
  set dateParticipation(DateTime? dateParticipation) =>
      _$this._dateParticipation = dateParticipation;

  String? _statut;
  String? get statut => _$this._statut;
  set statut(String? statut) => _$this._statut = statut;

  EleveBuilder? _eleve;
  EleveBuilder get eleve => _$this._eleve ??= EleveBuilder();
  set eleve(EleveBuilder? eleve) => _$this._eleve = eleve;

  DefiBuilder? _defi;
  DefiBuilder get defi => _$this._defi ??= DefiBuilder();
  set defi(DefiBuilder? defi) => _$this._defi = defi;

  EleveDefiBuilder() {
    EleveDefi._defaults(this);
  }

  EleveDefiBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reponseUtilisateur = $v.reponseUtilisateur;
      _dateEnvoie = $v.dateEnvoie;
      _dateParticipation = $v.dateParticipation;
      _statut = $v.statut;
      _eleve = $v.eleve?.toBuilder();
      _defi = $v.defi?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EleveDefi other) {
    _$v = other as _$EleveDefi;
  }

  @override
  void update(void Function(EleveDefiBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EleveDefi build() => _build();

  _$EleveDefi _build() {
    _$EleveDefi _$result;
    try {
      _$result =
          _$v ??
          _$EleveDefi._(
            id: id,
            reponseUtilisateur: reponseUtilisateur,
            dateEnvoie: dateEnvoie,
            dateParticipation: dateParticipation,
            statut: statut,
            eleve: _eleve?.build(),
            defi: _defi?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'eleve';
        _eleve?.build();
        _$failedField = 'defi';
        _defi?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EleveDefi',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
