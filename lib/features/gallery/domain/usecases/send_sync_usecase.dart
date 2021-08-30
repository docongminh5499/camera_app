import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/param.dart';

class SendSyncUsecase extends Usecase<void, SendSyncParams> {
  final GalleryRepository repository;
  SendSyncUsecase({@required this.repository});

  @override
  Future<Either<Failure, void>> call(SendSyncParams params) {
    return repository.sendSync(params.jwt, params.userId);
  }
}
