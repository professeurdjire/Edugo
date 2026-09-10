// Tests de fumée des écrans d'entrée de l'application.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edugo/screens/connexion%20et%20inscriptions/login.dart';
import 'package:edugo/screens/presentations/presentation1.dart';

void main() {
  testWidgets('L\'écran de bienvenue affiche le titre et le bouton Commencer',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    expect(find.text('Bienvenue Sur EDUGO'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
  });

  testWidgets('La connexion exige un email et un mot de passe',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.text('Se Connecter'));
    await tester.pump();

    expect(find.text('Veuillez entrer votre adresse email'), findsOneWidget);
    expect(find.text('Veuillez entrer votre mot de passe'), findsOneWidget);
  });

  testWidgets('La connexion rejette un email invalide',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.enterText(find.byType(TextFormField).first, 'pas-un-email');
    await tester.tap(find.text('Se Connecter'));
    await tester.pump();

    expect(find.text('Adresse email invalide'), findsOneWidget);
  });

  testWidgets('La connexion rejette un mot de passe trop court',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.text('Se Connecter'));
    await tester.pump();

    expect(find.text('Le mot de passe doit contenir au moins 6 caractères'),
        findsOneWidget);
  });
}
