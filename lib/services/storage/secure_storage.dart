import 'dart:convert';

import 'package:edugo/models/eleve.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stockage sécurisé de la session (jeton d'authentification et profil
/// de l'élève connecté).
class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  static const String _tokenKey = 'edugo_auth_token';
  static const String _eleveKey = 'edugo_eleve';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<void> saveEleve(Eleve eleve) {
    return _storage.write(key: _eleveKey, value: jsonEncode(eleve.toJson()));
  }

  Future<Eleve?> readEleve() async {
    final String? raw = await _storage.read(key: _eleveKey);
    if (raw == null) return null;
    try {
      return Eleve.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Efface toute la session (déconnexion).
  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _eleveKey);
  }
}
