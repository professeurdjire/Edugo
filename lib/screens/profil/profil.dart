import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Couleurs principales
    const Color primaryPurple = Color(0xFF9B7DE4);
    const Color lightPurple = Color(0xFFF3EDFC);
    const Color buttonPurple = Color(0xFFD6C2FF);
    const Color logoutRed = Color(0xFFD65A5A);

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Profil",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // ✅ Corps de la page
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Section Profil ---
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              decoration: BoxDecoration(
                color: primaryPurple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // 🧑‍🎨 Avatar
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: lightPurple,
                    backgroundImage: const AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(height: 10),

                  // 👤 Nom et email
                  const Text(
                    "Haoua Haïdara",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "haidarahaoua@gmail.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),

                  // --- Statistiques ---
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _StatItem(
                          icon: Icons.workspace_premium_outlined,
                          value: "5",
                          label: "badges",
                        ),
                        _StatItem(
                          icon: Icons.star,
                          value: "1000",
                          label: "points",
                        ),
                        _StatItem(
                          icon: Icons.emoji_events_outlined,
                          value: "7",
                          label: "challenge",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- Boutons d’action ---
                  _ActionButton(
                    text: "Modifier le profil",
                    color: buttonPurple,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  _ActionButton(
                    text: "Changer le mot de passe",
                    color: buttonPurple,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  _ActionButton(
                    text: "Suggestion",
                    color: buttonPurple,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),

                  // --- Bouton Déconnexion ---
                  _ActionButton(
                    text: "Déconnexion",
                    color: logoutRed,
                    textColor: Colors.white,
                    icon: Icons.logout,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ Barre de navigation inférieure
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: "Bibliothèque",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: "Challenge",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            label: "Exercice",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: "Assistance",
          ),
        ],
      ),
    );
  }
}

// 🔹 Widget Statistiques (badges, points, challenge)
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
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// 🔹 Widget pour les boutons d’action
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
