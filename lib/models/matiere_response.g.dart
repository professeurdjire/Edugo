// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matiere_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MatiereResponse extends MatiereResponse {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final DateTime? dateCreation;
  @override
  final DateTime? dateModification;

  factory _$MatiereResponse([void Function(MatiereResponseBuilder)? updates]) =>
      (MatiereResponseBuilder()..update(updates))._build();

  _$MatiereResponse._({
    this.id,
    this.nom,
    this.dateCreation,
    this.dateModification,
  }) : super._();
  @override
  MatiereResponse rebuild(void Function(MatiereResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MatiereResponseBuilder toBuilder() => MatiereResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MatiereResponse &&
        id == other.id &&
        nom == other.nom &&
        dateCreation == other.dateCreation &&
        dateModification == other.dateModification;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, dateCreation.hashCode);
    _$hash = $jc(_$hash, dateModification.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MatiereResponse')
          ..add('id', id)
          ..add('nom', nom)
          ..add('dateCreation', dateCreation)
          ..add('dateModification', dateModification))
        .toString();
  }
}

class MatiereResponseBuilder
    implements Builder<MatiereResponse, MatiereResponseBuilder> {
  _$MatiereResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  DateTime? _dateCreation;
  DateTime? get dateCreation => _$this._dateCreation;
  set dateCreation(DateTime? dateCreation) =>
      _$this._dateCreation = dateCreation;

  DateTime? _dateModification;
  DateTime? get dateModification => _$this._dateModification;
  set dateModification(DateTime? dateModification) =>
      _$this._dateModification = dateModification;

  MatiereResponseBuilder() {
    MatiereResponse._defaults(this);
  }

  MatiereResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _dateCreation = $v.dateCreation;
      _dateModification = $v.dateModification;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MatiereResponse other) {
    _$v = other as _$MatiereResponse;
  }

  @override
  void update(void Function(MatiereResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MatiereResponse build() => _build();

  _$MatiereResponse _build() {
    final _$result =
        _$v ??
        _$MatiereResponse._(
          id: id,
          nom: nom,
          dateCreation: dateCreation,
          dateModification: dateModification,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
