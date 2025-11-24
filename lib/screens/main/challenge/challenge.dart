import 'package:flutter/material.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/services/challenge_service.dart'; // Use challenge service instead of defi service
import 'package:built_collection/built_collection.dart'; // Add built collection import
import 'package:edugo/services/auth_service.dart'; // Add auth service import
import 'package:edugo/services/theme_service.dart'; // Add theme service import
import 'package:edugo/screens/main/challenge/challenge_details_screen.dart'; // Add challenge details screen import

// Constants for styling
const Color _colorBlack = Color(0xFF000000);
const Color _colorGrey = Color(0xFF757575);
const Color _colorBackground = Color(0xFFF8F9FA);
const String _fontFamily = 'Roboto';

class ChallengeScreen extends StatefulWidget {
  final int? eleveId;
  
  const ChallengeScreen({super.key, this.eleveId});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  BuiltList<Challenge>? _availableChallenges; // Change to BuiltList
  bool _isLoading = false;
  String _filter = 'all'; // Filter for challenges (all, active, upcoming, ended)
  final ChallengeService _challengeService = ChallengeService(); // Use challenge service instance
  final ThemeService _themeService = ThemeService(); // Add theme service

  @override
  void initState() {
    super.initState();
    print('ChallengeScreen initState called, widget.eleveId: ${widget.eleveId}');
    _loadChallenges(); // Load challenges when screen initializes
  }

  // Load available challenges
  Future<void> _loadChallenges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the current user ID from auth service if not provided
      final AuthService authService = AuthService();
      final int? currentUserId = authService.currentUserId;
      print('Current user ID from auth service: $currentUserId');
      
      // If we don't have a valid user ID, show an error
      if (currentUserId == null && widget.eleveId == null) {
        print('No valid user ID available');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez vous connecter pour voir les challenges')),
          );
        }
        return;
      }
      
      final int studentId = widget.eleveId ?? currentUserId ?? 1;
      print('Using student ID: $studentId');
      
      print('Loading challenges for student ID: $studentId');
      final challenges = await _challengeService.getChallengesDisponibles(studentId);
      print('Received challenges: ${challenges?.length ?? 0} items');
      if (challenges != null) {
        print('Challenge titles: ${challenges.map((c) => c.titre).toList()}');
      }
      
      if (mounted) {
        setState(() {
          _availableChallenges = challenges;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading challenges: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show error message with retry option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors du chargement des challenges'),
            action: SnackBarAction(
              label: 'Réessayer',
              onPressed: _loadChallenges,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building ChallengeScreen, _isLoading: $_isLoading, _availableChallenges: ${_availableChallenges?.length ?? 0}');
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          backgroundColor: _colorBackground,
          appBar: AppBar(
            title: const Text(
              'Challenges',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.black),
                onPressed: _showFilterOptions,
                tooltip: 'Filtrer',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: _loadChallenges,
                tooltip: 'Actualiser',
              ),
            ],
          ),
      body: _isLoading 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Chargement des challenges...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: _colorBlack,
                  ),
                ),
              ],
            ),
          )
        : _buildNewChallengesSection(false, false, primaryColor),
        );
      },
    );
  }

  Widget _buildNewChallengesSection(bool isSmallScreen, bool isLargeScreen, Color primaryColor) {
    // Use real data if available, otherwise use simulated data
    List<Map<String, dynamic>> newChallenges = [];
    
    print('Available challenges: ${_availableChallenges?.length ?? 0}');
    if (_availableChallenges != null && _availableChallenges!.isNotEmpty) {
      print('Processing ${_availableChallenges!.length} challenges');
      newChallenges = _availableChallenges!.toList().map((challenge) {
        print('Processing challenge: ${challenge.titre}');
        return {
          'id': challenge.id,
          'title': challenge.titre ?? 'Challenge sans titre',
          'description': challenge.description ?? 'Aucune description disponible',
          'date': _formatDate(challenge.dateDebut),
          'rawDate': challenge.dateDebut,
          'participants': 0, // This would need to be implemented
          'difficulty': challenge.typeChallenge?.toString() ?? 'Inconnu',
          'icon': Icons.help_outline,
          'color': primaryColor,
          'pointDefi': _calculateTotalPoints(challenge),
          'questionsCount': challenge.questionsChallenge?.length ?? 0,
          'startDate': challenge.dateDebut,
          'endDate': challenge.dateFin,
          'timeRemaining': _formatTimeRemaining(challenge.dateFin),

        };
      }).toList();
      
      // Sort challenges by start date (newest first)
      newChallenges.sort((a, b) {
        final dateA = a['rawDate'] as DateTime?;
        final dateB = b['rawDate'] as DateTime?;
        
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        
        return dateB.compareTo(dateA);
      });
      
      // Apply filter based on _filter state
      if (_filter != 'all') {
        newChallenges = newChallenges.where((challenge) {
          switch (_filter) {
            case 'active':
              return _isChallengeActive(challenge);
            case 'upcoming':
              return _isChallengeUpcoming(challenge);
            case 'ended':
              return _isChallengeEnded(challenge);
            default:
              return true;
          }
        }).toList();
      }
      
      print('Processed ${newChallenges.length} challenges for display');
    }

    print('Checking empty state: newChallenges.isEmpty=${newChallenges.isEmpty}, _isLoading=$_isLoading');
    // If we have no challenges but we're not loading, show empty state
    if (newChallenges.isEmpty && !_isLoading) {
      print('Showing empty state');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aucun challenge disponible',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _colorBlack,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Les challenges seront affichés ici lorsqu\'ils seront disponibles',
              style: TextStyle(
                fontSize: 16,
                color: _colorGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadChallenges,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    print('Building ListView with ${newChallenges.length} items');
    return RefreshIndicator(
      onRefresh: _loadChallenges,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: newChallenges.length,
        itemBuilder: (context, index) {
          print('Building item at index $index');
          final challenge = newChallenges[index];
          return _buildChallengeCard(challenge, primaryColor);
        },
      ),
    );
  }

  Widget _buildChallengeCard(Map<String, dynamic> challenge, Color primaryColor) {
    print('Building challenge card: ${challenge['title']}');
    print('Challenge data: $challenge');
    
    // Determine status badge
    String statusText = '';
    Color statusColor = Colors.grey;
    if (_isChallengeActive(challenge)) {
      statusText = 'Actif';
      statusColor = Colors.green;
    } else if (_isChallengeUpcoming(challenge)) {
      statusText = 'À venir';
      statusColor = Colors.orange;
    } else if (_isChallengeEnded(challenge)) {
      statusText = 'Terminé';
      statusColor = Colors.grey;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () {
          _navigateToChallengeDetails(challenge);
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title, points, and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      challenge['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _colorBlack,
                      ),
                    ),
                  ),
                  Row(
                    children: [
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
                              '${challenge['pointDefi']} pts',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                challenge['description'],
                style: const TextStyle(
                  color: _colorGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              
              // Additional info
              Row(
                children: [
                  Icon(
                    Icons.question_answer,
                    size: 16,
                    color: _colorGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${challenge['questionsCount']} questions',
                    style: const TextStyle(
                      color: _colorGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: _colorGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    challenge['timeRemaining'],
                    style: const TextStyle(
                      color: _colorGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Footer with difficulty and participate button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Difficulty badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: challenge['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          challenge['icon'],
                          color: challenge['color'],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          challenge['difficulty'],
                          style: TextStyle(
                            color: challenge['color'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Participate button
                  ElevatedButton(
                    onPressed: () {
                      final challengeId = challenge['id'] as int?;
                      if (challengeId != null) {
                        _participateInChallenge(challengeId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Impossible de participer à ce challenge')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Participer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    print('Formatting date: $date');
    if (date == null) {
      print('Date is null, returning default');
      return 'Date inconnue';
    }
    try {
      // Format as DD/MM/YYYY or provide a more readable format
      final now = DateTime.now();
      final difference = now.difference(date).inDays;
      
      if (difference == 0) {
        return 'Aujourd\'hui';
      } else if (difference == 1) {
        return 'Hier';
      } else if (difference < 7) {
        return 'Il y a $difference jours';
      } else if (date.year == now.year) {
        return '${date.day}/${date.month}';
      } else {
        final formatted = '${date.day}/${date.month}/${date.year}';
        print('Formatted date: $formatted');
        return formatted;
      }
    } catch (e) {
      print('Error formatting date: $e');
      return 'Date inconnue';
    }
  }
  
  Widget _buildChallengeStats(Color primaryColor) {
    // Count different types of challenges
    int activeCount = 0;
    int upcomingCount = 0;
    int endedCount = 0;
    
    if (_availableChallenges != null) {
      for (var challenge in _availableChallenges!) {
        final challengeMap = {
          'startDate': challenge.dateDebut,
          'endDate': challenge.dateFin,
        };
        
        if (_isChallengeActive(challengeMap)) {
          activeCount++;
        } else if (_isChallengeUpcoming(challengeMap)) {
          upcomingCount++;
        } else if (_isChallengeEnded(challengeMap)) {
          endedCount++;
        }
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(activeCount.toString(), 'Actifs', primaryColor, Icons.play_circle_fill),
          _buildStatItem(upcomingCount.toString(), 'À venir', Colors.orange, Icons.schedule),
          _buildStatItem(endedCount.toString(), 'Terminés', Colors.grey, Icons.check_circle),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: _colorGrey,
          ),
        ),
      ],
    );
  }
  
  int _calculateTotalPoints(Challenge challenge) {
    print('Calculating points for challenge: ${challenge.titre}');
    if (challenge.questionsChallenge == null) {
      print('No questions found for challenge');
      return 0;
    }
    
    int totalPoints = 0;
    for (var question in challenge.questionsChallenge!) {
      totalPoints += question.points ?? 0;
    }
    print('Total points for challenge: $totalPoints');
    return totalPoints;
  }
  
  Future<void> _participateInChallenge(int challengeId) async {
    try {
      // Get the current user ID
      final AuthService authService = AuthService();
      final int? currentUserId = authService.currentUserId;
      
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez vous connecter pour participer')),
        );
        return;
      }
      
      // Call the challenge service to participate
      final participation = await _challengeService.participerChallenge(currentUserId, challengeId);
      
      if (participation != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Participation réussie!')),
        );
        // TODO: Navigate to challenge details screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la participation')),
        );
      }
    } catch (e) {
      print('Error participating in challenge: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la participation')),
      );
    }
  }
  
  bool _isChallengeActive(Map<String, dynamic> challenge) {
    final endDate = challenge['endDate'] as DateTime?;
    final startDate = challenge['startDate'] as DateTime?;
    
    if (startDate == null || endDate == null) return false;
    
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }
  
  bool _isChallengeUpcoming(Map<String, dynamic> challenge) {
    final startDate = challenge['startDate'] as DateTime?;
    
    if (startDate == null) return false;
    
    final now = DateTime.now();
    return now.isBefore(startDate);
  }
  
  bool _isChallengeEnded(Map<String, dynamic> challenge) {
    final endDate = challenge['endDate'] as DateTime?;
    
    if (endDate == null) return false;
    
    final now = DateTime.now();
    return now.isAfter(endDate);
  }
  
  String _formatTimeRemaining(DateTime? endDate) {
    if (endDate == null) return 'Durée inconnue';
    
    final now = DateTime.now();
    final difference = endDate.difference(now);
    
    if (difference.isNegative) {
      return 'Terminé';
    }
    
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    
    if (days > 0) {
      return '$days jours restants';
    } else if (hours > 0) {
      return '$hours heures restantes';
    } else if (minutes > 0) {
      return '$minutes minutes restantes';
    } else {
      return 'Moins d\'une minute';
    }
  }
  
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ValueListenableBuilder<Color>(
          valueListenable: _themeService.primaryColorNotifier,
          builder: (context, primaryColor, child) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtrer par',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFilterOption('Tous les challenges', 'all'),
                  _buildFilterOption('Actifs', 'active'),
                  _buildFilterOption('À venir', 'upcoming'),
                  _buildFilterOption('Terminés', 'ended'),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Fermer'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  void _navigateToChallengeDetails(Map<String, dynamic> challenge) {
    // Navigate to the dedicated challenge details screen
    final challengeId = challenge['id'] as int?;
    if (challengeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeDetailsScreen(
            challengeId: challengeId,
            eleveId: widget.eleveId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir les détails du challenge')),
      );
    }
  }
  
  Widget _buildFilterOption(String title, String filterValue) {
    return RadioListTile<String>(
      title: Text(title),
      value: filterValue,
      groupValue: _filter,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _filter = value;
          });
          Navigator.pop(context);
        }
      },
    );
  }
}