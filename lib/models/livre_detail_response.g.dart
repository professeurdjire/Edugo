// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livre_detail_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LivreDetailResponse extends LivreDetailResponse {
  @override
  final int? id;
  @override
  final String? titre;
  @override
  final String? isbn;
  @override
  final String? auteur;
  @override
  final String? imageCouverture;
  @override
  final int? totalPages;
  @override
  final bool? lectureAuto;
  @override
  final bool? interactif;
  @override
  final int? anneePublication;
  @override
  final String? editeur;
  @override
  final int? niveauId;
  @override
  final String? niveauNom;
  @override
  final int? classeId;
  @override
  final String? classeNom;
  @override
  final int? matiereId;
  @override
  final String? matiereNom;
  @override
  final int? langueId;
  @override
  final String? langueNom;
  @override
  final double? progression;
  @override
  final JsonObject? statistiques;

  factory _$LivreDetailResponse([
    void Function(LivreDetailResponseBuilder)? updates,
  ]) => (LivreDetailResponseBuilder()..update(updates))._build();

  _$LivreDetailResponse._({
    this.id,
    this.titre,
    this.isbn,
    this.auteur,
    this.imageCouverture,
    this.totalPages,
    this.lectureAuto,
    this.interactif,
    this.anneePublication,
    this.editeur,
    this.niveauId,
    this.niveauNom,
    this.classeId,
    this.classeNom,
    this.matiereId,
    this.matiereNom,
    this.langueId,
    this.langueNom,
    this.progression,
    this.statistiques,
  }) : super._();
  @override
  LivreDetailResponse rebuild(
    void Function(LivreDetailResponseBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LivreDetailResponseBuilder toBuilder() =>
      LivreDetailResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LivreDetailResponse &&
        id == other.id &&
        titre == other.titre &&
        isbn == other.isbn &&
        auteur == other.auteur &&
        imageCouverture == other.imageCouverture &&
        totalPages == other.totalPages &&
        lectureAuto == other.lectureAuto &&
        interactif == other.interactif &&
        anneePublication == other.anneePublication &&
        editeur == other.editeur &&
        niveauId == other.niveauId &&
        niveauNom == other.niveauNom &&
        classeId == other.classeId &&
        classeNom == other.classeNom &&
        matiereId == other.matiereId &&
        matiereNom == other.matiereNom &&
        langueId == other.langueId &&
        langueNom == other.langueNom &&
        progression == other.progression &&
        statistiques == other.statistiques;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, isbn.hashCode);
    _$hash = $jc(_$hash, auteur.hashCode);
    _$hash = $jc(_$hash, imageCouverture.hashCode);
    _$hash = $jc(_$hash, totalPages.hashCode);
    _$hash = $jc(_$hash, lectureAuto.hashCode);
    _$hash = $jc(_$hash, interactif.hashCode);
    _$hash = $jc(_$hash, anneePublication.hashCode);
    _$hash = $jc(_$hash, editeur.hashCode);
    _$hash = $jc(_$hash, niveauId.hashCode);
    _$hash = $jc(_$hash, niveauNom.hashCode);
    _$hash = $jc(_$hash, classeId.hashCode);
    _$hash = $jc(_$hash, classeNom.hashCode);
    _$hash = $jc(_$hash, matiereId.hashCode);
    _$hash = $jc(_$hash, matiereNom.hashCode);
    _$hash = $jc(_$hash, langueId.hashCode);
    _$hash = $jc(_$hash, langueNom.hashCode);
    _$hash = $jc(_$hash, progression.hashCode);
    _$hash = $jc(_$hash, statistiques.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LivreDetailResponse')
          ..add('id', id)
          ..add('titre', titre)
          ..add('isbn', isbn)
          ..add('auteur', auteur)
          ..add('imageCouverture', imageCouverture)
          ..add('totalPages', totalPages)
          ..add('lectureAuto', lectureAuto)
          ..add('interactif', interactif)
          ..add('anneePublication', anneePublication)
          ..add('editeur', editeur)
          ..add('niveauId', niveauId)
          ..add('niveauNom', niveauNom)
          ..add('classeId', classeId)
          ..add('classeNom', classeNom)
          ..add('matiereId', matiereId)
          ..add('matiereNom', matiereNom)
          ..add('langueId', langueId)
          ..add('langueNom', langueNom)
          ..add('progression', progression)
          ..add('statistiques', statistiques))
        .toString();
  }
}

class LivreDetailResponseBuilder
    implements Builder<LivreDetailResponse, LivreDetailResponseBuilder> {
  _$LivreDetailResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _isbn;
  String? get isbn => _$this._isbn;
  set isbn(String? isbn) => _$this._isbn = isbn;

  String? _auteur;
  String? get auteur => _$this._auteur;
  set auteur(String? auteur) => _$this._auteur = auteur;

  String? _imageCouverture;
  String? get imageCouverture => _$this._imageCouverture;
  set imageCouverture(String? imageCouverture) =>
      _$this._imageCouverture = imageCouverture;

  int? _totalPages;
  int? get totalPages => _$this._totalPages;
  set totalPages(int? totalPages) => _$this._totalPages = totalPages;

  bool? _lectureAuto;
  bool? get lectureAuto => _$this._lectureAuto;
  set lectureAuto(bool? lectureAuto) => _$this._lectureAuto = lectureAuto;

  bool? _interactif;
  bool? get interactif => _$this._interactif;
  set interactif(bool? interactif) => _$this._interactif = interactif;

  int? _anneePublication;
  int? get anneePublication => _$this._anneePublication;
  set anneePublication(int? anneePublication) =>
      _$this._anneePublication = anneePublication;

  String? _editeur;
  String? get editeur => _$this._editeur;
  set editeur(String? editeur) => _$this._editeur = editeur;

  int? _niveauId;
  int? get niveauId => _$this._niveauId;
  set niveauId(int? niveauId) => _$this._niveauId = niveauId;

  String? _niveauNom;
  String? get niveauNom => _$this._niveauNom;
  set niveauNom(String? niveauNom) => _$this._niveauNom = niveauNom;

  int? _classeId;
  int? get classeId => _$this._classeId;
  set classeId(int? classeId) => _$this._classeId = classeId;

  String? _classeNom;
  String? get classeNom => _$this._classeNom;
  set classeNom(String? classeNom) => _$this._classeNom = classeNom;

  int? _matiereId;
  int? get matiereId => _$this._matiereId;
  set matiereId(int? matiereId) => _$this._matiereId = matiereId;

  String? _matiereNom;
  String? get matiereNom => _$this._matiereNom;
  set matiereNom(String? matiereNom) => _$this._matiereNom = matiereNom;

  int? _langueId;
  int? get langueId => _$this._langueId;
  set langueId(int? langueId) => _$this._langueId = langueId;

  String? _langueNom;
  String? get langueNom => _$this._langueNom;
  set langueNom(String? langueNom) => _$this._langueNom = langueNom;

  double? _progression;
  double? get progression => _$this._progression;
  set progression(double? progression) => _$this._progression = progression;

  JsonObject? _statistiques;
  JsonObject? get statistiques => _$this._statistiques;
  set statistiques(JsonObject? statistiques) =>
      _$this._statistiques = statistiques;

  LivreDetailResponseBuilder() {
    LivreDetailResponse._defaults(this);
  }

  LivreDetailResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _isbn = $v.isbn;
      _auteur = $v.auteur;
      _imageCouverture = $v.imageCouverture;
      _totalPages = $v.totalPages;
      _lectureAuto = $v.lectureAuto;
      _interactif = $v.interactif;
      _anneePublication = $v.anneePublication;
      _editeur = $v.editeur;
      _niveauId = $v.niveauId;
      _niveauNom = $v.niveauNom;
      _classeId = $v.classeId;
      _classeNom = $v.classeNom;
      _matiereId = $v.matiereId;
      _matiereNom = $v.matiereNom;
      _langueId = $v.langueId;
      _langueNom = $v.langueNom;
      _progression = $v.progression;
      _statistiques = $v.statistiques;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LivreDetailResponse other) {
    _$v = other as _$LivreDetailResponse;
  }

  @override
  void update(void Function(LivreDetailResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LivreDetailResponse build() => _build();

  _$LivreDetailResponse _build() {
    final _$result =
        _$v ??
        _$LivreDetailResponse._(
          id: id,
          titre: titre,
          isbn: isbn,
          auteur: auteur,
          imageCouverture: imageCouverture,
          totalPages: totalPages,
          lectureAuto: lectureAuto,
          interactif: interactif,
          anneePublication: anneePublication,
          editeur: editeur,
          niveauId: niveauId,
          niveauNom: niveauNom,
          classeId: classeId,
          classeNom: classeNom,
          matiereId: matiereId,
          matiereNom: matiereNom,
          langueId: langueId,
          langueNom: langueNom,
          progression: progression,
          statistiques: statistiques,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
