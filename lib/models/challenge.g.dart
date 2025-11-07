// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChallengeTypeChallengeEnum _$challengeTypeChallengeEnum_INTERCLASSE =
    const ChallengeTypeChallengeEnum._('INTERCLASSE');
const ChallengeTypeChallengeEnum _$challengeTypeChallengeEnum_INTERNIVEAU =
    const ChallengeTypeChallengeEnum._('INTERNIVEAU');

ChallengeTypeChallengeEnum _$challengeTypeChallengeEnumValueOf(String name) {
  switch (name) {
    case 'INTERCLASSE':
      return _$challengeTypeChallengeEnum_INTERCLASSE;
    case 'INTERNIVEAU':
      return _$challengeTypeChallengeEnum_INTERNIVEAU;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChallengeTypeChallengeEnum> _$challengeTypeChallengeEnumValues =
    BuiltSet<ChallengeTypeChallengeEnum>(const <ChallengeTypeChallengeEnum>[
      _$challengeTypeChallengeEnum_INTERCLASSE,
      _$challengeTypeChallengeEnum_INTERNIVEAU,
    ]);

Serializer<ChallengeTypeChallengeEnum> _$challengeTypeChallengeEnumSerializer =
    _$ChallengeTypeChallengeEnumSerializer();

class _$ChallengeTypeChallengeEnumSerializer
    implements PrimitiveSerializer<ChallengeTypeChallengeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INTERCLASSE': 'INTERCLASSE',
    'INTERNIVEAU': 'INTERNIVEAU',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INTERCLASSE': 'INTERCLASSE',
    'INTERNIVEAU': 'INTERNIVEAU',
  };

  @override
  final Iterable<Type> types = const <Type>[ChallengeTypeChallengeEnum];
  @override
  final String wireName = 'ChallengeTypeChallengeEnum';

  @override
  Object serialize(
    Serializers serializers,
    ChallengeTypeChallengeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  ChallengeTypeChallengeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => ChallengeTypeChallengeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$Challenge extends Challenge {
  @override
  final int? id;
  @override
  final String? titre;
  @override
  final String? description;
  @override
  final DateTime? dateDebut;
  @override
  final DateTime? dateFin;
  @override
  final String? rewardMode;
  @override
  final ChallengeTypeChallengeEnum? typeChallenge;
  @override
  final Niveau? niveau;
  @override
  final Classe? classe;
  @override
  final BuiltList<Badge>? rewards;
  @override
  final BuiltList<Question>? questionsChallenge;
  @override
  final BuiltList<Participation>? participations;

  factory _$Challenge([void Function(ChallengeBuilder)? updates]) =>
      (ChallengeBuilder()..update(updates))._build();

  _$Challenge._({
    this.id,
    this.titre,
    this.description,
    this.dateDebut,
    this.dateFin,
    this.rewardMode,
    this.typeChallenge,
    this.niveau,
    this.classe,
    this.rewards,
    this.questionsChallenge,
    this.participations,
  }) : super._();
  @override
  Challenge rebuild(void Function(ChallengeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChallengeBuilder toBuilder() => ChallengeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Challenge &&
        id == other.id &&
        titre == other.titre &&
        description == other.description &&
        dateDebut == other.dateDebut &&
        dateFin == other.dateFin &&
        rewardMode == other.rewardMode &&
        typeChallenge == other.typeChallenge &&
        niveau == other.niveau &&
        classe == other.classe &&
        rewards == other.rewards &&
        questionsChallenge == other.questionsChallenge &&
        participations == other.participations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, titre.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, dateDebut.hashCode);
    _$hash = $jc(_$hash, dateFin.hashCode);
    _$hash = $jc(_$hash, rewardMode.hashCode);
    _$hash = $jc(_$hash, typeChallenge.hashCode);
    _$hash = $jc(_$hash, niveau.hashCode);
    _$hash = $jc(_$hash, classe.hashCode);
    _$hash = $jc(_$hash, rewards.hashCode);
    _$hash = $jc(_$hash, questionsChallenge.hashCode);
    _$hash = $jc(_$hash, participations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Challenge')
          ..add('id', id)
          ..add('titre', titre)
          ..add('description', description)
          ..add('dateDebut', dateDebut)
          ..add('dateFin', dateFin)
          ..add('rewardMode', rewardMode)
          ..add('typeChallenge', typeChallenge)
          ..add('niveau', niveau)
          ..add('classe', classe)
          ..add('rewards', rewards)
          ..add('questionsChallenge', questionsChallenge)
          ..add('participations', participations))
        .toString();
  }
}

class ChallengeBuilder implements Builder<Challenge, ChallengeBuilder> {
  _$Challenge? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _titre;
  String? get titre => _$this._titre;
  set titre(String? titre) => _$this._titre = titre;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _dateDebut;
  DateTime? get dateDebut => _$this._dateDebut;
  set dateDebut(DateTime? dateDebut) => _$this._dateDebut = dateDebut;

  DateTime? _dateFin;
  DateTime? get dateFin => _$this._dateFin;
  set dateFin(DateTime? dateFin) => _$this._dateFin = dateFin;

  String? _rewardMode;
  String? get rewardMode => _$this._rewardMode;
  set rewardMode(String? rewardMode) => _$this._rewardMode = rewardMode;

  ChallengeTypeChallengeEnum? _typeChallenge;
  ChallengeTypeChallengeEnum? get typeChallenge => _$this._typeChallenge;
  set typeChallenge(ChallengeTypeChallengeEnum? typeChallenge) =>
      _$this._typeChallenge = typeChallenge;

  NiveauBuilder? _niveau;
  NiveauBuilder get niveau => _$this._niveau ??= NiveauBuilder();
  set niveau(NiveauBuilder? niveau) => _$this._niveau = niveau;

  ClasseBuilder? _classe;
  ClasseBuilder get classe => _$this._classe ??= ClasseBuilder();
  set classe(ClasseBuilder? classe) => _$this._classe = classe;

  ListBuilder<Badge>? _rewards;
  ListBuilder<Badge> get rewards => _$this._rewards ??= ListBuilder<Badge>();
  set rewards(ListBuilder<Badge>? rewards) => _$this._rewards = rewards;

  ListBuilder<Question>? _questionsChallenge;
  ListBuilder<Question> get questionsChallenge =>
      _$this._questionsChallenge ??= ListBuilder<Question>();
  set questionsChallenge(ListBuilder<Question>? questionsChallenge) =>
      _$this._questionsChallenge = questionsChallenge;

  ListBuilder<Participation>? _participations;
  ListBuilder<Participation> get participations =>
      _$this._participations ??= ListBuilder<Participation>();
  set participations(ListBuilder<Participation>? participations) =>
      _$this._participations = participations;

  ChallengeBuilder() {
    Challenge._defaults(this);
  }

  ChallengeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _titre = $v.titre;
      _description = $v.description;
      _dateDebut = $v.dateDebut;
      _dateFin = $v.dateFin;
      _rewardMode = $v.rewardMode;
      _typeChallenge = $v.typeChallenge;
      _niveau = $v.niveau?.toBuilder();
      _classe = $v.classe?.toBuilder();
      _rewards = $v.rewards?.toBuilder();
      _questionsChallenge = $v.questionsChallenge?.toBuilder();
      _participations = $v.participations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Challenge other) {
    _$v = other as _$Challenge;
  }

  @override
  void update(void Function(ChallengeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Challenge build() => _build();

  _$Challenge _build() {
    _$Challenge _$result;
    try {
      _$result =
          _$v ??
          _$Challenge._(
            id: id,
            titre: titre,
            description: description,
            dateDebut: dateDebut,
            dateFin: dateFin,
            rewardMode: rewardMode,
            typeChallenge: typeChallenge,
            niveau: _niveau?.build(),
            classe: _classe?.build(),
            rewards: _rewards?.build(),
            questionsChallenge: _questionsChallenge?.build(),
            participations: _participations?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'niveau';
        _niveau?.build();
        _$failedField = 'classe';
        _classe?.build();
        _$failedField = 'rewards';
        _rewards?.build();
        _$failedField = 'questionsChallenge';
        _questionsChallenge?.build();
        _$failedField = 'participations';
        _participations?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Challenge',
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
