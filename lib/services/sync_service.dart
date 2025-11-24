import 'package:edugo/services/connectivity_service.dart';
import 'package:edugo/services/offline_cache_service.dart';
import 'package:edugo/services/livre_service.dart';
import 'package:edugo/services/quiz_service.dart';
import 'package:edugo/services/exercise_service.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:edugo/services/defi_service.dart';
import 'package:edugo/services/eleveService.dart';
import 'package:edugo/services/badge_service.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/models/defi_response.dart';
import 'package:built_collection/built_collection.dart';

/// Service pour gérer la synchronisation automatique des données
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;

  final ConnectivityService _connectivityService = ConnectivityService();
  final OfflineCacheService _cacheService = OfflineCacheService();
  final LivreService _livreService = LivreService();
  final QuizService _quizService = QuizService();
  final ExerciseService _exerciseService = ExerciseService();
  final ChallengeService _challengeService = ChallengeService();
  final DefiService _defiService = DefiService();
  final EleveService _eleveService = EleveService();
  final BadgeService _badgeService = BadgeService();

  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  SyncService._internal() {
    _init();
  }

  void _init() {
    // Écouter les changements de connectivité
    _connectivityService.connectionStream.listen((isConnected) {
      if (isConnected && !_isSyncing) {
        print('[SyncService] ✅ Connexion détectée - Démarrage de la synchronisation');
        // Attendre un peu avant de synchroniser pour s'assurer que la connexion est stable
        Future.delayed(const Duration(seconds: 2), () {
          syncAllData();
        });
      }
    });
  }

  /// Synchroniser toutes les données pour un élève
  Future<void> syncAllData({int? eleveId}) async {
    if (_isSyncing) {
      print('[SyncService] ⚠️ Synchronisation déjà en cours');
      return;
    }

    if (!await _connectivityService.isConnected()) {
      print('[SyncService] ⚠️ Pas de connexion - Synchronisation annulée');
      return;
    }

    if (eleveId == null) {
      print('[SyncService] ⚠️ ID élève non fourni - Synchronisation annulée');
      return;
    }

    _isSyncing = true;
    print('[SyncService] 🔄 Démarrage de la synchronisation pour l\'élève $eleveId');

    try {
      // 1. Synchroniser le profil utilisateur
      await _syncUserProfile(eleveId);

      // 2. Synchroniser les livres
      await _syncBooks(eleveId);

      // 3. Synchroniser les quiz
      await _syncQuizzes(eleveId);

      // 4. Synchroniser les exercices
      await _syncExercises(eleveId);

      // 5. Synchroniser les défis
      await _syncChallenges(eleveId);

      // 6. Synchroniser les badges
      await _syncBadges(eleveId);

      // 7. Synchroniser la progression de lecture
      await _syncReadingProgress(eleveId);

      _lastSyncTime = DateTime.now();
      print('[SyncService] ✅ Synchronisation terminée avec succès');
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Synchroniser le profil utilisateur
  Future<void> _syncUserProfile(int eleveId) async {
    try {
      print('[SyncService] 📱 Synchronisation du profil utilisateur...');
      final eleve = await _eleveService.getEleveProfile(eleveId);
      if (eleve != null) {
        await _cacheService.cacheUserProfile(eleve);
        print('[SyncService] ✅ Profil utilisateur synchronisé');
      }
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation du profil: $e');
    }
  }

  /// Synchroniser les livres
  Future<void> _syncBooks(int eleveId) async {
    try {
      print('[SyncService] 📚 Synchronisation des livres...');
      final books = await _livreService.getLivresDisponibles(eleveId);
      if (books != null && books.isNotEmpty) {
        await _cacheService.cacheBooks(books, eleveId);
        print('[SyncService] ✅ ${books.length} livres synchronisés');
      }
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation des livres: $e');
    }
  }

  /// Synchroniser les quiz
  Future<void> _syncQuizzes(int eleveId) async {
    try {
      print('[SyncService] 📝 Synchronisation des quiz...');
      final quizzes = await _quizService.getQuizzesForEleve(eleveId);
      if (quizzes != null && quizzes.isNotEmpty) {
        await _cacheService.cacheQuizzes(quizzes, eleveId);
        print('[SyncService] ✅ ${quizzes.length} quiz synchronisés');
      }
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation des quiz: $e');
    }
  }

  /// Synchroniser les exercices
  Future<void> _syncExercises(int eleveId) async {
    try {
      print('[SyncService] ✏️ Synchronisation des exercices...');
      final exercises = await _exerciseService.getExercicesDisponibles(eleveId);
      if (exercises != null && exercises.isNotEmpty) {
        await _cacheService.cacheExercises(exercises, eleveId);
        print('[SyncService] ✅ ${exercises.length} exercices synchronisés');
      }
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation des exercices: $e');
    }
  }

  /// Synchroniser les défis
  Future<void> _syncChallenges(int eleveId) async {
    try {
      print('[SyncService] 🏆 Synchronisation des défis...');
      // Utiliser DefiService qui retourne DefiResponse (compatible avec le cache)
      final defis = await _defiService.getDefisDisponibles(eleveId);
      if (defis != null && defis.isNotEmpty) {
        await _cacheService.cacheChallenges(defis, eleveId);
        print('[SyncService] ✅ ${defis.length} défis synchronisés');
      }
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation des défis: $e');
    }
  }

  /// Synchroniser les badges
  Future<void> _syncBadges(int eleveId) async {
    try {
      print('[SyncService] 🎖️ Synchronisation des badges...');
      final badges = await _badgeService.getBadges(eleveId);
      if (badges != null && badges.isNotEmpty) {
        await _cacheService.cacheBadges(badges, eleveId);
        print('[SyncService] ✅ ${badges.length} badges synchronisés');
      }
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation des badges: $e');
    }
  }

  /// Synchroniser la progression de lecture
  Future<void> _syncReadingProgress(int eleveId) async {
    try {
      print('[SyncService] 📖 Synchronisation de la progression de lecture...');
      final progress = await _livreService.getProgressionLecture(eleveId);
      if (progress != null && progress.isNotEmpty) {
        await _cacheService.cacheReadingProgress(progress, eleveId);
        print('[SyncService] ✅ Progression de lecture synchronisée');
      }
    } catch (e) {
      print('[SyncService] ❌ Erreur lors de la synchronisation de la progression: $e');
    }
  }

  /// Obtenir la date de dernière synchronisation
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Vérifier si une synchronisation est en cours
  bool get isSyncing => _isSyncing;

  /// Forcer une synchronisation manuelle
  Future<void> forceSync({required int eleveId}) async {
    print('[SyncService] 🔄 Synchronisation manuelle demandée');
    await syncAllData(eleveId: eleveId);
  }
}

