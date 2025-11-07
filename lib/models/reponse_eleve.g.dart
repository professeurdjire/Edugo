// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reponse_eleve.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReponseEleve extends ReponseEleve {
  @override
  final int? id;
  @override
  final Eleve? eleve;
  @override
  final Question? question;
  @override
  final String? reponse;
  @override
  final double? pointsAttribues;
  @override
  final DateTime? dateReponse;

  factory _$ReponseEleve([void Function(ReponseEleveBuilder)? updates]) =>
      (ReponseEleveBuilder()..update(updates))._build();

  _$ReponseEleve._({
    this.id,
    this.eleve,
    this.question,
    this.reponse,
    this.pointsAttribues,
    this.dateReponse,
  }) : super._();
  @override
  ReponseEleve rebuild(void Function(ReponseEleveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReponseEleveBuilder toBuilder() => ReponseEleveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReponseEleve &&
        id == other.id &&
        eleve == other.eleve &&
        question == other.question &&
        reponse == other.reponse &&
        pointsAttribues == other.pointsAttribues &&
        dateReponse == other.dateReponse;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, eleve.hashCode);
    _$hash = $jc(_$hash, question.hashCode);
    _$hash = $jc(_$hash, reponse.hashCode);
    _$hash = $jc(_$hash, pointsAttribues.hashCode);
    _$hash = $jc(_$hash, dateReponse.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReponseEleve')
          ..add('id', id)
          ..add('eleve', eleve)
          ..add('question', question)
          ..add('reponse', reponse)
          ..add('pointsAttribues', pointsAttribues)
          ..add('dateReponse', dateReponse))
        .toString();
  }
}

class ReponseEleveBuilder
    implements Builder<ReponseEleve, ReponseEleveBuilder> {
  _$ReponseEleve? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  EleveBuilder? _eleve;
  EleveBuilder get eleve => _$this._eleve ??= EleveBuilder();
  set eleve(EleveBuilder? eleve) => _$this._eleve = eleve;

  QuestionBuilder? _question;
  QuestionBuilder get question => _$this._question ??= QuestionBuilder();
  set question(QuestionBuilder? question) => _$this._question = question;

  String? _reponse;
  String? get reponse => _$this._reponse;
  set reponse(String? reponse) => _$this._reponse = reponse;

  double? _pointsAttribues;
  double? get pointsAttribues => _$this._pointsAttribues;
  set pointsAttribues(double? pointsAttribues) =>
      _$this._pointsAttribues = pointsAttribues;

  DateTime? _dateReponse;
  DateTime? get dateReponse => _$this._dateReponse;
  set dateReponse(DateTime? dateReponse) => _$this._dateReponse = dateReponse;

  ReponseEleveBuilder() {
    ReponseEleve._defaults(this);
  }

  ReponseEleveBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _eleve = $v.eleve?.toBuilder();
      _question = $v.question?.toBuilder();
      _reponse = $v.reponse;
      _pointsAttribues = $v.pointsAttribues;
      _dateReponse = $v.dateReponse;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReponseEleve other) {
    _$v = other as _$ReponseEleve;
  }

  @override
  void update(void Function(ReponseEleveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReponseEleve build() => _build();

  _$ReponseEleve _build() {
    _$ReponseEleve _$result;
    try {
      _$result =
          _$v ??
          _$ReponseEleve._(
            id: id,
            eleve: _eleve?.build(),
            question: _question?.build(),
            reponse: reponse,
            pointsAttribues: pointsAttribues,
            dateReponse: dateReponse,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'eleve';
        _eleve?.build();
        _$failedField = 'question';
        _question?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ReponseEleve',
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
