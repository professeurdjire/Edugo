import 'package:flutter/material.dart';
import 'package:edugo/models/challenge.dart';
import 'package:edugo/services/challenge_service.dart'; // Use challenge service instead of defi service
import 'package:built_collection/built_collection.dart'; // Add built collection import
import 'package:edugo/services/auth_service.dart'; // Add auth service import

// Constants for styling
const Color _purpleMain = Color(0xFFA885D8);
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
  final ChallengeService _challengeService = ChallengeService(); // Use challenge service instance

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
    return Scaffold(
      backgroundColor: _colorBackground,
      appBar: AppBar(
        title: const Text('Challenges'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChallenges,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_purpleMain),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chargement des challenges...',
                  style: TextStyle(
                    fontSize: 16,
                    color: _colorGrey,
                  ),
                ),
              ],
            ),
          ) // Show loading indicator
        : _buildNewChallengesSection(false, false),
    );
  }

  Widget _buildNewChallengesSection(bool isSmallScreen, bool isLargeScreen) {
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
          'color': _purpleMain,
          'pointDefi': _calculateTotalPoints(challenge),
          'questionsCount': challenge.questionsChallenge?.length ?? 0,
        };
      }).toList();
      print('Processed ${newChallenges.length} challenges for display');
    } else if (!_isLoading) {
      // Show empty state if no challenges and not loading
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun challenge disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _colorGrey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Les challenges seront affichés ici lorsqu\'ils seront disponibles',
              style: TextStyle(
                fontSize: 14,
                color: _colorGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadChallenges,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleMain,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    print('Checking empty state: newChallenges.isEmpty=${newChallenges.isEmpty}, _isLoading=$_isLoading');
    // If we have no challenges but we're not loading, show empty state
    if (newChallenges.isEmpty && !_isLoading) {
      print('Showing empty state');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun challenge disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _colorGrey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Les challenges seront affichés ici lorsqu\'ils seront disponibles',
              style: TextStyle(
                fontSize: 14,
                color: _colorGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadChallenges,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _purpleMain,
                foregroundColor: Colors.white,
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
          return _buildChallengeCard(challenge);
        },
      ),
    );
  }

  Widget _buildChallengeCard(Map<String, dynamic> challenge) {
    print('Building challenge card: ${challenge['title']}');
    print('Challenge data: $challenge');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and points
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _purpleMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: _purpleMain,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${challenge['pointDefi']} pts',
                        style: const TextStyle(
                          color: _purpleMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Description
            Text(
              challenge['description'],
              style: const TextStyle(
                color: _colorGrey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            
            // Footer with info
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
                // Date
                Text(
                  challenge['date'],
                  style: const TextStyle(
                    color: _colorGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
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
      final formatted = '${date.day}/${date.month}/${date.year}';
      print('Formatted date: $formatted');
      return formatted;
    } catch (e) {
      print('Error formatting date: $e');
      return 'Date inconnue';
    }
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
}