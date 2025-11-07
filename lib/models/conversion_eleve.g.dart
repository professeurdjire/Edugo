// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_eleve.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConversionEleve extends ConversionEleve {
  @override
  final int? id;
  @override
  final OptionsConversion? option;
  @override
  final Eleve? eleve;
  @override
  final DateTime? dateConversion;

  factory _$ConversionEleve([void Function(ConversionEleveBuilder)? updates]) =>
      (ConversionEleveBuilder()..update(updates))._build();

  _$ConversionEleve._({this.id, this.option, this.eleve, this.dateConversion})
    : super._();
  @override
  ConversionEleve rebuild(void Function(ConversionEleveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConversionEleveBuilder toBuilder() => ConversionEleveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversionEleve &&
        id == other.id &&
        option == other.option &&
        eleve == other.eleve &&
        dateConversion == other.dateConversion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, option.hashCode);
    _$hash = $jc(_$hash, eleve.hashCode);
    _$hash = $jc(_$hash, dateConversion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConversionEleve')
          ..add('id', id)
          ..add('option', option)
          ..add('eleve', eleve)
          ..add('dateConversion', dateConversion))
        .toString();
  }
}

class ConversionEleveBuilder
    implements Builder<ConversionEleve, ConversionEleveBuilder> {
  _$ConversionEleve? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  OptionsConversionBuilder? _option;
  OptionsConversionBuilder get option =>
      _$this._option ??= OptionsConversionBuilder();
  set option(OptionsConversionBuilder? option) => _$this._option = option;

  EleveBuilder? _eleve;
  EleveBuilder get eleve => _$this._eleve ??= EleveBuilder();
  set eleve(EleveBuilder? eleve) => _$this._eleve = eleve;

  DateTime? _dateConversion;
  DateTime? get dateConversion => _$this._dateConversion;
  set dateConversion(DateTime? dateConversion) =>
      _$this._dateConversion = dateConversion;

  ConversionEleveBuilder() {
    ConversionEleve._defaults(this);
  }

  ConversionEleveBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _option = $v.option?.toBuilder();
      _eleve = $v.eleve?.toBuilder();
      _dateConversion = $v.dateConversion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConversionEleve other) {
    _$v = other as _$ConversionEleve;
  }

  @override
  void update(void Function(ConversionEleveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversionEleve build() => _build();

  _$ConversionEleve _build() {
    _$ConversionEleve _$result;
    try {
      _$result =
          _$v ??
          _$ConversionEleve._(
            id: id,
            option: _option?.build(),
            eleve: _eleve?.build(),
            dateConversion: dateConversion,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'option';
        _option?.build();
        _$failedField = 'eleve';
        _eleve?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ConversionEleve',
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
