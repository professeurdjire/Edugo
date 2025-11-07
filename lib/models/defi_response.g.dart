// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defi_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DefiResponse extends DefiResponse {
  @override
  final int? id;
  @override
  final String? titre;
  @override
  final int? pointDefi;
  @override
  final DateTime? dateAjout;
  @override
  final int? nbreParticipations;
  @override
  final int? classeId;
  @override
  final String? classeNom;
  @override
  final String? typeDefi;

  factory _$DefiResponse([void Function(DefiResponseBuilder)? updates]) =>
      (DefiResponseBuilder()..update(updates))._build();

  _$DefiResponse._({
    this.id,
    this.titre,
    this.pointDefi,
    this.dateAjout,
    this.nbreParticipations,
    this.classeId,
    this.classeNom,
    this.typeDefi,
  }) : super._();
  @override
  DefiResponse rebuild(void Function(DefiResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DefiResponseBuilder toBuilder() => DefiResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DefiResponse &&
        id == other.id &&
        titre == other.titre &&
        pointDefi == other.pointDefi &&
        dateAjout == other.dateAjout &&
        nbreParticipations == other.nbreParticipations &&
        classeId == other.classeId &&
        classeNom == other.classeNom &&
        typeDefi == other.typeDefi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, pointDefi.hashCode);
    _$hash = $jc(_$hash, dateAjout.hashCode);
    _$hash = $jc(_$hash, nbreParticipations.hashCode);
    _$hash = $jc(_$hash, classeId.hashCode);
    _$hash = $jc(_$hash, classeNom.hashCode);
    _$hash = $jc(_$hash, typeDefi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DefiResponse')
          ..add('id', id)
          ..add('titre', titre)
          ..add('pointDefi', pointDefi)
          ..add('dateAjout', dateAjout)
          ..add('nbreParticipations', nbreParticipations)
          ..add('classeId', classeId)
          ..add('classeNom', classeNom)
          ..add('typeDefi', typeDefi))
        .toString();
  }
}

class DefiResponseBuilder
    implements Builder<DefiResponse, DefiResponseBuilder> {
  _$DefiResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  int? _pointDefi;
  int? get pointDefi => _$this._pointDefi;
  set pointDefi(int? pointDefi) => _$this._pointDefi = pointDefi;

  DateTime? _dateAjout;
  DateTime? get dateAjout => _$this._dateAjout;
  set dateAjout(DateTime? dateAjout) => _$this._dateAjout = dateAjout;

  int? _nbreParticipations;
  int? get nbreParticipations => _$this._nbreParticipations;
  set nbreParticipations(int? nbreParticipations) =>
      _$this._nbreParticipations = nbreParticipations;

  int? _classeId;
  int? get classeId => _$this._classeId;
  set classeId(int? classeId) => _$this._classeId = classeId;

  String? _classeNom;
  String? get classeNom => _$this._classeNom;
  set classeNom(String? classeNom) => _$this._classeNom = classeNom;

  String? _typeDefi;
  String? get typeDefi => _$this._typeDefi;
  set typeDefi(String? typeDefi) => _$this._typeDefi = typeDefi;

  DefiResponseBuilder() {
    DefiResponse._defaults(this);
  }

  DefiResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _pointDefi = $v.pointDefi;
      _dateAjout = $v.dateAjout;
      _nbreParticipations = $v.nbreParticipations;
      _classeId = $v.classeId;
      _classeNom = $v.classeNom;
      _typeDefi = $v.typeDefi;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DefiResponse other) {
    _$v = other as _$DefiResponse;
  }

  @override
  void update(void Function(DefiResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DefiResponse build() => _build();

  _$DefiResponse _build() {
    final _$result =
        _$v ??
        _$DefiResponse._(
          id: id,
          titre: titre,
          pointDefi: pointDefi,
          dateAjout: dateAjout,
          nbreParticipations: nbreParticipations,
          classeId: classeId,
          classeNom: classeNom,
          typeDefi: typeDefi,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
