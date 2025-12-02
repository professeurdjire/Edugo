import 'package:flutter/material.dart';
import 'package:edugo/models/leaderboard_entry.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/auth_service.dart';

class ChallengeLeaderboardScreen extends StatefulWidget {
  final int challengeId;
  final String challengeTitle;
  
  const ChallengeLeaderboardScreen({
    Key? key,
    required this.challengeId,
    required this.challengeTitle,
  }) : super(key: key);

  @override
  State<ChallengeLeaderboardScreen> createState() => _ChallengeLeaderboardScreenState();
}

class _ChallengeLeaderboardScreenState extends State<ChallengeLeaderboardScreen> {
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = true;
  final ChallengeService _challengeService = ChallengeService();
  final ThemeService _themeService = ThemeService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final leaderboard = await _challengeService.getChallengeLeaderboard(widget.challengeId);
      if (mounted) {
        print('[ChallengeLeaderboardScreen] Loaded ${leaderboard.length} leaderboard entries');
        
        // Log pour déboguer - afficher toutes les informations
        print('[ChallengeLeaderboardScreen] ========== LEADERBOARD DEBUG ==========');
        for (var i = 0; i < leaderboard.length; i++) {
          final entry = leaderboard[i];
          print('[ChallengeLeaderboardScreen] Rank ${entry.rang}:');
          print('  - Nom complet: ${entry.fullName}');
          print('  - Eleve ID: ${entry.eleveId}');
          print('  - Score: ${entry.points}');
          print('  - Temps: ${entry.tempsPasse}s');
          print('  - Date participation: ${entry.dateParticipation}');
          print('  ---');
        }
        print('[ChallengeLeaderboardScreen] =======================================');
        
        setState(() {
          _leaderboard = leaderboard;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[ChallengeLeaderboardScreen] Error loading leaderboard: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement du classement: $e')),
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
              'Classement - ${widget.challengeTitle}',
              style: const TextStyle(
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: _loadLeaderboard,
                tooltip: 'Actualiser',
              ),
            ],
          ),
      body: Column(
        children: [
          if (_leaderboard.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLeaderboardHeader(primaryColor),
            ),
            const Divider(height: 1),
          ],
          Expanded(
            child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                )
              : _leaderboard.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.leaderboard, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucun participant avec score',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _leaderboard.length,
                      itemBuilder: (context, index) {
                        final entry = _leaderboard[index];
                        final currentUserId = _authService.currentUserId;
                        final isCurrentStudent = currentUserId != null && currentUserId == entry.eleveId;
                        return _buildLeaderboardItem(entry, primaryColor, isCurrentStudent);
                      },
                    ),
          ),
        ],
      ),
        );
      },
    );
  }
  
  Widget _buildLeaderboardHeader(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Rang',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Participant',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Score',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Temps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLeaderboardItem(LeaderboardEntry entry, Color primaryColor, bool isHighlighted) {
    final bool isTopThree = entry.rang <= 3;
    
    // Déterminer l'icône et la couleur selon le rang
    IconData? rankIcon;
    Color rankColor;
    
    if (entry.rang == 1) {
      rankIcon = Icons.emoji_events;
      rankColor = Colors.amber;
    } else if (entry.rang == 2) {
      rankIcon = Icons.workspace_premium;
      rankColor = Colors.grey;
    } else if (entry.rang == 3) {
      rankIcon = Icons.military_tech;
      rankColor = Colors.brown;
    } else {
      rankColor = Colors.grey.shade300;
    }
    
    // Format time spent
    final String timeSpent = _formatTime(entry.tempsPasse);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue.shade50 : Colors.white,
        border: isHighlighted 
            ? Border.all(color: Colors.blue, width: 2) 
            : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: rankColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: rankIcon != null
                ? Icon(rankIcon, color: Colors.white, size: 28)
                : Text(
                    '${entry.rang}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        title: Text(
          entry.fullName,
          style: TextStyle(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Temps: $timeSpent',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${entry.points}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              'points',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(int seconds) {
    if (seconds <= 0) {
      return '0s';
    }
    
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
}