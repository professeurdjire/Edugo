// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const QuizStatutEnum _$quizStatutEnum_ACTIF = const QuizStatutEnum._('ACTIF');
const QuizStatutEnum _$quizStatutEnum_INACTIF = const QuizStatutEnum._(
  'INACTIF',
);
const QuizStatutEnum _$quizStatutEnum_BROUILLON = const QuizStatutEnum._(
  'BROUILLON',
);

QuizStatutEnum _$quizStatutEnumValueOf(String name) {
  switch (name) {
    case 'ACTIF':
      return _$quizStatutEnum_ACTIF;
    case 'INACTIF':
      return _$quizStatutEnum_INACTIF;
    case 'BROUILLON':
      return _$quizStatutEnum_BROUILLON;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<QuizStatutEnum> _$quizStatutEnumValues =
    BuiltSet<QuizStatutEnum>(const <QuizStatutEnum>[
      _$quizStatutEnum_ACTIF,
      _$quizStatutEnum_INACTIF,
      _$quizStatutEnum_BROUILLON,
    ]);

Serializer<QuizStatutEnum> _$quizStatutEnumSerializer =
    _$QuizStatutEnumSerializer();

class _$QuizStatutEnumSerializer
    implements PrimitiveSerializer<QuizStatutEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIF': 'ACTIF',
    'INACTIF': 'INACTIF',
    'BROUILLON': 'BROUILLON',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIF': 'ACTIF',
    'INACTIF': 'INACTIF',
    'BROUILLON': 'BROUILLON',
  };

  @override
  final Iterable<Type> types = const <Type>[QuizStatutEnum];
  @override
  final String wireName = 'QuizStatutEnum';

  @override
  Object serialize(
    Serializers serializers,
    QuizStatutEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  QuizStatutEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => QuizStatutEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Quiz extends Quiz {
  @override
  final int? id;
  @override
  final QuizStatutEnum? statut;
  @override
  final DateTime? createdAt;
  @override
  final Livre? livre;
  @override
  final BuiltList<Question>? questionsQuiz;
  @override
  final int? nombreQuestions;

  factory _$Quiz([void Function(QuizBuilder)? updates]) =>
      (QuizBuilder()..update(updates))._build();

  _$Quiz._({
    this.id,
    this.statut,
    this.createdAt,
    this.livre,
    this.questionsQuiz,
    this.nombreQuestions,
  }) : super._();
  @override
  Quiz rebuild(void Function(QuizBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuizBuilder toBuilder() => QuizBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Quiz &&
        id == other.id &&
        statut == other.statut &&
        createdAt == other.createdAt &&
        livre == other.livre &&
        questionsQuiz == other.questionsQuiz &&
        nombreQuestions == other.nombreQuestions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, statut.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, livre.hashCode);
    _$hash = $jc(_$hash, questionsQuiz.hashCode);
    _$hash = $jc(_$hash, nombreQuestions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Quiz')
          ..add('id', id)
          ..add('statut', statut)
          ..add('createdAt', createdAt)
          ..add('livre', livre)
          ..add('questionsQuiz', questionsQuiz)
          ..add('nombreQuestions', nombreQuestions))
        .toString();
  }
}

class QuizBuilder implements Builder<Quiz, QuizBuilder> {
  _$Quiz? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  QuizStatutEnum? _statut;
  QuizStatutEnum? get statut => _$this._statut;
  set statut(QuizStatutEnum? statut) => _$this._statut = statut;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  LivreBuilder? _livre;
  LivreBuilder get livre => _$this._livre ??= LivreBuilder();
  set livre(LivreBuilder? livre) => _$this._livre = livre;

  ListBuilder<Question>? _questionsQuiz;
  ListBuilder<Question> get questionsQuiz =>
      _$this._questionsQuiz ??= ListBuilder<Question>();
  set questionsQuiz(ListBuilder<Question>? questionsQuiz) =>
      _$this._questionsQuiz = questionsQuiz;

  int? _nombreQuestions;
  int? get nombreQuestions => _$this._nombreQuestions;
  set nombreQuestions(int? nombreQuestions) =>
      _$this._nombreQuestions = nombreQuestions;

  QuizBuilder() {
    Quiz._defaults(this);
  }

  QuizBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _statut = $v.statut;
      _createdAt = $v.createdAt;
      _livre = $v.livre?.toBuilder();
      _questionsQuiz = $v.questionsQuiz?.toBuilder();
      _nombreQuestions = $v.nombreQuestions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Quiz other) {
    _$v = other as _$Quiz;
  }

  @override
  void update(void Function(QuizBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Quiz build() => _build();

  _$Quiz _build() {
    _$Quiz _$result;
    try {
      _$result =
          _$v ??
          _$Quiz._(
            id: id,
            statut: statut,
            createdAt: createdAt,
            livre: _livre?.build(),
            questionsQuiz: _questionsQuiz?.build(),
            nombreQuestions: nombreQuestions,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'livre';
        _livre?.build();
        _$failedField = 'questionsQuiz';
        _questionsQuiz?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Quiz', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
