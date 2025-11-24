import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/matiere_response.dart';
import 'package:edugo/services/api/matires_api.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/services/exercise_service.dart';

class MatiereService {
  static final MatiereService _instance = MatiereService._internal();
  factory MatiereService() => _instance;

  final AuthService _authService = AuthService();
  final ExerciseService _exerciseService = ExerciseService();
  late final MatiresApi _matieresApi;

  MatiereService._internal() {
    _matieresApi = MatiresApi(_authService.dio, standardSerializers);
  }

  Future<BuiltList<MatiereResponse>?> getAllMatieres() async {
    try {
      final response = await _matieresApi.getAllMatieres();
      if (response.statusCode == 200) {
        return response.data;
      }
      print('Error fetching subjects: status ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error fetching subjects: $e');
      // Return null instead of throwing to allow fallback behavior
      return null;
    }
  }

  // Method to get subjects for a specific student
  // Extracts subjects directly from available exercises (no need for /api/matieres endpoint)
  Future<BuiltList<MatiereResponse>?> getMatieresByEleve(int eleveId) async {
    try {
      // Get all available exercises for the student
      final exercices = await _exerciseService.getExercicesDisponibles(eleveId);
      
      // If exercises fetch fails (500 error), return empty list instead of null
      if (exercices == null) {
        print('Warning: Could not fetch exercises for student $eleveId. Returning empty subjects list.');
        return BuiltList<MatiereResponse>([]);
      }
      
      if (exercices.isNotEmpty) {
        // Extract unique subjects from exercises
        // Map: matiereId -> matiereNom
        final Map<int, String> matieresMap = {};
        
        for (final exercice in exercices) {
          final matiereId = exercice.matiereId;
          final matiereNom = exercice.matiereNom;
          
          if (matiereId != null && matiereNom != null && matiereNom.isNotEmpty) {
            // Avoid duplicates automatically (Map key is unique)
            matieresMap[matiereId] = matiereNom;
          }
        }
        
        // Convert Map to BuiltList<MatiereResponse>
        final matieresList = matieresMap.entries.map((entry) {
          return MatiereResponse((b) => b
            ..id = entry.key
            ..nom = entry.value
          );
        }).toList();
        
        return BuiltList<MatiereResponse>(matieresList);
      }
      
      return BuiltList<MatiereResponse>([]);
    } catch (e) {
      print('Error fetching subjects for student: $e');
      return null;
    }
  }
}