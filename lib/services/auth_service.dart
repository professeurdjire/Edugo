// auth_service.dart
import 'package:dio/dio.dart';
import 'package:edugo/models/login_request.dart';
import 'package:edugo/models/login_response.dart';
import 'package:edugo/models/register_request.dart';
import 'package:edugo/models/eleveProfileData.dart'; // ← NOUVEL IMPORT
import 'package:edugo/services/serializers.dart';
import 'package:built_value/serializer.dart';
import 'package:edugo/models/eleve.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb; // Add web detection

class AuthService {
  static final AuthService _instance = AuthService._internal();

  late Dio _dio;
  Eleve? _currentEleve;

  int? get currentUserId => _currentEleve?.id;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    _dio = Dio();
    
    // Configuration for different environments
    // Backend Spring Boot écoute sur http://192.168.10.117:8080/api (context-path=/api)
    // Pour BlueStacks/émulateur Android, utiliser 10.0.2.2:8080/api (localhost de la machine hôte)
    // Pour appareil physique Android, utiliser 192.168.10.117:8080/api
    // Pour web, utiliser localhost:8080/api
    
    String baseUrl;
    
    try {
      if (kIsWeb) {
        // Web platform - use localhost for development
        baseUrl = 'http://localhost:8080/api';
      } else if (Platform.isAndroid) {
        // TODO: Définir IS_EMULATOR à true pour BlueStacks, false pour appareil physique
        const bool IS_EMULATOR = false; // ← MODIFIER ICI: true pour BlueStacks, false pour appareil physique
        
        if (IS_EMULATOR) {
          // BlueStacks ou autre émulateur Android - utilise 10.0.2.2 pour accéder au localhost de la machine hôte
          baseUrl = 'http://10.0.2.2:8080/api';
        } else {
          // Appareil Android physique - utilise l'IP réseau de la machine où tourne Spring Boot
          // ⚠️ IMPORTANT: Vérifiez que cette IP correspond à l'IP de votre machine (voir ipconfig)
          // L'appareil Android et votre PC doivent être sur le même réseau Wi-Fi
          // ⚠️ NOTE: Le backend Swagger contient deux fois /api, donc baseUrl = /api et endpoints = /api/... pour avoir /api/api/...
          baseUrl = 'http://192.168.1.11:8080/api';
        }
      } else if (Platform.isIOS) {
        // iOS - utiliser localhost pour simulateur ou IP réseau pour appareil physique
        baseUrl = 'http://192.168.10.117:8080/api';
        // Pour iOS simulator: baseUrl = 'http://localhost:8080/api';
      } else {
        // Other platforms (including web) - default to localhost
        baseUrl = 'http://localhost:8080/api';
      }
    } catch (e) {
      // Platform detection may not work, default to localhost for web development
      baseUrl = 'http://localhost:8080/api';
    }
    
    _dio.options.baseUrl = baseUrl;
    _dio.options.contentType = 'application/json';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Ajouter un intercepteur pour s'assurer que le token est toujours envoyé
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // TOUJOURS s'assurer que le header Authorization est présent
        // D'abord, vérifier dans les headers globaux
        var authHeader = _dio.options.headers['Authorization'];
        
        // Si le token n'est pas dans les headers globaux ou est invalide, essayer de le récupérer
        if (authHeader == null || 
            authHeader.toString().isEmpty || 
            !authHeader.toString().startsWith('Bearer ')) {
          final token = getAuthToken();
          if (token != null && token.isNotEmpty) {
            authHeader = 'Bearer $token';
            _dio.options.headers['Authorization'] = authHeader;
            print('[AuthService Interceptor] Token récupéré et ajouté aux headers globaux');
          } else {
            print('[AuthService Interceptor] ⚠️ ATTENTION: Impossible de récupérer un token valide');
          }
        }
        
        // S'assurer que le token est dans cette requête spécifique
        if (authHeader != null && 
            authHeader.toString().isNotEmpty && 
            authHeader.toString().startsWith('Bearer ')) {
          options.headers['Authorization'] = authHeader;
          print('[AuthService Interceptor] ✅ Token présent pour: ${options.method} ${options.uri}');
        } else {
          // Ne pas bloquer les requêtes publiques (login, register, etc.)
          final isPublicEndpoint = options.uri.path.contains('/auth/login') || 
                                   options.uri.path.contains('/auth/register') ||
                                   options.uri.path.contains('/auth/refresh');
          
          if (!isPublicEndpoint) {
            print('[AuthService Interceptor] ⚠️ ATTENTION: Aucun token trouvé pour: ${options.method} ${options.uri}');
            print('[AuthService Interceptor] Headers globaux: ${_dio.options.headers.keys}');
            print('[AuthService Interceptor] AuthHeader value: $authHeader');
          }
        }
        
        return handler.next(options);
      },
      onError: (error, handler) {
        // Log détaillé des erreurs d'authentification
        if (error.response?.statusCode == 403 || error.response?.statusCode == 401) {
          print('[AuthService Interceptor] ⚠️ Erreur d\'authentification (${error.response?.statusCode})');
          print('[AuthService Interceptor] URL: ${error.requestOptions.uri}');
          print('[AuthService Interceptor] Method: ${error.requestOptions.method}');
          print('[AuthService Interceptor] Headers envoyés: ${error.requestOptions.headers}');
          print('[AuthService Interceptor] Token dans headers: ${error.requestOptions.headers.containsKey('Authorization') ? "Oui" : "Non"}');
          print('[AuthService Interceptor] Réponse du serveur: ${error.response?.data}');
          
          // Si c'est une erreur 403, vérifier si le token est présent
          if (error.response?.statusCode == 403) {
            final hasToken = error.requestOptions.headers.containsKey('Authorization') && 
                           error.requestOptions.headers['Authorization'] != null &&
                           error.requestOptions.headers['Authorization'].toString().isNotEmpty;
            
            if (!hasToken) {
              print('[AuthService Interceptor] ❌ ERREUR CRITIQUE: Token manquant dans la requête 403!');
            } else {
              print('[AuthService Interceptor] ⚠️ Token présent mais accès refusé (403). Vérifiez les permissions.');
            }
          }
        }
        return handler.next(error);
      },
    ));
    
    print('🔧 Configuration du service d\'authentification:');
    print('   Plateforme: ${kIsWeb ? "Web" : Platform.isAndroid ? "Android" : Platform.isIOS ? "iOS" : "Other"}');
    print('   Base URL: $baseUrl');
    print('   Content-Type: ${_dio.options.contentType}');
    print('   ⚠️ IMPORTANT: Assurez-vous que:');
    print('      1. Le backend Spring Boot est démarré sur le port 8080');
    print('      2. Votre appareil Android et votre PC sont sur le même réseau Wi-Fi');
    print('      3. Le firewall Windows autorise les connexions sur le port 8080');
    print('      4. L\'IP $baseUrl est accessible depuis votre appareil Android');
  }

  Dio get dio => _dio; // Getter public pour l'instance Dio

  // Getters pour l'utilisateur courant
  Eleve? get currentEleve => _currentEleve;
  String get userName => '${_currentEleve?.prenom ?? ''} ${_currentEleve?.nom ?? ''}'.trim();
  String get userPhoto => _currentEleve?.photoProfil ?? '';
  int get userPoints => _currentEleve?.pointAccumule ?? 0;

  // ✅ MÉTHODE CORRIGÉE : Utilise EleveProfileData
  Future<EleveProfileData?> getCurrentUserProfile() async {
    try {
      print('🔄 Tentative de récupération du profil utilisateur depuis: ${_dio.options.baseUrl}/auth/me');
      final response = await _dio.get('/auth/me');

      if (response.statusCode == 200) {
        print('✅ Réponse /auth/me reçue: ${response.data}');

        // ✅ UTILISE EleveProfileData.fromJson
        final profileData = EleveProfileData.fromJson(response.data);

        // Convertir en Eleve et stocker
        _updateCurrentEleveFromProfile(profileData);

        return profileData;
      } else {
        print('⚠️ Code de statut inattendu: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du profil via /auth/me: $e');
      if (e is DioException) {
        print('🌐 Détails de l\'erreur réseau:');
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Réponse: ${e.response?.data}');
        print('   Code de statut: ${e.response?.statusCode}');
      }
    }
    return null;
  }

  // ✅ MÉTHODE CORRIGÉE : Accepte EleveProfileData
  void _updateCurrentEleveFromProfile(EleveProfileData profile) {
    _currentEleve = Eleve((b) => b
      ..id = profile.id
      ..nom = profile.nom
      ..prenom = profile.prenom
      ..email = profile.email
      ..photoProfil = profile.photoProfil
      ..pointAccumule = profile.pointAccumule
      ..role = EleveRoleEnum.ELEVE
      ..estActive = true
      ..enabled = true
      ..accountNonExpired = true
      ..accountNonLocked = true
      ..credentialsNonExpired = true
    );

    print('✅ Données utilisateur mises à jour: ${profile.nom} ${profile.prenom}');
  }

  // Méthode pour récupérer le profil élève par ID
  Future<Eleve?> getEleveProfileById(int eleveId) async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/eleve/profil/$eleveId');

      if (response.statusCode == 200) {
        final eleveData = standardSerializers.deserializeWith(Eleve.serializer, response.data);
        _currentEleve = eleveData;
        return eleveData;
      }
    } catch (e) {
      print('Erreur lors de la récupération du profil élève: $e');
    }
    return null;
  }

  // Stocker l'élève après connexion
  void setCurrentEleve(Eleve eleve) {
    _currentEleve = eleve;
  }

  // Méthode login
  Future<LoginResponse?> login(String email, String password) async {
    try {
      print('🔄 Tentative de connexion avec l\'email: $email');
      print('🌐 URL de connexion: ${_dio.options.baseUrl}/auth/login');
      
      final loginRequest = LoginRequest((b) => b
        ..email = email
        ..motDePasse = password);

      final serialized = standardSerializers.serialize(loginRequest);
      final response = await _dio.post('/api/auth/login', data: serialized);

      print('✅ Réponse de connexion reçue avec code: ${response.statusCode}');
      
      final loginResponse = standardSerializers.deserializeWith(LoginResponse.serializer, response.data);

      if (loginResponse != null && loginResponse.token != null) {
        print('🔑 Token JWT reçu, configuration de l\'authentification...');
        setAuthToken(loginResponse.token!);
        await getCurrentUserProfile(); // ✅ Charge les données automatiquement
      }

      return loginResponse;
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      if (e is DioException) {
        print('🌐 Détails de l\'erreur réseau:');
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Réponse: ${e.response?.data}');
        print('   Code de statut: ${e.response?.statusCode}');
      }
      return null;
    }
  }

  /// Inscription d'un nouvel elève
  Future<LoginResponse?> register({
    required String email,
    required String motDePasse,
    required String nom,
    required String prenom,
    required String ville,
    String? photoProfil,
    required int classeId,
    required int telephone,
    required int niveauId,
  }) async {
    try {
      print('🎯 DONNÉES REÇUES DANS register():');
      print('📧 Email: $email');
      print('👤 Nom: $nom, Prénom: $prenom');
      print('🏙️ Ville reçue: "$ville"');
      print('🌐 URL d\'inscription: ${_dio.options.baseUrl}/auth/register');

      final registerRequest = RegisterRequest((b) => b
        ..email = email
        ..motDePasse = motDePasse
        ..nom = nom
        ..prenom = prenom
        ..ville = ville
        ..photoProfil = photoProfil
        ..classeId = classeId
        ..telephone = telephone
        ..niveauId = niveauId
      );

      final serialized = standardSerializers.serialize(registerRequest);
      final response = await _dio.post('/api/auth/register', data: serialized);

      print('✅ Réponse d\'inscription reçue avec code: ${response.statusCode}');

      final loginResponse = standardSerializers.deserializeWith(LoginResponse.serializer, response.data);

      // Après l'inscription, récupérez aussi le profil
      if (loginResponse != null && loginResponse.token != null) {
        print('🔑 Token JWT reçu, configuration de l\'authentification...');
        setAuthToken(loginResponse.token!);
        await getCurrentUserProfile(); // ✅ Charge les données automatiquement
      }

      return loginResponse;
    } catch (e) {
      print('❌ ERREUR INSCRIPTION: $e');
      if (e is DioException) {
        print('🌐 Détails de l\'erreur réseau:');
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        print('   Réponse: ${e.response?.data}');
        print('   Code de statut: ${e.response?.statusCode}');
      }
      return null;
    }
  }

  /// Refresh JWT token
  Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/api/auth/refresh', data: {
        'refreshToken': refreshToken,
      });

      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Refresh token error: $e');
      return null;
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      await _dio.post('/api/auth/logout');
      _dio.options.headers.remove('Authorization');
      _currentEleve = null;
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
  
  /// Set the authorization token for subsequent API calls
  void setAuthToken(String token) {
    if (token.isEmpty) {
      print('⚠️ Tentative de définir un token vide');
      return;
    }
    _dio.options.headers['Authorization'] = 'Bearer $token';
    print('🔑 Token défini dans les headers Dio: Bearer ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
    print('🔑 Headers Dio après définition: ${_dio.options.headers.keys}');
  }
  
  /// Get the current authorization token
  String? getAuthToken() {
    final authHeader = _dio.options.headers['Authorization'];
    if (authHeader is String && authHeader.startsWith('Bearer ')) {
      final token = authHeader.substring(7); // Remove 'Bearer ' prefix
      if (token.isNotEmpty) {
        return token;
      }
    }
    print('⚠️ Aucun token valide trouvé dans les headers Dio');
    print('   Headers disponibles: ${_dio.options.headers.keys}');
    return null;
  }
  
  /// Test the connection to the backend server
  Future<bool> testConnection() async {
    try {
      print('🔍 Test de connexion au serveur backend...');
      print('🌐 URL de test: ${_dio.options.baseUrl}/auth/me');
      
      final response = await _dio.get('/auth/me', options: Options(
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ));
      
      print('✅ Test de connexion réussi. Code de statut: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 401; // 401 means server is reachable but requires auth
    } catch (e) {
      print('❌ Échec du test de connexion: $e');
      if (e is DioException) {
        print('🌐 Détails de l\'erreur:');
        print('   Type: ${e.type}');
        print('   Message: ${e.message}');
        if (e.response != null) {
          print('   Code de statut: ${e.response?.statusCode}');
          print('   Réponse: ${e.response?.data}');
        }
      }
      return false;
    }
  }
}