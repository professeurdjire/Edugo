import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:edugo/models/niveau_response.dart';
import 'package:edugo/models/classe_response.dart';
import 'package:edugo/services/serializers.dart';

class SchoolDataService {
  static final SchoolDataService _instance = SchoolDataService._internal();
  
  late Dio _dio;
  
  factory SchoolDataService() {
    return _instance;
  }
  
  SchoolDataService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8080'; // Update with your actual API URL
  }
  
  /// Fetch all school levels (niveaux)
  Future<BuiltList<NiveauResponse>?> fetchSchoolLevels() async {
    try {
      final response = await _dio.get('/api/niveaux');
      if (response.data != null) {
        final niveaux = standardSerializers.deserialize(
          response.data,
          specifiedType: const FullType(BuiltList, [FullType(NiveauResponse)]),
        ) as BuiltList<NiveauResponse>;
        return niveaux;
      }
      return null;
    } catch (e) {
      print('Error fetching school levels: $e');
      return null;
    }
  }
  
  /// Fetch all classes
  Future<BuiltList<ClasseResponse>?> fetchClasses() async {
    try {
      final response = await _dio.get('/api/classes');
      if (response.data != null) {
        final classes = standardSerializers.deserialize(
          response.data,
          specifiedType: const FullType(BuiltList, [FullType(ClasseResponse)]),
        ) as BuiltList<ClasseResponse>;
        return classes;
      }
      return null;
    } catch (e) {
      print('Error fetching classes: $e');
      return null;
    }
  }
}