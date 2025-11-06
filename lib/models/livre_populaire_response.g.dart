// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livre_populaire_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LivrePopulaireResponse extends LivrePopulaireResponse {
  @override
  final int? livreId;
  @override
  final String? titre;
  @override
  final String? auteur;
  @override
  final int? nombreLecteurs;

  factory _$LivrePopulaireResponse([
    void Function(LivrePopulaireResponseBuilder)? updates,
  ]) => (LivrePopulaireResponseBuilder()..update(updates))._build();

  _$LivrePopulaireResponse._({
    this.livreId,
    this.titre,
    this.auteur,
    this.nombreLecteurs,
  }) : super._();
  @override
  LivrePopulaireResponse rebuild(
    void Function(LivrePopulaireResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LivrePopulaireResponseBuilder toBuilder() =>
      LivrePopulaireResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LivrePopulaireResponse &&
        livreId == other.livreId &&
        titre == other.titre &&
        auteur == other.auteur &&
        nombreLecteurs == other.nombreLecteurs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, livreId.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, auteur.hashCode);
    _$hash = $jc(_$hash, nombreLecteurs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LivrePopulaireResponse')
          ..add('livreId', livreId)
          ..add('titre', titre)
          ..add('auteur', auteur)
          ..add('nombreLecteurs', nombreLecteurs))
        .toString();
  }
}

class LivrePopulaireResponseBuilder
    implements Builder<LivrePopulaireResponse, LivrePopulaireResponseBuilder> {
  _$LivrePopulaireResponse? _$v;

  int? _livreId;
  int? get livreId => _$this._livreId;
  set livreId(int? livreId) => _$this._livreId = livreId;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _auteur;
  String? get auteur => _$this._auteur;
  set auteur(String? auteur) => _$this._auteur = auteur;

  int? _nombreLecteurs;
  int? get nombreLecteurs => _$this._nombreLecteurs;
  set nombreLecteurs(int? nombreLecteurs) =>
      _$this._nombreLecteurs = nombreLecteurs;

  LivrePopulaireResponseBuilder() {
    LivrePopulaireResponse._defaults(this);
  }

  LivrePopulaireResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _livreId = $v.livreId;
      _titre = $v.titre;
      _auteur = $v.auteur;
      _nombreLecteurs = $v.nombreLecteurs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LivrePopulaireResponse other) {
    _$v = other as _$LivrePopulaireResponse;
  }

  @override
  void update(void Function(LivrePopulaireResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LivrePopulaireResponse build() => _build();

  _$LivrePopulaireResponse _build() {
    final _$result =
        _$v ??
        _$LivrePopulaireResponse._(
          livreId: livreId,
          titre: titre,
          auteur: auteur,
          nombreLecteurs: nombreLecteurs,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
