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
    
    // TODO: Définir IS_EMULATOR à true pour BlueStacks, false pour appareil physique
    const bool IS_EMULATOR = true; // ← MODIFIER ICI: true pour BlueStacks, false pour appareil physique
    
    String baseUrl;
    
    try {
      if (Platform.isAndroid) {
        if (IS_EMULATOR) {
          // BlueStacks ou autre émulateur Android - utilise 10.0.2.2 pour accéder au localhost de la machine hôte
          baseUrl = 'http://10.0.2.2:8080/api';
        } else {
          // Appareil Android physique - utilise l'IP réseau de la machine où tourne Spring Boot
          baseUrl = 'http://192.168.1.7:8080/api';
        }
      } else if (Platform.isIOS) {
        // iOS - utiliser localhost pour simulateur ou IP réseau pour appareil physique
        baseUrl = 'http://192.168.10.117:8080/api';
        // Pour iOS simulator: baseUrl = 'http://localhost:8080/api';
      } else {
        // Web ou autre plateforme
        baseUrl = 'http://192.168.1.7:8080/api';
      }
    } catch (e) {
      // Platform detection may not work, default to emulator address
      baseUrl = 'http://10.0.2.2:8080/api';
    }
    
    _dio.options.baseUrl = baseUrl;
    _dio.options.contentType = 'application/json';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    print('🔧 Configuration du service d\'authentification:');
    print('   Plateforme: ${Platform.isAndroid ? (IS_EMULATOR ? "Android Emulator (BlueStacks)" : "Android Physical") : "iOS/Other"}');
    print('   Base URL: $baseUrl');
    print('   Content-Type: ${_dio.options.contentType}');
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
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
  
  /// Test the connection to the backend server
  Future<bool> testConnection() async {
    try {
      print('🔍 Test de connexion au serveur backend...');
      print('🌐 URL de test: ${_dio.options.baseUrl}/auth/me');
      
      final response = await _dio.get('/api/auth/me', options: Options(
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