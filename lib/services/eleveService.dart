// services/eleve_service.dart
import 'package:dio/dio.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/services/auth_service.dart';

class EleveService {
  static final EleveService _instance = EleveService._internal();

  late Dio _dio;

  factory EleveService() {
    return _instance;
  }

  EleveService._internal() {
    // Utilise l'instance Dio publique d'AuthService via le getter
    _dio = AuthService().dio; // ← CORRECTION : utilisez le getter public
  }

  // Récupérer le profil d'un élève par ID
  Future<Eleve?> getEleveProfile(int eleveId) async {
    try {
      final response = await _dio.get('/api/eleve/profil/$eleveId');

      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(Eleve.serializer, response.data);
      }
    } catch (e) {
      print('Erreur lors de la récupération du profil élève: $e');
    }
    return null;
  }

  // MÉTHODE CORRIGÉE : Accepte Map<String, dynamic> pour la mise à jour
  Future<Eleve?> updateEleveProfile(int eleveId, Map<String, dynamic> updateData) async {
    try {
      print('🔄 Mise à jour du profil élève $eleveId: $updateData');

      final response = await _dio.put(
        '/api/eleve/profil/$eleveId',
        data: updateData
      );

      if (response.statusCode == 200) {
        print('✅ Profil mis à jour avec succès');
        print('📨 Réponse du serveur: ${response.data}');

        // OPTION 1: Si la réponse est un Eleve complet
        try {
          return standardSerializers.deserializeWith(Eleve.serializer, response.data);
        } catch (e) {
          print('⚠️ Erreur désérialisation Eleve: $e');
          // OPTION 2: Si la réponse est juste un message de succès
          // Recharger les données depuis /auth/me
          final authService = AuthService();
          await authService.getCurrentUserProfile();
          return authService.currentEleve;
        }
      } else {
        print('❌ Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du profil élève: $e');
      if (e is DioException) {
        print('🔍 Détails Dio: ${e.response?.statusCode} - ${e.response?.data}');
      }
    }
    return null;
  }


  // NOUVELLE MÉTHODE : Changer le mot de passe
    Future<bool> changePassword(int eleveId, String oldPassword, String newPassword) async {
      try {
        print('🔄 Changement de mot de passe pour l\'élève $eleveId');

        final Map<String, dynamic> passwordData = {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        };

        final response = await _dio.post(
          '/api/eleve/profil/$eleveId/change-password',
          data: passwordData,
        );

        if (response.statusCode == 200) {
          print('✅ Mot de passe changé avec succès');
          print('📨 Réponse: ${response.data}');
          return true;
        } else {
          print('❌ Erreur HTTP: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        print('❌ Erreur lors du changement de mot de passe: $e');
        if (e is DioException) {
          print('🔍 Détails Dio: ${e.response?.statusCode} - ${e.response?.data}');

          // Gérer les erreurs spécifiques
          if (e.response?.statusCode == 400) {
            throw Exception('Ancien mot de passe incorrect');
          } else if (e.response?.statusCode == 401) {
            throw Exception('Non autorisé - Veuillez vous reconnecter');
          }
        }
        rethrow;
      }
    }


  // Récupérer les points de l'élève
  Future<int?> getElevePoints(int eleveId) async {
    try {
      final response = await _dio.get('/api/eleve/points/$eleveId');

      if (response.statusCode == 200) {
        return response.data['points'];
      }
    } catch (e) {
      print('Erreur lors de la récupération des points: $e');
    }
    return null;
  }

  // Définir le token d'authentification (maintenant inutile car partagé avec AuthService)
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}