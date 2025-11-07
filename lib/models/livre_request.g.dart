// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livre_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LivreRequest extends LivreRequest {
  @override
  final String? titre;
  @override
  final String? isbn;
  @override
  final String? description;
  @override
  final int? anneePublication;
  @override
  final String? editeur;
  @override
  final String? auteur;
  @override
  final int? totalPages;
  @override
  final String? imageCouverture;
  @override
  final bool? lectureAuto;
  @override
  final bool? interactif;
  @override
  final int? niveauId;
  @override
  final int? classeId;
  @override
  final int? matiereId;
  @override
  final int? langueId;

  factory _$LivreRequest([void Function(LivreRequestBuilder)? updates]) =>
      (LivreRequestBuilder()..update(updates))._build();

  _$LivreRequest._({
    this.titre,
    this.isbn,
    this.description,
    this.anneePublication,
    this.editeur,
    this.auteur,
    this.totalPages,
    this.imageCouverture,
    this.lectureAuto,
    this.interactif,
    this.niveauId,
    this.classeId,
    this.matiereId,
    this.langueId,
  }) : super._();
  @override
  LivreRequest rebuild(void Function(LivreRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LivreRequestBuilder toBuilder() => LivreRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LivreRequest &&
        titre == other.titre &&
        isbn == other.isbn &&
        description == other.description &&
        anneePublication == other.anneePublication &&
        editeur == other.editeur &&
        auteur == other.auteur &&
        totalPages == other.totalPages &&
        imageCouverture == other.imageCouverture &&
        lectureAuto == other.lectureAuto &&
        interactif == other.interactif &&
        niveauId == other.niveauId &&
        classeId == other.classeId &&
        matiereId == other.matiereId &&
        langueId == other.langueId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, isbn.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, anneePublication.hashCode);
    _$hash = $jc(_$hash, editeur.hashCode);
    _$hash = $jc(_$hash, auteur.hashCode);
    _$hash = $jc(_$hash, totalPages.hashCode);
    _$hash = $jc(_$hash, imageCouverture.hashCode);
    _$hash = $jc(_$hash, lectureAuto.hashCode);
    _$hash = $jc(_$hash, interactif.hashCode);
    _$hash = $jc(_$hash, niveauId.hashCode);
    _$hash = $jc(_$hash, classeId.hashCode);
    _$hash = $jc(_$hash, matiereId.hashCode);
    _$hash = $jc(_$hash, langueId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LivreRequest')
          ..add('titre', titre)
          ..add('isbn', isbn)
          ..add('description', description)
          ..add('anneePublication', anneePublication)
          ..add('editeur', editeur)
          ..add('auteur', auteur)
          ..add('totalPages', totalPages)
          ..add('imageCouverture', imageCouverture)
          ..add('lectureAuto', lectureAuto)
          ..add('interactif', interactif)
          ..add('niveauId', niveauId)
          ..add('classeId', classeId)
          ..add('matiereId', matiereId)
          ..add('langueId', langueId))
        .toString();
  }
}

class LivreRequestBuilder
    implements Builder<LivreRequest, LivreRequestBuilder> {
  _$LivreRequest? _$v;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _isbn;
  String? get isbn => _$this._isbn;
  set isbn(String? isbn) => _$this._isbn = isbn;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _anneePublication;
  int? get anneePublication => _$this._anneePublication;
  set anneePublication(int? anneePublication) =>
      _$this._anneePublication = anneePublication;

  String? _editeur;
  String? get editeur => _$this._editeur;
  set editeur(String? editeur) => _$this._editeur = editeur;

  String? _auteur;
  String? get auteur => _$this._auteur;
  set auteur(String? auteur) => _$this._auteur = auteur;

  int? _totalPages;
  int? get totalPages => _$this._totalPages;
  set totalPages(int? totalPages) => _$this._totalPages = totalPages;

  String? _imageCouverture;
  String? get imageCouverture => _$this._imageCouverture;
  set imageCouverture(String? imageCouverture) =>
      _$this._imageCouverture = imageCouverture;

  bool? _lectureAuto;
  bool? get lectureAuto => _$this._lectureAuto;
  set lectureAuto(bool? lectureAuto) => _$this._lectureAuto = lectureAuto;

  bool? _interactif;
  bool? get interactif => _$this._interactif;
  set interactif(bool? interactif) => _$this._interactif = interactif;

  int? _niveauId;
  int? get niveauId => _$this._niveauId;
  set niveauId(int? niveauId) => _$this._niveauId = niveauId;

  int? _classeId;
  int? get classeId => _$this._classeId;
  set classeId(int? classeId) => _$this._classeId = classeId;

  int? _matiereId;
  int? get matiereId => _$this._matiereId;
  set matiereId(int? matiereId) => _$this._matiereId = matiereId;

  int? _langueId;
  int? get langueId => _$this._langueId;
  set langueId(int? langueId) => _$this._langueId = langueId;

  LivreRequestBuilder() {
    LivreRequest._defaults(this);
  }

  LivreRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _titre = $v.titre;
      _isbn = $v.isbn;
      _description = $v.description;
      _anneePublication = $v.anneePublication;
      _editeur = $v.editeur;
      _auteur = $v.auteur;
      _totalPages = $v.totalPages;
      _imageCouverture = $v.imageCouverture;
      _lectureAuto = $v.lectureAuto;
      _interactif = $v.interactif;
      _niveauId = $v.niveauId;
      _classeId = $v.classeId;
      _matiereId = $v.matiereId;
      _langueId = $v.langueId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LivreRequest other) {
    _$v = other as _$LivreRequest;
  }

  @override
  void update(void Function(LivreRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LivreRequest build() => _build();

  _$LivreRequest _build() {
    final _$result =
        _$v ??
        _$LivreRequest._(
          titre: titre,
          isbn: isbn,
          description: description,
          anneePublication: anneePublication,
          editeur: editeur,
          auteur: auteur,
          totalPages: totalPages,
          imageCouverture: imageCouverture,
          lectureAuto: lectureAuto,
          interactif: interactif,
          niveauId: niveauId,
          classeId: classeId,
          matiereId: matiereId,
          langueId: langueId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
