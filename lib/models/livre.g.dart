// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livre.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Livre extends Livre {
  @override
  final int? id;
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
  final Niveau? niveau;
  @override
  final Classe? classe;
  @override
  final Matiere? matiere;
  @override
  final Langue? langue;
  @override
  final BuiltList<FichierLivre>? fichiers;
  @override
  final Quiz? quiz;
  @override
  final BuiltList<Progression>? progressions;
  @override
  final BuiltList<Tag>? tags;

  factory _$Livre([void Function(LivreBuilder)? updates]) =>
      (LivreBuilder()..update(updates))._build();

  _$Livre._({
    this.id,
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
    this.niveau,
    this.classe,
    this.matiere,
    this.langue,
    this.fichiers,
    this.quiz,
    this.progressions,
    this.tags,
  }) : super._();
  @override
  Livre rebuild(void Function(LivreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LivreBuilder toBuilder() => LivreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Livre &&
        id == other.id &&
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
        niveau == other.niveau &&
        classe == other.classe &&
        matiere == other.matiere &&
        langue == other.langue &&
        fichiers == other.fichiers &&
        quiz == other.quiz &&
        progressions == other.progressions &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
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
    _$hash = $jc(_$hash, niveau.hashCode);
    _$hash = $jc(_$hash, classe.hashCode);
    _$hash = $jc(_$hash, matiere.hashCode);
    _$hash = $jc(_$hash, langue.hashCode);
    _$hash = $jc(_$hash, fichiers.hashCode);
    _$hash = $jc(_$hash, quiz.hashCode);
    _$hash = $jc(_$hash, progressions.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Livre')
          ..add('id', id)
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
          ..add('niveau', niveau)
          ..add('classe', classe)
          ..add('matiere', matiere)
          ..add('langue', langue)
          ..add('fichiers', fichiers)
          ..add('quiz', quiz)
          ..add('progressions', progressions)
          ..add('tags', tags))
        .toString();
  }
}

class LivreBuilder implements Builder<Livre, LivreBuilder> {
  _$Livre? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

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

  NiveauBuilder? _niveau;
  NiveauBuilder get niveau => _$this._niveau ??= NiveauBuilder();
  set niveau(NiveauBuilder? niveau) => _$this._niveau = niveau;

  ClasseBuilder? _classe;
  ClasseBuilder get classe => _$this._classe ??= ClasseBuilder();
  set classe(ClasseBuilder? classe) => _$this._classe = classe;

  MatiereBuilder? _matiere;
  MatiereBuilder get matiere => _$this._matiere ??= MatiereBuilder();
  set matiere(MatiereBuilder? matiere) => _$this._matiere = matiere;

  LangueBuilder? _langue;
  LangueBuilder get langue => _$this._langue ??= LangueBuilder();
  set langue(LangueBuilder? langue) => _$this._langue = langue;

  ListBuilder<FichierLivre>? _fichiers;
  ListBuilder<FichierLivre> get fichiers =>
      _$this._fichiers ??= ListBuilder<FichierLivre>();
  set fichiers(ListBuilder<FichierLivre>? fichiers) =>
      _$this._fichiers = fichiers;

  QuizBuilder? _quiz;
  QuizBuilder get quiz => _$this._quiz ??= QuizBuilder();
  set quiz(QuizBuilder? quiz) => _$this._quiz = quiz;

  ListBuilder<Progression>? _progressions;
  ListBuilder<Progression> get progressions =>
      _$this._progressions ??= ListBuilder<Progression>();
  set progressions(ListBuilder<Progression>? progressions) =>
      _$this._progressions = progressions;

  ListBuilder<Tag>? _tags;
  ListBuilder<Tag> get tags => _$this._tags ??= ListBuilder<Tag>();
  set tags(ListBuilder<Tag>? tags) => _$this._tags = tags;

  LivreBuilder() {
    Livre._defaults(this);
  }

  LivreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
      _niveau = $v.niveau?.toBuilder();
      _classe = $v.classe?.toBuilder();
      _matiere = $v.matiere?.toBuilder();
      _langue = $v.langue?.toBuilder();
      _fichiers = $v.fichiers?.toBuilder();
      _quiz = $v.quiz?.toBuilder();
      _progressions = $v.progressions?.toBuilder();
      _tags = $v.tags?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Livre other) {
    _$v = other as _$Livre;
  }

  @override
  void update(void Function(LivreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Livre build() => _build();

  _$Livre _build() {
    _$Livre _$result;
    try {
      _$result =
          _$v ??
          _$Livre._(
            id: id,
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
            niveau: _niveau?.build(),
            classe: _classe?.build(),
            matiere: _matiere?.build(),
            langue: _langue?.build(),
            fichiers: _fichiers?.build(),
            quiz: _quiz?.build(),
            progressions: _progressions?.build(),
            tags: _tags?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'niveau';
        _niveau?.build();
        _$failedField = 'classe';
        _classe?.build();
        _$failedField = 'matiere';
        _matiere?.build();
        _$failedField = 'langue';
        _langue?.build();
        _$failedField = 'fichiers';
        _fichiers?.build();
        _$failedField = 'quiz';
        _quiz?.build();
        _$failedField = 'progressions';
        _progressions?.build();
        _$failedField = 'tags';
        _tags?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Livre', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
