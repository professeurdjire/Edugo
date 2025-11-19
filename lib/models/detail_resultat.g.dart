// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_resultat.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DetailResultat> _$detailResultatSerializer =
    _$DetailResultatSerializer();

class _$DetailResultatSerializer
    implements StructuredSerializer<DetailResultat> {
  @override
  final Iterable<Type> types = const [DetailResultat, _$DetailResultat];
  @override
  final String wireName = 'DetailResultat';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    DetailResultat object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'questionId',
      serializers.serialize(
        object.questionId,
        specifiedType: const FullType(int),
      ),
      'points',
      serializers.serialize(object.points, specifiedType: const FullType(int)),
      'correct',
      serializers.serialize(
        object.correct,
        specifiedType: const FullType(bool),
      ),
    ];

    return result;
  }

  @override
  DetailResultat deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DetailResultatBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'questionId':
          result.questionId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'points':
          result.points =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'correct':
          result.correct =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$DetailResultat extends DetailResultat {
  @override
  final int questionId;
  @override
  final int points;
  @override
  final bool correct;

  factory _$DetailResultat([void Function(DetailResultatBuilder)? updates]) =>
      (DetailResultatBuilder()..update(updates))._build();

  _$DetailResultat._({
    required this.questionId,
    required this.points,
    required this.correct,
  }) : super._();
  @override
  DetailResultat rebuild(void Function(DetailResultatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DetailResultatBuilder toBuilder() => DetailResultatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DetailResultat &&
        questionId == other.questionId &&
        points == other.points &&
        correct == other.correct;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, questionId.hashCode);
    _$hash = $jc(_$hash, points.hashCode);
    _$hash = $jc(_$hash, correct.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DetailResultat')
          ..add('questionId', questionId)
          ..add('points', points)
          ..add('correct', correct))
        .toString();
  }
}

class DetailResultatBuilder
    implements Builder<DetailResultat, DetailResultatBuilder> {
  _$DetailResultat? _$v;

  int? _questionId;
  int? get questionId => _$this._questionId;
  set questionId(int? questionId) => _$this._questionId = questionId;

  int? _points;
  int? get points => _$this._points;
  set points(int? points) => _$this._points = points;

  bool? _correct;
  bool? get correct => _$this._correct;
  set correct(bool? correct) => _$this._correct = correct;

  DetailResultatBuilder();

  DetailResultatBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _questionId = $v.questionId;
      _points = $v.points;
      _correct = $v.correct;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DetailResultat other) {
    _$v = other as _$DetailResultat;
  }

  @override
  void update(void Function(DetailResultatBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DetailResultat build() => _build();

  _$DetailResultat _build() {
    final _$result =
        _$v ??
        _$DetailResultat._(
          questionId: BuiltValueNullFieldError.checkNotNull(
            questionId,
            r'DetailResultat',
            'questionId',
          ),
          points: BuiltValueNullFieldError.checkNotNull(
            points,
            r'DetailResultat',
            'points',
          ),
          correct: BuiltValueNullFieldError.checkNotNull(
            correct,
            r'DetailResultat',
            'correct',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
