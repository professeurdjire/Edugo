import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/partenaire.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:dio/dio.dart';

class PartenaireService {
  static final PartenaireService _instance = PartenaireService._internal();
  factory PartenaireService() => _instance;

  final AuthService _authService = AuthService();
  Dio get _dio => _authService.dio;

  PartenaireService._internal();

  /// Récupérer tous les partenaires
  /// Endpoint: GET /api/partenaires
  /// Note: baseUrl already contains /api, so we need to add /api again for double /api
  Future<BuiltList<Partenaire>?> getAllPartenaires() async {
    try {
      print('[PartenaireService] Fetching all partners...');
      // Utiliser directement l'endpoint /api/partenaires
      // Note: baseUrl already contains /api, so we need to add /api again for double /api
      final response = await _dio.get('/api/partenaires');
      
      print('[PartenaireService] Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        print('[PartenaireService] Response data type: ${data.runtimeType}');
        
        if (data != null) {
          // Deserialize the list of partners
          final List<Partenaire> partners = [];
          for (var item in data as List) {
            try {
              print('[PartenaireService] Deserializing partner item: $item');
              final partner = standardSerializers.deserializeWith(
                Partenaire.serializer,
                item,
              ) as Partenaire;
              print('[PartenaireService] Deserialized partner: id=${partner.id}, nom=${partner.nom}, actif=${partner.actif}');
              partners.add(partner);
            } catch (e, stackTrace) {
              print('[PartenaireService] Error deserializing partner item: $e');
              print('[PartenaireService] Stack trace: $stackTrace');
              print('[PartenaireService] Item data: $item');
            }
          }
          
          print('[PartenaireService] Successfully fetched ${partners.length} partners');
          return BuiltList<Partenaire>(partners);
        }
      } else {
        print('[PartenaireService] Unexpected status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('[PartenaireService] Error fetching partners: $e');
      print('[PartenaireService] Stack trace: $stackTrace');
      return BuiltList<Partenaire>([]);
    }
    return BuiltList<Partenaire>([]);
  }

  /// Récupérer les partenaires actifs uniquement
  Future<BuiltList<Partenaire>?> getPartenairesActifs() async {
    try {
      final allPartners = await getAllPartenaires();
      if (allPartners != null) {
        print('[PartenaireService] Total partners fetched: ${allPartners.length}');
        for (var p in allPartners) {
          print('[PartenaireService] Partner: id=${p.id}, nom=${p.nom}, actif=${p.actif}');
        }
        final activePartners = allPartners.where((p) => p.actif == true).toList();
        print('[PartenaireService] Active partners: ${activePartners.length}');
        return BuiltList<Partenaire>(activePartners);
      }
    } catch (e) {
      print('[PartenaireService] Error fetching active partners: $e');
    }
    return BuiltList<Partenaire>([]);
  }
}

