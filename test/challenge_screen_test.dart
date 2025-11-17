import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/main/challenge/challenge.dart';

void main() {
  group('ChallengeScreen Tests', () {
    test('ChallengeScreen should be a widget', () {
      // Test that the widget can be instantiated
      expect(const ChallengeScreen(), isA<Widget>());
      expect(const ChallengeScreen(eleveId: 123), isA<Widget>());
    });

    testWidgets('ChallengeScreen should build without errors', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeScreen(),
          ),
        ),
      );

      // Verify that the screen builds without throwing errors
      expect(find.text('Challenges'), findsOneWidget);
    });
  });
}