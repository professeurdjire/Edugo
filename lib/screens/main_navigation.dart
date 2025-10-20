import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/accueil/accueille.dart';
import 'package:edugo/screens/principales/bibliotheque/bibliotheque.dart';
import 'package:edugo/screens/principales/challenge/challenge.dart';
import 'package:edugo/screens/principales/exercice/exercice1.dart';
import 'package:edugo/screens/principales/assistant/assistant1.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Liste des écrans
  final List<Widget> _screens = const [
    HomeScreen(),
    LibraryScreen(),
    ChallengeScreen(),
    ExerciseMatiereScreen(),
    AssistanceScreen(),
  ];

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
