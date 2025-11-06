// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correction_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CorrectionRequest extends CorrectionRequest {
  @override
  final int? note;
  @override
  final String? commentaire;

  factory _$CorrectionRequest([
    void Function(CorrectionRequestBuilder)? updates,
  ]) => (CorrectionRequestBuilder()..update(updates))._build();

  _$CorrectionRequest._({this.note, this.commentaire}) : super._();
  @override
  CorrectionRequest rebuild(void Function(CorrectionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CorrectionRequestBuilder toBuilder() =>
      CorrectionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CorrectionRequest &&
        note == other.note &&
        commentaire == other.commentaire;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, commentaire.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CorrectionRequest')
          ..add('note', note)
          ..add('commentaire', commentaire))
        .toString();
  }
}

class CorrectionRequestBuilder
    implements Builder<CorrectionRequest, CorrectionRequestBuilder> {
  _$CorrectionRequest? _$v;

  int? _note;
  int? get note => _$this._note;
  set note(int? note) => _$this._note = note;

  String? _commentaire;
  String? get commentaire => _$this._commentaire;
  set commentaire(String? commentaire) => _$this._commentaire = commentaire;

  CorrectionRequestBuilder() {
    CorrectionRequest._defaults(this);
  }

  CorrectionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _commentaire = $v.commentaire;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CorrectionRequest other) {
    _$v = other as _$CorrectionRequest;
  }

  @override
  void update(void Function(CorrectionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CorrectionRequest build() => _build();

  _$CorrectionRequest _build() {
    final _$result =
        _$v ?? _$CorrectionRequest._(note: note, commentaire: commentaire);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
