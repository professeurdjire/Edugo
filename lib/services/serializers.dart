import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:edugo/models/login_request.dart';
import 'package:edugo/models/login_response.dart';
import 'package:edugo/models/register_request.dart';

part 'serializers.g.dart';

@SerializersFor([
  LoginRequest,
  LoginResponse,
  RegisterRequest,
])
Serializers serializers = _$serializers;

Serializers standardSerializers = (serializers.toBuilder()
  ..addPlugin(StandardJsonPlugin())
).build();