// auth_service.dart
import 'package:dio/dio.dart';
import 'package:edugo/models/login_request.dart';
import 'package:edugo/models/login_response.dart';
import 'package:edugo/models/register_request.dart';
import 'package:edugo/models/eleveProfileData.dart'; // ← NOUVEL IMPORT
import 'package:edugo/services/serializers.dart';
import 'package:built_value/serializer.dart';
import 'package:edugo/models/eleve.dart';

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
    _dio.options.baseUrl = 'http://localhost:8080';
    _dio.options.contentType = 'application/json';
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
      final response = await _dio.get('/api/auth/me');

      if (response.statusCode == 200) {
        print('✅ Réponse /auth/me reçue: ${response.data}');

        // ✅ UTILISE EleveProfileData.fromJson
        final profileData = EleveProfileData.fromJson(response.data);

        // Convertir en Eleve et stocker
        _updateCurrentEleveFromProfile(profileData);

        return profileData;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du profil via /auth/me: $e');
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
      final response = await _dio.get('/api/api/eleve/profil/$eleveId');

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
      final loginRequest = LoginRequest((b) => b
        ..email = email
        ..motDePasse = password);

      final serialized = standardSerializers.serialize(loginRequest);
      final response = await _dio.post('/api/auth/login', data: serialized);

      final loginResponse = standardSerializers.deserializeWith(LoginResponse.serializer, response.data);

      if (loginResponse != null && loginResponse.token != null) {
        setAuthToken(loginResponse.token!);
        await getCurrentUserProfile(); // ✅ Charge les données automatiquement
      }

      return loginResponse;
    } catch (e) {
      print('Login error: $e');
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
      print('🏙️ Ville reçue: "$ville"');

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

      final loginResponse = standardSerializers.deserializeWith(LoginResponse.serializer, response.data);

      // Après l'inscription, récupérez aussi le profil
      if (loginResponse != null && loginResponse.token != null) {
        setAuthToken(loginResponse.token!);
        await getCurrentUserProfile(); // ✅ Charge les données automatiquement
      }

      return loginResponse;
    } catch (e) {
      print('❌ ERREUR INSCRIPTION: $e');
      if (e is DioException) {
        print('🔍 STATUT ERREUR: ${e.response?.statusCode}');
        print('🔍 DONNÉES ERREUR: ${e.response?.data}');
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
}