import 'package:flutter/material.dart';
import 'package:edugo/models/notification.dart' as NotificationModel;
import 'package:edugo/screens/main/challenge/challenge_details_screen.dart';
import 'package:edugo/screens/main/challenge/challenge_leaderboard_screen.dart';
import 'package:edugo/screens/main/accueil/badges.dart';
import 'package:edugo/services/challenge_service.dart';

/// Service pour gérer le routage des notifications vers les écrans appropriés
class NotificationRoutingService {
  /// Gérer la navigation en fonction des données de notification locales
  static void handleNotificationNavigation(
    BuildContext context,
    NotificationModel.NotificationModel notification,
  ) {
    final type = (notification.type ?? '').toUpperCase();
    final metadata = notification.metadata ?? {};
    
    print('[NotificationRoutingService] Handling notification type: $type');
    print('[NotificationRoutingService] Metadata: $metadata');
    
    // Extraire les IDs depuis les métadonnées ou depuis le contenu
    final int? quizId = _extractId(metadata, 'quizId');
    final int? challengeId = _extractId(metadata, 'challengeId');
    final int? defiId = _extractId(metadata, 'defiId');
    final int? exerciceId = _extractId(metadata, 'exerciceId');
    final int? livreId = _extractId(metadata, 'livreId');
    final int? suggestionId = _extractId(metadata, 'suggestionId');
    
    switch (type) {
      case 'QUIZ_TERMINE':
        if (quizId != null) {
          // Pour les quiz terminés, on pourrait naviguer vers un écran de résultats
          // Pour l'instant, on affiche juste un message car on n'a pas les données du résultat
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quiz terminé ! Consultez vos résultats dans l\'historique.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        break;
        
      case 'CHALLENGE_TERMINE':
        if (challengeId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeDetailsScreen(
                challengeId: challengeId,
              ),
            ),
          );
        }
        break;
        
      case 'DEFI_TERMINE':
        if (defiId != null) {
          // Naviguer vers les détails du défi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Défi terminé ! ID: $defiId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'EXERCICE_CORRIGE':
        if (exerciceId != null) {
          // Naviguer vers l'exercice corrigé
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Exercice corrigé ! ID: $exerciceId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'NOUVEAU_CHALLENGE':
        if (challengeId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeDetailsScreen(
                challengeId: challengeId,
              ),
            ),
          );
        }
        break;
        
      case 'NOUVEAU_DEFI':
        if (defiId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nouveau défi disponible ! ID: $defiId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'RAPPEL_DEADLINE':
        final entityType = (metadata['entityType'] as String? ?? '').toUpperCase();
        final entityId = _extractId(metadata, 'entityId');
        if (entityType == 'CHALLENGE' && entityId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeDetailsScreen(
                challengeId: entityId,
              ),
            ),
          );
        } else if (entityType == 'DEFI' && entityId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rappel: Défi se termine bientôt ! ID: $entityId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'BADGE_OBTENU':
        // Naviguer vers l'écran des badges et rafraîchir automatiquement
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BadgesScreen(),
          ),
        ).then((_) {
          // Rafraîchir les badges sur la page d'accueil après retour
          if (context.mounted) {
            final badgeNom = metadata['badgeNom'] as String?;
            final challengeTitre = metadata['challengeTitre'] as String?;
            final pourcentage = metadata['pourcentage'] as num?;
            
            String message;
            if (badgeNom != null && challengeTitre != null && pourcentage != null) {
              message = 'Félicitations ! Vous avez obtenu le badge "$badgeNom" pour le challenge "$challengeTitre" (${pourcentage.toStringAsFixed(0)}%) ! 🎉';
            } else if (badgeNom != null) {
              message = 'Félicitations ! Vous avez obtenu le badge "$badgeNom" ! 🎉';
            } else {
              message = 'Félicitations ! Vous avez obtenu un nouveau badge ! 🎉';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(message),
                    ),
                  ],
                ),
                backgroundColor: Colors.amber.shade700,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
        break;
        
      case 'BADGE_PROGRESSION':
        // Naviguer vers l'écran des badges et afficher un message de félicitations
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BadgesScreen(),
          ),
        ).then((_) {
          if (context.mounted) {
            final badgeNom = metadata['badgeNom'] as String?;
            final points = metadata['points'] as num?;
            final seuil = metadata['seuil'] as num?;
            
            String message;
            if (badgeNom != null && points != null && seuil != null) {
              message = 'Félicitations ! Vous avez atteint $points points et obtenu le badge "$badgeNom" ! 🏆';
            } else if (badgeNom != null) {
              message = 'Félicitations ! Vous avez obtenu le badge de progression "$badgeNom" ! 🏆';
            } else {
              message = 'Félicitations ! Vous avez obtenu un nouveau badge de progression ! 🏆';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.purple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(message),
                    ),
                  ],
                ),
                backgroundColor: Colors.purple.shade700,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
        break;
        
      case 'NOUVEAU_LIVRE':
        if (livreId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nouveau livre disponible ! ID: $livreId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'OBJECTIF_ATTEINT':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Félicitations ! Vous avez atteint votre objectif !'),
            duration: Duration(seconds: 3),
          ),
        );
        break;
        
      case 'MESSAGE_ADMIN':
      case 'NOUVEAU_MESSAGE_ADMIN':
        _showAdminMessageModal(context, notification);
        break;
        
      case 'CLASSEMENT_AMELIORE':
      case 'AMELIORATION_CLASSEMENT':
        if (challengeId != null) {
          // Charger le titre du challenge depuis le service
          final challengeService = ChallengeService();
          challengeService.getChallengeById(challengeId).then((challenge) {
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeLeaderboardScreen(
                    challengeId: challengeId,
                    challengeTitle: challenge?.titre ?? 'Challenge $challengeId',
                  ),
                ),
              );
            }
          }).catchError((e) {
            print('[NotificationRoutingService] Error loading challenge: $e');
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeLeaderboardScreen(
                    challengeId: challengeId,
                    challengeTitle: 'Challenge $challengeId',
                  ),
                ),
              );
            }
          });
        }
        break;
        
      case 'NOUVEAU_QUIZ':
        if (quizId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nouveau quiz disponible ! ID: $quizId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'REPONSE_SUGGESTION':
        if (suggestionId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Réponse à votre suggestion reçue ! ID: $suggestionId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      default:
        print('[NotificationRoutingService] Type de notification non géré: $type');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification: ${notification.titre ?? type}'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }
  
  /// Extraire un ID depuis les métadonnées (supporte int et String)
  static int? _extractId(Map<String, dynamic> metadata, String key) {
    final value = metadata[key];
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }
  
  /// Gérer la navigation en fonction des données de notification push
  static void handleNotificationNavigationFromPush(
    BuildContext context,
    Map<String, dynamic> notificationData,
  ) {
    final type = (notificationData['type'] as String? ?? '').toUpperCase();
    if (type.isEmpty) {
      print('[NotificationRoutingService] No type found in push notification data');
      return;
    }
    
    print('[NotificationRoutingService] Handling push notification type: $type');
    print('[NotificationRoutingService] Push notification data: $notificationData');
    
    // Extraire les IDs depuis les données de notification
    final int? quizId = _extractIdFromData(notificationData, 'quizId');
    final int? challengeId = _extractIdFromData(notificationData, 'challengeId');
    final int? defiId = _extractIdFromData(notificationData, 'defiId');
    final int? exerciceId = _extractIdFromData(notificationData, 'exerciceId');
    final int? livreId = _extractIdFromData(notificationData, 'livreId');
    final int? suggestionId = _extractIdFromData(notificationData, 'suggestionId');
    
    switch (type) {
      case 'QUIZ_TERMINE':
        if (quizId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quiz terminé ! Consultez vos résultats dans l\'historique.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        break;
        
      case 'CHALLENGE_TERMINE':
        if (challengeId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeDetailsScreen(
                challengeId: challengeId,
              ),
            ),
          );
        }
        break;
        
      case 'DEFI_TERMINE':
        if (defiId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Défi terminé ! ID: $defiId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'EXERCICE_CORRIGE':
        if (exerciceId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Exercice corrigé ! ID: $exerciceId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'NOUVEAU_CHALLENGE':
        if (challengeId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeDetailsScreen(
                challengeId: challengeId,
              ),
            ),
          );
        }
        break;
        
      case 'NOUVEAU_DEFI':
        if (defiId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nouveau défi disponible ! ID: $defiId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'RAPPEL_DEADLINE':
        final entityType = (notificationData['entityType'] as String? ?? '').toUpperCase();
        final entityId = _extractIdFromData(notificationData, 'entityId');
        if (entityType == 'CHALLENGE' && entityId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeDetailsScreen(
                challengeId: entityId,
              ),
            ),
          );
        } else if (entityType == 'DEFI' && entityId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rappel: Défi se termine bientôt ! ID: $entityId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'BADGE_OBTENU':
        // Naviguer vers l'écran des badges et rafraîchir automatiquement
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BadgesScreen(),
          ),
        ).then((_) {
          // Rafraîchir les badges sur la page d'accueil après retour
          if (context.mounted) {
            final badgeNom = notificationData['badgeNom'] as String?;
            final challengeTitre = notificationData['challengeTitre'] as String?;
            final pourcentage = notificationData['pourcentage'] as num?;
            
            String message;
            if (badgeNom != null && challengeTitre != null && pourcentage != null) {
              message = 'Félicitations ! Vous avez obtenu le badge "$badgeNom" pour le challenge "$challengeTitre" (${pourcentage.toStringAsFixed(0)}%) ! 🎉';
            } else if (badgeNom != null) {
              message = 'Félicitations ! Vous avez obtenu le badge "$badgeNom" ! 🎉';
            } else {
              message = 'Félicitations ! Vous avez obtenu un nouveau badge ! 🎉';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(message),
                    ),
                  ],
                ),
                backgroundColor: Colors.amber.shade700,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
        break;
        
      case 'BADGE_PROGRESSION':
        // Naviguer vers l'écran des badges et afficher un message de félicitations
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BadgesScreen(),
          ),
        ).then((_) {
          if (context.mounted) {
            final badgeNom = notificationData['badgeNom'] as String?;
            final points = notificationData['points'] as num?;
            final seuil = notificationData['seuil'] as num?;
            
            String message;
            if (badgeNom != null && points != null && seuil != null) {
              message = 'Félicitations ! Vous avez atteint $points points et obtenu le badge "$badgeNom" ! 🏆';
            } else if (badgeNom != null) {
              message = 'Félicitations ! Vous avez obtenu le badge de progression "$badgeNom" ! 🏆';
            } else {
              message = 'Félicitations ! Vous avez obtenu un nouveau badge de progression ! 🏆';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.purple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(message),
                    ),
                  ],
                ),
                backgroundColor: Colors.purple.shade700,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
        break;
        
      case 'NOUVEAU_LIVRE':
        if (livreId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nouveau livre disponible ! ID: $livreId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'OBJECTIF_ATTEINT':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Félicitations ! Vous avez atteint votre objectif !'),
            duration: Duration(seconds: 3),
          ),
        );
        break;
        
      case 'MESSAGE_ADMIN':
      case 'NOUVEAU_MESSAGE_ADMIN':
        _showAdminMessageModalFromPush(context, notificationData);
        break;
        
      case 'CLASSEMENT_AMELIORE':
      case 'AMELIORATION_CLASSEMENT':
        if (challengeId != null) {
          // Charger le titre du challenge depuis le service
          final challengeService = ChallengeService();
          challengeService.getChallengeById(challengeId).then((challenge) {
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeLeaderboardScreen(
                    challengeId: challengeId,
                    challengeTitle: challenge?.titre ?? 'Challenge $challengeId',
                  ),
                ),
              );
            }
          }).catchError((e) {
            print('[NotificationRoutingService] Error loading challenge: $e');
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeLeaderboardScreen(
                    challengeId: challengeId,
                    challengeTitle: 'Challenge $challengeId',
                  ),
                ),
              );
            }
          });
        }
        break;
        
      case 'NOUVEAU_QUIZ':
        if (quizId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nouveau quiz disponible ! ID: $quizId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'REPONSE_SUGGESTION':
        if (suggestionId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Réponse à votre suggestion reçue ! ID: $suggestionId'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;
        
      default:
        print('[NotificationRoutingService] Type de notification push non géré: $type');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification: $type'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }
  
  /// Extraire un ID depuis les données de notification push (supporte int et String)
  static int? _extractIdFromData(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }
  
  /// Afficher un message d'administrateur dans une modal (à partir d'une notification locale)
  static void _showAdminMessageModal(
    BuildContext context,
    NotificationModel.NotificationModel notification,
  ) {
    final titre = notification.titre ?? 'Message de l\'administration';
    final message = notification.contenu ?? 'Aucun message';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titre),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
  
  /// Afficher un message d'administrateur dans une modal (à partir d'une notification push)
  static void _showAdminMessageModalFromPush(
    BuildContext context,
    Map<String, dynamic> notificationData,
  ) {
    final titre = notificationData['titre'] as String? ?? 'Message de l\'administration';
    final message = notificationData['message'] as String? ?? 'Aucun message';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titre),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}