import 'package:permission_handler/permission_handler.dart';

/// Service pour gérer les permissions de l'application
class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;

  PermissionService._internal();

  /// Demander les permissions nécessaires pour l'application
  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    final permissions = [
      Permission.storage, // Pour Android < 13
      Permission.photos, // Pour Android 13+
      Permission.audio, // Pour la lecture audio
      Permission.notification, // Pour les notifications
    ];

    final statuses = await permissions.request();
    return statuses;
  }

  /// Vérifier si une permission est accordée
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Demander une permission spécifique
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Vérifier et demander les permissions de stockage
  Future<bool> requestStoragePermission() async {
    if (await isPermissionGranted(Permission.storage)) {
      return true;
    }
    return await requestPermission(Permission.storage);
  }

  /// Vérifier et demander les permissions de photos (Android 13+)
  Future<bool> requestPhotosPermission() async {
    if (await isPermissionGranted(Permission.photos)) {
      return true;
    }
    return await requestPermission(Permission.photos);
  }

  /// Vérifier et demander les permissions audio
  Future<bool> requestAudioPermission() async {
    if (await isPermissionGranted(Permission.audio)) {
      return true;
    }
    return await requestPermission(Permission.audio);
  }

  /// Vérifier et demander les permissions de notifications
  Future<bool> requestNotificationPermission() async {
    if (await isPermissionGranted(Permission.notification)) {
      return true;
    }
    return await requestPermission(Permission.notification);
  }

  /// Ouvrir les paramètres de l'application
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Vérifier si les permissions sont refusées de manière permanente
  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }
}

