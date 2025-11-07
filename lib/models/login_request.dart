import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_request.g.dart';

abstract class LoginRequest implements Built<LoginRequest, LoginRequestBuilder> {
  String get email;
  @BuiltValueField(wireName: 'motDePasse')
  String get motDePasse;

  LoginRequest._();

  factory LoginRequest([void Function(LoginRequestBuilder) updates]) = _$LoginRequest;

  static Serializer<LoginRequest> get serializer => _$loginRequestSerializer;
}
