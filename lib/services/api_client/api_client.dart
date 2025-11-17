import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  
  late Dio _dio;
  Dio get dio => _dio;
  
  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    // Initialize Dio
    _dio = Dio();
    
    // Configure base URL (you should update this to your actual API endpoint)
    _dio.options.baseUrl = 'http://10.0.2.2:8080'; // Update with your API URL
  }

  // Method to update base URL if needed
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  // Method to add authorization header
  void addAuthorizationHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Method to remove authorization header
  void removeAuthorizationHeader() {
    _dio.options.headers.remove('Authorization');
  }
}