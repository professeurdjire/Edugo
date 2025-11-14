import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_request.g.dart';

abstract class RegisterRequest implements Built<RegisterRequest, RegisterRequestBuilder> {
  String get email;
  String get motDePasse;
  String get nom;
  String get prenom;
  String get ville;
  String? get photoProfil; // facultatif
  int get classeId;
  int get telephone;
  int get niveauId;

  RegisterRequest._();

  factory RegisterRequest([void Function(RegisterRequestBuilder) updates]) = _$RegisterRequest;

  static Serializer<RegisterRequest> get serializer => _$registerRequestSerializer;
}
