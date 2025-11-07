// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Participation extends Participation {
  @override
  final int? id;
  @override
  final int? score;
  @override
  final int? rang;
  @override
  final int? tempsPasse;
  @override
  final String? statut;
  @override
  final DateTime? dateParticipation;
  @override
  final bool? isaParticiper;
  @override
  final Eleve? eleve;
  @override
  final Challenge? challenge;
  @override
  final Badge? badge;

  factory _$Participation([void Function(ParticipationBuilder)? updates]) =>
      (ParticipationBuilder()..update(updates))._build();

  _$Participation._({
    this.id,
    this.score,
    this.rang,
    this.tempsPasse,
    this.statut,
    this.dateParticipation,
    this.isaParticiper,
    this.eleve,
    this.challenge,
    this.badge,
  }) : super._();
  @override
  Participation rebuild(void Function(ParticipationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParticipationBuilder toBuilder() => ParticipationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Participation &&
        id == other.id &&
        score == other.score &&
        rang == other.rang &&
        tempsPasse == other.tempsPasse &&
        statut == other.statut &&
        dateParticipation == other.dateParticipation &&
        isaParticiper == other.isaParticiper &&
        eleve == other.eleve &&
        challenge == other.challenge &&
        badge == other.badge;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, rang.hashCode);
    _$hash = $jc(_$hash, tempsPasse.hashCode);
    _$hash = $jc(_$hash, statut.hashCode);
    _$hash = $jc(_$hash, dateParticipation.hashCode);
    _$hash = $jc(_$hash, isaParticiper.hashCode);
    _$hash = $jc(_$hash, eleve.hashCode);
    _$hash = $jc(_$hash, challenge.hashCode);
    _$hash = $jc(_$hash, badge.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Participation')
          ..add('id', id)
          ..add('score', score)
          ..add('rang', rang)
          ..add('tempsPasse', tempsPasse)
          ..add('statut', statut)
          ..add('dateParticipation', dateParticipation)
          ..add('isaParticiper', isaParticiper)
          ..add('eleve', eleve)
          ..add('challenge', challenge)
          ..add('badge', badge))
        .toString();
  }
}

class ParticipationBuilder
    implements Builder<Participation, ParticipationBuilder> {
  _$Participation? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  int? _rang;
  int? get rang => _$this._rang;
  set rang(int? rang) => _$this._rang = rang;

  int? _tempsPasse;
  int? get tempsPasse => _$this._tempsPasse;
  set tempsPasse(int? tempsPasse) => _$this._tempsPasse = tempsPasse;

  String? _statut;
  String? get statut => _$this._statut;
  set statut(String? statut) => _$this._statut = statut;

  DateTime? _dateParticipation;
  DateTime? get dateParticipation => _$this._dateParticipation;
  set dateParticipation(DateTime? dateParticipation) =>
      _$this._dateParticipation = dateParticipation;

  bool? _isaParticiper;
  bool? get isaParticiper => _$this._isaParticiper;
  set isaParticiper(bool? isaParticiper) =>
      _$this._isaParticiper = isaParticiper;

  EleveBuilder? _eleve;
  EleveBuilder get eleve => _$this._eleve ??= EleveBuilder();
  set eleve(EleveBuilder? eleve) => _$this._eleve = eleve;

  ChallengeBuilder? _challenge;
  ChallengeBuilder get challenge => _$this._challenge ??= ChallengeBuilder();
  set challenge(ChallengeBuilder? challenge) => _$this._challenge = challenge;

  BadgeBuilder? _badge;
  BadgeBuilder get badge => _$this._badge ??= BadgeBuilder();
  set badge(BadgeBuilder? badge) => _$this._badge = badge;

  ParticipationBuilder() {
    Participation._defaults(this);
  }

  ParticipationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _score = $v.score;
      _rang = $v.rang;
      _tempsPasse = $v.tempsPasse;
      _statut = $v.statut;
      _dateParticipation = $v.dateParticipation;
      _isaParticiper = $v.isaParticiper;
      _eleve = $v.eleve?.toBuilder();
      _challenge = $v.challenge?.toBuilder();
      _badge = $v.badge?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Participation other) {
    _$v = other as _$Participation;
  }

  @override
  void update(void Function(ParticipationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Participation build() => _build();

  _$Participation _build() {
    _$Participation _$result;
    try {
      _$result =
          _$v ??
          _$Participation._(
            id: id,
            score: score,
            rang: rang,
            tempsPasse: tempsPasse,
            statut: statut,
            dateParticipation: dateParticipation,
            isaParticiper: isaParticiper,
            eleve: _eleve?.build(),
            challenge: _challenge?.build(),
            badge: _badge?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'eleve';
        _eleve?.build();
        _$failedField = 'challenge';
        _challenge?.build();
        _$failedField = 'badge';
        _badge?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Participation',
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
