import 'package:flutter_test/flutter_test.dart';
import 'package:edugo/services/exercice_service.dart';

void main() {
  group('ExerciceService Tests', () {
    late ExerciceService exerciceService;

    setUp(() {
      exerciceService = ExerciceService();
    });

    test('ExerciceService should be a singleton', () {
      final anotherInstance = ExerciceService();
      expect(exerciceService, equals(anotherInstance));
    });

    // Note: These tests would require a mock API or actual backend to run properly
    // They're here to verify the structure is correct
    test('ExerciceService should have required methods', () {
      expect(exerciceService.getAllExercices, isA<Function>());
      expect(exerciceService.getExerciceById, isA<Function>());
      expect(exerciceService.getExercicesDisponibles, isA<Function>());
      expect(exerciceService.getExercicesByMatiere, isA<Function>());
      expect(exerciceService.getExercicesByDifficulte, isA<Function>());
      expect(exerciceService.getExercicesByLivre, isA<Function>());
      expect(exerciceService.getHistoriqueExercices, isA<Function>());
      expect(exerciceService.getExerciceRealise, isA<Function>());
      expect(exerciceService.soumettreExercice, isA<Function>());
      expect(exerciceService.searchExercicesByTitre, isA<Function>());
    });
  });
}