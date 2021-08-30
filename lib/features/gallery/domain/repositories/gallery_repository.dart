import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';

abstract class GalleryRepository {
  Future<Either<Failure, void>> sendSync(String jwt, String userId);
  Future<Either<Failure, List<Picture>>> getPicture(
    String jwt,
    String userId,
    int limit,
    int skip,
  );
}
