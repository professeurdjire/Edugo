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
  final List<Color> availableColors = [
    const Color(0xFFA885D8), // Violet original
    const Color(0xFF4CAF50), // Vert
    const Color(0xFF2196F3), // Bleu
    const Color(0xFFFF9800), // Orange
    const Color(0xFFE91E63), // Rose
    const Color(0xFF9C27B0), // Violet foncé
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
}