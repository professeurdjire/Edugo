import 'package:dio/dio.dart';
import 'package:edugo/services/auth_service.dart';
import 'package:edugo/services/serializers.dart';
import 'package:edugo/models/conversion_eleve.dart';
import 'package:edugo/models/options_conversion.dart';
import 'package:built_collection/built_collection.dart';

class ConversionService {
  static final ConversionService _instance = ConversionService._internal();
  factory ConversionService() => _instance;

  late Dio _dio;

  ConversionService._internal() {
    // Use the shared Dio instance from AuthService to ensure consistent base URL and headers
    _dio = AuthService().dio;
  }

  /// Convertir des points en récompense
  Future<ConversionEleve?> convertirPoints({
    required int eleveId,
    required int optionId,
    required int points,
  }) async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.post(
        '/api/conversions',
        data: {
          'eleveId': eleveId,
          'optionId': optionId,
          'points': points,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return standardSerializers.deserializeWith(
          ConversionEleve.serializer,
          response.data,
        );
      }
      return null;
    } catch (e) {
      print('Erreur lors de la conversion de points: $e');
      return null;
    }
  }

  /// Récupérer toutes les options de conversion disponibles
  Future<BuiltList<OptionsConversion>?> getOptionsConversion() async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/conversions/options');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  OptionsConversion.serializer,
                  json,
                ))
            .whereType<OptionsConversion>()
            .toList()
            .toBuiltList();
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des options de conversion: $e');
      return null;
    }
  }

  /// Récupérer l'historique des conversions d'un élève
  Future<BuiltList<ConversionEleve>?> getConversionsByEleve(int eleveId) async {
    try {
      // Note: baseUrl contains /api, and endpoints need /api/api/... (double /api)
      final response = await _dio.get('/api/conversions/eleve/$eleveId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => standardSerializers.deserializeWith(
                  ConversionEleve.serializer,
                  json,
                ))
            .whereType<ConversionEleve>()
            .toList()
            .toBuiltList();
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des conversions: $e');
      return null;
    }
  }
}

