// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercice_submission_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExerciceSubmissionRequest extends ExerciceSubmissionRequest {
  @override
  final String? reponse;

  factory _$ExerciceSubmissionRequest([
    void Function(ExerciceSubmissionRequestBuilder)? updates,
  ]) => (ExerciceSubmissionRequestBuilder()..update(updates))._build();

  _$ExerciceSubmissionRequest._({this.reponse}) : super._();
  @override
  ExerciceSubmissionRequest rebuild(
    void Function(ExerciceSubmissionRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ExerciceSubmissionRequestBuilder toBuilder() =>
      ExerciceSubmissionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciceSubmissionRequest && reponse == other.reponse;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reponse.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ExerciceSubmissionRequest',
    )..add('reponse', reponse)).toString();
  }
}

class ExerciceSubmissionRequestBuilder
    implements
        Builder<ExerciceSubmissionRequest, ExerciceSubmissionRequestBuilder> {
  _$ExerciceSubmissionRequest? _$v;

  String? _reponse;
  String? get reponse => _$this._reponse;
  set reponse(String? reponse) => _$this._reponse = reponse;

  ExerciceSubmissionRequestBuilder() {
    ExerciceSubmissionRequest._defaults(this);
  }

  ExerciceSubmissionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reponse = $v.reponse;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExerciceSubmissionRequest other) {
    _$v = other as _$ExerciceSubmissionRequest;
  }

  @override
  void update(void Function(ExerciceSubmissionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExerciceSubmissionRequest build() => _build();

  _$ExerciceSubmissionRequest _build() {
    final _$result = _$v ?? _$ExerciceSubmissionRequest._(reponse: reponse);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
