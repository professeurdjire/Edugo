import 'package:flutter/material.dart';

// Vous pouvez nommer ce fichier 'point_exchange_screen.dart'

class PointExchangeScreen extends StatefulWidget {
  const PointExchangeScreen({super.key});

  @override
  State<PointExchangeScreen> createState() => _PointExchangeScreenState();
}

class _PointExchangeScreenState extends State<PointExchangeScreen> {
  // --- Palettes de Couleurs et Variables d'État ---
  final Color primaryPurple = const Color(0xFFA885D8); // Couleur principale
  final Color orangePoints = const Color(0xFFFF7900); // Couleur des points
  final Color selectedBorderColor = const Color(0xFFA885D8);
  final Color unselectedCardColor = const Color(0xFFFFFFFF);
  final Color selectedCardColor = const Color(0xFFF3EDFC); // Fond plus clair

  // Simuler le solde de points actuel
  final int currentPoints = 1000;

  // Variable pour stocker l'index sélectionné
  int? _selectedIndex;

  // Liste des options d'échange
  final List<Map<String, dynamic>> exchangeOptions = [
    {'data': '200Mo', 'points': 100},
    {'data': '250Mo', 'points': 150},
    {'data': '500Mo', 'points': 250},
    {'data': '1Go', 'points': 1000},
    {'data': '1,5Go', 'points': 1500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- 1. Barre d'application ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Échanger des points',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      // --- 2. Corps de l’écran ---
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // --- Solde Actuel ---
                  _buildCurrentBalanceCard(),
                  const SizedBox(height: 30),

                  // --- Titre Options d'échange ---
                  const Text(
                    'Options d\'échange',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- Liste des options ---
                  ...exchangeOptions.asMap().entries.map((entry) {
                    int index = entry.key;
                    var option = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: _buildExchangeOptionCard(
                        index: index,
                        data: option['data'],
                        points: option['points'],
                        isSelected: _selectedIndex == index,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // --- Bouton Échanger ---
          _buildExchangeButton(),

          // --- Barre de Navigation Inférieure ---
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  // --- Widgets de Construction ---

  Widget _buildCurrentBalanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Solde actuel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            '$currentPoints points',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: orangePoints,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeOptionCard({
    required int index,
    required String data,
    required int points,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        decoration: BoxDecoration(
          color: isSelected ? selectedCardColor : unselectedCardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? selectedBorderColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? primaryPurple : Colors.black,
              ),
            ),
            Text(
              '$points points',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: orangePoints,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeButton() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedIndex != null
              ? () {
                  var selectedOption = exchangeOptions[_selectedIndex!];
                  _showExchangePopup(
                      selectedOption['data'], selectedOption['points']);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            disabledBackgroundColor: primaryPurple.withOpacity(0.5),
          ),
          child: const Text(
            'Échanger',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // --- Popup personnalisé ---
  void _showExchangePopup(String data, int points) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icône circulaire
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBE0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.compare_arrows,
                    size: 40,
                    color: Color(0xFFA885D8),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Vous êtes sur le point d'échanger",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 5),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: data),
                      const TextSpan(
                        text: ' pour ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: '$points points',
                        style: const TextStyle(color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryPurple,
                          side: BorderSide(color: primaryPurple),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            const Text('Annuler', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Échange de $data pour $points points effectué !'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Confirmer',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryPurple,
      unselectedItemColor: Colors.grey,
      currentIndex: 3,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          label: 'Bibliothèque',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          label: 'Challenge',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Exercice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Assistance',
        ),
      ],
      onTap: (index) {
        // Implémenter la navigation si nécessaire
      },
    );
  }
}
