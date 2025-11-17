import 'package:edugo/screens/main/accueil/accueille.dart';
import 'package:edugo/screens/main/assistant/assistant1.dart';
import 'package:edugo/screens/main/bibliotheque/bibliotheque.dart';
import 'package:edugo/screens/main/challenge/challenge.dart';
import 'package:edugo/screens/main/exercice/exercice1.dart';
import 'package:flutter/material.dart';
import 'package:edugo/core/constants/constant.dart';
import 'package:edugo/services/theme_service.dart';

class MainScreen extends StatefulWidget {
  final int? eleveId;
  final ThemeService themeService;

  const MainScreen({super.key, this.eleveId, required this.themeService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialiser les pages avec l'ID de l'élève et le themeService
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      HomeScreen(eleveId: widget.eleveId, themeService: widget.themeService),
      LibraryScreen(eleveId: widget.eleveId), // Si LibraryScreen n'a pas besoin de themeService
      ChallengeScreen(eleveId: widget.eleveId), // Si ChallengeScreen n'a pas besoin de themeService
      MatiereListScreen(eleveId: widget.eleveId), // Si MatiereListScreen n'a pas besoin de themeService
      AssistanceScreen(eleveId: widget.eleveId), // Si AssistanceScreen n'a pas besoin de themeService
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: widget.themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: _buildBottomNavBar(primaryColor),
        );
      },
    );
  }

  Widget _buildBottomNavBar(Color primaryColor) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(icon: Icons.home, label: 'Accueil', index: 0, primaryColor: primaryColor),
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque', index: 1, primaryColor: primaryColor),
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge', index: 2, primaryColor: primaryColor),
          _NavBarItem(icon: Icons.checklist, label: 'Exercice', index: 3, primaryColor: primaryColor),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance', index: 4, primaryColor: primaryColor),
        ],
      ),
    );
  }

  Widget _NavBarItem({required IconData icon, required String label, required int index, required Color primaryColor}) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryColor : Colors.black,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryColor : Colors.black,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}