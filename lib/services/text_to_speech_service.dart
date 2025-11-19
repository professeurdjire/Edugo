import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  
  late FlutterTts _flutterTts;
  bool _isInitialized = false;
  
  TextToSpeechService._internal() {
    _flutterTts = FlutterTts();
    _initializeTts();
  }
  
  Future<void> _initializeTts() async {
    try {
      await _flutterTts.awaitSpeakCompletion(true);
      
      // Set default language
      await _flutterTts.setLanguage("fr-FR");
      
      // Set default speech rate
      await _flutterTts.setSpeechRate(0.5);
      
      // Set default volume
      await _flutterTts.setVolume(1.0);
      
      // Set default pitch
      await _flutterTts.setPitch(1.0);
      
      _isInitialized = true;
    } catch (e) {
      print("Error initializing TTS: $e");
      _isInitialized = false;
    }
  }
  
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print("Error speaking text: $e");
    }
  }
  
  Future<void> stop() async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      await _flutterTts.stop();
    } catch (e) {
      print("Error stopping speech: $e");
    }
  }
  
  Future<void> pause() async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      await _flutterTts.pause();
    } catch (e) {
      print("Error pausing speech: $e");
    }
  }
  
  Future<List<String>?> getLanguages() async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return null;
    }
    
    try {
      return await _flutterTts.getLanguages;
    } catch (e) {
      print("Error getting languages: $e");
      return null;
    }
  }
  
  Future<void> setLanguage(String language) async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      await _flutterTts.setLanguage(language);
    } catch (e) {
      print("Error setting language: $e");
    }
  }
  
  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print("Error setting speech rate: $e");
    }
  }
  
  Future<void> setVolume(double volume) async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      print("Error setting volume: $e");
    }
  }
  
  Future<void> setPitch(double pitch) async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      print("Error setting pitch: $e");
    }
  }
  
  Future<bool> isLanguageAvailable(String language) async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return false;
    }
    
    try {
      return await _flutterTts.isLanguageAvailable(language);
    } catch (e) {
      print("Error checking language availability: $e");
      return false;
    }
  }
  
  // Method to read text word by word for highlighting
  Future<void> speakWithWordCallback(String text, Function(String) onWord) async {
    if (!_isInitialized) {
      print("TTS not initialized");
      return;
    }
    
    try {
      // Set up word boundary callback
      _flutterTts.setProgressHandler((String text, int start, int end, String word) {
        onWord(word);
      });
      
      await _flutterTts.speak(text);
    } catch (e) {
      print("Error speaking with word callback: $e");
    }
  }
  
  // Add method to check if TTS is properly initialized
  bool get isReady => _isInitialized;
}