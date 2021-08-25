import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';

abstract class AnalysisPictureRepository {
  Future<Either<Failure, void>> analysisPicture(
    String jwt,
    String userId,
    String data,
    DateTime analysisTime,
  );
}
