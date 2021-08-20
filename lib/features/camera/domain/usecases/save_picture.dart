import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/camera/domain/repositories/camera_repository.dart';
import 'package:my_camera_app_demo/features/camera/domain/usecases/params.dart';

class SavePictureUsecase extends Usecase<void, SavePictureParams> {
  CameraRepository repository;

  SavePictureUsecase({@required this.repository});

  Future<Either<Failure, void>> call(SavePictureParams params) async {
    return await repository.savePicture(params.jwt, params.path, params.userId);
  }
}
