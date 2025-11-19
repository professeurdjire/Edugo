import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/login_request.dart';
import 'package:edugo/models/login_response.dart';
import 'package:edugo/models/register_request.dart';
import 'package:edugo/models/assistant_message.dart';
import 'package:edugo/models/livre_response.dart';
import 'package:edugo/models/livre_detail_response.dart';
import 'package:edugo/models/livre_populaire_response.dart';
import 'package:edugo/models/livre.dart';
import 'package:edugo/models/fichier_livre.dart';
import 'package:edugo/models/progression_response.dart';
import 'package:edugo/models/statistiques_livre_response.dart';
import 'package:edugo/models/classe.dart';
import 'package:edugo/models/niveau.dart';
import 'package:edugo/models/matiere.dart';
import 'package:edugo/models/langue.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/progression.dart';
import 'package:edugo/models/tag.dart';
import 'package:edugo/models/progression_update_request.dart';
import 'package:edugo/models/livre_request.dart';
import 'package:edugo/models/matiere_response.dart';
import 'package:edugo/models/niveau_response.dart';
import 'package:edugo/models/classe_response.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/eleve_lite_response.dart';
import 'package:edugo/models/defi_response.dart';
import 'package:edugo/models/defi_detail_response.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:edugo/models/exercice_detail_response.dart';
import 'package:edugo/models/faire_exercice_response.dart';
import 'package:edugo/models/eleve_defi_response.dart';
import 'package:edugo/models/badge.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/models/conversion_eleve.dart';
import 'package:edugo/models/defi.dart';
import 'package:edugo/models/eleve_defi.dart';
import 'package:edugo/models/exercice.dart';
import 'package:edugo/models/faire_exercice.dart';
import 'package:edugo/models/granted_authority.dart';
import 'package:edugo/models/options_conversion.dart';
import 'package:edugo/models/participation.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/reponse_eleve.dart';
import 'package:edugo/models/reponse_possible.dart';
import 'package:edugo/models/suggestion.dart';
import 'package:edugo/models/type_question.dart';

part 'serializers.g.dart';

@SerializersFor([
  LoginRequest,
  LoginResponse,
  RegisterRequest,
  AssistantMessage,
  Message,
  LivreResponse,
  LivreDetailResponse,
  LivrePopulaireResponse,
  Livre,
  FichierLivre,
  FichierLivreTypeEnum,
  ProgressionResponse,
  StatistiquesLivreResponse,
  Classe,
  Niveau,
  Matiere,
  Langue,
  Quiz,
  Progression,
  Tag,
  ProgressionUpdateRequest,
  LivreRequest,
  MatiereResponse,
  NiveauResponse,
  ClasseResponse,
  Eleve,
  EleveLiteResponse,
  DefiResponse,
  DefiDetailResponse,
  ExerciceResponse,
  ExerciceDetailResponse,
  FaireExerciceResponse,
  EleveDefiResponse,
  Badge,
  BadgeTypeEnum,
  Challenge,
  ChallengeTypeChallengeEnum,
  ConversionEleve,
  Defi,
  EleveDefi,
  EleveRoleEnum,
  Exercice,
  FaireExercice,
  FaireExerciceStatutEnum,
  GrantedAuthority,
  OptionsConversion,
  Participation,
  Question,
  ReponseEleve,
  ReponsePossible,
  Suggestion,
  TypeQuestion,
  QuizStatutEnum,
])
Serializers serializers = _$serializers;

Serializers standardSerializers = (serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(FlexibleDateTimeSerializer())
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DefiResponse)]),
        () => ListBuilder<DefiResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(EleveDefiResponse)]),
        () => ListBuilder<EleveDefiResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ExerciceResponse)]),
        () => ListBuilder<ExerciceResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MatiereResponse)]),
        () => ListBuilder<MatiereResponse>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ProgressionResponse)]),
        () => ListBuilder<ProgressionResponse>(),
      )
    )
    .build();

class FlexibleDateTimeSerializer implements PrimitiveSerializer<DateTime> {
  @override
  final Iterable<Type> types = const [DateTime];

  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    return dateTime.toIso8601String();
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    if (serialized is DateTime) return serialized;
    if (serialized is String) {
      return DateTime.parse(serialized);
    }
    if (serialized is int) {
      return DateTime.fromMillisecondsSinceEpoch(serialized);
    }
    if (serialized is double) {
      return DateTime.fromMillisecondsSinceEpoch(serialized.toInt());
    }
    throw ArgumentError('Cannot deserialize $serialized to DateTime');
  }
}