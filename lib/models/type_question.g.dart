// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_question.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TypeQuestion extends TypeQuestion {
  @override
  final int? id;
  @override
  final String? libelleType;
  @override
  final BuiltList<Question>? questions;

  factory _$TypeQuestion([void Function(TypeQuestionBuilder)? updates]) =>
      (TypeQuestionBuilder()..update(updates))._build();

  _$TypeQuestion._({this.id, this.libelleType, this.questions}) : super._();
  @override
  TypeQuestion rebuild(void Function(TypeQuestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TypeQuestionBuilder toBuilder() => TypeQuestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TypeQuestion &&
        id == other.id &&
        libelleType == other.libelleType &&
        questions == other.questions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, libelleType.hashCode);
    _$hash = $jc(_$hash, questions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TypeQuestion')
          ..add('id', id)
          ..add('libelleType', libelleType)
          ..add('questions', questions))
        .toString();
  }
}

class TypeQuestionBuilder
    implements Builder<TypeQuestion, TypeQuestionBuilder> {
  _$TypeQuestion? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _libelleType;
  String? get libelleType => _$this._libelleType;
  set libelleType(String? libelleType) => _$this._libelleType = libelleType;

  ListBuilder<Question>? _questions;
  ListBuilder<Question> get questions =>
      _$this._questions ??= ListBuilder<Question>();
  set questions(ListBuilder<Question>? questions) =>
      _$this._questions = questions;

  TypeQuestionBuilder() {
    TypeQuestion._defaults(this);
  }

  TypeQuestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _libelleType = $v.libelleType;
      _questions = $v.questions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TypeQuestion other) {
    _$v = other as _$TypeQuestion;
  }

  @override
  void update(void Function(TypeQuestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TypeQuestion build() => _build();

  _$TypeQuestion _build() {
    _$TypeQuestion _$result;
    try {
      _$result =
          _$v ??
          _$TypeQuestion._(
            id: id,
            libelleType: libelleType,
            questions: _questions?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'questions';
        _questions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TypeQuestion',
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
