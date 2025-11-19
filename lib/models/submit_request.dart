import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:edugo/models/reponse_eleve.dart';

part 'submit_request.g.dart';

abstract class SubmitRequest implements Built<SubmitRequest, SubmitRequestBuilder> {
  int get eleveId;

  BuiltList<ReponseEleve> get reponses;

  SubmitRequest._();

  factory SubmitRequest([void updates(SubmitRequestBuilder b)]) = _$SubmitRequest;

  static Serializer<SubmitRequest> get serializer => _$submitRequestSerializer;
}