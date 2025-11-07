// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_update_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressionUpdateRequest extends ProgressionUpdateRequest {
  @override
  final int? pageActuelle;

  factory _$ProgressionUpdateRequest([
    void Function(ProgressionUpdateRequestBuilder)? updates,
  ]) => (ProgressionUpdateRequestBuilder()..update(updates))._build();

  _$ProgressionUpdateRequest._({this.pageActuelle}) : super._();
  @override
  ProgressionUpdateRequest rebuild(
    void Function(ProgressionUpdateRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ProgressionUpdateRequestBuilder toBuilder() =>
      ProgressionUpdateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressionUpdateRequest &&
        pageActuelle == other.pageActuelle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pageActuelle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'ProgressionUpdateRequest',
    )..add('pageActuelle', pageActuelle)).toString();
  }
}

class ProgressionUpdateRequestBuilder
    implements
        Builder<ProgressionUpdateRequest, ProgressionUpdateRequestBuilder> {
  _$ProgressionUpdateRequest? _$v;

  int? _pageActuelle;
  int? get pageActuelle => _$this._pageActuelle;
  set pageActuelle(int? pageActuelle) => _$this._pageActuelle = pageActuelle;

  ProgressionUpdateRequestBuilder() {
    ProgressionUpdateRequest._defaults(this);
  }

  ProgressionUpdateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pageActuelle = $v.pageActuelle;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressionUpdateRequest other) {
    _$v = other as _$ProgressionUpdateRequest;
  }

  @override
  void update(void Function(ProgressionUpdateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressionUpdateRequest build() => _build();

  _$ProgressionUpdateRequest _build() {
    final _$result =
        _$v ?? _$ProgressionUpdateRequest._(pageActuelle: pageActuelle);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
