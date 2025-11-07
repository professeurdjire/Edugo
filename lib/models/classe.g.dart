// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classe.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Classe extends Classe {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final Niveau? niveau;
  @override
  final BuiltList<Eleve>? eleves;
  @override
  final BuiltList<Livre>? livres;
  @override
  final BuiltList<Challenge>? challenges;

  factory _$Classe([void Function(ClasseBuilder)? updates]) =>
      (ClasseBuilder()..update(updates))._build();

  _$Classe._({
    this.id,
    this.nom,
    this.niveau,
    this.eleves,
    this.livres,
    this.challenges,
  }) : super._();
  @override
  Classe rebuild(void Function(ClasseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClasseBuilder toBuilder() => ClasseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Classe &&
        id == other.id &&
        nom == other.nom &&
        niveau == other.niveau &&
        eleves == other.eleves &&
        livres == other.livres &&
        challenges == other.challenges;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, niveau.hashCode);
    _$hash = $jc(_$hash, eleves.hashCode);
    _$hash = $jc(_$hash, livres.hashCode);
    _$hash = $jc(_$hash, challenges.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Classe')
          ..add('id', id)
          ..add('nom', nom)
          ..add('niveau', niveau)
          ..add('eleves', eleves)
          ..add('livres', livres)
          ..add('challenges', challenges))
        .toString();
  }
}

class ClasseBuilder implements Builder<Classe, ClasseBuilder> {
  _$Classe? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  NiveauBuilder? _niveau;
  NiveauBuilder get niveau => _$this._niveau ??= NiveauBuilder();
  set niveau(NiveauBuilder? niveau) => _$this._niveau = niveau;

  ListBuilder<Eleve>? _eleves;
  ListBuilder<Eleve> get eleves => _$this._eleves ??= ListBuilder<Eleve>();
  set eleves(ListBuilder<Eleve>? eleves) => _$this._eleves = eleves;

  ListBuilder<Livre>? _livres;
  ListBuilder<Livre> get livres => _$this._livres ??= ListBuilder<Livre>();
  set livres(ListBuilder<Livre>? livres) => _$this._livres = livres;

  ListBuilder<Challenge>? _challenges;
  ListBuilder<Challenge> get challenges =>
      _$this._challenges ??= ListBuilder<Challenge>();
  set challenges(ListBuilder<Challenge>? challenges) =>
      _$this._challenges = challenges;

  ClasseBuilder() {
    Classe._defaults(this);
  }

  ClasseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _niveau = $v.niveau?.toBuilder();
      _eleves = $v.eleves?.toBuilder();
      _livres = $v.livres?.toBuilder();
      _challenges = $v.challenges?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Classe other) {
    _$v = other as _$Classe;
  }

  @override
  void update(void Function(ClasseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Classe build() => _build();

  _$Classe _build() {
    _$Classe _$result;
    try {
      _$result =
          _$v ??
          _$Classe._(
            id: id,
            nom: nom,
            niveau: _niveau?.build(),
            eleves: _eleves?.build(),
            livres: _livres?.build(),
            challenges: _challenges?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'niveau';
        _niveau?.build();
        _$failedField = 'eleves';
        _eleves?.build();
        _$failedField = 'livres';
        _livres?.build();
        _$failedField = 'challenges';
        _challenges?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Classe',
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
