// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Question extends Question {
  @override
  final int? id;
  @override
  final String? enonce;
  @override
  final int? points;
  @override
  final DateTime? dateCreation;
  @override
  final DateTime? dateModification;
  @override
  final Challenge? challenge;
  @override
  final Quiz? quiz;
  @override
  final Exercice? exercice;
  @override
  final TypeQuestion? type;
  @override
  final BuiltList<ReponsePossible>? reponsesPossibles;
  @override
  final BuiltList<ReponseEleve>? reponsesEleves;

  factory _$Question([void Function(QuestionBuilder)? updates]) =>
      (QuestionBuilder()..update(updates))._build();

  _$Question._({
    this.id,
    this.enonce,
    this.points,
    this.dateCreation,
    this.dateModification,
    this.challenge,
    this.quiz,
    this.exercice,
    this.type,
    this.reponsesPossibles,
    this.reponsesEleves,
  }) : super._();
  @override
  Question rebuild(void Function(QuestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuestionBuilder toBuilder() => QuestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Question &&
        id == other.id &&
        enonce == other.enonce &&
        points == other.points &&
        dateCreation == other.dateCreation &&
        dateModification == other.dateModification &&
        challenge == other.challenge &&
        quiz == other.quiz &&
        exercice == other.exercice &&
        type == other.type &&
        reponsesPossibles == other.reponsesPossibles &&
        reponsesEleves == other.reponsesEleves;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, enonce.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, dateCreation.hashCode);
    _$hash = $jc(_$hash, dateModification.hashCode);
    _$hash = $jc(_$hash, challenge.hashCode);
    _$hash = $jc(_$hash, quiz.hashCode);
    _$hash = $jc(_$hash, exercice.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, reponsesPossibles.hashCode);
    _$hash = $jc(_$hash, reponsesEleves.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Question')
          ..add('id', id)
          ..add('enonce', enonce)
          ..add('points', points)
          ..add('dateCreation', dateCreation)
          ..add('dateModification', dateModification)
          ..add('challenge', challenge)
          ..add('quiz', quiz)
          ..add('exercice', exercice)
          ..add('type', type)
          ..add('reponsesPossibles', reponsesPossibles)
          ..add('reponsesEleves', reponsesEleves))
        .toString();
  }
}

class QuestionBuilder implements Builder<Question, QuestionBuilder> {
  _$Question? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _enonce;
  String? get enonce => _$this._enonce;
  set enonce(String? enonce) => _$this._enonce = enonce;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  DateTime? _dateCreation;
  DateTime? get dateCreation => _$this._dateCreation;
  set dateCreation(DateTime? dateCreation) =>
      _$this._dateCreation = dateCreation;

  DateTime? _dateModification;
  DateTime? get dateModification => _$this._dateModification;
  set dateModification(DateTime? dateModification) =>
      _$this._dateModification = dateModification;

  ChallengeBuilder? _challenge;
  ChallengeBuilder get challenge => _$this._challenge ??= ChallengeBuilder();
  set challenge(ChallengeBuilder? challenge) => _$this._challenge = challenge;

  QuizBuilder? _quiz;
  QuizBuilder get quiz => _$this._quiz ??= QuizBuilder();
  set quiz(QuizBuilder? quiz) => _$this._quiz = quiz;

  ExerciceBuilder? _exercice;
  ExerciceBuilder get exercice => _$this._exercice ??= ExerciceBuilder();
  set exercice(ExerciceBuilder? exercice) => _$this._exercice = exercice;

  TypeQuestionBuilder? _type;
  TypeQuestionBuilder get type => _$this._type ??= TypeQuestionBuilder();
  set type(TypeQuestionBuilder? type) => _$this._type = type;

  ListBuilder<ReponsePossible>? _reponsesPossibles;
  ListBuilder<ReponsePossible> get reponsesPossibles =>
      _$this._reponsesPossibles ??= ListBuilder<ReponsePossible>();
  set reponsesPossibles(ListBuilder<ReponsePossible>? reponsesPossibles) =>
      _$this._reponsesPossibles = reponsesPossibles;

  ListBuilder<ReponseEleve>? _reponsesEleves;
  ListBuilder<ReponseEleve> get reponsesEleves =>
      _$this._reponsesEleves ??= ListBuilder<ReponseEleve>();
  set reponsesEleves(ListBuilder<ReponseEleve>? reponsesEleves) =>
      _$this._reponsesEleves = reponsesEleves;

  QuestionBuilder() {
    Question._defaults(this);
  }

  QuestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _enonce = $v.enonce;
      _points = $v.points;
      _dateCreation = $v.dateCreation;
      _dateModification = $v.dateModification;
      _challenge = $v.challenge?.toBuilder();
      _quiz = $v.quiz?.toBuilder();
      _exercice = $v.exercice?.toBuilder();
      _type = $v.type?.toBuilder();
      _reponsesPossibles = $v.reponsesPossibles?.toBuilder();
      _reponsesEleves = $v.reponsesEleves?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Question other) {
    _$v = other as _$Question;
  }

  @override
  void update(void Function(QuestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Question build() => _build();

  _$Question _build() {
    _$Question _$result;
    try {
      _$result =
          _$v ??
          _$Question._(
            id: id,
            enonce: enonce,
            points: points,
            dateCreation: dateCreation,
            dateModification: dateModification,
            challenge: _challenge?.build(),
            quiz: _quiz?.build(),
            exercice: _exercice?.build(),
            type: _type?.build(),
            reponsesPossibles: _reponsesPossibles?.build(),
            reponsesEleves: _reponsesEleves?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'challenge';
        _challenge?.build();
        _$failedField = 'quiz';
        _quiz?.build();
        _$failedField = 'exercice';
        _exercice?.build();
        _$failedField = 'type';
        _type?.build();
        _$failedField = 'reponsesPossibles';
        _reponsesPossibles?.build();
        _$failedField = 'reponsesEleves';
        _reponsesEleves?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Question',
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
