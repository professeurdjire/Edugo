import 'package:edugo/screens/main_navigation.dart';
import 'package:edugo/screens/presentations/presentation1.dart';
import 'package:edugo/services/api/api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDUGO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StartupGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Décide de l'écran de départ : un utilisateur déjà connecté (jeton
/// présent) arrive directement dans l'application, sinon sur l'accueil.
class StartupGate extends StatelessWidget {
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.hasSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          );
        }
        return snapshot.data == true
            ? const MainNavigation()
            : const WelcomeScreen();
      },
    );
  }
}
