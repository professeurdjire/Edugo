import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:edugo/models/eleve.dart';
import 'package:edugo/services/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

/// Configuration de l'API EDUGO.
///
/// Par défaut l'application tourne en MODE DÉMO : aucun appel réseau,
/// les opérations d'authentification simulent une réussite (comportement
/// historique de l'app, utile tant que le backend n'est pas déployé).
///
/// Pour brancher le vrai backend :
///   flutter run --dart-define=EDUGO_DEMO=false \
///               --dart-define=EDUGO_API_URL=https://votre-backend.exemple
class ApiConfig {
  static const bool demoMode =
      bool.fromEnvironment('EDUGO_DEMO', defaultValue: true);

  static const String baseUrl = String.fromEnvironment(
    'EDUGO_API_URL',
    // Placeholder : à remplacer par l'URL réelle du backend EDUGO.
    defaultValue: 'https://api.edugo.example',
  );

  static const Duration timeout = Duration(seconds: 15);
}

/// Erreur d'API présentable à l'utilisateur (message en français).
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Service d'authentification EDUGO (issue #3).
///
/// Endpoints attendus côté backend (à aligner avec l'API réelle) :
///   POST /auth/login              {email, motDePasse} -> {token, eleve}
///   POST /auth/register           {eleve..., motDePasse} -> {token, eleve}
///   POST /auth/mot-de-passe/oubli {email} -> 204
///   POST /auth/mot-de-passe/reinitialiser {email, code, nouveau} -> 204
///                                 (code à 6 chiffres reçu par e-mail)
///   POST /auth/mot-de-passe       {ancien, nouveau} (Bearer) -> {token}
///                                 (les jetons antérieurs sont invalidés)
///   POST /auth/logout             (Bearer) -> 204
///   PUT  /eleves/moi              {eleve...} (Bearer) -> {eleve}
///   POST /suggestions             {message} (Bearer) -> 204
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final SecureStorageService _storage = SecureStorageService.instance;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final String? token = await _storage.readToken();
      if (token == null) {
        throw const ApiException('Session expirée, reconnectez-vous.');
      }
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Traduit les erreurs réseau/HTTP en messages présentables.
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(ApiConfig.timeout);
    } on SocketException {
      throw const ApiException(
          'Impossible de contacter le serveur. Vérifiez votre connexion.');
    } on TimeoutException {
      throw const ApiException('Le serveur met trop de temps à répondre.');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode == 401) {
      throw const ApiException('Email ou mot de passe incorrect.',
          statusCode: 401);
    }
    if (response.statusCode >= 400) {
      String message = 'Une erreur est survenue (${response.statusCode}).';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['message'] is String) {
          message = decoded['message'] as String;
        }
      } catch (_) {}
      throw ApiException(message, statusCode: response.statusCode);
    }
    if (response.body.isEmpty) return const {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> _storeSession(Map<String, dynamic> data,
      {Eleve? fallback}) async {
    final String? token = data['token'] as String?;
    if (token != null) await _storage.saveToken(token);
    final dynamic eleveJson = data['eleve'];
    if (eleveJson is Map<String, dynamic>) {
      await _storage.saveEleve(Eleve.fromJson(eleveJson));
    } else if (fallback != null) {
      await _storage.saveEleve(fallback);
    }
  }

  /// Vrai si une session (jeton) est présente localement.
  Future<bool> hasSession() async => await _storage.readToken() != null;

  Future<void> login({required String email, required String password}) async {
    if (ApiConfig.demoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      await _storage.saveToken('demo-token');
      return;
    }
    final response = await _send(() => http.post(
          _uri('/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'motDePasse': password}),
        ));
    await _storeSession(_decode(response));
  }

  Future<void> register({required Eleve eleve, required String password}) async {
    if (ApiConfig.demoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      await _storage.saveToken('demo-token');
      await _storage.saveEleve(eleve);
      return;
    }
    final response = await _send(() => http.post(
          _uri('/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({...eleve.toJson(), 'motDePasse': password}),
        ));
    await _storeSession(_decode(response), fallback: eleve);
  }

  Future<void> requestPasswordReset({required String email}) async {
    if (ApiConfig.demoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      return;
    }
    final response = await _send(() => http.post(
          _uri('/auth/mot-de-passe/oubli'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        ));
    _decode(response);
  }

  /// Consomme le code à 6 chiffres reçu par e-mail pour définir un
  /// nouveau mot de passe (les jetons existants sont invalidés).
  Future<void> resetPasswordWithCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    if (ApiConfig.demoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      return;
    }
    final response = await _send(() => http.post(
          _uri('/auth/mot-de-passe/reinitialiser'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {'email': email, 'code': code, 'nouveau': newPassword}),
        ));
    _decode(response);
  }

  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    if (ApiConfig.demoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      return;
    }
    final response = await _send(() async => http.post(
          _uri('/auth/mot-de-passe'),
          headers: await _headers(auth: true),
          body: jsonEncode({'ancien': oldPassword, 'nouveau': newPassword}),
        ));
    // Le backend invalide les jetons antérieurs et en renvoie un neuf.
    final Map<String, dynamic> data = _decode(response);
    final String? token = data['token'] as String?;
    if (token != null) await _storage.saveToken(token);
  }

  /// Profil de l'élève connecté, tel que stocké localement.
  Future<Eleve?> currentEleve() => _storage.readEleve();

  /// Met à jour le profil de l'élève connecté (et le cache local).
  Future<void> updateProfile(Eleve eleve) async {
    if (ApiConfig.demoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      await _storage.saveEleve(eleve);
      return;
    }
    final response = await _send(() async => http.put(
          _uri('/eleves/moi'),
          headers: await _headers(auth: true),
          body: jsonEncode(eleve.toJson()),
        ));
    _decode(response);
    await _storage.saveEleve(eleve);
  }

  /// Envoie une suggestion d'amélioration.
  Future<void> sendSuggestion(String message) async {
    if (ApiConfig.demoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return;
    }
    final response = await _send(() async => http.post(
          _uri('/suggestions'),
          headers: await _headers(auth: true),
          body: jsonEncode({'message': message}),
        ));
    _decode(response);
  }

  /// Déconnexion : efface la session locale (et notifie le backend
  /// silencieusement quand il est branché).
  Future<void> logout() async {
    if (!ApiConfig.demoMode) {
      try {
        await _send(() async =>
            http.post(_uri('/auth/logout'), headers: await _headers(auth: true)));
      } catch (_) {
        // La déconnexion locale prime : on ignore les erreurs réseau.
      }
    }
    await _storage.clearSession();
  }
}
