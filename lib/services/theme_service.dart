import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() => _instance;

  ThemeService._internal();

  static const String _primaryColorKey = 'primary_color';
  static const String _defaultPrimaryColor = '0xFFA885D8';

  final ValueNotifier<Color> primaryColorNotifier =
      ValueNotifier<Color>(Color(int.parse(_defaultPrimaryColor)));

  // Liste des couleurs disponibles pour le sélecteur
  // final List<Color> availableColors = [
  //   const Color(0xFFA885D8), // Violet original
  //   const Color(0xFF4CAF50), // Vert
  //   const Color(0xFF2196F3), // Bleu
  //   const Color(0xFFFF9800), // Orange
  //   const Color(0xFFE91E63), // Rose
  //   const Color(0xFF9C27B0), // Violet foncé
  // ];

  final List<Color> availableColors = [
  const Color(0xFF6A3FA8), // Violet principal
  const Color(0xFFFF7900), // Digital Orange
  const Color(0xFF50BE87), // Vert
  const Color(0xFF527EDB), // Bleu classique
  const Color(0xFFA885D8), // 
  const Color(0xFFFFB4E6), // Rose
];


  Future<void> initialize() async {
    final colorValue = await getPrimaryColor();
    primaryColorNotifier.value = Color(int.parse(colorValue));
  }

  Future<void> setPrimaryColor(String colorValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_primaryColorKey, colorValue);
    primaryColorNotifier.value = Color(int.parse(colorValue));
  }

  Future<String> getPrimaryColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_primaryColorKey) ?? _defaultPrimaryColor;
  }

  Color get currentPrimaryColor => primaryColorNotifier.value;

  // Méthodes utilitaires pour les variations de couleur
  Color get lightVariant => currentPrimaryColor.withOpacity(0.1);
  Color get mediumVariant => currentPrimaryColor.withOpacity(0.5);
  Color get darkVariant => currentPrimaryColor.withOpacity(0.8);

  // Convertir une Color en String pour le stockage
  String colorToString(Color color) {
    return color.value.toString();
  }

  // === Couleurs pour les badges et coupes ===
  Color get badgeGold => const Color(0xFFFFD200);
  Color get badgeSilver => const Color(0xFFC0C0C0);
  Color get badgeBronze => const Color(0xFFCD7F32);
  Color get badgeProgression => const Color(0xFF9C27B0); // Violet pour les badges de progression

  // === Couleurs pour les activités récentes ===
  Color get activitySuccess => const Color(0xFF32C832);
  Color get activityBook => const Color(0xFF90A4AE);
  Color get activityTrophy => const Color(0xFFE8981A);

  // === Couleurs pour les défis ===
  Color get challengeWarning => const Color(0xFFFF9800);

  // === Couleurs pour les progressions de lecture ===
  Color get readingProgressLow => const Color(0xFFFF9800); // Orange pour progression < 40%
  Color get readingProgressComplete => const Color(0xFF32C832); // Vert pour terminé

  // === Couleurs pour les partenaires ===
  Color get partnerKhaki => const Color(0xFF3B5998);
  Color get partnerGreen => const Color(0xFF6AC259);

  // === Couleurs de base ===
  Color get colorBlack => const Color(0xFF000000);
  Color get colorWhite => const Color(0xFFFFFFFF);
}