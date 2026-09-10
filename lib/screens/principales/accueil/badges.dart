import 'package:edugo/core/constants/constant.dart';
import 'package:flutter/material.dart';

const Color _colorGold = Color(0xFFFFD700);
const Color _colorSilver = Color(0xFFC0C0C0);
const Color _colorBronze = Color(0xFFCD7F32);

class _Badge {
  final String label;
  final String description;
  final Color color;
  final bool unlocked;

  const _Badge({
    required this.label,
    required this.description,
    required this.color,
    this.unlocked = true,
  });
}

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  // Données simulées, cohérentes avec l'accueil (3 badges affichés)
  // et le profil (5 badges au total)
  static const List<_Badge> _badges = [
    _Badge(
      label: 'Génie math',
      description: '10 quiz de mathématiques réussis',
      color: _colorGold,
    ),
    _Badge(
      label: '20 questions/10min',
      description: '20 bonnes réponses en moins de 10 minutes',
      color: _colorBronze,
    ),
    _Badge(
      label: 'Calcul mental',
      description: 'Série de calculs sans erreur',
      color: _colorSilver,
    ),
    _Badge(
      label: 'Premier livre',
      description: 'Premier livre terminé',
      color: _colorGold,
    ),
    _Badge(
      label: 'Quiz parfait',
      description: 'Un quiz réussi à 100 %',
      color: _colorSilver,
    ),
    _Badge(
      label: '10 livres lus',
      description: 'Terminez 10 livres pour débloquer',
      color: _colorGold,
      unlocked: false,
    ),
    _Badge(
      label: 'Champion',
      description: 'Gagnez un challenge pour débloquer',
      color: _colorGold,
      unlocked: false,
    ),
    _Badge(
      label: '7 jours d\'affilée',
      description: 'Lisez 7 jours de suite pour débloquer',
      color: _colorSilver,
      unlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final int unlockedCount = _badges.where((b) => b.unlocked).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: AppConst.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Succès et Badges',
          style: TextStyle(
            color: AppConst.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Text(
              '$unlockedCount badge${unlockedCount > 1 ? 's' : ''} débloqué${unlockedCount > 1 ? 's' : ''} sur ${_badges.length}',
              style: const TextStyle(
                color: AppConst.textGrey,
                fontSize: 15,
                fontFamily: AppConst.fontFamily,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.05,
              ),
              itemCount: _badges.length,
              itemBuilder: (context, index) {
                final _Badge badge = _badges[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: badge.unlocked
                        ? AppConst.purpleInputFill
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        badge.unlocked ? Icons.emoji_events : Icons.lock_outline,
                        color: badge.unlocked
                            ? badge.color
                            : AppConst.textGrey.withOpacity(0.6),
                        size: 50,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: badge.unlocked
                              ? AppConst.textDark
                              : AppConst.textGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConst.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        badge.description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppConst.textGrey,
                          fontSize: 12,
                          fontFamily: AppConst.fontFamily,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
