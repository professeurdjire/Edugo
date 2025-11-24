import 'package:flutter/material.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/exercise_service.dart';
import 'package:edugo/services/quiz_service.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:edugo/services/defi_service.dart';
import 'package:edugo/models/faire_exercice_response.dart';
import 'package:edugo/models/quiz.dart';
import 'package:edugo/models/participation.dart';
import 'package:edugo/models/eleve_defi_response.dart';
import 'package:built_collection/built_collection.dart';

/// Modèle pour une activité récente
class ActiviteRecente {
  final String type; // 'quiz', 'exercice', 'challenge', 'defi'
  final String titre;
  final String description;
  final DateTime date;
  final int? score;
  final int? totalPoints;
  final IconData icon;
  final Color iconColor;

  ActiviteRecente({
    required this.type,
    required this.titre,
    required this.description,
    required this.date,
    this.score,
    this.totalPoints,
    required this.icon,
    required this.iconColor,
  });
}

class ActiviteService {
  static final ActiviteService _instance = ActiviteService._internal();
  factory ActiviteService() => _instance;

  final AuthService _authService = AuthService();
  final ExerciseService _exerciseService = ExerciseService();
  final QuizService _quizService = QuizService();
  final ChallengeService _challengeService = ChallengeService();
  final DefiService _defiService = DefiService();

  ActiviteService._internal();

  /// Récupérer toutes les activités récentes d'un élève
  /// Combine les quiz, exercices, challenges et défis
  Future<List<ActiviteRecente>> getActivitesRecentess(int eleveId) async {
    final List<ActiviteRecente> activites = [];

    try {
      // 1. Récupérer l'historique des exercices
      final exercices = await _exerciseService.getHistoriqueExercices(eleveId);
      if (exercices != null) {
        for (var exercice in exercices) {
          activites.add(ActiviteRecente(
            type: 'exercice',
            titre: exercice.exerciceTitre ?? 'Exercice',
            description: 'Exercice terminé avec un score de ${exercice.note ?? 0}',
            date: exercice.dateSoumission ?? DateTime.now(),
            score: exercice.note,
            totalPoints: null, // FaireExerciceResponse n'a pas de noteMax
            icon: Icons.check_circle,
            iconColor: const Color(0xFF32C832), // Vert
          ));
        }
      }

      // 2. Récupérer les quiz (on peut utiliser les quiz disponibles et vérifier s'ils ont été complétés)
      // Note: Il faudrait un endpoint pour l'historique des quiz, pour l'instant on utilise les quiz disponibles
      final quizzes = await _quizService.getQuizzesForEleve(eleveId);
      // TODO: Ajouter un endpoint pour l'historique des quiz si disponible

      // 3. Récupérer les participations aux challenges
      final participations = await _challengeService.getChallengesParticipes(eleveId);
      if (participations != null) {
        for (var participation in participations) {
          final challengeTitre = participation.challenge?.titre ?? 'Challenge';
          activites.add(ActiviteRecente(
            type: 'challenge',
            titre: challengeTitre,
            description: 'Challenge terminé avec un score de ${participation.score ?? 0}',
            date: participation.dateParticipation ?? DateTime.now(),
            score: participation.score,
            totalPoints: null, // Participation n'a pas de totalPoints directement
            icon: Icons.emoji_events,
            iconColor: const Color(0xFFFFA500), // Orange
          ));
        }
      }

      // 4. Récupérer les défis participés
      final defisParticipes = await _defiService.getDefisParticipes(eleveId);
      if (defisParticipes != null) {
        for (var defi in defisParticipes) {
          activites.add(ActiviteRecente(
            type: 'defi',
            titre: defi.defiTitre ?? 'Défi',
            description: 'Défi ${defi.statut ?? 'en cours'}',
            date: defi.dateEnvoie ?? DateTime.now(),
            icon: Icons.volume_up,
            iconColor: const Color(0xFF2196F3), // Bleu
          ));
        }
      }

      // Trier par date (plus récent en premier)
      activites.sort((a, b) => b.date.compareTo(a.date));

      return activites;
    } catch (e) {
      print('Error fetching recent activities: $e');
      return activites;
    }
  }

  /// Grouper les activités par jour
  Map<String, List<ActiviteRecente>> grouperParJour(List<ActiviteRecente> activites) {
    final Map<String, List<ActiviteRecente>> groupes = {};

    for (var activite in activites) {
      final date = activite.date;
      final aujourdhui = DateTime.now();
      final hier = aujourdhui.subtract(const Duration(days: 1));

      String cle;
      if (date.year == aujourdhui.year &&
          date.month == aujourdhui.month &&
          date.day == aujourdhui.day) {
        cle = 'Aujourd\'hui';
      } else if (date.year == hier.year &&
          date.month == hier.month &&
          date.day == hier.day) {
        cle = 'Hier';
      } else {
        // Formater la date (ex: "15 Nov 2024")
        final mois = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
        cle = '${date.day} ${mois[date.month - 1]} ${date.year}';
      }

      if (!groupes.containsKey(cle)) {
        groupes[cle] = [];
      }
      groupes[cle]!.add(activite);
    }

    return groupes;
  }
}

