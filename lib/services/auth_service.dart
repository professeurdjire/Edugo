import 'package:dio/dio.dart';
import 'package:edugo/models/login_request.dart';
import 'package:edugo/models/login_response.dart';
import 'package:edugo/models/register_request.dart';
import 'package:edugo/services/serializers.dart';
import 'package:built_value/serializer.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  late Dio _dio;
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8080'; // Update with your actual API URL
    _dio.options.contentType = 'application/json';
  }
  
  /// Login with email and password
  Future<LoginResponse?> login(String email, String password) async {
    try {
      final loginRequest = LoginRequest((b) => b
        ..email = email
        ..motDePasse = password);
      
      final serialized = standardSerializers.serialize(loginRequest);
      final response = await _dio.post('/api/auth/login', data: serialized);
      
      final loginResponse = standardSerializers.deserializeWith(LoginResponse.serializer, response.data);
      return loginResponse;
    } catch (e) {
      // Handle error appropriately
      print('Login error: $e');
      return null;
    }
  }
  
  /// Register a new student
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
      return loginResponse;
    } catch (e) {
      print('Register error: $e');
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
      // Handle error appropriately
      print('Refresh token error: $e');
      return null;
    }
  }
  
  /// Logout user
  Future<bool> logout() async {
    try {
      await _dio.post('/api/auth/logout');
      // Remove authorization header
      _dio.options.headers.remove('Authorization');
      return true;
    } catch (e) {
      // Handle error appropriately
      print('Logout error: $e');
      return false;
    }
  }
  
  /// Set the authorization token for subsequent API calls
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}