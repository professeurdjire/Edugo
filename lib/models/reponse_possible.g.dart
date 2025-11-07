// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reponse_possible.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReponsePossible extends ReponsePossible {
  @override
  final int? id;
  @override
  final String? libelleReponse;
  @override
  final bool? estCorrecte;
  @override
  final Question? question;

  factory _$ReponsePossible([void Function(ReponsePossibleBuilder)? updates]) =>
      (ReponsePossibleBuilder()..update(updates))._build();

  _$ReponsePossible._({
    this.id,
    this.libelleReponse,
    this.estCorrecte,
    this.question,
  }) : super._();
  @override
  ReponsePossible rebuild(void Function(ReponsePossibleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReponsePossibleBuilder toBuilder() => ReponsePossibleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReponsePossible &&
        id == other.id &&
        libelleReponse == other.libelleReponse &&
        estCorrecte == other.estCorrecte &&
        question == other.question;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, libelleReponse.hashCode);
    _$hash = $jc(_$hash, estCorrecte.hashCode);
    _$hash = $jc(_$hash, question.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReponsePossible')
          ..add('id', id)
          ..add('libelleReponse', libelleReponse)
          ..add('estCorrecte', estCorrecte)
          ..add('question', question))
        .toString();
  }
}

class ReponsePossibleBuilder
    implements Builder<ReponsePossible, ReponsePossibleBuilder> {
  _$ReponsePossible? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _libelleReponse;
  String? get libelleReponse => _$this._libelleReponse;
  set libelleReponse(String? libelleReponse) =>
      _$this._libelleReponse = libelleReponse;

  bool? _estCorrecte;
  bool? get estCorrecte => _$this._estCorrecte;
  set estCorrecte(bool? estCorrecte) => _$this._estCorrecte = estCorrecte;

  QuestionBuilder? _question;
  QuestionBuilder get question => _$this._question ??= QuestionBuilder();
  set question(QuestionBuilder? question) => _$this._question = question;

  ReponsePossibleBuilder() {
    ReponsePossible._defaults(this);
  }

  ReponsePossibleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _libelleReponse = $v.libelleReponse;
      _estCorrecte = $v.estCorrecte;
      _question = $v.question?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReponsePossible other) {
    _$v = other as _$ReponsePossible;
  }

  @override
  void update(void Function(ReponsePossibleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReponsePossible build() => _build();

  _$ReponsePossible _build() {
    _$ReponsePossible _$result;
    try {
      _$result =
          _$v ??
          _$ReponsePossible._(
            id: id,
            libelleReponse: libelleReponse,
            estCorrecte: estCorrecte,
            question: _question?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'question';
        _question?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ReponsePossible',
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
