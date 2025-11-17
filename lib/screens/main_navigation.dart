import 'package:edugo/screens/main/exercice/exercice1.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/main/accueil/accueille.dart';
import 'package:edugo/screens/main/bibliotheque/bibliotheque.dart';
import 'package:edugo/screens/main/challenge/challenge.dart';
import 'package:edugo/screens/main/assistant/assistant1.dart';

class MainNavigation extends StatefulWidget {
  final int? eleveId;
  final dynamic themeService; // Using dynamic to avoid import issues

  const MainNavigation({super.key, this.eleveId, this.themeService});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Liste des écrans
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens = [
      HomeScreen(eleveId: widget.eleveId, themeService: widget.themeService),
      LibraryScreen(eleveId: widget.eleveId),
      ChallengeScreen(eleveId: widget.eleveId),
      MatiereListScreen(eleveId: widget.eleveId),
      AssistanceScreen(eleveId: widget.eleveId),
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
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFA885D8),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bibliotheque'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Challenge'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Exercice'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Assistance'),
        ],
      ),
    );
  }
}