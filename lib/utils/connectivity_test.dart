import 'package:edugo/services/auth_service.dart';
import 'dart:io';

/// Utility class for testing backend connectivity
class ConnectivityTest {
  final AuthService _authService = AuthService();
  
  /// Test if the backend server is reachable
  Future<bool> testBackendConnectivity() async {
    try {
      print('🔍 Testing backend connectivity...');
      print('🌐 Base URL: ${_authService.dio.options.baseUrl}');
      
      // Test basic connectivity
      final result = await _authService.testConnection();
      
      if (result) {
        print('✅ Backend is reachable');
        return true;
      } else {
        print('❌ Backend is not reachable');
        return false;
      }
    } catch (e) {
      print('❌ Error testing connectivity: $e');
      return false;
    }
  }
  
  /// Test network availability
  Future<bool> testNetworkAvailability() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('✅ Internet connection is available');
        return true;
      }
    } on SocketException catch (_) {
      print('❌ No internet connection available');
      return false;
    }
    return false;
  }
  
  /// Comprehensive connectivity test
  Future<void> runComprehensiveTest() async {
    print('🚀 Running comprehensive connectivity test...');
    
    // Test internet availability
    final isInternetAvailable = await testNetworkAvailability();
    
    if (!isInternetAvailable) {
      print('⚠️  No internet connection. Please check your network.');
      return;
    }
    
    // Test backend connectivity
    final isBackendReachable = await testBackendConnectivity();
    
    if (!isBackendReachable) {
      print('⚠️  Backend server is not reachable. Please check:');
      print('   1. Backend server is running on ${_authService.dio.options.baseUrl}');
      print('   2. Both devices are on the same network');
      print('   3. Firewall allows connections on port 8080');
      print('   4. Backend accepts external connections (not just localhost)');
      return;
    }
    
    print('🎉 All connectivity tests passed!');
  }
}