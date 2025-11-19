// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SubmitRequest> _$submitRequestSerializer =
    _$SubmitRequestSerializer();

class _$SubmitRequestSerializer implements StructuredSerializer<SubmitRequest> {
  @override
  final Iterable<Type> types = const [SubmitRequest, _$SubmitRequest];
  @override
  final String wireName = 'SubmitRequest';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    SubmitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'eleveId',
      serializers.serialize(object.eleveId, specifiedType: const FullType(int)),
      'reponses',
      serializers.serialize(
        object.reponses,
        specifiedType: const FullType(BuiltList, const [
          const FullType(ReponseEleve),
        ]),
      ),
    ];

    return result;
  }

  @override
  SubmitRequest deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubmitRequestBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'eleveId':
          result.eleveId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'reponses':
          result.reponses.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(ReponseEleve),
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

class _$SubmitRequest extends SubmitRequest {
  @override
  final int eleveId;
  @override
  final BuiltList<ReponseEleve> reponses;

  factory _$SubmitRequest([void Function(SubmitRequestBuilder)? updates]) =>
      (SubmitRequestBuilder()..update(updates))._build();

  _$SubmitRequest._({required this.eleveId, required this.reponses})
    : super._();
  @override
  SubmitRequest rebuild(void Function(SubmitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubmitRequestBuilder toBuilder() => SubmitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubmitRequest &&
        eleveId == other.eleveId &&
        reponses == other.reponses;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, eleveId.hashCode);
    _$hash = $jc(_$hash, reponses.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubmitRequest')
          ..add('eleveId', eleveId)
          ..add('reponses', reponses))
        .toString();
  }
}

class SubmitRequestBuilder
    implements Builder<SubmitRequest, SubmitRequestBuilder> {
  _$SubmitRequest? _$v;

  int? _eleveId;
  int? get eleveId => _$this._eleveId;
  set eleveId(int? eleveId) => _$this._eleveId = eleveId;

  ListBuilder<ReponseEleve>? _reponses;
  ListBuilder<ReponseEleve> get reponses =>
      _$this._reponses ??= ListBuilder<ReponseEleve>();
  set reponses(ListBuilder<ReponseEleve>? reponses) =>
      _$this._reponses = reponses;

  SubmitRequestBuilder();

  SubmitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _eleveId = $v.eleveId;
      _reponses = $v.reponses.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmitRequest other) {
    _$v = other as _$SubmitRequest;
  }

  @override
  void update(void Function(SubmitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubmitRequest build() => _build();

  _$SubmitRequest _build() {
    _$SubmitRequest _$result;
    try {
      _$result =
          _$v ??
          _$SubmitRequest._(
            eleveId: BuiltValueNullFieldError.checkNotNull(
              eleveId,
              r'SubmitRequest',
              'eleveId',
            ),
            reponses: reponses.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reponses';
        reponses.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SubmitRequest',
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
