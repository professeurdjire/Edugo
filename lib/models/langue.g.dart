// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'langue.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Langue extends Langue {
  @override
  final int? id;
  @override
  final String? codeIso;
  @override
  final BuiltList<Livre>? livres;
  @override
  final String? nom;

  factory _$Langue([void Function(LangueBuilder)? updates]) =>
      (LangueBuilder()..update(updates))._build();

  _$Langue._({this.id, this.codeIso, this.livres, this.nom}) : super._();
  @override
  Langue rebuild(void Function(LangueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LangueBuilder toBuilder() => LangueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Langue &&
        id == other.id &&
        codeIso == other.codeIso &&
        livres == other.livres &&
        nom == other.nom;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, codeIso.hashCode);
    _$hash = $jc(_$hash, livres.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Langue')
          ..add('id', id)
          ..add('codeIso', codeIso)
          ..add('livres', livres)
          ..add('nom', nom))
        .toString();
  }
}

class LangueBuilder implements Builder<Langue, LangueBuilder> {
  _$Langue? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _codeIso;
  String? get codeIso => _$this._codeIso;
  set codeIso(String? codeIso) => _$this._codeIso = codeIso;

  ListBuilder<Livre>? _livres;
  ListBuilder<Livre> get livres => _$this._livres ??= ListBuilder<Livre>();
  set livres(ListBuilder<Livre>? livres) => _$this._livres = livres;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  LangueBuilder() {
    Langue._defaults(this);
  }

  LangueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _codeIso = $v.codeIso;
      _livres = $v.livres?.toBuilder();
      _nom = $v.nom;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Langue other) {
    _$v = other as _$Langue;
  }

  @override
  void update(void Function(LangueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Langue build() => _build();

  _$Langue _build() {
    _$Langue _$result;
    try {
      _$result =
          _$v ??
          _$Langue._(
            id: id,
            codeIso: codeIso,
            livres: _livres?.build(),
            nom: nom,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'livres';
        _livres?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Langue',
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
