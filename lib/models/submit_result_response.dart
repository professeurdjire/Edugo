import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'submit_result_response.g.dart';

abstract class SubmitResultResponse implements Built<SubmitResultResponse, SubmitResultResponseBuilder> {
  int get ownerId;
  
  String get ownerType;
  
  int get eleveId;
  
  int get score;
  
  int get totalPoints;
  
  BuiltList<DetailResultat> get details;

  SubmitResultResponse._();

  factory SubmitResultResponse([void updates(SubmitResultResponseBuilder b)]) = _$SubmitResultResponse;

  static Serializer<SubmitResultResponse> get serializer => _$submitResultResponseSerializer;
}

abstract class DetailResultat implements Built<DetailResultat, DetailResultatBuilder> {
  int get questionId;
  
  int get points;
  
  bool get correct;

  DetailResultat._();

  factory DetailResultat([void updates(DetailResultatBuilder b)]) = _$DetailResultat;

  static Serializer<DetailResultat> get serializer => _$detailResultatSerializer;
}