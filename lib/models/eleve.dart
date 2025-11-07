//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:edugo/models/classe.dart';
import 'package:edugo/models/progression.dart';
import 'package:edugo/models/reponse_eleve.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/conversion_eleve.dart';
import 'package:edugo/models/granted_authority.dart';
import 'package:edugo/models/participation.dart';
import 'package:edugo/models/eleve_defi.dart';
import 'package:edugo/models/faire_exercice.dart';
import 'package:edugo/models/suggestion.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'eleve.g.dart';

/// Eleve
///
/// Properties:
/// * [id] 
/// * [nom] 
/// * [prenom] 
/// * [email] 
/// * [motDePasse] 
/// * [role] 
/// * [dateCreation] 
/// * [dateModification] 
/// * [estActive] 
/// * [photoProfil] 
/// * [dateNaissance] 
/// * [classe] 
/// * [pointAccumule] 
/// * [participations] 
/// * [progressions] 
/// * [eleveDefis] 
/// * [faireExercices] 
/// * [reponsesUtilisateurs] 
/// * [conversions] 
/// * [suggestions] 
/// * [enabled] 
/// * [authorities] 
/// * [password] 
/// * [username] 
/// * [credentialsNonExpired] 
/// * [accountNonExpired] 
/// * [accountNonLocked] 
@BuiltValue()
abstract class Eleve implements Built<Eleve, EleveBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'nom')
  String? get nom;

  @BuiltValueField(wireName: r'prenom')
  String? get prenom;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'motDePasse')
  String? get motDePasse;

  @BuiltValueField(wireName: r'role')
  EleveRoleEnum? get role;
  // enum roleEnum {  ADMIN,  ELEVE,  };

  @BuiltValueField(wireName: r'dateCreation')
  DateTime? get dateCreation;

  @BuiltValueField(wireName: r'dateModification')
  DateTime? get dateModification;

  @BuiltValueField(wireName: r'estActive')
  bool? get estActive;

  @BuiltValueField(wireName: r'photoProfil')
  String? get photoProfil;

  @BuiltValueField(wireName: r'dateNaissance')
  String? get dateNaissance;

  @BuiltValueField(wireName: r'classe')
  Classe? get classe;

  @BuiltValueField(wireName: r'pointAccumule')
  int? get pointAccumule;

  @BuiltValueField(wireName: r'participations')
  BuiltList<Participation>? get participations;

  @BuiltValueField(wireName: r'progressions')
  BuiltList<Progression>? get progressions;

  @BuiltValueField(wireName: r'eleveDefis')
  BuiltList<EleveDefi>? get eleveDefis;

  @BuiltValueField(wireName: r'faireExercices')
  BuiltList<FaireExercice>? get faireExercices;

  @BuiltValueField(wireName: r'reponsesUtilisateurs')
  BuiltList<ReponseEleve>? get reponsesUtilisateurs;

  @BuiltValueField(wireName: r'conversions')
  BuiltList<ConversionEleve>? get conversions;

  @BuiltValueField(wireName: r'suggestions')
  BuiltList<Suggestion>? get suggestions;

  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  @BuiltValueField(wireName: r'authorities')
  BuiltList<GrantedAuthority>? get authorities;

  @BuiltValueField(wireName: r'password')
  String? get password;

  @BuiltValueField(wireName: r'username')
  String? get username;

  @BuiltValueField(wireName: r'credentialsNonExpired')
  bool? get credentialsNonExpired;

  @BuiltValueField(wireName: r'accountNonExpired')
  bool? get accountNonExpired;

  @BuiltValueField(wireName: r'accountNonLocked')
  bool? get accountNonLocked;

  Eleve._();

  factory Eleve([void updates(EleveBuilder b)]) = _$Eleve;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EleveBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Eleve> get serializer => _$EleveSerializer();
}

class _$EleveSerializer implements PrimitiveSerializer<Eleve> {
  @override
  final Iterable<Type> types = const [Eleve, _$Eleve];

  @override
  final String wireName = r'Eleve';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Eleve object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.nom != null) {
      yield r'nom';
      yield serializers.serialize(
        object.nom,
        specifiedType: const FullType(String),
      );
    }
    if (object.prenom != null) {
      yield r'prenom';
      yield serializers.serialize(
        object.prenom,
        specifiedType: const FullType(String),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
    if (object.motDePasse != null) {
      yield r'motDePasse';
      yield serializers.serialize(
        object.motDePasse,
        specifiedType: const FullType(String),
      );
    }
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(EleveRoleEnum),
      );
    }
    if (object.dateCreation != null) {
      yield r'dateCreation';
      yield serializers.serialize(
        object.dateCreation,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.dateModification != null) {
      yield r'dateModification';
      yield serializers.serialize(
        object.dateModification,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.estActive != null) {
      yield r'estActive';
      yield serializers.serialize(
        object.estActive,
        specifiedType: const FullType(bool),
      );
    }
    if (object.photoProfil != null) {
      yield r'photoProfil';
      yield serializers.serialize(
        object.photoProfil,
        specifiedType: const FullType(String),
      );
    }
    if (object.dateNaissance != null) {
      yield r'dateNaissance';
      yield serializers.serialize(
        object.dateNaissance,
        specifiedType: const FullType(String),
      );
    }
    if (object.classe != null) {
      yield r'classe';
      yield serializers.serialize(
        object.classe,
        specifiedType: const FullType(Classe),
      );
    }
    if (object.pointAccumule != null) {
      yield r'pointAccumule';
      yield serializers.serialize(
        object.pointAccumule,
        specifiedType: const FullType(int),
      );
    }
    if (object.participations != null) {
      yield r'participations';
      yield serializers.serialize(
        object.participations,
        specifiedType: const FullType(BuiltList, [FullType(Participation)]),
      );
    }
    if (object.progressions != null) {
      yield r'progressions';
      yield serializers.serialize(
        object.progressions,
        specifiedType: const FullType(BuiltList, [FullType(Progression)]),
      );
    }
    if (object.eleveDefis != null) {
      yield r'eleveDefis';
      yield serializers.serialize(
        object.eleveDefis,
        specifiedType: const FullType(BuiltList, [FullType(EleveDefi)]),
      );
    }
    if (object.faireExercices != null) {
      yield r'faireExercices';
      yield serializers.serialize(
        object.faireExercices,
        specifiedType: const FullType(BuiltList, [FullType(FaireExercice)]),
      );
    }
    if (object.reponsesUtilisateurs != null) {
      yield r'reponsesUtilisateurs';
      yield serializers.serialize(
        object.reponsesUtilisateurs,
        specifiedType: const FullType(BuiltList, [FullType(ReponseEleve)]),
      );
    }
    if (object.conversions != null) {
      yield r'conversions';
      yield serializers.serialize(
        object.conversions,
        specifiedType: const FullType(BuiltList, [FullType(ConversionEleve)]),
      );
    }
    if (object.suggestions != null) {
      yield r'suggestions';
      yield serializers.serialize(
        object.suggestions,
        specifiedType: const FullType(BuiltList, [FullType(Suggestion)]),
      );
    }
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.authorities != null) {
      yield r'authorities';
      yield serializers.serialize(
        object.authorities,
        specifiedType: const FullType(BuiltList, [FullType(GrantedAuthority)]),
      );
    }
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      );
    }
    if (object.username != null) {
      yield r'username';
      yield serializers.serialize(
        object.username,
        specifiedType: const FullType(String),
      );
    }
    if (object.credentialsNonExpired != null) {
      yield r'credentialsNonExpired';
      yield serializers.serialize(
        object.credentialsNonExpired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.accountNonExpired != null) {
      yield r'accountNonExpired';
      yield serializers.serialize(
        object.accountNonExpired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.accountNonLocked != null) {
      yield r'accountNonLocked';
      yield serializers.serialize(
        object.accountNonLocked,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Eleve object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EleveBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'nom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nom = valueDes;
          break;
        case r'prenom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prenom = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'motDePasse':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.motDePasse = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EleveRoleEnum),
          ) as EleveRoleEnum;
          result.role = valueDes;
          break;
        case r'dateCreation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateCreation = valueDes;
          break;
        case r'dateModification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dateModification = valueDes;
          break;
        case r'estActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.estActive = valueDes;
          break;
        case r'photoProfil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.photoProfil = valueDes;
          break;
        case r'dateNaissance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dateNaissance = valueDes;
          break;
        case r'classe':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Classe),
          ) as Classe;
          result.classe.replace(valueDes);
          break;
        case r'pointAccumule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pointAccumule = valueDes;
          break;
        case r'participations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Participation)]),
          ) as BuiltList<Participation>;
          result.participations.replace(valueDes);
          break;
        case r'progressions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Progression)]),
          ) as BuiltList<Progression>;
          result.progressions.replace(valueDes);
          break;
        case r'eleveDefis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EleveDefi)]),
          ) as BuiltList<EleveDefi>;
          result.eleveDefis.replace(valueDes);
          break;
        case r'faireExercices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FaireExercice)]),
          ) as BuiltList<FaireExercice>;
          result.faireExercices.replace(valueDes);
          break;
        case r'reponsesUtilisateurs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReponseEleve)]),
          ) as BuiltList<ReponseEleve>;
          result.reponsesUtilisateurs.replace(valueDes);
          break;
        case r'conversions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ConversionEleve)]),
          ) as BuiltList<ConversionEleve>;
          result.conversions.replace(valueDes);
          break;
        case r'suggestions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Suggestion)]),
          ) as BuiltList<Suggestion>;
          result.suggestions.replace(valueDes);
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'authorities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GrantedAuthority)]),
          ) as BuiltList<GrantedAuthority>;
          result.authorities.replace(valueDes);
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'credentialsNonExpired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.credentialsNonExpired = valueDes;
          break;
        case r'accountNonExpired':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accountNonExpired = valueDes;
          break;
        case r'accountNonLocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accountNonLocked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Eleve deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EleveBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class EleveRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const EleveRoleEnum ADMIN = _$eleveRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'ELEVE')
  static const EleveRoleEnum ELEVE = _$eleveRoleEnum_ELEVE;

  static Serializer<EleveRoleEnum> get serializer => _$eleveRoleEnumSerializer;

  const EleveRoleEnum._(String name): super(name);

  static BuiltSet<EleveRoleEnum> get values => _$eleveRoleEnumValues;
  static EleveRoleEnum valueOf(String name) => _$eleveRoleEnumValueOf(name);
}

