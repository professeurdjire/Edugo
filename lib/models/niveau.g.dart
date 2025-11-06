// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'niveau.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Niveau extends Niveau {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final BuiltList<Classe>? classes;
  @override
  final BuiltList<Livre>? livres;
  @override
  final BuiltList<Challenge>? challenges;

  factory _$Niveau([void Function(NiveauBuilder)? updates]) =>
      (NiveauBuilder()..update(updates))._build();

  _$Niveau._({this.id, this.nom, this.classes, this.livres, this.challenges})
    : super._();
  @override
  Niveau rebuild(void Function(NiveauBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NiveauBuilder toBuilder() => NiveauBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Niveau &&
        id == other.id &&
        nom == other.nom &&
        classes == other.classes &&
        livres == other.livres &&
        challenges == other.challenges;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, classes.hashCode);
    _$hash = $jc(_$hash, livres.hashCode);
    _$hash = $jc(_$hash, challenges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Niveau')
          ..add('id', id)
          ..add('nom', nom)
          ..add('classes', classes)
          ..add('livres', livres)
          ..add('challenges', challenges))
        .toString();
  }
}

class NiveauBuilder implements Builder<Niveau, NiveauBuilder> {
  _$Niveau? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  ListBuilder<Classe>? _classes;
  ListBuilder<Classe> get classes => _$this._classes ??= ListBuilder<Classe>();
  set classes(ListBuilder<Classe>? classes) => _$this._classes = classes;

  ListBuilder<Livre>? _livres;
  ListBuilder<Livre> get livres => _$this._livres ??= ListBuilder<Livre>();
  set livres(ListBuilder<Livre>? livres) => _$this._livres = livres;

  ListBuilder<Challenge>? _challenges;
  ListBuilder<Challenge> get challenges =>
      _$this._challenges ??= ListBuilder<Challenge>();
  set challenges(ListBuilder<Challenge>? challenges) =>
      _$this._challenges = challenges;

  NiveauBuilder() {
    Niveau._defaults(this);
  }

  NiveauBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _classes = $v.classes?.toBuilder();
      _livres = $v.livres?.toBuilder();
      _challenges = $v.challenges?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Niveau other) {
    _$v = other as _$Niveau;
  }

  @override
  void update(void Function(NiveauBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Niveau build() => _build();

  _$Niveau _build() {
    _$Niveau _$result;
    try {
      _$result =
          _$v ??
          _$Niveau._(
            id: id,
            nom: nom,
            classes: _classes?.build(),
            livres: _livres?.build(),
            challenges: _challenges?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'classes';
        _classes?.build();
        _$failedField = 'livres';
        _livres?.build();
        _$failedField = 'challenges';
        _challenges?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Niveau',
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
