import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_request.g.dart';

abstract class RegisterRequest implements Built<RegisterRequest, RegisterRequestBuilder> {
  String get email;
  String get password;
  String get nom;
  String get prenom;

  RegisterRequest._();

  factory RegisterRequest([void Function(RegisterRequestBuilder) updates]) = _$RegisterRequest;

  static Serializer<RegisterRequest> get serializer => _$registerRequestSerializer;
}
