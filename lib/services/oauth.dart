//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';

class OAuthInterceptor extends Interceptor {
  final Map<String, String> tokens = {};

  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Si nécessaire, vous pouvez remplir manuellement tokens[...] ailleurs
    // puis accéder ici via l'URL ou d'autres métadonnées.
    // Pour l'instant, on laisse simplement passer la requête.
    handler.next(options);
  }

}
