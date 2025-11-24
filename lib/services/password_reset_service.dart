import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';

/// Service pour gérer la réinitialisation de mot de passe
class PasswordResetService {
  static final PasswordResetService _instance = PasswordResetService._internal();
  
  final AuthService _authService = AuthService();
  
  factory PasswordResetService() {
    return _instance;
  }
  
  PasswordResetService._internal();
  
  Dio get _dio => _authService.dio;
  
  /// Demander la réinitialisation de mot de passe
  /// POST /api/auth/forgot-password
  /// Body: { "email": "user@example.com" }
  Future<PasswordResetResponse> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/api/auth/forgot-password',
        data: {
          'email': email,
        },
      );
      
      if (response.statusCode == 200) {
        return PasswordResetResponse(
          success: response.data['success'] ?? true,
          message: response.data['message'] ?? 'Email envoyé avec succès',
          email: response.data['email'] ?? email,
        );
      } else {
        throw Exception('Erreur lors de la demande de réinitialisation');
      }
    } on DioException catch (e) {
      print('[PasswordResetService] ❌ Erreur lors de la demande de réinitialisation: $e');
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erreur lors de la demande de réinitialisation';
        throw Exception(message);
      }
      throw Exception('Erreur de connexion. Vérifiez votre connexion internet.');
    } catch (e) {
      print('[PasswordResetService] ❌ Erreur inattendue: $e');
      throw Exception('Erreur inattendue: $e');
    }
  }
  
  /// Vérifier si un token de réinitialisation est valide
  /// POST /api/auth/reset-password/verify
  /// Body: { "token": "abc123..." }
  Future<PasswordResetVerifyResponse> verifyToken(String token) async {
    try {
      final response = await _dio.post(
        '/api/auth/reset-password/verify',
        data: {
          'token': token,
        },
      );
      
      if (response.statusCode == 200) {
        return PasswordResetVerifyResponse(
          success: response.data['success'] ?? true,
          message: response.data['message'] ?? 'Token valide',
          email: response.data['email'],
        );
      } else {
        throw Exception('Token invalide ou expiré');
      }
    } on DioException catch (e) {
      print('[PasswordResetService] ❌ Erreur lors de la vérification du token: $e');
      if (e.response?.statusCode == 404) {
        throw Exception('Token invalide ou expiré');
      }
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erreur lors de la vérification du token';
        throw Exception(message);
      }
      throw Exception('Erreur de connexion. Vérifiez votre connexion internet.');
    } catch (e) {
      print('[PasswordResetService] ❌ Erreur inattendue: $e');
      throw Exception('Erreur inattendue: $e');
    }
  }
  
  /// Réinitialiser le mot de passe avec un token
  /// POST /api/auth/reset-password
  /// Body: {
  ///   "token": "abc123...",
  ///   "nouveauMotDePasse": "newPassword123",
  ///   "confirmationMotDePasse": "newPassword123"
  /// }
  Future<PasswordResetResponse> resetPassword({
    required String token,
    required String nouveauMotDePasse,
    required String confirmationMotDePasse,
  }) async {
    try {
      // Vérifier que les mots de passe correspondent
      if (nouveauMotDePasse != confirmationMotDePasse) {
        throw Exception('Les mots de passe ne correspondent pas');
      }
      
      // Vérifier la longueur minimale du mot de passe
      if (nouveauMotDePasse.length < 6) {
        throw Exception('Le mot de passe doit contenir au moins 6 caractères');
      }
      
      final response = await _dio.post(
        '/api/auth/reset-password',
        data: {
          'token': token,
          'nouveauMotDePasse': nouveauMotDePasse,
          'confirmationMotDePasse': confirmationMotDePasse,
        },
      );
      
      if (response.statusCode == 200) {
        return PasswordResetResponse(
          success: response.data['success'] ?? true,
          message: response.data['message'] ?? 'Mot de passe réinitialisé avec succès',
          email: response.data['email'],
        );
      } else {
        throw Exception('Erreur lors de la réinitialisation du mot de passe');
      }
    } on DioException catch (e) {
      print('[PasswordResetService] ❌ Erreur lors de la réinitialisation: $e');
      if (e.response?.statusCode == 400) {
        final message = e.response?.data['message'] ?? 'Les mots de passe ne correspondent pas';
        throw Exception(message);
      }
      if (e.response?.statusCode == 404) {
        throw Exception('Token invalide ou expiré');
      }
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erreur lors de la réinitialisation';
        throw Exception(message);
      }
      throw Exception('Erreur de connexion. Vérifiez votre connexion internet.');
    } catch (e) {
      if (e.toString().contains('correspondent pas') || e.toString().contains('6 caractères')) {
        rethrow;
      }
      print('[PasswordResetService] ❌ Erreur inattendue: $e');
      throw Exception('Erreur inattendue: $e');
    }
  }
}

/// Réponse de la demande de réinitialisation
class PasswordResetResponse {
  final bool success;
  final String message;
  final String? email;
  
  PasswordResetResponse({
    required this.success,
    required this.message,
    this.email,
  });
}

/// Réponse de la vérification du token
class PasswordResetVerifyResponse {
  final bool success;
  final String message;
  final String? email;
  
  PasswordResetVerifyResponse({
    required this.success,
    required this.message,
    this.email,
  });
}

