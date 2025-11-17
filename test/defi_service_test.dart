import 'package:flutter_test/flutter_test.dart';
import 'package:edugo/services/defi_service.dart';

void main() {
  group('DefiService Tests', () {
    late DefiService defiService;

    setUp(() {
      defiService = DefiService();
    });

    test('DefiService should be a singleton', () {
      final anotherInstance = DefiService();
      expect(defiService, equals(anotherInstance));
    });

    // Note: These tests would require a mock API or actual backend to run properly
    // They're here to verify the structure is correct
    test('DefiService should have required methods', () {
      expect(defiService.getDefisDisponibles, isA<Function>());
      expect(defiService.getDefisParticipes, isA<Function>());
      expect(defiService.getDefiById, isA<Function>());
      expect(defiService.participerDefi, isA<Function>());
      expect(defiService.getAllDefis, isA<Function>());
    });
  });
}