import 'package:dio/dio.dart';
import 'package:edugo/models/login_request.dart';
import 'package:edugo/models/login_response.dart';
import 'package:edugo/models/register_request.dart';
import 'package:edugo/services/serializers.dart';
import 'package:built_value/serializer.dart';
import 'package:edugo/models/eleve.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  late Dio _dio;
  Eleve? _currentEleve;

   // LE GETTER
    int? get currentUserId => _currentEleve?.id;
  
  factory AuthService() {
    return _instance;
  }
  
  AuthService._internal() {
    _dio = Dio();
    _dio.options.baseUrl = 'http://localhost:8089'; // Update with your actual API URL
    _dio.options.contentType = 'application/json';
  }

 // Getters pour l'utilisateur courant
   Eleve? get currentEleve => _currentEleve;
   String get userName => '${_currentEleve?.prenom ?? ''} ${_currentEleve?.nom ?? ''}'.trim();
   String get userPhoto => _currentEleve?.photoProfil ?? '';
   int get userPoints => _currentEleve?.pointAccumule ?? 0;

   // Méthode pour récupérer le profil élève par ID
   Future<Eleve?> getEleveProfileById(int eleveId) async {
     try {
       final response = await _dio.get('/api/api/eleve/profil/$eleveId');

       if (response.statusCode == 200) {
         final eleveData = standardSerializers.deserializeWith(Eleve.serializer, response.data);
         _currentEleve = eleveData;
         return eleveData;
       }
     } catch (e) {
       print('Erreur lors de la récupération du profil élève: $e');
     }
     return null;
   }

   // Méthode pour récupérer le profil de l'élève connecté (nécessite d'avoir l'ID)
   Future<Eleve?> getCurrentEleveProfile() async {
     try {
       // Si vous avez un endpoint qui retourne l'élève courant sans ID
       // Sinon, vous devrez stocker l'ID après la connexion
       if (_currentEleve?.id != null) {
         return await getEleveProfileById(_currentEleve!.id!);
       }
     } catch (e) {
       print('Erreur lors de la récupération du profil élève courant: $e');
     }
     return null;
   }

   // Stocker l'élève après connexion
   void setCurrentEleve(Eleve eleve) {
     _currentEleve = eleve;
   }

   // Dans votre méthode login, stockez l'ID après connexion
   Future<LoginResponse?> login(String email, String password) async {
     try {
       final loginRequest = LoginRequest((b) => b
         ..email = email
         ..motDePasse = password);

       final serialized = standardSerializers.serialize(loginRequest);
       final response = await _dio.post('/api/auth/login', data: serialized);

       final loginResponse = standardSerializers.deserializeWith(LoginResponse.serializer, response.data);

       if (loginResponse != null && loginResponse.token != null) {
         setAuthToken(loginResponse.token!);

         // Ici vous devrez récupérer l'ID de l'élève connecté
         // Soit depuis la réponse login, soit via un autre endpoint
         await _loadCurrentEleveData();
       }

       return loginResponse;
     } catch (e) {
       print('Login error: $e');
       return null;
     }
   }

   // Méthode pour charger les données élève après connexion
   Future<void> _loadCurrentEleveData() async {
     try {
       // Si votre API a un endpoint pour récupérer l'utilisateur courant
       final response = await _dio.get('/api/auth/me');
       if (response.statusCode == 200) {
         // Adaptez selon la structure de votre réponse
         final userData = response.data;
         final eleveId = userData['id'];

         if (eleveId != null) {
           await getEleveProfileById(eleveId);
         }
       }
     } catch (e) {
       print('Erreur lors du chargement des données élève: $e');
     }
   }
  
  /// Inscription d'un nouvel elève
 Future<LoginResponse?> register({
   required String email,
   required String motDePasse,
   required String nom,
   required String prenom,
   required String ville,
   String? photoProfil,
   required int classeId,
   required int telephone,
   required int niveauId,
 }) async {
   try {
     print('🎯 DONNÉES REÇUES DANS register():');
     print('🏙️ Ville reçue: "$ville" (type: ${ville.runtimeType})');
     print('📧 Email: $email');
     print('👤 Nom: $nom');
     print('👤 Prénom: $prenom');
     print('📞 Téléphone: $telephone');
     print('🎒 Classe ID: $classeId');
     print('📚 Niveau ID: $niveauId');

     // Création de la requête
     final registerRequest = RegisterRequest((b) => b
       ..email = email
       ..motDePasse = motDePasse
       ..nom = nom
       ..prenom = prenom
       ..ville = ville
       ..photoProfil = photoProfil
       ..classeId = classeId
       ..telephone = telephone
       ..niveauId = niveauId
     );

     // ✅ DEBUG: Vérifiez l'objet RegisterRequest
     print('📦 OBJET RegisterRequest CRÉÉ:');
     print('Ville dans l\'objet: "${registerRequest.ville}"');
     print('Email dans l\'objet: "${registerRequest.email}"');

     // Sérialisation
     final serialized = standardSerializers.serialize(registerRequest);
     print('🔤 DONNÉES SÉRIALISÉES (JSON):');
     print(serialized);

     // Vérifiez spécifiquement si "ville" est dans les données sérialisées
     if (serialized is Map<String, dynamic>) {
       print('✅ Clés dans les données sérialisées: ${serialized.keys}');
       print('✅ Ville dans JSON: "${serialized['ville']}"');
     }

     // Envoi de la requête
     print('🚀 ENVOI DE LA REQUÊTE...');
     final response = await _dio.post('/api/auth/register', data: serialized);

     print('✅ RÉPONSE REÇUE: ${response.statusCode}');
     print('📄 DONNÉES RÉPONSE: ${response.data}');

     final loginResponse = standardSerializers.deserializeWith(LoginResponse.serializer, response.data);
     return loginResponse;
   } catch (e) {
     print('❌ ERREUR INSCRIPTION: $e');
     if (e is DioException) {
       print('🔍 STATUT ERREUR: ${e.response?.statusCode}');
       print('🔍 DONNÉES ERREUR: ${e.response?.data}');
       print('🔍 HEADERS ERREUR: ${e.response?.headers}');
     }
     return null;
   }
 }

  
  /// Refresh JWT token
  Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/api/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // Handle error appropriately
      print('Refresh token error: $e');
      return null;
    }
  }
  
  /// Logout user
  Future<bool> logout() async {
    try {
      await _dio.post('/api/auth/logout');
      // Remove authorization header
      _dio.options.headers.remove('Authorization');
      return true;
    } catch (e) {
      // Handle error appropriately
      print('Logout error: $e');
      return false;
    }
  }
  
  /// Set the authorization token for subsequent API calls
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}