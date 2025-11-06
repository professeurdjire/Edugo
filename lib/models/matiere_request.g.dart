// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matiere_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MatiereRequest extends MatiereRequest {
  @override
  final String nom;

  factory _$MatiereRequest([void Function(MatiereRequestBuilder)? updates]) =>
      (MatiereRequestBuilder()..update(updates))._build();

  _$MatiereRequest._({required this.nom}) : super._();
  @override
  MatiereRequest rebuild(void Function(MatiereRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MatiereRequestBuilder toBuilder() => MatiereRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MatiereRequest && nom == other.nom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MatiereRequest',
    )..add('nom', nom)).toString();
  }
}

class MatiereRequestBuilder
    implements Builder<MatiereRequest, MatiereRequestBuilder> {
  _$MatiereRequest? _$v;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  MatiereRequestBuilder() {
    MatiereRequest._defaults(this);
  }

  MatiereRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nom = $v.nom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MatiereRequest other) {
    _$v = other as _$MatiereRequest;
  }

  @override
  void update(void Function(MatiereRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MatiereRequest build() => _build();

  _$MatiereRequest _build() {
    final _$result =
        _$v ??
        _$MatiereRequest._(
          nom: BuiltValueNullFieldError.checkNotNull(
            nom,
            r'MatiereRequest',
            'nom',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
