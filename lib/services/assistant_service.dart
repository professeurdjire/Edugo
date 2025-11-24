import 'package:dio/dio.dart';
import 'package:edugo/models/assistant_message.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:built_collection/built_collection.dart';

class AssistantService {
  static final AssistantService _instance = AssistantService._internal();
  
  final AuthService _authService = AuthService();
  
  factory AssistantService() {
    return _instance;
  }
  
  AssistantService._internal();

  Dio get _dio => _authService.dio;

  /// Envoyer un message au chatbot
  Future<AssistantMessage?> sendMessage(String message, int eleveId) async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.post(
        '/api/ia/chat',
        data: {
          'message': message,
          'eleveId': eleveId,
        },
      );

      if (response.statusCode == 200) {
        return standardSerializers.deserializeWith(
          AssistantMessage.serializer,
          response.data,
        );
      }
    } catch (e) {
      print('Error sending message: $e');
    }
    return null;
  }

  /// Récupérer l'historique des sessions de chat
  Future<BuiltList<AssistantMessage>?> getChatSessions(int eleveId) async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/ia/chat/sessions?eleveId=$eleveId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  AssistantMessage.serializer,
                  json,
                ))
            .whereType<AssistantMessage>()
            .toList()
            .toBuiltList();
      }
    } catch (e) {
      print('Error fetching chat sessions: $e');
    }
    return null;
  }
}