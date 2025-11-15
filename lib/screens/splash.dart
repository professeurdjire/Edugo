import 'dart:async';
import 'package:flutter/material.dart';
import 'package:edugo/services/theme_service.dart';
import 'package:edugo/screens/onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  final ThemeService themeService;
  const SplashScreen({super.key, required this.themeService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(themeService: widget.themeService),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.themeService.primaryColorNotifier.value;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo.png',
                width: 72,
                height: 72,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.menu_book_rounded, color: primary, size: 56);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'EduGo',
              style: TextStyle(
                color: primary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
