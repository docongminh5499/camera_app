import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/param.dart';

class GetPictureUsecase extends Usecase<List<Picture>, GetPictureParams> {
  GalleryRepository repository;
  GetPictureUsecase({@required this.repository});

  @override
  Future<Either<Failure, List<Picture>>> call(GetPictureParams params) async {
    return await repository.getPicture(params.jwt, params.userId, params.limit, params.skip);
  }
}
