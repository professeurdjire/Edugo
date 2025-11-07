// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options_conversion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OptionsConversion extends OptionsConversion {
  @override
  final int? id;
  @override
  final String? libelle;
  @override
  final bool? etat;
  @override
  final int? nbrePoint;
  @override
  final DateTime? dateAjout;
  @override
  final BuiltList<ConversionEleve>? conversions;

  factory _$OptionsConversion([
    void Function(OptionsConversionBuilder)? updates,
  ]) => (OptionsConversionBuilder()..update(updates))._build();

  _$OptionsConversion._({
    this.id,
    this.libelle,
    this.etat,
    this.nbrePoint,
    this.dateAjout,
    this.conversions,
  }) : super._();
  @override
  OptionsConversion rebuild(void Function(OptionsConversionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OptionsConversionBuilder toBuilder() =>
      OptionsConversionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OptionsConversion &&
        id == other.id &&
        libelle == other.libelle &&
        etat == other.etat &&
        nbrePoint == other.nbrePoint &&
        dateAjout == other.dateAjout &&
        conversions == other.conversions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, libelle.hashCode);
    _$hash = $jc(_$hash, etat.hashCode);
    _$hash = $jc(_$hash, nbrePoint.hashCode);
    _$hash = $jc(_$hash, dateAjout.hashCode);
    _$hash = $jc(_$hash, conversions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OptionsConversion')
          ..add('id', id)
          ..add('libelle', libelle)
          ..add('etat', etat)
          ..add('nbrePoint', nbrePoint)
          ..add('dateAjout', dateAjout)
          ..add('conversions', conversions))
        .toString();
  }
}

class OptionsConversionBuilder
    implements Builder<OptionsConversion, OptionsConversionBuilder> {
  _$OptionsConversion? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _libelle;
  String? get libelle => _$this._libelle;
  set libelle(String? libelle) => _$this._libelle = libelle;

  bool? _etat;
  bool? get etat => _$this._etat;
  set etat(bool? etat) => _$this._etat = etat;

  int? _nbrePoint;
  int? get nbrePoint => _$this._nbrePoint;
  set nbrePoint(int? nbrePoint) => _$this._nbrePoint = nbrePoint;

  DateTime? _dateAjout;
  DateTime? get dateAjout => _$this._dateAjout;
  set dateAjout(DateTime? dateAjout) => _$this._dateAjout = dateAjout;

  ListBuilder<ConversionEleve>? _conversions;
  ListBuilder<ConversionEleve> get conversions =>
      _$this._conversions ??= ListBuilder<ConversionEleve>();
  set conversions(ListBuilder<ConversionEleve>? conversions) =>
      _$this._conversions = conversions;

  OptionsConversionBuilder() {
    OptionsConversion._defaults(this);
  }

  OptionsConversionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _libelle = $v.libelle;
      _etat = $v.etat;
      _nbrePoint = $v.nbrePoint;
      _dateAjout = $v.dateAjout;
      _conversions = $v.conversions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OptionsConversion other) {
    _$v = other as _$OptionsConversion;
  }

  @override
  void update(void Function(OptionsConversionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OptionsConversion build() => _build();

  _$OptionsConversion _build() {
    _$OptionsConversion _$result;
    try {
      _$result =
          _$v ??
          _$OptionsConversion._(
            id: id,
            libelle: libelle,
            etat: etat,
            nbrePoint: nbrePoint,
            dateAjout: dateAjout,
            conversions: _conversions?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conversions';
        _conversions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'OptionsConversion',
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
