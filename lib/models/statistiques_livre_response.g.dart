// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistiques_livre_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatistiquesLivreResponse extends StatistiquesLivreResponse {
  @override
  final int? livreId;
  @override
  final String? titre;
  @override
  final String? auteur;
  @override
  final int? totalPages;
  @override
  final int? nombreLecteurs;
  @override
  final int? nombreLecteursComplets;
  @override
  final double? progressionMoyenne;

  factory _$StatistiquesLivreResponse([
    void Function(StatistiquesLivreResponseBuilder)? updates,
  ]) => (StatistiquesLivreResponseBuilder()..update(updates))._build();

  _$StatistiquesLivreResponse._({
    this.livreId,
    this.titre,
    this.auteur,
    this.totalPages,
    this.nombreLecteurs,
    this.nombreLecteursComplets,
    this.progressionMoyenne,
  }) : super._();
  @override
  StatistiquesLivreResponse rebuild(
    void Function(StatistiquesLivreResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  StatistiquesLivreResponseBuilder toBuilder() =>
      StatistiquesLivreResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatistiquesLivreResponse &&
        livreId == other.livreId &&
        titre == other.titre &&
        auteur == other.auteur &&
        totalPages == other.totalPages &&
        nombreLecteurs == other.nombreLecteurs &&
        nombreLecteursComplets == other.nombreLecteursComplets &&
        progressionMoyenne == other.progressionMoyenne;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, livreId.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, auteur.hashCode);
    _$hash = $jc(_$hash, totalPages.hashCode);
    _$hash = $jc(_$hash, nombreLecteurs.hashCode);
    _$hash = $jc(_$hash, nombreLecteursComplets.hashCode);
    _$hash = $jc(_$hash, progressionMoyenne.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatistiquesLivreResponse')
          ..add('livreId', livreId)
          ..add('titre', titre)
          ..add('auteur', auteur)
          ..add('totalPages', totalPages)
          ..add('nombreLecteurs', nombreLecteurs)
          ..add('nombreLecteursComplets', nombreLecteursComplets)
          ..add('progressionMoyenne', progressionMoyenne))
        .toString();
  }
}

class StatistiquesLivreResponseBuilder
    implements
        Builder<StatistiquesLivreResponse, StatistiquesLivreResponseBuilder> {
  _$StatistiquesLivreResponse? _$v;

  int? _livreId;
  int? get livreId => _$this._livreId;
  set livreId(int? livreId) => _$this._livreId = livreId;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _auteur;
  String? get auteur => _$this._auteur;
  set auteur(String? auteur) => _$this._auteur = auteur;

  int? _totalPages;
  int? get totalPages => _$this._totalPages;
  set totalPages(int? totalPages) => _$this._totalPages = totalPages;

  int? _nombreLecteurs;
  int? get nombreLecteurs => _$this._nombreLecteurs;
  set nombreLecteurs(int? nombreLecteurs) =>
      _$this._nombreLecteurs = nombreLecteurs;

  int? _nombreLecteursComplets;
  int? get nombreLecteursComplets => _$this._nombreLecteursComplets;
  set nombreLecteursComplets(int? nombreLecteursComplets) =>
      _$this._nombreLecteursComplets = nombreLecteursComplets;

  double? _progressionMoyenne;
  double? get progressionMoyenne => _$this._progressionMoyenne;
  set progressionMoyenne(double? progressionMoyenne) =>
      _$this._progressionMoyenne = progressionMoyenne;

  StatistiquesLivreResponseBuilder() {
    StatistiquesLivreResponse._defaults(this);
  }

  StatistiquesLivreResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _livreId = $v.livreId;
      _titre = $v.titre;
      _auteur = $v.auteur;
      _totalPages = $v.totalPages;
      _nombreLecteurs = $v.nombreLecteurs;
      _nombreLecteursComplets = $v.nombreLecteursComplets;
      _progressionMoyenne = $v.progressionMoyenne;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatistiquesLivreResponse other) {
    _$v = other as _$StatistiquesLivreResponse;
  }

  @override
  void update(void Function(StatistiquesLivreResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatistiquesLivreResponse build() => _build();

  _$StatistiquesLivreResponse _build() {
    final _$result =
        _$v ??
        _$StatistiquesLivreResponse._(
          livreId: livreId,
          titre: titre,
          auteur: auteur,
          totalPages: totalPages,
          nombreLecteurs: nombreLecteurs,
          nombreLecteursComplets: nombreLecteursComplets,
          progressionMoyenne: progressionMoyenne,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
