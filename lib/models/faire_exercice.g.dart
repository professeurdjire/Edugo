// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faire_exercice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FaireExerciceStatutEnum _$faireExerciceStatutEnum_PAS_DEBUTE =
    const FaireExerciceStatutEnum._('PAS_DEBUTE');
const FaireExerciceStatutEnum _$faireExerciceStatutEnum_ENCOURS =
    const FaireExerciceStatutEnum._('ENCOURS');
const FaireExerciceStatutEnum _$faireExerciceStatutEnum_TERMINE =
    const FaireExerciceStatutEnum._('TERMINE');
const FaireExerciceStatutEnum _$faireExerciceStatutEnum_SOUMIS =
    const FaireExerciceStatutEnum._('SOUMIS');
const FaireExerciceStatutEnum _$faireExerciceStatutEnum_CORRIGE =
    const FaireExerciceStatutEnum._('CORRIGE');

FaireExerciceStatutEnum _$faireExerciceStatutEnumValueOf(String name) {
  switch (name) {
    case 'PAS_DEBUTE':
      return _$faireExerciceStatutEnum_PAS_DEBUTE;
    case 'ENCOURS':
      return _$faireExerciceStatutEnum_ENCOURS;
    case 'TERMINE':
      return _$faireExerciceStatutEnum_TERMINE;
    case 'SOUMIS':
      return _$faireExerciceStatutEnum_SOUMIS;
    case 'CORRIGE':
      return _$faireExerciceStatutEnum_CORRIGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FaireExerciceStatutEnum> _$faireExerciceStatutEnumValues =
    BuiltSet<FaireExerciceStatutEnum>(const <FaireExerciceStatutEnum>[
      _$faireExerciceStatutEnum_PAS_DEBUTE,
      _$faireExerciceStatutEnum_ENCOURS,
      _$faireExerciceStatutEnum_TERMINE,
      _$faireExerciceStatutEnum_SOUMIS,
      _$faireExerciceStatutEnum_CORRIGE,
    ]);

Serializer<FaireExerciceStatutEnum> _$faireExerciceStatutEnumSerializer =
    _$FaireExerciceStatutEnumSerializer();

class _$FaireExerciceStatutEnumSerializer
    implements PrimitiveSerializer<FaireExerciceStatutEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PAS_DEBUTE': 'PAS_DEBUTE',
    'ENCOURS': 'ENCOURS',
    'TERMINE': 'TERMINE',
    'SOUMIS': 'SOUMIS',
    'CORRIGE': 'CORRIGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PAS_DEBUTE': 'PAS_DEBUTE',
    'ENCOURS': 'ENCOURS',
    'TERMINE': 'TERMINE',
    'SOUMIS': 'SOUMIS',
    'CORRIGE': 'CORRIGE',
  };

  @override
  final Iterable<Type> types = const <Type>[FaireExerciceStatutEnum];
  @override
  final String wireName = 'FaireExerciceStatutEnum';

  @override
  Object serialize(
    Serializers serializers,
    FaireExerciceStatutEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  FaireExerciceStatutEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => FaireExerciceStatutEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$FaireExercice extends FaireExercice {
  @override
  final int? id;
  @override
  final Eleve? eleve;
  @override
  final Exercice? exercice;
  @override
  final int? pointExercice;
  @override
  final FaireExerciceStatutEnum? statut;
  @override
  final DateTime? dateExercice;
  @override
  final String? reponse;
  @override
  final DateTime? dateSoumission;
  @override
  final int? note;
  @override
  final String? commentaire;
  @override
  final DateTime? dateCorrection;

  factory _$FaireExercice([void Function(FaireExerciceBuilder)? updates]) =>
      (FaireExerciceBuilder()..update(updates))._build();

  _$FaireExercice._({
    this.id,
    this.eleve,
    this.exercice,
    this.pointExercice,
    this.statut,
    this.dateExercice,
    this.reponse,
    this.dateSoumission,
    this.note,
    this.commentaire,
    this.dateCorrection,
  }) : super._();
  @override
  FaireExercice rebuild(void Function(FaireExerciceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FaireExerciceBuilder toBuilder() => FaireExerciceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FaireExercice &&
        id == other.id &&
        eleve == other.eleve &&
        exercice == other.exercice &&
        pointExercice == other.pointExercice &&
        statut == other.statut &&
        dateExercice == other.dateExercice &&
        reponse == other.reponse &&
        dateSoumission == other.dateSoumission &&
        note == other.note &&
        commentaire == other.commentaire &&
        dateCorrection == other.dateCorrection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, eleve.hashCode);
    _$hash = $jc(_$hash, exercice.hashCode);
    _$hash = $jc(_$hash, pointExercice.hashCode);
    _$hash = $jc(_$hash, statut.hashCode);
    _$hash = $jc(_$hash, dateExercice.hashCode);
    _$hash = $jc(_$hash, reponse.hashCode);
    _$hash = $jc(_$hash, dateSoumission.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, commentaire.hashCode);
    _$hash = $jc(_$hash, dateCorrection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FaireExercice')
          ..add('id', id)
          ..add('eleve', eleve)
          ..add('exercice', exercice)
          ..add('pointExercice', pointExercice)
          ..add('statut', statut)
          ..add('dateExercice', dateExercice)
          ..add('reponse', reponse)
          ..add('dateSoumission', dateSoumission)
          ..add('note', note)
          ..add('commentaire', commentaire)
          ..add('dateCorrection', dateCorrection))
        .toString();
  }
}

class FaireExerciceBuilder
    implements Builder<FaireExercice, FaireExerciceBuilder> {
  _$FaireExercice? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  EleveBuilder? _eleve;
  EleveBuilder get eleve => _$this._eleve ??= EleveBuilder();
  set eleve(EleveBuilder? eleve) => _$this._eleve = eleve;

  ExerciceBuilder? _exercice;
  ExerciceBuilder get exercice => _$this._exercice ??= ExerciceBuilder();
  set exercice(ExerciceBuilder? exercice) => _$this._exercice = exercice;

  int? _pointExercice;
  int? get pointExercice => _$this._pointExercice;
  set pointExercice(int? pointExercice) =>
      _$this._pointExercice = pointExercice;

  FaireExerciceStatutEnum? _statut;
  FaireExerciceStatutEnum? get statut => _$this._statut;
  set statut(FaireExerciceStatutEnum? statut) => _$this._statut = statut;

  DateTime? _dateExercice;
  DateTime? get dateExercice => _$this._dateExercice;
  set dateExercice(DateTime? dateExercice) =>
      _$this._dateExercice = dateExercice;

  String? _reponse;
  String? get reponse => _$this._reponse;
  set reponse(String? reponse) => _$this._reponse = reponse;

  DateTime? _dateSoumission;
  DateTime? get dateSoumission => _$this._dateSoumission;
  set dateSoumission(DateTime? dateSoumission) =>
      _$this._dateSoumission = dateSoumission;

  int? _note;
  int? get note => _$this._note;
  set note(int? note) => _$this._note = note;

  String? _commentaire;
  String? get commentaire => _$this._commentaire;
  set commentaire(String? commentaire) => _$this._commentaire = commentaire;

  DateTime? _dateCorrection;
  DateTime? get dateCorrection => _$this._dateCorrection;
  set dateCorrection(DateTime? dateCorrection) =>
      _$this._dateCorrection = dateCorrection;

  FaireExerciceBuilder() {
    FaireExercice._defaults(this);
  }

  FaireExerciceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _eleve = $v.eleve?.toBuilder();
      _exercice = $v.exercice?.toBuilder();
      _pointExercice = $v.pointExercice;
      _statut = $v.statut;
      _dateExercice = $v.dateExercice;
      _reponse = $v.reponse;
      _dateSoumission = $v.dateSoumission;
      _note = $v.note;
      _commentaire = $v.commentaire;
      _dateCorrection = $v.dateCorrection;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FaireExercice other) {
    _$v = other as _$FaireExercice;
  }

  @override
  void update(void Function(FaireExerciceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FaireExercice build() => _build();

  _$FaireExercice _build() {
    _$FaireExercice _$result;
    try {
      _$result =
          _$v ??
          _$FaireExercice._(
            id: id,
            eleve: _eleve?.build(),
            exercice: _exercice?.build(),
            pointExercice: pointExercice,
            statut: statut,
            dateExercice: dateExercice,
            reponse: reponse,
            dateSoumission: dateSoumission,
            note: note,
            commentaire: commentaire,
            dateCorrection: dateCorrection,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'eleve';
        _eleve?.build();
        _$failedField = 'exercice';
        _exercice?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'FaireExercice',
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
