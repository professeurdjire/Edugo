// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defi_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DefiRequest extends DefiRequest {
  @override
  final String? titre;
  @override
  final String? ennonce;
  @override
  final int? pointDefi;
  @override
  final int? classeId;
  @override
  final String? typeDefi;
  @override
  final String? reponseDefi;

  factory _$DefiRequest([void Function(DefiRequestBuilder)? updates]) =>
      (DefiRequestBuilder()..update(updates))._build();

  _$DefiRequest._({
    this.titre,
    this.ennonce,
    this.pointDefi,
    this.classeId,
    this.typeDefi,
    this.reponseDefi,
  }) : super._();
  @override
  DefiRequest rebuild(void Function(DefiRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DefiRequestBuilder toBuilder() => DefiRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DefiRequest &&
        titre == other.titre &&
        ennonce == other.ennonce &&
        pointDefi == other.pointDefi &&
        classeId == other.classeId &&
        typeDefi == other.typeDefi &&
        reponseDefi == other.reponseDefi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, ennonce.hashCode);
    _$hash = $jc(_$hash, pointDefi.hashCode);
    _$hash = $jc(_$hash, classeId.hashCode);
    _$hash = $jc(_$hash, typeDefi.hashCode);
    _$hash = $jc(_$hash, reponseDefi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DefiRequest')
          ..add('titre', titre)
          ..add('ennonce', ennonce)
          ..add('pointDefi', pointDefi)
          ..add('classeId', classeId)
          ..add('typeDefi', typeDefi)
          ..add('reponseDefi', reponseDefi))
        .toString();
  }
}

class DefiRequestBuilder implements Builder<DefiRequest, DefiRequestBuilder> {
  _$DefiRequest? _$v;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _ennonce;
  String? get ennonce => _$this._ennonce;
  set ennonce(String? ennonce) => _$this._ennonce = ennonce;

  int? _pointDefi;
  int? get pointDefi => _$this._pointDefi;
  set pointDefi(int? pointDefi) => _$this._pointDefi = pointDefi;

  int? _classeId;
  int? get classeId => _$this._classeId;
  set classeId(int? classeId) => _$this._classeId = classeId;

  String? _typeDefi;
  String? get typeDefi => _$this._typeDefi;
  set typeDefi(String? typeDefi) => _$this._typeDefi = typeDefi;

  String? _reponseDefi;
  String? get reponseDefi => _$this._reponseDefi;
  set reponseDefi(String? reponseDefi) => _$this._reponseDefi = reponseDefi;

  DefiRequestBuilder() {
    DefiRequest._defaults(this);
  }

  DefiRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _titre = $v.titre;
      _ennonce = $v.ennonce;
      _pointDefi = $v.pointDefi;
      _classeId = $v.classeId;
      _typeDefi = $v.typeDefi;
      _reponseDefi = $v.reponseDefi;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DefiRequest other) {
    _$v = other as _$DefiRequest;
  }

  @override
  void update(void Function(DefiRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DefiRequest build() => _build();

  _$DefiRequest _build() {
    final _$result =
        _$v ??
        _$DefiRequest._(
          titre: titre,
          ennonce: ennonce,
          pointDefi: pointDefi,
          classeId: classeId,
          typeDefi: typeDefi,
          reponseDefi: reponseDefi,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
