import 'package:flutter/material.dart';
import 'package:edugo/screens/onboarding/splash_screen.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/onesignal_service.dart';
import 'package:edugo/services/sync_service.dart';
import 'package:edugo/widgets/offline_indicator.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le service de thème
  final themeService = ThemeService();
  await themeService.initialize();
  
  // Initialiser OneSignal pour les notifications push
  final oneSignalService = OneSignalService();
  await oneSignalService.initialize();
  
  // Initialiser le service de synchronisation
  final syncService = SyncService();
  
  // Test de connexion au backend
  await _testBackendConnection();

  runApp(MyApp(themeService: themeService));
}

/// Teste la connexion au backend au démarrage de l'application
Future<void> _testBackendConnection() async {
  try {
    print('🚀 Démarrage du test de connexion au backend...');
    final authService = AuthService();
    
    // Attendre un peu pour s'assurer que le service est prêt
    await Future.delayed(const Duration(milliseconds: 500));
    
    final isConnected = await authService.testConnection();
    
    if (isConnected) {
      print('✅ Connexion au backend établie avec succès!');
    } else {
      print('⚠️ Impossible de se connecter au backend. Vérifiez:');
      print('   1. Que le serveur backend est en cours d\'exécution');
      print('   2. Que l\'adresse IP est correcte (10.0.2.2:8080 pour BlueStacks, 192.168.10.117:8080 pour appareil physique)');
      print('   3. Que les deux appareils sont sur le même réseau');
      print('   4. Que le firewall autorise les connexions sur le port 8080');
      print('   5. Pour BlueStacks: vérifiez que IS_EMULATOR=true dans auth_service.dart');
    }
  } catch (e) {
    print('❌ Erreur lors du test de connexion: $e');
  }
}

class MyApp extends StatefulWidget {
  final ThemeService themeService;

  const MyApp({super.key, required this.themeService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  String? _initialLink;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Récupérer le lien initial si l'app a été ouverte via un deep link
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _initialLink = initialLink.toString();
        print('[MyApp] 🔗 Deep link initial détecté: $_initialLink');
      }
    } catch (e) {
      print('[MyApp] ❌ Erreur lors de la récupération du lien initial: $e');
    }

    // Écouter les deep links pendant l'exécution de l'app
    _appLinks.uriLinkStream.listen((uri) {
      print('[MyApp] 🔗 Deep link reçu: $uri');
      _handleDeepLink(uri.toString());
    }, onError: (err) {
      print('[MyApp] ❌ Erreur lors de l\'écoute des deep links: $err');
    });

    setState(() {
      _isInitialized = true;
    });
  }

  void _handleDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      
      // Vérifier si c'est un lien de réinitialisation de mot de passe
      if (uri.path.contains('reset-password') || uri.queryParameters.containsKey('token')) {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          print('[MyApp] ✅ Token de réinitialisation détecté: $token');
          // Naviguer vers l'écran de réinitialisation avec le token
          _navigateToPasswordReset(token);
        }
      }
    } catch (e) {
      print('[MyApp] ❌ Erreur lors du traitement du deep link: $e');
    }
  }

  void _navigateToPasswordReset(String token) {
    // Mettre à jour le token initial pour que le SplashScreen le détecte
    setState(() {
      _initialLink = 'edugo://reset-password?token=$token';
    });
    print('[MyApp] 🔄 Token mis à jour pour navigation: $token');
    // Le SplashScreen vérifiera le token lors du prochain rebuild
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Afficher un écran de chargement pendant l'initialisation des deep links
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.themeService.currentPrimaryColor,
              ),
            ),
          ),
        ),
      );
    }

    return ValueListenableBuilder<Color>(
      valueListenable: widget.themeService.primaryColorNotifier,
      builder: (context, primaryColor, child) {
        return OfflineIndicator(
          child: MaterialApp(
            title: 'EDUGO',
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
          home: SplashScreen(
            themeService: widget.themeService,
            initialPasswordResetToken: _extractTokenFromLink(_initialLink),
          ),
          debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }

  String? _extractTokenFromLink(String? link) {
    if (link == null || link.isEmpty) return null;
    try {
      final uri = Uri.parse(link);
      // Support pour https://www.edugo.ml/reset-password?token=...
      // et edugo://reset-password?token=...
      if (uri.path.contains('reset-password') || uri.queryParameters.containsKey('token')) {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          print('[MyApp] ✅ Token extrait du deep link: $token');
          return token;
        }
      }
    } catch (e) {
      print('[MyApp] ❌ Erreur lors de l\'extraction du token: $e');
    }
    return null;
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