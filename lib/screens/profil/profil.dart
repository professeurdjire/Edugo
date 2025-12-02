import 'package:edugo/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/profil/modifierProfil.dart';
import 'package:edugo/screens/profil/changerMotPasse.dart';
import 'package:edugo/screens/profil/suggestion.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/badge_service.dart';
import 'package:edugo/services/challenge_service.dart';
import 'package:built_collection/built_collection.dart';

class ProfilScreen extends StatefulWidget {
  final int? eleveId;

  const ProfilScreen({super.key, this.eleveId});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final AuthService _authService = AuthService();
  final ThemeService _themeService = ThemeService();
  final BadgeService _badgeService = BadgeService();
  final ChallengeService _challengeService = ChallengeService();
  
  int _badgesCount = 0;
  int _challengesWonCount = 0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // S'assurer que les données utilisateur sont à jour
    await _authService.getCurrentUserProfile();
    
    // Charger les statistiques (badges et challenges remportés)
    await _loadStatistics();
    
    setState(() {});
  }
  
  Future<void> _loadStatistics() async {
    setState(() {
      _isLoadingStats = true;
    });
    
    try {
      final eleveId = _authService.currentUserId ?? widget.eleveId;
      if (eleveId != null) {
        // Charger les badges
        final badges = await _badgeService.getBadges(eleveId);
        _badgesCount = badges?.length ?? 0;
        print('[ProfilScreen] Loaded ${_badgesCount} badges');
        
        // Charger les challenges participés et compter ceux qui sont terminés/validés
        final participations = await _challengeService.getChallengesParticipes(eleveId);
        if (participations != null) {
          _challengesWonCount = participations.where((p) {
            final statut = p.statut?.toUpperCase() ?? '';
            return statut == 'TERMINE' || statut == 'VALIDE';
          }).length;
          print('[ProfilScreen] Loaded ${_challengesWonCount} challenges won out of ${participations.length} participations');
        } else {
          _challengesWonCount = 0;
        }
      }
    } catch (e) {
      print('[ProfilScreen] Error loading statistics: $e');
      _badgesCount = 0;
      _challengesWonCount = 0;
    } finally {
      setState(() {
        _isLoadingStats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEleve = _authService.currentEleve;

    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        // Couleurs dynamiques basées sur le thème
        final Color primaryPurple = primaryColor;
        final Color lightPurple = primaryColor.withOpacity(0.1);
        final Color cardBackground = const Color(0xFFF8F9FA);
        final Color logoutRed = const Color(0xFFFF6B6B);
        final Color textDark = const Color(0xFF2D3748);
        final Color textLight = const Color(0xFF718096);

        return Scaffold(
          backgroundColor: Colors.white,

          // AppBar améliorée
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              "Profil",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
          ),

          // Corps de la page
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // --- Carte Profil Principale ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryPurple.withOpacity(0.9), primaryPurple],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPurple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar avec photo réelle
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: lightPurple,
                          backgroundImage: currentEleve?.photoProfil != null &&
                                          currentEleve!.photoProfil!.isNotEmpty
                              ? NetworkImage(currentEleve.photoProfil!)
                              : const AssetImage('assets/avatar.png') as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nom et email réels
                      Text(
                        "${currentEleve?.prenom ?? 'Prénom'} ${currentEleve?.nom ?? 'Nom'}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentEleve?.email ?? "email@example.com",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Statistiques avec données réelles ---
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              icon: Icons.workspace_premium,
                              value: _isLoadingStats ? "..." : "$_badgesCount",
                              label: "Badges",
                              color: const Color(0xFFFFD700),
                            ),
                            _StatItem(
                              icon: Icons.star_rounded,
                              value: "${currentEleve?.pointAccumule ?? 0}",
                              label: "Points",
                              color: const Color(0xFFFFA500),
                            ),
                            _StatItem(
                              icon: Icons.emoji_events_rounded,
                              value: _isLoadingStats ? "..." : "$_challengesWonCount",
                              label: "Challenges",
                              color: const Color(0xFF4CAF50),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- Section Paramètres ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Paramètres",
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 16),

                      _ActionButton(
                        text: "Modifier le profil",
                        icon: Icons.person_outline,
                        color: Colors.white,
                        primaryColor: primaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _ActionButton(
                        text: "Changer le mot de passe",
                        icon: Icons.lock_outline,
                        color: Colors.white,
                        primaryColor: primaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _ActionButton(
                        text: "Changer la couleur du thème",
                        icon: Icons.color_lens,
                        color: Colors.white,
                        primaryColor: primaryColor,
                        onPressed: () {
                          _showColorPickerDialog(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      _ActionButton(
                        text: "Suggestion",
                        icon: Icons.lightbulb_outline,
                        color: Colors.white,
                        primaryColor: primaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SuggestionScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Bouton Déconnexion ---
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: logoutRed.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: logoutRed.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: logoutRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Déconnexion",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Déconnexion",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          content: const Text(
            "Êtes-vous sûr de vouloir vous déconnecter ?",
            style: TextStyle(
              fontFamily: 'Roboto',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Annuler",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authService = AuthService();
                await authService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                "Déconnexion",
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Choisir la couleur du thème",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _themeService.availableColors.length,
              itemBuilder: (context, index) {
                final color = _themeService.availableColors[index];
                return GestureDetector(
                  onTap: () {
                    _themeService.setPrimaryColor(color.value.toString());
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Annuler",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget Statistiques amélioré
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF2D3748),
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}

// Widget pour les boutons d'action amélioré
class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final Color primaryColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.color,
    required this.icon,
    required this.primaryColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onPressed,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w500,
            fontSize: 15,
            fontFamily: 'Roboto',
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: primaryColor,
            size: 14,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}