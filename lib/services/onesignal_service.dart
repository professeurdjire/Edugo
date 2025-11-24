import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:edugo/services/auth_service.dart';

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
      const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';

      // Initialiser OneSignal
      OneSignal.initialize(oneSignalAppId);

      // Demander la permission pour les notifications
      OneSignal.Notifications.requestPermission(true);

      // Obtenir le Player ID (identifiant unique de l'appareil)
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
      // Vous pouvez naviguer vers une page spécifique ici
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
}

