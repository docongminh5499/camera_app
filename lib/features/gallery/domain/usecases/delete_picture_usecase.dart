import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/param.dart';

class DeletePictureUsecase extends NoFailureUsecase<bool, DeletePictureParams> {
  GalleryRepository repository;
  DeletePictureUsecase({
    @required this.repository,
  });

  @override
  Future<bool> call(DeletePictureParams params) async {
    return await repository.deletePicture(params.jwt, params.pictures);
  }
}
