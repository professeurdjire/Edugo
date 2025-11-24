import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;

  late FlutterTts _flutterTts;
  bool _isInitialized = false;
  bool _initializationAttempted = false;
  Function(String)? _onWordCallback;
  Function(int, int)? _onProgressCallback;

  TextToSpeechService._internal() {
    _flutterTts = FlutterTts();

    // Configure handlers
    _flutterTts.setStartHandler(() {
      print("TTS started");
    });

    _flutterTts.setCompletionHandler(() {
      print("TTS completed");
      _isInitialized = true;
    });

    _flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
      _isInitialized = false;
    });

    // Progress handler for word highlighting
    _flutterTts.setProgressHandler((String text, int start, int end, String word) {
      _onWordCallback?.call(word);
      _onProgressCallback?.call(start, end);
    });
  }

  Future<void> initialize() async {
    if (_initializationAttempted && _isInitialized) return;
    _initializationAttempted = true;

    try {
      // Vérifier les langues disponibles
      final languages = await _flutterTts.getLanguages;
      print("TTS Available languages: $languages");
      
      // Essayer d'abord fr-FR, puis fr, puis la langue par défaut
      String? selectedLanguage;
      if (languages != null && languages.isNotEmpty) {
        if (languages.contains("fr-FR")) {
          selectedLanguage = "fr-FR";
        } else if (languages.contains("fr")) {
          selectedLanguage = "fr";
        } else {
          selectedLanguage = languages.first.toString();
        }
      }
      
      if (selectedLanguage != null) {
        await _flutterTts.setLanguage(selectedLanguage);
        print("TTS Language set to: $selectedLanguage");
      } else {
        print("TTS Warning: No language available, using default");
      }
      
      // Configuration pour Android - s'assurer que le volume est à 1.0
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0); // Volume maximum
      await _flutterTts.setPitch(1.0);
      
      // Pour Android, s'assurer que le moteur TTS est prêt
      await _flutterTts.awaitSpeakCompletion(true);
      
      _isInitialized = true;
      print("TTS initialized successfully with language: $selectedLanguage, volume: 1.0");
    } catch (e) {
      print("Error initializing TTS: $e");
      _isInitialized = false;
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();
    if (!_isInitialized) {
      print("TTS Error: Cannot speak, TTS not initialized");
      return;
    }

    try {
      // S'assurer que le volume est à 1.0 avant de parler
      await _flutterTts.setVolume(1.0);
      print("TTS Speaking text (length: ${text.length}): ${text.substring(0, text.length > 50 ? 50 : text.length)}...");
      await _flutterTts.speak(text);
      print("TTS Speak command sent successfully");
    } catch (e) {
      print("Error speaking text: $e");
      // Réessayer l'initialisation en cas d'erreur
      await reinitialize();
      try {
        await _flutterTts.setVolume(1.0);
        await _flutterTts.speak(text);
      } catch (e2) {
        print("Error speaking text after reinitialization: $e2");
      }
    }
  }

  Future<void> stop() async {
    if (!_isInitialized) return;
    try {
      await _flutterTts.stop();
    } catch (e) {
      print("Error stopping speech: $e");
    }
  }

  Future<void> pause() async {
    if (!_isInitialized) return;
    try {
      await _flutterTts.pause();
    } catch (e) {
      print("Error pausing speech: $e");
    }
  }

  Future<void> setLanguage(String language) async {
    if (!_isInitialized) return;
    try {
      await _flutterTts.setLanguage(language);
    } catch (e) {
      print("Error setting language: $e");
    }
  }

  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) await initialize();
    if (!_isInitialized) return;
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print("Error setting speech rate: $e");
    }
  }

  Future<void> setVolume(double volume) async {
    if (!_isInitialized) await initialize();
    if (!_isInitialized) return;
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      print("Error setting volume: $e");
    }
  }

  Future<void> setPitch(double pitch) async {
    if (!_isInitialized) await initialize();
    if (!_isInitialized) return;
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      print("Error setting pitch: $e");
    }
  }

  Future<List<String>?> getLanguages() async {
    if (!_isInitialized) return null;
    try {
      final langs = await _flutterTts.getLanguages;
      if (langs is List) return langs.map((e) => e.toString()).toList();
      return null;
    } catch (e) {
      print("Error getting languages: $e");
      return null;
    }
  }

  Future<bool> isLanguageAvailable(String language) async {
    if (!_isInitialized) return false;
    try {
      return await _flutterTts.isLanguageAvailable(language);
    } catch (e) {
      print("Error checking language availability: $e");
      return false;
    }
  }

  Future<void> speakWithProgress(
      String text, Function(String) onWord, Function(int, int) onProgress) async {
    _onWordCallback = onWord;
    _onProgressCallback = onProgress;
    try {
      await speak(text);
    } catch (e) {
      print("Error in speakWithProgress: $e");
      rethrow;
    }
  }

  Future<void> speakWithWordCallback(String text, Function(String) onWord) async {
    _onWordCallback = onWord;
    await speak(text);
  }

  bool get isReady => _isInitialized;

  Future<void> reinitialize() async {
    _initializationAttempted = false;
    _isInitialized = false;
    await initialize();
  }
}
