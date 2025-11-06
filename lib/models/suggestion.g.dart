// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Suggestion extends Suggestion {
  @override
  final int? id;
  @override
  final String? contenu;
  @override
  final DateTime? dateEnvoie;
  @override
  final Eleve? eleve;

  factory _$Suggestion([void Function(SuggestionBuilder)? updates]) =>
      (SuggestionBuilder()..update(updates))._build();

  _$Suggestion._({this.id, this.contenu, this.dateEnvoie, this.eleve})
    : super._();
  @override
  Suggestion rebuild(void Function(SuggestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SuggestionBuilder toBuilder() => SuggestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Suggestion &&
        id == other.id &&
        contenu == other.contenu &&
        dateEnvoie == other.dateEnvoie &&
        eleve == other.eleve;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, contenu.hashCode);
    _$hash = $jc(_$hash, dateEnvoie.hashCode);
    _$hash = $jc(_$hash, eleve.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Suggestion')
          ..add('id', id)
          ..add('contenu', contenu)
          ..add('dateEnvoie', dateEnvoie)
          ..add('eleve', eleve))
        .toString();
  }
}

class SuggestionBuilder implements Builder<Suggestion, SuggestionBuilder> {
  _$Suggestion? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _contenu;
  String? get contenu => _$this._contenu;
  set contenu(String? contenu) => _$this._contenu = contenu;

  DateTime? _dateEnvoie;
  DateTime? get dateEnvoie => _$this._dateEnvoie;
  set dateEnvoie(DateTime? dateEnvoie) => _$this._dateEnvoie = dateEnvoie;

  EleveBuilder? _eleve;
  EleveBuilder get eleve => _$this._eleve ??= EleveBuilder();
  set eleve(EleveBuilder? eleve) => _$this._eleve = eleve;

  SuggestionBuilder() {
    Suggestion._defaults(this);
  }

  SuggestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _contenu = $v.contenu;
      _dateEnvoie = $v.dateEnvoie;
      _eleve = $v.eleve?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Suggestion other) {
    _$v = other as _$Suggestion;
  }

  @override
  void update(void Function(SuggestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Suggestion build() => _build();

  _$Suggestion _build() {
    _$Suggestion _$result;
    try {
      _$result =
          _$v ??
          _$Suggestion._(
            id: id,
            contenu: contenu,
            dateEnvoie: dateEnvoie,
            eleve: _eleve?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'eleve';
        _eleve?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Suggestion',
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
