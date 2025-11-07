// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fichier_livre.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FichierLivreTypeEnum _$fichierLivreTypeEnum_PDF =
    const FichierLivreTypeEnum._('PDF');
const FichierLivreTypeEnum _$fichierLivreTypeEnum_EPUB =
    const FichierLivreTypeEnum._('EPUB');
const FichierLivreTypeEnum _$fichierLivreTypeEnum_IMAGE =
    const FichierLivreTypeEnum._('IMAGE');
const FichierLivreTypeEnum _$fichierLivreTypeEnum_VIDEO =
    const FichierLivreTypeEnum._('VIDEO');
const FichierLivreTypeEnum _$fichierLivreTypeEnum_AUDIO =
    const FichierLivreTypeEnum._('AUDIO');

FichierLivreTypeEnum _$fichierLivreTypeEnumValueOf(String name) {
  switch (name) {
    case 'PDF':
      return _$fichierLivreTypeEnum_PDF;
    case 'EPUB':
      return _$fichierLivreTypeEnum_EPUB;
    case 'IMAGE':
      return _$fichierLivreTypeEnum_IMAGE;
    case 'VIDEO':
      return _$fichierLivreTypeEnum_VIDEO;
    case 'AUDIO':
      return _$fichierLivreTypeEnum_AUDIO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FichierLivreTypeEnum> _$fichierLivreTypeEnumValues =
    BuiltSet<FichierLivreTypeEnum>(const <FichierLivreTypeEnum>[
      _$fichierLivreTypeEnum_PDF,
      _$fichierLivreTypeEnum_EPUB,
      _$fichierLivreTypeEnum_IMAGE,
      _$fichierLivreTypeEnum_VIDEO,
      _$fichierLivreTypeEnum_AUDIO,
    ]);

Serializer<FichierLivreTypeEnum> _$fichierLivreTypeEnumSerializer =
    _$FichierLivreTypeEnumSerializer();

class _$FichierLivreTypeEnumSerializer
    implements PrimitiveSerializer<FichierLivreTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PDF': 'PDF',
    'EPUB': 'EPUB',
    'IMAGE': 'IMAGE',
    'VIDEO': 'VIDEO',
    'AUDIO': 'AUDIO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PDF': 'PDF',
    'EPUB': 'EPUB',
    'IMAGE': 'IMAGE',
    'VIDEO': 'VIDEO',
    'AUDIO': 'AUDIO',
  };

  @override
  final Iterable<Type> types = const <Type>[FichierLivreTypeEnum];
  @override
  final String wireName = 'FichierLivreTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    FichierLivreTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  FichierLivreTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => FichierLivreTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$FichierLivre extends FichierLivre {
  @override
  final int? id;
  @override
  final String? nom;
  @override
  final String? cheminFichier;
  @override
  final FichierLivreTypeEnum? type;
  @override
  final int? taille;
  @override
  final String? format;
  @override
  final Livre? livre;
  @override
  final String? tailleFormattee;

  factory _$FichierLivre([void Function(FichierLivreBuilder)? updates]) =>
      (FichierLivreBuilder()..update(updates))._build();

  _$FichierLivre._({
    this.id,
    this.nom,
    this.cheminFichier,
    this.type,
    this.taille,
    this.format,
    this.livre,
    this.tailleFormattee,
  }) : super._();
  @override
  FichierLivre rebuild(void Function(FichierLivreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FichierLivreBuilder toBuilder() => FichierLivreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FichierLivre &&
        id == other.id &&
        nom == other.nom &&
        cheminFichier == other.cheminFichier &&
        type == other.type &&
        taille == other.taille &&
        format == other.format &&
        livre == other.livre &&
        tailleFormattee == other.tailleFormattee;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nom.hashCode);
    _$hash = $jc(_$hash, cheminFichier.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, taille.hashCode);
    _$hash = $jc(_$hash, format.hashCode);
    _$hash = $jc(_$hash, livre.hashCode);
    _$hash = $jc(_$hash, tailleFormattee.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FichierLivre')
          ..add('id', id)
          ..add('nom', nom)
          ..add('cheminFichier', cheminFichier)
          ..add('type', type)
          ..add('taille', taille)
          ..add('format', format)
          ..add('livre', livre)
          ..add('tailleFormattee', tailleFormattee))
        .toString();
  }
}

class FichierLivreBuilder
    implements Builder<FichierLivre, FichierLivreBuilder> {
  _$FichierLivre? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _nom;
  String? get nom => _$this._nom;
  set nom(String? nom) => _$this._nom = nom;

  String? _cheminFichier;
  String? get cheminFichier => _$this._cheminFichier;
  set cheminFichier(String? cheminFichier) =>
      _$this._cheminFichier = cheminFichier;

  FichierLivreTypeEnum? _type;
  FichierLivreTypeEnum? get type => _$this._type;
  set type(FichierLivreTypeEnum? type) => _$this._type = type;

  int? _taille;
  int? get taille => _$this._taille;
  set taille(int? taille) => _$this._taille = taille;

  String? _format;
  String? get format => _$this._format;
  set format(String? format) => _$this._format = format;

  LivreBuilder? _livre;
  LivreBuilder get livre => _$this._livre ??= LivreBuilder();
  set livre(LivreBuilder? livre) => _$this._livre = livre;

  String? _tailleFormattee;
  String? get tailleFormattee => _$this._tailleFormattee;
  set tailleFormattee(String? tailleFormattee) =>
      _$this._tailleFormattee = tailleFormattee;

  FichierLivreBuilder() {
    FichierLivre._defaults(this);
  }

  FichierLivreBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nom = $v.nom;
      _cheminFichier = $v.cheminFichier;
      _type = $v.type;
      _taille = $v.taille;
      _format = $v.format;
      _livre = $v.livre?.toBuilder();
      _tailleFormattee = $v.tailleFormattee;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FichierLivre other) {
    _$v = other as _$FichierLivre;
  }

  @override
  void update(void Function(FichierLivreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FichierLivre build() => _build();

  _$FichierLivre _build() {
    _$FichierLivre _$result;
    try {
      _$result =
          _$v ??
          _$FichierLivre._(
            id: id,
            nom: nom,
            cheminFichier: cheminFichier,
            type: type,
            taille: taille,
            format: format,
            livre: _livre?.build(),
            tailleFormattee: tailleFormattee,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'livre';
        _livre?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FichierLivre',
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
