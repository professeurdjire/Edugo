import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service pour gérer la connectivité réseau
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectionController;
  Stream<bool>? _connectionStream;
  bool _isConnected = true;

  ConnectivityService._internal() {
    _init();
  }

  void _init() {
    _connectionController = StreamController<bool>.broadcast();
    _connectionStream = _connectionController!.stream;
    
    // Vérifier l'état initial
    _checkConnectivity();
    
    // Écouter les changements de connectivité
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
  }

  /// Vérifier l'état de la connectivité
  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('[ConnectivityService] Erreur lors de la vérification: $e');
      _isConnected = false;
      _connectionController?.add(false);
    }
  }

  /// Mettre à jour le statut de connexion
  void _updateConnectionStatus(dynamic result) {
    final wasConnected = _isConnected;
    
    // Gérer les deux formats possibles (List ou ConnectivityResult)
    bool isConnectedNow = false;
    if (result is List<ConnectivityResult>) {
      isConnectedNow = result.any((r) => r != ConnectivityResult.none);
    } else if (result is ConnectivityResult) {
      isConnectedNow = result != ConnectivityResult.none;
    }
    
    _isConnected = isConnectedNow;
    
    if (wasConnected != _isConnected) {
      print('[ConnectivityService] Statut de connexion: ${_isConnected ? "Connecté" : "Hors ligne"}');
      _connectionController?.add(_isConnected);
    }
  }

  /// Vérifier si l'appareil est connecté
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      return _isConnected;
    } catch (e) {
      print('[ConnectivityService] Erreur: $e');
      return false;
    }
  }

  /// Obtenir le stream de connexion
  Stream<bool> get connectionStream => _connectionStream ?? const Stream<bool>.empty();

  /// Obtenir l'état actuel de connexion
  bool get isConnectedNow => _isConnected;

  /// Disposer des ressources
  void dispose() {
    _connectionController?.close();
  }
}

