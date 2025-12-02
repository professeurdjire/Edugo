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
      print('[NotificationService] Fetching unread notification count for student $eleveId');
      // Essayer plusieurs endpoints possibles
      try {
        final response = await _authService.dio.get(
          '/api/eleve/$eleveId/notifications/unread-count',
        );
        print('[NotificationService] Response status: ${response.statusCode}');
        print('[NotificationService] Response data type: ${response.data.runtimeType}');
        print('[NotificationService] Response data: ${response.data}');
        
        if (response.statusCode == 200) {
          final data = response.data;
          if (data is Map && data.containsKey('count')) {
            final count = (data['count'] as num).toInt();
            print('[NotificationService] Found count in response: $count');
            return count;
          } else if (data is int) {
            print('[NotificationService] Response is int: $data');
            return data;
          } else if (data is Map && data.containsKey('unreadCount')) {
            final count = (data['unreadCount'] as num).toInt();
            print('[NotificationService] Found unreadCount in response: $count');
            return count;
          } else {
            print('[NotificationService] ⚠️ Unexpected response format: $data');
          }
        }
      } catch (e) {
        // Essayer un autre endpoint
        print('[NotificationService] Premier endpoint échoué, essai alternatif: $e');
        if (e is DioException) {
          print('[NotificationService] DioException status: ${e.response?.statusCode}');
          print('[NotificationService] DioException data: ${e.response?.data}');
        }
      }

      // Endpoint alternatif
      try {
        final response = await _authService.dio.get(
          '/api/notifications/unread-count',
          queryParameters: {'eleveId': eleveId},
        );
        print('[NotificationService] Alternative endpoint response status: ${response.statusCode}');
        print('[NotificationService] Alternative endpoint response data: ${response.data}');
        if (response.statusCode == 200) {
          final data = response.data;
          if (data is Map && data.containsKey('count')) {
            final count = (data['count'] as num).toInt();
            print('[NotificationService] Found count in alternative response: $count');
            return count;
          } else if (data is int) {
            print('[NotificationService] Alternative response is int: $data');
            return data;
          } else if (data is Map && data.containsKey('unreadCount')) {
            final count = (data['unreadCount'] as num).toInt();
            print('[NotificationService] Found unreadCount in alternative response: $count');
            return count;
          }
        }
      } catch (e) {
        print('[NotificationService] Endpoint alternatif échoué: $e');
        if (e is DioException) {
          print('[NotificationService] DioException status: ${e.response?.statusCode}');
          print('[NotificationService] DioException data: ${e.response?.data}');
        }
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
        print('[NotificationService] Alternative 2 endpoint response status: ${response.statusCode}');
        print('[NotificationService] Alternative 2 endpoint response data: ${response.data}');
        if (response.statusCode == 200) {
          final data = response.data;
          if (data is List) {
            print('[NotificationService] Alternative 2 response is List with ${data.length} items');
            return data.length;
          }
        }
      } catch (e) {
        print('[NotificationService] Endpoint alternatif 2 échoué: $e');
        if (e is DioException) {
          print('[NotificationService] DioException status: ${e.response?.statusCode}');
          print('[NotificationService] DioException data: ${e.response?.data}');
        }
      }
    } catch (e) {
      print('[NotificationService] Erreur lors de la récupération du nombre de notifications: $e');
    }
    
    print('[NotificationService] ⚠️ Aucun endpoint n\'a retourné de données valides, retour de 0 par défaut');
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
  /// Si l'endpoint n'existe pas, marque les notifications individuellement
  Future<bool> markAllAsRead(int eleveId) async {
    try {
      // Essayer d'abord l'endpoint global
      try {
        final response = await _authService.dio.put(
          '/api/eleve/$eleveId/notifications/mark-all-read',
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          print('[NotificationService] All notifications marked as read via global endpoint');
          return true;
        }
      } catch (e) {
        if (e is DioException) {
          final statusCode = e.response?.statusCode;
          if (statusCode == 404) {
            print('[NotificationService] Global mark-all-read endpoint not found (404), trying individual marking');
            // Si l'endpoint global n'existe pas, marquer individuellement
            return await _markAllAsReadIndividually(eleveId);
          }
        }
        print('[NotificationService] Error with global mark-all-read endpoint: $e');
      }
      
      // Essayer un endpoint alternatif
      try {
        final response = await _authService.dio.put(
          '/api/notifications/mark-all-read',
          queryParameters: {'eleveId': eleveId},
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          print('[NotificationService] All notifications marked as read via alternative endpoint');
          return true;
        }
      } catch (e) {
        print('[NotificationService] Alternative mark-all-read endpoint also failed: $e');
        // Essayer de marquer individuellement
        return await _markAllAsReadIndividually(eleveId);
      }
      
      return false;
    } catch (e) {
      print('[NotificationService] Erreur lors du marquage de toutes les notifications comme lues: $e');
      // En dernier recours, essayer de marquer individuellement
      return await _markAllAsReadIndividually(eleveId);
    }
  }
  
  /// Marquer toutes les notifications comme lues individuellement
  /// Cette méthode est utilisée si l'endpoint global n'existe pas
  Future<bool> _markAllAsReadIndividually(int eleveId) async {
    try {
      // Récupérer toutes les notifications non lues
      final notifications = await getAllNotifications(eleveId);
      final unreadNotifications = notifications.where((n) => !(n.lu ?? false)).toList();
      
      if (unreadNotifications.isEmpty) {
        print('[NotificationService] No unread notifications to mark');
        return true;
      }
      
      print('[NotificationService] Marking ${unreadNotifications.length} notifications individually');
      
      // Marquer chaque notification individuellement
      int successCount = 0;
      for (final notification in unreadNotifications) {
        if (notification.id != null) {
          final success = await markAsRead(notification.id!);
          if (success) {
            successCount++;
          }
        }
      }
      
      print('[NotificationService] Successfully marked $successCount/${unreadNotifications.length} notifications as read');
      return successCount > 0;
    } catch (e) {
      print('[NotificationService] Error marking notifications individually: $e');
      return false;
    }
  }

  /// Récupérer toutes les notifications d'un élève
  /// Endpoint: GET /api/eleve/{eleveId}/notifications
  /// Ou: GET /api/notifications?eleveId={eleveId}
  Future<List<NotificationModel.NotificationModel>> getAllNotifications(int eleveId) async {
    try {
      print('[NotificationService] Fetching all notifications for student $eleveId');
      // Essayer le premier endpoint
      try {
        final response = await _authService.dio.get(
          '/api/eleve/$eleveId/notifications',
        );
        print('[NotificationService] Response status: ${response.statusCode}');
        print('[NotificationService] Response data type: ${response.data.runtimeType}');
        print('[NotificationService] Response data: ${response.data}');
        
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          if (data is List) {
            print('[NotificationService] Response is a List with ${data.length} items');
            final notifications = data.map((json) {
              try {
                return NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('[NotificationService] Error parsing notification: $e');
                print('[NotificationService] Notification data: $json');
                return null;
              }
            }).whereType<NotificationModel.NotificationModel>().toList();
            print('[NotificationService] Successfully parsed ${notifications.length} notifications');
            return notifications;
          } else if (data is Map && data.containsKey('notifications')) {
            final notificationsList = data['notifications'] as List;
            print('[NotificationService] Found notifications in Map with ${notificationsList.length} items');
            return notificationsList.map((json) => NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
          } else {
            print('[NotificationService] ⚠️ Unexpected response format: $data');
          }
        }
      } catch (e) {
        print('[NotificationService] Premier endpoint échoué, essai alternatif: $e');
        if (e is DioException) {
          print('[NotificationService] DioException status: ${e.response?.statusCode}');
          print('[NotificationService] DioException data: ${e.response?.data}');
        }
      }

      // Endpoint alternatif
      try {
        final response = await _authService.dio.get(
          '/api/notifications',
          queryParameters: {'eleveId': eleveId},
        );
        print('[NotificationService] Alternative endpoint response status: ${response.statusCode}');
        print('[NotificationService] Alternative endpoint response data type: ${response.data.runtimeType}');
        print('[NotificationService] Alternative endpoint response data: ${response.data}');
        
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          if (data is List) {
            print('[NotificationService] Alternative response is a List with ${data.length} items');
            final notifications = data.map((json) {
              try {
                return NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('[NotificationService] Error parsing notification: $e');
                print('[NotificationService] Notification data: $json');
                return null;
              }
            }).whereType<NotificationModel.NotificationModel>().toList();
            print('[NotificationService] Successfully parsed ${notifications.length} notifications from alternative endpoint');
            return notifications;
          } else if (data is Map && data.containsKey('notifications')) {
            final notificationsList = data['notifications'] as List;
            print('[NotificationService] Found notifications in Map with ${notificationsList.length} items');
            return notificationsList.map((json) => NotificationModel.NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
          } else {
            print('[NotificationService] ⚠️ Unexpected alternative response format: $data');
          }
        }
      } catch (e) {
        print('[NotificationService] Endpoint alternatif échoué: $e');
        if (e is DioException) {
          print('[NotificationService] DioException status: ${e.response?.statusCode}');
          print('[NotificationService] DioException data: ${e.response?.data}');
        }
      }
    } catch (e) {
      print('[NotificationService] Erreur lors de la récupération des notifications: $e');
    }
    
    print('[NotificationService] ⚠️ Aucune notification trouvée, retour d\'une liste vide');
    // Retourner une liste vide par défaut
    return [];
  }
}

