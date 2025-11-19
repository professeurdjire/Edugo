// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_result_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SubmitResultResponse> _$submitResultResponseSerializer =
    _$SubmitResultResponseSerializer();
Serializer<DetailResultat> _$detailResultatSerializer =
    _$DetailResultatSerializer();

class _$SubmitResultResponseSerializer
    implements StructuredSerializer<SubmitResultResponse> {
  @override
  final Iterable<Type> types = const [
    SubmitResultResponse,
    _$SubmitResultResponse,
  ];
  @override
  final String wireName = 'SubmitResultResponse';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    SubmitResultResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'ownerId',
      serializers.serialize(object.ownerId, specifiedType: const FullType(int)),
      'ownerType',
      serializers.serialize(
        object.ownerType,
        specifiedType: const FullType(String),
      ),
      'eleveId',
      serializers.serialize(object.eleveId, specifiedType: const FullType(int)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
      'totalPoints',
      serializers.serialize(
        object.totalPoints,
        specifiedType: const FullType(int),
      ),
      'details',
      serializers.serialize(
        object.details,
        specifiedType: const FullType(BuiltList, const [
          const FullType(DetailResultat),
        ]),
      ),
    ];

    return result;
  }

  @override
  SubmitResultResponse deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubmitResultResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ownerId':
          result.ownerId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'ownerType':
          result.ownerType =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'eleveId':
          result.eleveId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'score':
          result.score =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'totalPoints':
          result.totalPoints =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'details':
          result.details.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(DetailResultat),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

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

class _$SubmitResultResponse extends SubmitResultResponse {
  @override
  final int ownerId;
  @override
  final String ownerType;
  @override
  final int eleveId;
  @override
  final int score;
  @override
  final int totalPoints;
  @override
  final BuiltList<DetailResultat> details;

  factory _$SubmitResultResponse([
    void Function(SubmitResultResponseBuilder)? updates,
  ]) => (SubmitResultResponseBuilder()..update(updates))._build();

  _$SubmitResultResponse._({
    required this.ownerId,
    required this.ownerType,
    required this.eleveId,
    required this.score,
    required this.totalPoints,
    required this.details,
  }) : super._();
  @override
  SubmitResultResponse rebuild(
    void Function(SubmitResultResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SubmitResultResponseBuilder toBuilder() =>
      SubmitResultResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubmitResultResponse &&
        ownerId == other.ownerId &&
        ownerType == other.ownerType &&
        eleveId == other.eleveId &&
        score == other.score &&
        totalPoints == other.totalPoints &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ownerId.hashCode);
    _$hash = $jc(_$hash, ownerType.hashCode);
    _$hash = $jc(_$hash, eleveId.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, totalPoints.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubmitResultResponse')
          ..add('ownerId', ownerId)
          ..add('ownerType', ownerType)
          ..add('eleveId', eleveId)
          ..add('score', score)
          ..add('totalPoints', totalPoints)
          ..add('details', details))
        .toString();
  }
}

class SubmitResultResponseBuilder
    implements Builder<SubmitResultResponse, SubmitResultResponseBuilder> {
  _$SubmitResultResponse? _$v;

  int? _ownerId;
  int? get ownerId => _$this._ownerId;
  set ownerId(int? ownerId) => _$this._ownerId = ownerId;

  String? _ownerType;
  String? get ownerType => _$this._ownerType;
  set ownerType(String? ownerType) => _$this._ownerType = ownerType;

  int? _eleveId;
  int? get eleveId => _$this._eleveId;
  set eleveId(int? eleveId) => _$this._eleveId = eleveId;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  int? _totalPoints;
  int? get totalPoints => _$this._totalPoints;
  set totalPoints(int? totalPoints) => _$this._totalPoints = totalPoints;

  ListBuilder<DetailResultat>? _details;
  ListBuilder<DetailResultat> get details =>
      _$this._details ??= ListBuilder<DetailResultat>();
  set details(ListBuilder<DetailResultat>? details) =>
      _$this._details = details;

  SubmitResultResponseBuilder();

  SubmitResultResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ownerId = $v.ownerId;
      _ownerType = $v.ownerType;
      _eleveId = $v.eleveId;
      _score = $v.score;
      _totalPoints = $v.totalPoints;
      _details = $v.details.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmitResultResponse other) {
    _$v = other as _$SubmitResultResponse;
  }

  @override
  void update(void Function(SubmitResultResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubmitResultResponse build() => _build();

  _$SubmitResultResponse _build() {
    _$SubmitResultResponse _$result;
    try {
      _$result =
          _$v ??
          _$SubmitResultResponse._(
            ownerId: BuiltValueNullFieldError.checkNotNull(
              ownerId,
              r'SubmitResultResponse',
              'ownerId',
            ),
            ownerType: BuiltValueNullFieldError.checkNotNull(
              ownerType,
              r'SubmitResultResponse',
              'ownerType',
            ),
            eleveId: BuiltValueNullFieldError.checkNotNull(
              eleveId,
              r'SubmitResultResponse',
              'eleveId',
            ),
            score: BuiltValueNullFieldError.checkNotNull(
              score,
              r'SubmitResultResponse',
              'score',
            ),
            totalPoints: BuiltValueNullFieldError.checkNotNull(
              totalPoints,
              r'SubmitResultResponse',
              'totalPoints',
            ),
            details: details.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        details.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SubmitResultResponse',
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
