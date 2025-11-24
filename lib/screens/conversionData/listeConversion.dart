import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

class PointExchangeScreen extends StatefulWidget {
  final ThemeService? themeService;

  const PointExchangeScreen({super.key, this.themeService});

  @override
  State<PointExchangeScreen> createState() => _PointExchangeScreenState();
}

class _PointExchangeScreenState extends State<PointExchangeScreen> {
  // Variables d'État
  int? _selectedIndex;
  late ThemeService _themeService;

  // Simuler le solde de points actuel
  final int currentPoints = 1000;

  // Liste des options d'échange
  final List<Map<String, dynamic>> exchangeOptions = [
    {'data': '200Mo', 'points': 100},
    {'data': '250Mo', 'points': 150},
    {'data': '500Mo', 'points': 250},
    {'data': '1Go', 'points': 1000},
    {'data': '1,5Go', 'points': 1500},
  ];

  @override
  void initState() {
    super.initState();
    _themeService = widget.themeService ?? ThemeService();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        // Couleurs dynamiques basées sur le thème
        final Color primaryPurple = primaryColor;
        final Color orangePoints = const Color(0xFFFF7900);
        final Color selectedCardColor = primaryColor.withOpacity(0.1);
        final Color unselectedCardColor = const Color(0xFFFFFFFF);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black12,
            iconTheme: const IconThemeData(color: Colors.black12),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black12),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Échanger des points',
              style: TextStyle(
                color: Colors.black12,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildCurrentBalanceCard(primaryColor, orangePoints),
                      const SizedBox(height: 30),
                      Text(
                        'Options d\'échange',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 15),
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
                            primaryColor: primaryColor,
                            selectedCardColor: selectedCardColor,
                            unselectedCardColor: unselectedCardColor,
                            orangePoints: orangePoints,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              _buildExchangeButton(primaryColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentBalanceCard(Color primaryColor, Color orangePoints) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Solde actuel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryColor,
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
    required Color primaryColor,
    required Color selectedCardColor,
    required Color unselectedCardColor,
    required Color orangePoints,
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
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? primaryColor : Colors.black,
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

  Widget _buildExchangeButton(Color primaryColor) {
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
                    selectedOption['data'],
                    selectedOption['points'],
                    primaryColor,
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            disabledBackgroundColor: primaryColor.withOpacity(0.5),
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

  void _showExchangePopup(String data, int points, Color primaryColor) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.compare_arrows,
                    size: 40,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Vous êtes sur le point d'échanger",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: data),
                      const TextSpan(
                        text: ' pour ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: '$points points',
                        style: const TextStyle(color: Color(0xFFFF7900)),
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
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Annuler', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: primaryColor,
                              content: Text(
                                'Échange de $data pour $points points effectué !',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Confirmer', style: TextStyle(fontSize: 16)),
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

}