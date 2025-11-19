import 'package:flutter/material.dart';
import 'package:edugo/models/participation.dart';

class ChallengeLeaderboardScreen extends StatelessWidget {
  final List<Participation> leaderboard;
  final String challengeTitle;
  
  const ChallengeLeaderboardScreen({
    Key? key,
    required this.leaderboard,
    required this.challengeTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort leaderboard by points in descending order
    final sortedLeaderboard = List<Participation>.from(leaderboard)
      ..sort((a, b) => b.score!.compareTo(a.score!));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Classement - $challengeTitle'),
        backgroundColor: const Color(0xFFA885D8),
        foregroundColor: Colors.white,
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
            Expanded(
              child: ListView.builder(
                itemCount: sortedLeaderboard.length,
                itemBuilder: (context, index) {
                  final Participation participation = sortedLeaderboard[index];
                  return _buildLeaderboardItem(participation, index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLeaderboardItem(Participation participation, int rank) {
    final bool isTopThree = rank <= 3;
    final Color rankColor = rank == 1 
        ? const Color(0xFFFFD700) 
        : rank == 2 
            ? const Color(0xFFC0C0C0) 
            : rank == 3 
                ? const Color(0xFFCD7F32) 
                : Colors.grey;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
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
        title: Text(
          '${participation.eleve?.prenom ?? ''} ${participation.eleve?.nom ?? ''}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          '${participation.score} pts',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}