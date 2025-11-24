import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/eleve.dart';
import 'package:edugo/services/api/lve_api.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';

class CamaradeService {
  static final CamaradeService _instance = CamaradeService._internal();
  factory CamaradeService() => _instance;

  final AuthService _authService = AuthService();
  late LveApi _lveApi;

  CamaradeService._internal() {
    _lveApi = LveApi(_authService.dio, standardSerializers);
  }

  /// Récupérer les camarades de classe d'un élève
  /// GET /api/eleve/camarades/{eleveId}
  /// Retourne la liste des élèves de la même classe
  Future<BuiltList<Eleve>?> getCamarades(int eleveId) async {
    try {
      final response = await _lveApi.getCamaradesClasse(id: eleveId);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching classmates: $e');
    }
    return null;
  }
}

