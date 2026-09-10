import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/screens/connexion%20et%20inscriptions/login.dart';
import 'package:edugo/screens/profil/changerMotPasse.dart';
import 'package:edugo/screens/profil/modifierProfil.dart';
import 'package:edugo/screens/profil/suggestion.dart';
import 'package:edugo/services/api/api.dart';
import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  // Couleurs propres à cet écran
  static const Color _buttonPurple = Color(0xFFD6C2FF);
  static const Color _logoutRed = Color(0xFFD65A5A);

  void _handleLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Déconnexion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        content: const Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: TextStyle(fontFamily: AppConst.fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppConst.textGrey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              // Efface le jeton et le profil stockés localement
              await AuthService.instance.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Se déconnecter',
              style: TextStyle(
                color: _logoutRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Profil',
          style: TextStyle(
            color: AppConst.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Carte profil ---
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              decoration: BoxDecoration(
                color: AppConst.purpleButton,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: AppConst.purpleInputFill,
                    backgroundImage: AssetImage('assets/images/avatar1.png'),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'Haoua Haïdara',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConst.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'haidarahaoua@gmail.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: AppConst.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Statistiques ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.workspace_premium_outlined,
                          value: '5',
                          label: 'badges',
                        ),
                        _StatItem(
                          icon: Icons.star,
                          value: '1000',
                          label: 'points',
                        ),
                        _StatItem(
                          icon: Icons.emoji_events_outlined,
                          value: '7',
                          label: 'challenges',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- Boutons d'action ---
                  _ActionButton(
                    text: 'Modifier le profil',
                    color: _buttonPurple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _ActionButton(
                    text: 'Changer le mot de passe',
                    color: _buttonPurple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChangePasswordScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _ActionButton(
                    text: 'Suggestion',
                    color: _buttonPurple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuggestionScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  _ActionButton(
                    text: 'Déconnexion',
                    color: _logoutRed,
                    textColor: Colors.white,
                    icon: Icons.logout,
                    onPressed: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Statistiques (badges, points, challenges)
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 26),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConst.textDark,
            fontFamily: AppConst.fontFamily,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppConst.textGrey,
            fontFamily: AppConst.fontFamily,
          ),
        ),
      ],
    );
  }
}

// Widget pour les boutons d'action
class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.textColor = Colors.black,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                fontFamily: AppConst.fontFamily,
              ),
            ),
            Icon(
              icon ?? Icons.arrow_right_alt,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
