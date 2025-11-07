// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matiere.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Matiere extends Matiere {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final BuiltList<Exercice>? exercice;

  factory _$Matiere([void Function(MatiereBuilder)? updates]) =>
      (MatiereBuilder()..update(updates))._build();

  _$Matiere._({this.id, this.nom, this.exercice}) : super._();
  @override
  Matiere rebuild(void Function(MatiereBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MatiereBuilder toBuilder() => MatiereBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Matiere &&
        id == other.id &&
        nom == other.nom &&
        exercice == other.exercice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, exercice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Matiere')
          ..add('id', id)
          ..add('nom', nom)
          ..add('exercice', exercice))
        .toString();
  }
}

class MatiereBuilder implements Builder<Matiere, MatiereBuilder> {
  _$Matiere? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  ListBuilder<Exercice>? _exercice;
  ListBuilder<Exercice> get exercice =>
      _$this._exercice ??= ListBuilder<Exercice>();
  set exercice(ListBuilder<Exercice>? exercice) => _$this._exercice = exercice;

  MatiereBuilder() {
    Matiere._defaults(this);
  }

  MatiereBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _exercice = $v.exercice?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Matiere other) {
    _$v = other as _$Matiere;
  }

  @override
  void update(void Function(MatiereBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Matiere build() => _build();

  _$Matiere _build() {
    _$Matiere _$result;
    try {
      _$result =
          _$v ?? _$Matiere._(id: id, nom: nom, exercice: _exercice?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'exercice';
        _exercice?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Matiere',
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
