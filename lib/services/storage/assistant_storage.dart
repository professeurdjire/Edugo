import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edugo/models/assistant_message.dart';

class AssistantStorage {
  static const _chatHistoryKey = 'assistant_chat_history_';
  
  /// Save chat history for a specific student
  static Future<void> saveChatHistory(int eleveId, List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_chatHistoryKey$eleveId';
    
    // Convert messages to JSON
    final List<Map<String, dynamic>> messagesJson = messages
        .map((message) => {
              'role': message.role,
              'content': message.content,
              'createdAt': message.createdAt,
            })
        .toList();
    
    final jsonString = jsonEncode(messagesJson);
    await prefs.setString(key, jsonString);
  }
  
  /// Load chat history for a specific student
  static Future<List<Message>> loadChatHistory(int eleveId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_chatHistoryKey$eleveId';
    
    final jsonString = prefs.getString(key);
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> messagesJson = jsonDecode(jsonString);
      final List<Message> messages = messagesJson
          .map((json) => Message((b) => b
                ..role = json['role'] as String?
                ..content = json['content'] as String?
                ..createdAt = json['createdAt'] as String?))
          .toList();
      
      return messages;
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }
  
  /// Clear chat history for a specific student
  static Future<void> clearChatHistory(int eleveId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_chatHistoryKey$eleveId';
    await prefs.remove(key);
  }
  
  /// Clear all chat history
  static Future<void> clearAllChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_chatHistoryKey)) {
        await prefs.remove(key);
      }
    }
  }
}