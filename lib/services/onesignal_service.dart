import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/notification_routing_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OneSignalService {
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;

  final AuthService _authService = AuthService();
  bool _isInitialized = false;
  String? _playerId;

  OneSignalService._internal();

  /// Initialiser OneSignal
  /// Remplacez 'YOUR_ONESIGNAL_APP_ID' par votre App ID OneSignal
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // ⚠️ IMPORTANT: Remplacez par votre App ID OneSignal
      // Vous pouvez le trouver dans votre dashboard OneSignal
      const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID'; // TODO: Remplacer par votre App ID

      // Initialiser OneSignal
      OneSignal.initialize(oneSignalAppId);

      // Demander la permission pour les notifications
      final permission = await OneSignal.Notifications.requestPermission(true);
      print('[OneSignalService] Permission granted: $permission');

      // Obtenir le Player ID (identifiant unique de l'appareil)
      // Attendre un peu pour s'assurer que l'initialisation est terminée
      await Future.delayed(const Duration(seconds: 2));
      _playerId = await OneSignal.User.pushSubscription.id;
      print('[OneSignalService] Player ID: $_playerId');

      // Configurer les handlers de notifications
      _setupNotificationHandlers();

      // Associer le Player ID à l'utilisateur connecté
      await _associatePlayerIdWithUser();

      _isInitialized = true;
      print('[OneSignalService] OneSignal initialized successfully');
    } catch (e) {
      print('[OneSignalService] Error initializing OneSignal: $e');
    }
  }

  /// Configurer les handlers de notifications
  void _setupNotificationHandlers() {
    // Handler pour les notifications reçues en arrière-plan
    OneSignal.Notifications.addClickListener((event) {
      print('[OneSignalService] Notification clicked: ${event.notification.body}');
      // Les données supplémentaires sont directement accessibles via additionalData
      final data = event.notification.additionalData;
      if (data != null) {
        print('[OneSignalService] Notification data: $data');
        // TODO: Implémenter la navigation vers l'écran approprié
      }
    });

    // Handler pour les notifications reçues en premier plan
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('[OneSignalService] Notification received in foreground: ${event.notification.body}');
      // Vous pouvez personnaliser l'affichage de la notification ici
    });
  }

  /// Associer le Player ID à l'utilisateur connecté
  /// Cela permet au backend d'envoyer des notifications ciblées
  Future<void> _associatePlayerIdWithUser() async {
    final eleveId = _authService.currentUserId;
    if (eleveId != null && _playerId != null) {
      try {
        // Envoyer le Player ID au backend pour l'associer à l'utilisateur
        // Vous devrez créer un endpoint backend pour cela
        // Exemple: POST /api/eleve/{eleveId}/onesignal-player-id
        await _authService.dio.post(
          '/api/eleve/$eleveId/onesignal-player-id',
          data: {'playerId': _playerId},
        );
        print('[OneSignalService] Player ID associated with user $eleveId');
      } catch (e) {
        print('[OneSignalService] Error associating Player ID: $e');
      }
    } else {
      print('[OneSignalService] Cannot associate Player ID - eleveId: $eleveId, playerId: $_playerId');
    }
  }

  /// Obtenir le Player ID
  String? get playerId => _playerId;

  /// Vérifier si OneSignal est initialisé
  bool get isInitialized => _isInitialized;

  /// Envoyer une notification de test (pour le développement)
  Future<void> sendTestNotification() async {
    if (!_isInitialized) {
      print('[OneSignalService] OneSignal not initialized');
      return;
    }

    try {
      // Cette fonctionnalité nécessite généralement un appel au backend
      // qui utilise l'API OneSignal pour envoyer des notifications
      print('[OneSignalService] Test notification would be sent here');
    } catch (e) {
      print('[OneSignalService] Error sending test notification: $e');
    }
  }
  
  /// Gérer la navigation en fonction des données de notification
  void handleNotificationNavigation(BuildContext context, Map<String, dynamic> data) {
    // Utiliser le service de routage pour gérer la navigation
    NotificationRoutingService.handleNotificationNavigationFromPush(context, data);
  }

  /// Récupérer une notification en attente (si l'app a été ouverte via une notification)
  Future<Map<String, dynamic>?> getPendingNotification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingDataJson = prefs.getString('pending_notification');
      if (pendingDataJson != null) {
        return json.decode(pendingDataJson) as Map<String, dynamic>;
      }
    } catch (e) {
      print('[OneSignalService] Error getting pending notification: $e');
    }
    return null;
  }

  /// Effacer une notification en attente
  Future<void> clearPendingNotification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('pending_notification');
    } catch (e) {
      print('[OneSignalService] Error clearing pending notification: $e');
    }
  }

  /// Traiter une notification en attente (si l'app a été ouverte via une notification)
  Future<void> processPendingNotification(BuildContext context) async {
    try {
      final pendingData = await getPendingNotification();
      if (pendingData != null && context.mounted) {
        print('[OneSignalService] Processing pending notification: $pendingData');
        handleNotificationNavigation(context, pendingData);
        await clearPendingNotification();
      }
    } catch (e) {
      print('[OneSignalService] Error processing pending notification: $e');
    }
  }
}