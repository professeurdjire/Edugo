import 'package:edugo/screens/main/mainScreen.dart';
import 'package:edugo/screens/onboarding/onboarding_screen.dart';
import 'package:edugo/screens/auth/login.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final ThemeService themeService;

  const SplashScreen({super.key, required this.themeService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            themeService: widget.themeService,
            onFinished: () async {
              await prefs.setBool('hasSeenOnboarding', true);
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(themeService: widget.themeService),
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    try {
      final profile = await _authService.getCurrentUserProfile();
      if (!mounted) return;

      if (profile != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainScreen(themeService: widget.themeService),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(themeService: widget.themeService),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(themeService: widget.themeService),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.themeService.currentPrimaryColor;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.15),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 24),
            const Text(
              'EduGo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }
}

