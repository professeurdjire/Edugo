import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edugo/models/livre.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/exercice_response.dart';
import 'package:edugo/models/defi_response.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/progression_response.dart';
import 'package:edugo/models/badge.dart' as BadgeModel;
import 'package:edugo/services/serializers.dart';
import 'package:built_collection/built_collection.dart';

/// Service pour gérer le cache local et le mode hors ligne
class OfflineCacheService {
  static final OfflineCacheService _instance = OfflineCacheService._internal();
  factory OfflineCacheService() => _instance;

  OfflineCacheService._internal();

  // Clés pour le stockage
  static const String _keyBooks = 'cached_books';
  static const String _keyQuizzes = 'cached_quizzes';
  static const String _keyExercises = 'cached_exercises';
  static const String _keyChallenges = 'cached_challenges';
  static const String _keyUserProfile = 'cached_user_profile';
  static const String _keyReadingProgress = 'cached_reading_progress';
  static const String _keyBadges = 'cached_badges';
  static const String _keyCacheTimestamp = 'cache_timestamp';
  static const String _keyOfflineMode = 'offline_mode_enabled';

  /// Vérifier si le mode hors ligne est activé
  Future<bool> isOfflineModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOfflineMode) ?? true; // Activé par défaut
  }

  /// Activer/désactiver le mode hors ligne
  Future<void> setOfflineModeEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOfflineMode, enabled);
  }

  /// Obtenir la date de dernière mise à jour du cache
  Future<DateTime?> getLastCacheUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_keyCacheTimestamp);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  /// Mettre à jour le timestamp du cache
  Future<void> updateCacheTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCacheTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  // ========== CACHE DES LIVRES ==========

  /// Sauvegarder les livres en cache
  Future<void> cacheBooks(BuiltList<Livre> books, int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = books.map((book) => 
        standardSerializers.serializeWith(Livre.serializer, book)
      ).toList();
      await prefs.setString('${_keyBooks}_$eleveId', jsonEncode(jsonList));
      await updateCacheTimestamp();
      print('[OfflineCache] ✅ ${books.length} livres mis en cache');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la mise en cache des livres: $e');
    }
  }

  /// Récupérer les livres depuis le cache
  Future<BuiltList<Livre>?> getCachedBooks(int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyBooks}_$eleveId');
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      final books = jsonList.map((item) => 
        standardSerializers.deserializeWith(Livre.serializer, item) as Livre
      ).toList();
      
      print('[OfflineCache] ✅ ${books.length} livres récupérés du cache');
      return BuiltList<Livre>(books);
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la récupération des livres: $e');
      return null;
    }
  }

  // ========== CACHE DES QUIZ ==========

  /// Sauvegarder les quiz en cache
  Future<void> cacheQuizzes(BuiltList<Quiz> quizzes, int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = quizzes.map((quiz) => 
        standardSerializers.serializeWith(Quiz.serializer, quiz)
      ).toList();
      await prefs.setString('${_keyQuizzes}_$eleveId', jsonEncode(jsonList));
      await updateCacheTimestamp();
      print('[OfflineCache] ✅ ${quizzes.length} quiz mis en cache');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la mise en cache des quiz: $e');
    }
  }

  /// Récupérer les quiz depuis le cache
  Future<BuiltList<Quiz>?> getCachedQuizzes(int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyQuizzes}_$eleveId');
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      final quizzes = jsonList.map((item) => 
        standardSerializers.deserializeWith(Quiz.serializer, item) as Quiz
      ).toList();
      
      print('[OfflineCache] ✅ ${quizzes.length} quiz récupérés du cache');
      return BuiltList<Quiz>(quizzes);
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la récupération des quiz: $e');
      return null;
    }
  }

  // ========== CACHE DES EXERCICES ==========

  /// Sauvegarder les exercices en cache
  Future<void> cacheExercises(BuiltList<ExerciceResponse> exercises, int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = exercises.map((exercise) => 
        standardSerializers.serializeWith(ExerciceResponse.serializer, exercise)
      ).toList();
      await prefs.setString('${_keyExercises}_$eleveId', jsonEncode(jsonList));
      await updateCacheTimestamp();
      print('[OfflineCache] ✅ ${exercises.length} exercices mis en cache');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la mise en cache des exercices: $e');
    }
  }

  /// Récupérer les exercices depuis le cache
  Future<BuiltList<ExerciceResponse>?> getCachedExercises(int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyExercises}_$eleveId');
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      final exercises = jsonList.map((item) => 
        standardSerializers.deserializeWith(ExerciceResponse.serializer, item) as ExerciceResponse
      ).toList();
      
      print('[OfflineCache] ✅ ${exercises.length} exercices récupérés du cache');
      return BuiltList<ExerciceResponse>(exercises);
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la récupération des exercices: $e');
      return null;
    }
  }

  // ========== CACHE DES DÉFIS ==========

  /// Sauvegarder les défis en cache
  Future<void> cacheChallenges(BuiltList<DefiResponse> challenges, int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = challenges.map((challenge) => 
        standardSerializers.serializeWith(DefiResponse.serializer, challenge)
      ).toList();
      await prefs.setString('${_keyChallenges}_$eleveId', jsonEncode(jsonList));
      await updateCacheTimestamp();
      print('[OfflineCache] ✅ ${challenges.length} défis mis en cache');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la mise en cache des défis: $e');
    }
  }

  /// Récupérer les défis depuis le cache
  Future<BuiltList<DefiResponse>?> getCachedChallenges(int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyChallenges}_$eleveId');
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      final challenges = jsonList.map((item) => 
        standardSerializers.deserializeWith(DefiResponse.serializer, item) as DefiResponse
      ).toList();
      
      print('[OfflineCache] ✅ ${challenges.length} défis récupérés du cache');
      return BuiltList<DefiResponse>(challenges);
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la récupération des défis: $e');
      return null;
    }
  }

  // ========== CACHE DU PROFIL UTILISATEUR ==========

  /// Sauvegarder le profil utilisateur en cache
  Future<void> cacheUserProfile(Eleve eleve) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = standardSerializers.serializeWith(Eleve.serializer, eleve);
      await prefs.setString('${_keyUserProfile}_${eleve.id}', jsonEncode(json));
      await updateCacheTimestamp();
      print('[OfflineCache] ✅ Profil utilisateur mis en cache');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la mise en cache du profil: $e');
    }
  }

  /// Récupérer le profil utilisateur depuis le cache
  Future<Eleve?> getCachedUserProfile(int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyUserProfile}_$eleveId');
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString);
      final eleve = standardSerializers.deserializeWith(Eleve.serializer, json) as Eleve;
      
      print('[OfflineCache] ✅ Profil utilisateur récupéré du cache');
      return eleve;
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la récupération du profil: $e');
      return null;
    }
  }

  // ========== CACHE DE LA PROGRESSION DE LECTURE ==========

  /// Sauvegarder la progression de lecture en cache
  Future<void> cacheReadingProgress(BuiltList<ProgressionResponse> progress, int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = progress.map((p) => 
        standardSerializers.serializeWith(ProgressionResponse.serializer, p)
      ).toList();
      await prefs.setString('${_keyReadingProgress}_$eleveId', jsonEncode(jsonList));
      await updateCacheTimestamp();
      print('[OfflineCache] ✅ Progression de lecture mise en cache');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la mise en cache de la progression: $e');
    }
  }

  /// Récupérer la progression de lecture depuis le cache
  Future<BuiltList<ProgressionResponse>?> getCachedReadingProgress(int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyReadingProgress}_$eleveId');
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      final progress = jsonList.map((item) => 
        standardSerializers.deserializeWith(ProgressionResponse.serializer, item) as ProgressionResponse
      ).toList();
      
      print('[OfflineCache] ✅ Progression de lecture récupérée du cache');
      return BuiltList<ProgressionResponse>(progress);
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la récupération de la progression: $e');
      return null;
    }
  }

  // ========== CACHE DES BADGES ==========

  /// Sauvegarder les badges en cache
  Future<void> cacheBadges(BuiltList<BadgeModel.Badge> badges, int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = badges.map((badge) => 
        standardSerializers.serializeWith(BadgeModel.Badge.serializer, badge)
      ).toList();
      await prefs.setString('${_keyBadges}_$eleveId', jsonEncode(jsonList));
      await updateCacheTimestamp();
      print('[OfflineCache] ✅ ${badges.length} badges mis en cache');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la mise en cache des badges: $e');
    }
  }

  /// Récupérer les badges depuis le cache
  Future<BuiltList<BadgeModel.Badge>?> getCachedBadges(int eleveId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyBadges}_$eleveId');
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      final badges = jsonList.map((item) => 
        standardSerializers.deserializeWith(BadgeModel.Badge.serializer, item) as BadgeModel.Badge
      ).toList();
      
      print('[OfflineCache] ✅ ${badges.length} badges récupérés du cache');
      return BuiltList<BadgeModel.Badge>(badges);
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors de la récupération des badges: $e');
      return null;
    }
  }

  // ========== NETTOYAGE DU CACHE ==========

  /// Vider tout le cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => 
        key.startsWith(_keyBooks) ||
        key.startsWith(_keyQuizzes) ||
        key.startsWith(_keyExercises) ||
        key.startsWith(_keyChallenges) ||
        key.startsWith(_keyUserProfile) ||
        key.startsWith(_keyReadingProgress) ||
        key.startsWith(_keyBadges)
      ).toList();
      
      for (final key in keys) {
        await prefs.remove(key);
      }
      
      await prefs.remove(_keyCacheTimestamp);
      print('[OfflineCache] ✅ Cache vidé');
    } catch (e) {
      print('[OfflineCache] ❌ Erreur lors du vidage du cache: $e');
    }
  }

  /// Obtenir la taille du cache (approximative)
  Future<int> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int totalSize = 0;
      final keys = prefs.getKeys().where((key) => 
        key.startsWith(_keyBooks) ||
        key.startsWith(_keyQuizzes) ||
        key.startsWith(_keyExercises) ||
        key.startsWith(_keyChallenges) ||
        key.startsWith(_keyUserProfile) ||
        key.startsWith(_keyReadingProgress) ||
        key.startsWith(_keyBadges)
      ).toList();
      
      for (final key in keys) {
        final value = prefs.getString(key);
        if (value != null) {
          totalSize += value.length;
        }
      }
      
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}

