// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Progression extends Progression {
  @override
  final int? id;
  @override
  final int? pourcentageCompletion;
  @override
  final int? tempsLecture;
  @override
  final int? pageActuelle;
  @override
  final DateTime? dateDerniereLecture;
  @override
  final Eleve? eleve;
  @override
  final Livre? livre;
  @override
  final DateTime? dateMiseAJour;

  factory _$Progression([void Function(ProgressionBuilder)? updates]) =>
      (ProgressionBuilder()..update(updates))._build();

  _$Progression._({
    this.id,
    this.pourcentageCompletion,
    this.tempsLecture,
    this.pageActuelle,
    this.dateDerniereLecture,
    this.eleve,
    this.livre,
    this.dateMiseAJour,
  }) : super._();
  @override
  Progression rebuild(void Function(ProgressionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressionBuilder toBuilder() => ProgressionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Progression &&
        id == other.id &&
        pourcentageCompletion == other.pourcentageCompletion &&
        tempsLecture == other.tempsLecture &&
        pageActuelle == other.pageActuelle &&
        dateDerniereLecture == other.dateDerniereLecture &&
        eleve == other.eleve &&
        livre == other.livre &&
        dateMiseAJour == other.dateMiseAJour;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, pourcentageCompletion.hashCode);
    _$hash = $jc(_$hash, tempsLecture.hashCode);
    _$hash = $jc(_$hash, pageActuelle.hashCode);
    _$hash = $jc(_$hash, dateDerniereLecture.hashCode);
    _$hash = $jc(_$hash, eleve.hashCode);
    _$hash = $jc(_$hash, livre.hashCode);
    _$hash = $jc(_$hash, dateMiseAJour.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Progression')
          ..add('id', id)
          ..add('pourcentageCompletion', pourcentageCompletion)
          ..add('tempsLecture', tempsLecture)
          ..add('pageActuelle', pageActuelle)
          ..add('dateDerniereLecture', dateDerniereLecture)
          ..add('eleve', eleve)
          ..add('livre', livre)
          ..add('dateMiseAJour', dateMiseAJour))
        .toString();
  }
}

class ProgressionBuilder implements Builder<Progression, ProgressionBuilder> {
  _$Progression? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _pourcentageCompletion;
  int? get pourcentageCompletion => _$this._pourcentageCompletion;
  set pourcentageCompletion(int? pourcentageCompletion) =>
      _$this._pourcentageCompletion = pourcentageCompletion;

  int? _tempsLecture;
  int? get tempsLecture => _$this._tempsLecture;
  set tempsLecture(int? tempsLecture) => _$this._tempsLecture = tempsLecture;

  int? _pageActuelle;
  int? get pageActuelle => _$this._pageActuelle;
  set pageActuelle(int? pageActuelle) => _$this._pageActuelle = pageActuelle;

  DateTime? _dateDerniereLecture;
  DateTime? get dateDerniereLecture => _$this._dateDerniereLecture;
  set dateDerniereLecture(DateTime? dateDerniereLecture) =>
      _$this._dateDerniereLecture = dateDerniereLecture;

  EleveBuilder? _eleve;
  EleveBuilder get eleve => _$this._eleve ??= EleveBuilder();
  set eleve(EleveBuilder? eleve) => _$this._eleve = eleve;

  LivreBuilder? _livre;
  LivreBuilder get livre => _$this._livre ??= LivreBuilder();
  set livre(LivreBuilder? livre) => _$this._livre = livre;

  DateTime? _dateMiseAJour;
  DateTime? get dateMiseAJour => _$this._dateMiseAJour;
  set dateMiseAJour(DateTime? dateMiseAJour) =>
      _$this._dateMiseAJour = dateMiseAJour;

  ProgressionBuilder() {
    Progression._defaults(this);
  }

  ProgressionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _pourcentageCompletion = $v.pourcentageCompletion;
      _tempsLecture = $v.tempsLecture;
      _pageActuelle = $v.pageActuelle;
      _dateDerniereLecture = $v.dateDerniereLecture;
      _eleve = $v.eleve?.toBuilder();
      _livre = $v.livre?.toBuilder();
      _dateMiseAJour = $v.dateMiseAJour;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Progression other) {
    _$v = other as _$Progression;
  }

  @override
  void update(void Function(ProgressionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Progression build() => _build();

  _$Progression _build() {
    _$Progression _$result;
    try {
      _$result =
          _$v ??
          _$Progression._(
            id: id,
            pourcentageCompletion: pourcentageCompletion,
            tempsLecture: tempsLecture,
            pageActuelle: pageActuelle,
            dateDerniereLecture: dateDerniereLecture,
            eleve: _eleve?.build(),
            livre: _livre?.build(),
            dateMiseAJour: dateMiseAJour,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'eleve';
        _eleve?.build();
        _$failedField = 'livre';
        _livre?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Progression',
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
