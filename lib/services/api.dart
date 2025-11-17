//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/services/api_key_auth.dart';
import 'package:edugo/services/basic_auth.dart';
import 'package:edugo/services/bearer_auth.dart';
import 'package:edugo/services/oauth.dart';
import 'package:edugo/services/api/administration_api.dart';
import 'package:edugo/services/api/authentification_api.dart';
import 'package:edugo/services/api/badges_api.dart';
import 'package:edugo/services/api/challenges_api.dart';
import 'package:edugo/services/api/classes_api.dart';
import 'package:edugo/services/api/dfis_api.dart';
import 'package:edugo/services/api/exercices_api.dart';
import 'package:edugo/services/api/livres_api.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/api/matires_api.dart';
import 'package:edugo/services/api/niveaux_api.dart';

class Openapi {
  static const String basePath = r'http://localhost:8089/api';

  final Dio dio;
  final Serializers serializers;

  Openapi({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Get AdministrationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdministrationApi getAdministrationApi() {
    return AdministrationApi(dio, serializers);
  }

  /// Get AuthentificationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthentificationApi getAuthentificationApi() {
    return AuthentificationApi(dio, serializers);
  }

  /// Get BadgesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BadgesApi getBadgesApi() {
    return BadgesApi(dio, serializers);
  }

  /// Get ChallengesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ChallengesApi getChallengesApi() {
    return ChallengesApi(dio, serializers);
  }

  /// Get ClassesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ClassesApi getClassesApi() {
    return ClassesApi(dio, serializers);
  }

  /// Get DfisApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DfisApi getDfisApi() {
    return DfisApi(dio, serializers);
  }

  /// Get ExercicesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ExercicesApi getExercicesApi() {
    return ExercicesApi(dio, serializers);
  }

  /// Get LivresApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  LivresApi getLivresApi() {
    return LivresApi(dio, serializers);
  }

  /// Get LveApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  LveApi getLveApi() {
    return LveApi(dio, serializers);
  }

  /// Get MatiresApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MatiresApi getMatiresApi() {
    return MatiresApi(dio, serializers);
  }

  /// Get NiveauxApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  NiveauxApi getNiveauxApi() {
    return NiveauxApi(dio, serializers);
  }
}
