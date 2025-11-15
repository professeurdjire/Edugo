import 'dart:convert';
import 'package:http/http.dart' as http;

class AssistantService {
  final String baseUrl;
  final http.Client _client;

  AssistantService({required this.baseUrl, http.Client? client}) : _client = client ?? http.Client();

  /// Envoie un message d'assistance au backend et retourne la réponse texte.
  Future<String> sendMessage({required String message, int? eleveId}) async {
    final uri = Uri.parse('$baseUrl/api/api/ia/chat');
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
        if (eleveId != null) 'eleveId': eleveId,
      }),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      try {
        final data = jsonDecode(resp.body);
        // Attend un JSON { "reply": "..." } côté Spring Boot
        if (data is Map && data['reply'] is String) {
          return data['reply'] as String;
        }
        // Si backend renvoie directement du texte
        return resp.body.toString();
      } catch (_) {
        // Réponse non-JSON
        return resp.body.toString();
      }
    }

    throw Exception('Assistant API error: ${resp.statusCode} ${resp.body}');
  }
}
