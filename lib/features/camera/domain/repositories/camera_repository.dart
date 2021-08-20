import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';

abstract class CameraRepository {
  Future<Either<Failure, void>> savePicture(
    String jwt,
    String path,
    String userId,
  );
}
