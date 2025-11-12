import 'package:edugo/screens/principales/accueil/accueille.dart';
import 'package:edugo/screens/principales/assistant/assistant1.dart';
import 'package:edugo/screens/principales/bibliotheque/bibliotheque.dart';
import 'package:edugo/screens/principales/challenge/challenge.dart';
import 'package:edugo/screens/principales/exercice/exercice1.dart';
import 'package:flutter/material.dart';
import 'package:edugo/core/constants/constant.dart';

class MainScreen extends StatefulWidget {
  final int? eleveId;

  const MainScreen({super.key, this.eleveId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialiser les pages avec l'ID de l'élève
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      HomeScreen(eleveId: widget.eleveId), // Passer l'ID à HomeScreen
      LibraryScreen(eleveId: widget.eleveId), // Passer l'ID à LibraryScreen si nécessaire
      ChallengeScreen(eleveId: widget.eleveId), // Passer l'ID à ChallengeScreen si nécessaire
      MatiereListScreen(eleveId: widget.eleveId), // Passer l'ID à MatiereListScreen si nécessaire
      AssistanceScreen(eleveId: widget.eleveId), // Passer l'ID à AssistanceScreen si nécessaire
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
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
          _NavBarItem(icon: Icons.home, label: 'Accueil', index: 0),
          _NavBarItem(icon: Icons.book, label: 'Bibliothèque', index: 1),
          _NavBarItem(icon: Icons.emoji_events_outlined, label: 'Challenge', index: 2),
          _NavBarItem(icon: Icons.checklist, label: 'Exercice', index: 3),
          _NavBarItem(icon: Icons.chat_bubble_outline, label: 'Assistance', index: 4),
        ],
      ),
    );
  }

  Widget _NavBarItem({required IconData icon, required String label, required int index}) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFFA885D8) : Colors.black,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFFA885D8) : Colors.black,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}