import 'package:edugo/services/auth_service.dart';
import 'package:edugo/models/notification.dart' as NotificationModel;
import 'package:dio/dio.dart';

/// Service pour gérer les notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final AuthService _authService = AuthService();

  NotificationService._internal();

  /// Récupérer le nombre de notifications non lues
  /// Endpoint: GET /api/eleve/{eleveId}/notifications/unread-count
  /// Ou: GET /api/notifications/unread-count?eleveId={eleveId}
  Future<int> getUnreadNotificationCount(int eleveId) async {
    try {
      // Essayer plusieurs endpoints possibles
      try {
        final response = await _authService.dio.get(
          '/api/eleve/$eleveId/notifications/unread-count',
        );
        if (response.statusCode == 200) {
          final data = response.data;
          if (data is Map && data.containsKey('count')) {
            return (data['count'] as num).toInt();
          } else if (data is int) {
            return data;
          } else if (data is Map && data.containsKey('unreadCount')) {
            return (data['unreadCount'] as num).toInt();
          }
        }
      } catch (e) {
        // Essayer un autre endpoint
        print('[NotificationService] Premier endpoint échoué, essai alternatif: $e');
      }

      // Endpoint alternatif
      try {
        final response = await _authService.dio.get(
          '/api/notifications/unread-count',
          queryParameters: {'eleveId': eleveId},
        );
        if (response.statusCode == 200) {
          final data = response.data;
          if (data is Map && data.containsKey('count')) {
            return (data['count'] as num).toInt();
          } else if (data is int) {
            return data;
          } else if (data is Map && data.containsKey('unreadCount')) {
            return (data['unreadCount'] as num).toInt();
          }
        }
      } catch (e) {
        print('[NotificationService] Endpoint alternatif échoué: $e');
      }

      // Endpoint alternatif 2: GET /api/notifications?eleveId={eleveId}&unreadOnly=true
      try {
        final response = await _authService.dio.get(
          '/api/notifications',
          queryParameters: {
            'eleveId': eleveId,
            'unreadOnly': true,
          },
        );
        if (response.statusCode == 200) {
          final data = response.data;
          if (data is List) {
            return data.length;
          }
        }
      } catch (e) {
        print('[NotificationService] Endpoint alternatif 2 échoué: $e');
      }
    } catch (e) {
      print('[NotificationService] Erreur lors de la récupération du nombre de notifications: $e');
    }
    
    // Retourner 0 par défaut si aucun endpoint ne fonctionne
    return 0;
  }

  /// Marquer une notification comme lue
  /// Endpoint: PUT /api/notifications/{notificationId}/read
  Future<bool> markAsRead(int notificationId) async {
    try {
      final response = await _authService.dio.put(
        '/api/notifications/$notificationId/read',
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('[NotificationService] Erreur lors du marquage de la notification comme lue: $e');
      return false;
    }
  }

  /// Marquer toutes les notifications comme lues
  /// Endpoint: PUT /api/eleve/{eleveId}/notifications/mark-all-read
  Future<bool> markAllAsRead(int eleveId) async {
    try {
      final response = await _authService.dio.put(
        '/api/eleve/$eleveId/notifications/mark-all-read',
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('[NotificationService] Erreur lors du marquage de toutes les notifications comme lues: $e');
      return false;
    }
  }

  /// Récupérer toutes les notifications d'un élève
  /// Endpoint: GET /api/eleve/{eleveId}/notifications
  /// Ou: GET /api/notifications?eleveId={eleveId}
  Future<List<NotificationModel.NotificationModel>> getAllNotifications(int eleveId) async {
    try {
      // Essayer le premier endpoint
      try {
        final response = await _authService.dio.get(
          '/api/eleve/$eleveId/notifications',
        );
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          if (data is List) {
            return data.map((json) => NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
          } else if (data is Map && data.containsKey('notifications')) {
            final notifications = data['notifications'] as List;
            return notifications.map((json) => NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
          }
        }
      } catch (e) {
        print('[NotificationService] Premier endpoint échoué, essai alternatif: $e');
      }

      // Endpoint alternatif
      try {
        final response = await _authService.dio.get(
          '/api/notifications',
          queryParameters: {'eleveId': eleveId},
        );
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          if (data is List) {
            return data.map((json) => NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
          } else if (data is Map && data.containsKey('notifications')) {
            final notifications = data['notifications'] as List;
            return notifications.map((json) => NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
          }
        }
      } catch (e) {
        print('[NotificationService] Endpoint alternatif échoué: $e');
      }
    } catch (e) {
      print('[NotificationService] Erreur lors de la récupération des notifications: $e');
    }
    
    // Retourner une liste vide par défaut
    return [];
  }
}

