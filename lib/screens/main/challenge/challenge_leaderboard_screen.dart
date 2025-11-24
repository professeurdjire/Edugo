import 'package:flutter/material.dart';
import 'package:edugo/models/participation.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/models/challenge.dart';

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
  List<Participation> _leaderboard = [];
  bool _isLoading = true;
  final ChallengeService _challengeService = ChallengeService();
  final ThemeService _themeService = ThemeService();

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
      if (leaderboard != null && mounted) {
        // Sort leaderboard by points in descending order
        final sortedLeaderboard = List<Participation>.from(leaderboard)
          ..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
        
        setState(() {
          _leaderboard = sortedLeaderboard;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors du chargement du classement')),
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
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Classement',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Voici le classement des participants',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            if (_leaderboard.isNotEmpty)
              _buildLeaderboardHeader(primaryColor),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : _leaderboard.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun participant pour le moment',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _leaderboard.length,
                        itemBuilder: (context, index) {
                          final Participation participation = _leaderboard[index];
                          return _buildLeaderboardItem(participation, index + 1, primaryColor);
                        },
                      ),
            ),
          ],
        ),
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
  
  Widget _buildLeaderboardItem(Participation participation, int rank, Color primaryColor) {
    final bool isTopThree = rank <= 3;
    final Color rankColor = rank == 1 
        ? const Color(0xFFFFD700) 
        : rank == 2 
            ? const Color(0xFFC0C0C0) 
            : rank == 3 
                ? const Color(0xFFCD7F32) 
                : Colors.grey;
    
    // Format time spent
    final String timeSpent = _formatTime(participation.tempsPasse ?? 0);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isTopThree ? rankColor : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isTopThree ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Participant name - améliorer l'affichage
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getParticipantName(participation),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  if (participation.eleve?.email != null)
                    Text(
                      participation.eleve!.email!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Score
            Expanded(
              flex: 2,
              child: Text(
                '${participation.score ?? 0} pts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            // Time spent
            Expanded(
              flex: 2,
              child: Text(
                timeSpent,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int secs = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
  
  String _getParticipantName(Participation participation) {
    // Essayer d'abord avec l'objet eleve
    if (participation.eleve != null) {
      final prenom = participation.eleve!.prenom ?? '';
      final nom = participation.eleve!.nom ?? '';
      if (prenom.isNotEmpty || nom.isNotEmpty) {
        return '${prenom.trim()} ${nom.trim()}'.trim();
      }
    }
    
    // Fallback: utiliser l'ID de l'élève si disponible
    if (participation.eleve?.id != null) {
      return 'Élève #${participation.eleve!.id}';
    }
    
    // Dernier recours
    return 'Participant inconnu';
  }
}