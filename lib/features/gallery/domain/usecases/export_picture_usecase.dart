import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/param.dart';

class ExportPictureUsecase extends NoFailureUsecase<bool, ExportPictureParams> {
  GalleryRepository repository;
  ExportPictureUsecase({@required this.repository});

  @override
  Future<bool> call(ExportPictureParams params) async {
    return await repository.exportPicture(params.pictures);
  }
}
