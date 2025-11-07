// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livre_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LivreResponse extends LivreResponse {
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

  factory _$LivreResponse([void Function(LivreResponseBuilder)? updates]) =>
      (LivreResponseBuilder()..update(updates))._build();

  _$LivreResponse._({
    this.id,
    this.titre,
    this.isbn,
    this.auteur,
    this.imageCouverture,
    this.totalPages,
  }) : super._();
  @override
  LivreResponse rebuild(void Function(LivreResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LivreResponseBuilder toBuilder() => LivreResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LivreResponse &&
        id == other.id &&
        titre == other.titre &&
        isbn == other.isbn &&
        auteur == other.auteur &&
        imageCouverture == other.imageCouverture &&
        totalPages == other.totalPages;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LivreResponse')
          ..add('id', id)
          ..add('titre', titre)
          ..add('isbn', isbn)
          ..add('auteur', auteur)
          ..add('imageCouverture', imageCouverture)
          ..add('totalPages', totalPages))
        .toString();
  }
}

class LivreResponseBuilder
    implements Builder<LivreResponse, LivreResponseBuilder> {
  _$LivreResponse? _$v;

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

  LivreResponseBuilder() {
    LivreResponse._defaults(this);
  }

  LivreResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _isbn = $v.isbn;
      _auteur = $v.auteur;
      _imageCouverture = $v.imageCouverture;
      _totalPages = $v.totalPages;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LivreResponse other) {
    _$v = other as _$LivreResponse;
  }

  @override
  void update(void Function(LivreResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LivreResponse build() => _build();

  _$LivreResponse _build() {
    final _$result =
        _$v ??
        _$LivreResponse._(
          id: id,
          titre: titre,
          isbn: isbn,
          auteur: auteur,
          imageCouverture: imageCouverture,
          totalPages: totalPages,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
