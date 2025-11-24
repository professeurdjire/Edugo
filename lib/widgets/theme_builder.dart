import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';

/// Widget helper pour faciliter l'utilisation du thème dans toutes les pages
/// Utilise ValueListenableBuilder pour réagir automatiquement aux changements de thème
class ThemeBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Color primaryColor, ThemeService themeService) builder;
  final ThemeService? themeService;

  const ThemeBuilder({
    super.key,
    required this.builder,
    this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final service = themeService ?? ThemeService();
    
    return ValueListenableBuilder<Color>(
      valueListenable: service.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return builder(context, primaryColor, service);
      },
    );
  }
}

/// Extension pour faciliter l'accès aux variations de couleurs
extension ThemeColorExtensions on Color {
  /// Couleur claire (opacité 0.1)
  Color get light => withOpacity(0.1);
  
  /// Couleur moyenne (opacité 0.5)
  Color get medium => withOpacity(0.5);
  
  /// Couleur foncée (opacité 0.8)
  Color get dark => withOpacity(0.8);
  
  /// Couleur très claire (opacité 0.05)
  Color get veryLight => withOpacity(0.05);
}

/// Mixin pour faciliter l'accès au ThemeService dans les StatefulWidget
mixin ThemeMixin<T extends StatefulWidget> on State<T> {
  ThemeService get themeService => ThemeService();
  
  Color get primaryColor => themeService.currentPrimaryColor;
  
  Color get lightPrimaryColor => primaryColor.light;
  
  Color get mediumPrimaryColor => primaryColor.medium;
  
  Color get darkPrimaryColor => primaryColor.dark;
}

