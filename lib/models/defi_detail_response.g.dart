// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defi_detail_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DefiDetailResponse extends DefiDetailResponse {
  @override
  final int? id;
  @override
  final String? titre;
  @override
  final String? ennonce;
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
  @override
  final String? reponseDefi;
  @override
  final BuiltList<EleveLiteResponse>? participants;

  factory _$DefiDetailResponse([
    void Function(DefiDetailResponseBuilder)? updates,
  ]) => (DefiDetailResponseBuilder()..update(updates))._build();

  _$DefiDetailResponse._({
    this.id,
    this.titre,
    this.ennonce,
    this.pointDefi,
    this.dateAjout,
    this.nbreParticipations,
    this.classeId,
    this.classeNom,
    this.typeDefi,
    this.reponseDefi,
    this.participants,
  }) : super._();
  @override
  DefiDetailResponse rebuild(
    void Function(DefiDetailResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  DefiDetailResponseBuilder toBuilder() =>
      DefiDetailResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DefiDetailResponse &&
        id == other.id &&
        titre == other.titre &&
        ennonce == other.ennonce &&
        pointDefi == other.pointDefi &&
        dateAjout == other.dateAjout &&
        nbreParticipations == other.nbreParticipations &&
        classeId == other.classeId &&
        classeNom == other.classeNom &&
        typeDefi == other.typeDefi &&
        reponseDefi == other.reponseDefi &&
        participants == other.participants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, ennonce.hashCode);
    _$hash = $jc(_$hash, pointDefi.hashCode);
    _$hash = $jc(_$hash, dateAjout.hashCode);
    _$hash = $jc(_$hash, nbreParticipations.hashCode);
    _$hash = $jc(_$hash, classeId.hashCode);
    _$hash = $jc(_$hash, classeNom.hashCode);
    _$hash = $jc(_$hash, typeDefi.hashCode);
    _$hash = $jc(_$hash, reponseDefi.hashCode);
    _$hash = $jc(_$hash, participants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DefiDetailResponse')
          ..add('id', id)
          ..add('titre', titre)
          ..add('ennonce', ennonce)
          ..add('pointDefi', pointDefi)
          ..add('dateAjout', dateAjout)
          ..add('nbreParticipations', nbreParticipations)
          ..add('classeId', classeId)
          ..add('classeNom', classeNom)
          ..add('typeDefi', typeDefi)
          ..add('reponseDefi', reponseDefi)
          ..add('participants', participants))
        .toString();
  }
}

class DefiDetailResponseBuilder
    implements Builder<DefiDetailResponse, DefiDetailResponseBuilder> {
  _$DefiDetailResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _ennonce;
  String? get ennonce => _$this._ennonce;
  set ennonce(String? ennonce) => _$this._ennonce = ennonce;

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

  String? _reponseDefi;
  String? get reponseDefi => _$this._reponseDefi;
  set reponseDefi(String? reponseDefi) => _$this._reponseDefi = reponseDefi;

  ListBuilder<EleveLiteResponse>? _participants;
  ListBuilder<EleveLiteResponse> get participants =>
      _$this._participants ??= ListBuilder<EleveLiteResponse>();
  set participants(ListBuilder<EleveLiteResponse>? participants) =>
      _$this._participants = participants;

  DefiDetailResponseBuilder() {
    DefiDetailResponse._defaults(this);
  }

  DefiDetailResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _ennonce = $v.ennonce;
      _pointDefi = $v.pointDefi;
      _dateAjout = $v.dateAjout;
      _nbreParticipations = $v.nbreParticipations;
      _classeId = $v.classeId;
      _classeNom = $v.classeNom;
      _typeDefi = $v.typeDefi;
      _reponseDefi = $v.reponseDefi;
      _participants = $v.participants?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DefiDetailResponse other) {
    _$v = other as _$DefiDetailResponse;
  }

  @override
  void update(void Function(DefiDetailResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DefiDetailResponse build() => _build();

  _$DefiDetailResponse _build() {
    _$DefiDetailResponse _$result;
    try {
      _$result =
          _$v ??
          _$DefiDetailResponse._(
            id: id,
            titre: titre,
            ennonce: ennonce,
            pointDefi: pointDefi,
            dateAjout: dateAjout,
            nbreParticipations: nbreParticipations,
            classeId: classeId,
            classeNom: classeNom,
            typeDefi: typeDefi,
            reponseDefi: reponseDefi,
            participants: _participants?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'participants';
        _participants?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'DefiDetailResponse',
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
