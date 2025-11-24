import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/models/question.dart';
import 'package:edugo/models/participation.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/screens/main/challenge/challenge_leaderboard_screen.dart';
import 'package:edugo/screens/main/challenge/take_challenge_screen.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final int challengeId;
  final int? eleveId;
  
  const ChallengeDetailsScreen({
    Key? key,
    required this.challengeId,
    this.eleveId,
  }) : super(key: key);

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  Challenge? _challenge;
  bool _isLoading = true;
  bool _isParticipating = false;
  bool _hasParticipated = false; // Vérifier si l'utilisateur a déjà participé
  final ChallengeService _challengeService = ChallengeService();
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _loadChallengeDetails();
  }

  Future<void> _loadChallengeDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final challenge = await _challengeService.getChallengeById(widget.challengeId);
      
      // Vérifier si l'utilisateur a déjà participé
      final int? currentUserId = _authService.currentUserId ?? widget.eleveId;
      Participation? existingParticipation;
      
      if (currentUserId != null) {
        // Utiliser la nouvelle méthode getParticipation pour récupérer la participation spécifique
        existingParticipation = await _challengeService.getParticipation(currentUserId, widget.challengeId);
        
        if (mounted) {
          setState(() {
            _hasParticipated = existingParticipation != null;
          });
        }
        
        // Si l'utilisateur a déjà participé avec statut "EN_COURS", on peut directement naviguer
        if (existingParticipation != null) {
          final statut = existingParticipation.statut?.toUpperCase() ?? '';
          print('[ChallengeDetailsScreen] Existing participation found: Status=$statut, Score=${existingParticipation.score}');
          
          if (statut == 'EN_COURS') {
            print('[ChallengeDetailsScreen] Participation is EN_COURS, user can continue answering questions');
          } else if (statut == 'TERMINE' || statut == 'VALIDE') {
            print('[ChallengeDetailsScreen] Participation is TERMINE/VALIDE, challenge already completed');
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _challenge = challenge;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[ChallengeDetailsScreen] Error loading challenge details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement du challenge: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _participateInChallenge() async {
    setState(() {
      _isParticipating = true;
    });

    try {
      // Get the current user ID
      final AuthService authService = AuthService();
      final int? currentUserId = authService.currentUserId ?? widget.eleveId;
      
      if (currentUserId == null) {
        if (mounted) {
          setState(() {
            _isParticipating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez vous connecter pour participer')),
          );
        }
        return;
      }
      
      print('[ChallengeDetailsScreen] Participating in challenge ${widget.challengeId} for student $currentUserId');
      
      // ÉTAPE 1 : Participer au challenge
      Participation? participation;
      try {
        participation = await _challengeService.participerChallenge(currentUserId, widget.challengeId);
      } catch (e) {
        // Gérer les erreurs spécifiques
        final errorMessage = e.toString();
        print('[ChallengeDetailsScreen] Participation error: $errorMessage');
        
        if (errorMessage.contains('participez déjà') || errorMessage.contains('already participated')) {
          // L'utilisateur a déjà participé - récupérer la participation existante
          print('[ChallengeDetailsScreen] User already participated, fetching existing participation...');
          participation = await _challengeService.getParticipation(currentUserId, widget.challengeId);
          
          if (participation != null) {
            print('[ChallengeDetailsScreen] Found existing participation: Status=${participation.statut}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vous participez déjà à ce challenge'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } else {
            if (mounted) {
              setState(() {
                _isParticipating = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur: Impossible de récupérer votre participation'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
        } else if (errorMessage.contains('pas actuellement disponible') || 
                   errorMessage.contains('not currently available')) {
          if (mounted) {
            setState(() {
              _isParticipating = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ce challenge n\'est pas actuellement disponible'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 4),
              ),
            );
          }
          return;
        } else {
          // Autre erreur
          rethrow;
        }
      }
      
      if (mounted) {
        setState(() {
          _isParticipating = false;
        });
        
        if (participation != null) {
          print('[ChallengeDetailsScreen] Participation successful! Status: ${participation.statut}');
          
          // Vérifier le statut de la participation
          final statut = participation.statut?.toUpperCase() ?? '';
          
          if (statut == 'TERMINE' || statut == 'VALIDE') {
            // Challenge déjà terminé - afficher les résultats
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Vous avez déjà terminé ce challenge. Score: ${participation.score ?? 0}'),
                  backgroundColor: Colors.green,
                ),
              );
            }
            // Optionnel: naviguer vers l'écran de résultats
            return;
          }
          
          // ÉTAPE 2 : Naviguer IMMÉDIATEMENT vers l'écran de questions
          // Les questions seront chargées dans TakeChallengeScreen
          print('[ChallengeDetailsScreen] Navigating to TakeChallengeScreen to load questions...');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakeChallengeScreen(
                challengeId: widget.challengeId,
                eleveId: currentUserId,
                challengeTitle: _challenge?.titre ?? widget.challengeId.toString(),
              ),
            ),
          );
        } else {
          // Aucune participation créée/récupérée
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erreur lors de la participation. Vérifiez votre connexion et réessayez.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('[ChallengeDetailsScreen] Unexpected error in _participateInChallenge: $e');
      if (mounted) {
        setState(() {
          _isParticipating = false;
        });
        String errorMessage = 'Erreur lors de la participation';
        if (e is DioException) {
          if (e.response?.statusCode == 403) {
            errorMessage = 'Accès refusé. Vérifiez vos permissions.';
          } else if (e.response?.statusCode == 401) {
            errorMessage = 'Non autorisé. Veuillez vous reconnecter.';
          } else if (e.response?.statusCode == 404) {
            errorMessage = 'Challenge ou élève introuvable.';
          } else if (e.response?.statusCode == 400) {
            errorMessage = 'Requête invalide.';
          } else {
            final errorData = e.response?.data?.toString() ?? '';
            errorMessage = 'Erreur ${e.response?.statusCode}: ${errorData.isNotEmpty ? errorData : "Erreur inconnue"}';
          }
        } else if (e is Exception) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _challenge?.titre ?? 'Détails du challenge',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                )
              : _challenge == null
                  ? const Center(
                      child: Text(
                        'Impossible de charger les détails du challenge',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : _buildChallengeDetails(primaryColor),
        );
      },
    );
  }

  Widget _buildChallengeDetails(Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Challenge title and points
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _challenge!.titre ?? 'Challenge sans titre',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_calculateTotalPoints(_challenge!)} pts',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _challenge!.description ?? 'Aucune description disponible',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Challenge info cards
          _buildInfoCard(
            icon: Icons.question_answer,
            title: 'Questions',
            value: '${_challenge!.questionsChallenge?.length ?? 0}',
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.access_time,
            title: 'Durée',
            value: _formatDuration(_challenge!.dateDebut, _challenge!.dateFin),
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.group,
            title: 'Type',
            value: _challenge!.typeChallenge?.toString() ?? 'Inconnu',
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: 'Dates',
            value: '${_formatDate(_challenge!.dateDebut)} - ${_formatDate(_challenge!.dateFin)}',
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 20),
          
          // Questions section
          if (_challenge!.questionsChallenge != null && _challenge!.questionsChallenge!.isNotEmpty)
            _buildQuestionsSection(primaryColor),
          
          const SizedBox(height: 20),
          
          // View leaderboard button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengeLeaderboardScreen(
                      challengeId: widget.challengeId,
                      challengeTitle: _challenge!.titre ?? 'Challenge',
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Voir le classement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Participate or Start button
          if (_hasParticipated && _challenge?.questionsChallenge != null && _challenge!.questionsChallenge!.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final int? currentUserId = _authService.currentUserId ?? widget.eleveId;
                  if (currentUserId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TakeChallengeScreen(
                          challengeId: widget.challengeId,
                          eleveId: currentUserId,
                          challengeTitle: _challenge?.titre,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Commencer le challenge',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isParticipating ? null : _participateInChallenge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isParticipating
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Participer au challenge',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotalPoints(Challenge challenge) {
    if (challenge.questionsChallenge == null) {
      return 0;
    }
    
    int totalPoints = 0;
    for (var question in challenge.questionsChallenge!) {
      totalPoints += question.points ?? 0;
    }
    return totalPoints;
  }
  
  String _formatDuration(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return 'Durée inconnue';
    
    final difference = endDate.difference(startDate);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    
    if (days > 0) {
      return '$days jours';
    } else if (hours > 0) {
      return '$hours heures';
    } else {
      return 'Moins d\'une heure';
    }
  }
  
  String _formatDate(DateTime? date) {
    if (date == null) return 'Date inconnue';
    return '${date.day}/${date.month}/${date.year}';
  }
  
  Widget _buildQuestionsSection(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._challenge!.questionsChallenge!.map((question) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.enonce ?? 'Question sans texte',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${question.points ?? 0} points',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (question.type != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            question.type.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}