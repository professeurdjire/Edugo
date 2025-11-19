import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'detail_resultat.g.dart';

abstract class DetailResultat implements Built<DetailResultat, DetailResultatBuilder> {
  int get questionId;
  
  int get points;
  
  bool get correct;

  DetailResultat._();

  factory DetailResultat([void updates(DetailResultatBuilder b)]) = _$DetailResultat;

  static Serializer<DetailResultat> get serializer => _$detailResultatSerializer;
}