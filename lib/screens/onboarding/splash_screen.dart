import 'package:edugo/screens/onboarding/onboarding_screen.dart';
import 'package:edugo/screens/auth/login.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/screens/profil/reenitialiserMotDePasse/nouveauMotDePasse.dart';
import 'package:edugo/widgets/dynamic_logo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final ThemeService themeService;
  final String? initialPasswordResetToken;

  const SplashScreen({
    super.key,
    required this.themeService,
    this.initialPasswordResetToken,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Create animation controller for logo
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Create animation that repeats with reverse
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    // Start the animation
    _controller.repeat(reverse: true);
    
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Vérifier si on a un token de réinitialisation de mot de passe depuis un deep link
    if (widget.initialPasswordResetToken != null && widget.initialPasswordResetToken!.isNotEmpty) {
      if (!mounted) return;
      // Naviguer directement vers l'écran de réinitialisation avec le token
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => NouveauMotPasse(token: widget.initialPasswordResetToken!),
        ),
      );
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    
    if (!mounted) return;

    // Afficher l'onboarding à chaque démarrage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OnboardingScreen(
          themeService: widget.themeService,
          onFinished: () async {
            // Marquer l'onboarding comme terminé (même si on l'affichera à chaque fois)
            await prefs.setBool('hasSeenOnboarding', true);
            if (!mounted) return;
            // Rediriger vers l'écran de connexion après l'onboarding
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LoginScreen(themeService: widget.themeService),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.themeService.currentPrimaryColor;

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: SizedBox(
                width: 180,
                child: DynamicLogoSimple(
                  assetPath: 'assets/images/logo.svg',
                  primaryColor: color,
                  secondaryColor: Colors.black,
                  height: 120,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}