import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/main/exercice/exercice1.dart';
import 'package:edugo/screens/main/exercice/exercice2.dart';

void main() {
  group('Exercise Screens Tests', () {
    testWidgets('MatiereListScreen should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: MatiereListScreen(),
        ),
      );

      // Verify that the screen builds without throwing errors
      expect(find.text('Exercices'), findsOneWidget);
    });

    testWidgets('ExerciseMatiereListScreen should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: ExerciseMatiereListScreen(matiere: 'Mathématiques'),
        ),
      );

      // Verify that the screen builds without throwing errors
      expect(find.text('Mathématiques'), findsOneWidget);
    });

    testWidgets('MatiereListScreen should accept eleveId parameter', (WidgetTester tester) async {
      // Build our app with a specific eleveId
      await tester.pumpWidget(
        const MaterialApp(
          home: MatiereListScreen(eleveId: 123),
        ),
      );

      // Verify that the screen builds without throwing errors
      expect(find.text('Exercices'), findsOneWidget);
    });
  });
}