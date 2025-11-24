import 'package:edugo/screens/main/accueil/accueille.dart';
import 'package:edugo/screens/main/assistant/assistant1.dart';
import 'package:edugo/screens/main/bibliotheque/bibliotheque.dart';
import 'package:edugo/screens/main/challenge/challenge.dart';
import 'package:edugo/screens/main/exercice/exercice1.dart';
import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

class MainScreen extends StatefulWidget {
  final int? eleveId;
  final ThemeService themeService;

  const MainScreen({
    super.key,
    this.eleveId,
    required this.themeService,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      HomeScreen(eleveId: widget.eleveId, themeService: widget.themeService),
      LibraryScreen(eleveId: widget.eleveId),
      ChallengeScreen(eleveId: widget.eleveId),
      MatiereListScreen(eleveId: widget.eleveId),
      AssistanceScreen(eleveId: widget.eleveId),
    ];
  }

  void _onItemTapped(int index) {
    _previousIndex = _selectedIndex;
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0 && _previousIndex != 0) {
      HomeScreen.refresh(context);
    }
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
       margin: const EdgeInsets.only(bottom: 32.0),
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
          _navItem(Icons.home, "Accueil", 0, primaryColor),
          _navItem(Icons.book, "Bibliothèque", 1, primaryColor),
          _navItem(Icons.emoji_events_outlined, "Challenge", 2, primaryColor),
          _navItem(Icons.checklist, "Exercice", 3, primaryColor),
          _navItem(Icons.chat_bubble_outline, "Assistance", 4, primaryColor),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    int index,
    Color primaryColor,
  ) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryColor : Colors.black,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryColor : Colors.black,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
