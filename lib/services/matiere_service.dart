import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/matiere_response.dart';
import 'package:edugo/services/api/matires_api.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';

class MatiereService {
  static final MatiereService _instance = MatiereService._internal();
  factory MatiereService() => _instance;

  final AuthService _authService = AuthService();
  late final MatiresApi _matieresApi;

  MatiereService._internal() {
    _matieresApi = MatiresApi(_authService.dio, standardSerializers);
  }

  Future<BuiltList<MatiereResponse>?> getAllMatieres() async {
    try {
      final response = await _matieresApi.getAllMatieres();
      return response.data;
    } catch (e) {
      print('Error fetching subjects: $e');
      return null;
    }
  }
}

