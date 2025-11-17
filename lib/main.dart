import 'package:flutter/material.dart';
import 'package:edugo/screens/auth/login.dart';
import 'package:edugo/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le service de thème
  final themeService = ThemeService();
  await themeService.initialize();

  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;

  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return MaterialApp(
          title: 'EduGo',
          theme: ThemeData(
            // Couleur principale dynamique
            primaryColor: primaryColor,
            primarySwatch: _createMaterialColor(primaryColor),

            // Scheme de couleurs cohérent
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              primary: primaryColor,
              secondary: primaryColor.withOpacity(0.8),
              background: Colors.white,
            ),

            // AppBar theme
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
            ),

            // Boutons elevated
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),

            // Boutons text
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ),

            // Boutons outlined
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ),

            // Input decoration theme
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),

            // Floating action button
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),

            // Progress indicators
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: primaryColor,
            ),

            // Switch theme
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(primaryColor),
              trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
            ),

            // Checkbox theme
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.all(primaryColor),
            ),

            // Radio theme
            radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.all(primaryColor),
            ),

            // Autres propriétés générales
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),
          home: LoginScreen(themeService: themeService),
          debugShowCheckedModeBanner: false,

          // Gestion des routes (optionnel)
          onGenerateRoute: (settings) {
            // Toutes vos routes bénéficieront du thème dynamique
            return MaterialPageRoute(
              builder: (context) {
                // Ici vous pouvez retourner les différents écrans de votre app
                return  LoginScreen(themeService: themeService);
              },
            );
          },
        );
      },
    );
  }

  // Méthode pour créer une MaterialColor à partir d'une Color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = [.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  // Alias pour la compatibilité
  static MaterialColor _createMaterialColor(Color color) => createMaterialColor(color);
}