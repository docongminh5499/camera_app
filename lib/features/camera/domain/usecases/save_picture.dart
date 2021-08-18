import 'package:flutter/foundation.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/camera/domain/repositories/camera_repository.dart';
import 'package:my_camera_app_demo/features/camera/domain/usecases/params.dart';

class SavePictureUsecase extends NoFailureUsecase<bool, SavePictureParams> {
  CameraRepository repository;

  SavePictureUsecase({@required this.repository});

  Future<bool> call(SavePictureParams params) async {
    return await repository.savePicture(params.path);
  }
}
