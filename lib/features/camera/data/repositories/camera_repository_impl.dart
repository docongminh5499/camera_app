import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/network/network_info.dart';
import 'package:my_camera_app_demo/features/camera/data/datasources/local_camera_datasource.dart';
import 'package:my_camera_app_demo/features/camera/data/datasources/remote_camera_datasource.dart';
import 'package:my_camera_app_demo/features/camera/data/models/picture_model.dart';
import 'package:my_camera_app_demo/features/camera/domain/repositories/camera_repository.dart';

class CameraRepositoryImpl implements CameraRepository {
  final LocalCameraDatasource localCameraDatasource;
  final RemoteCameraDatasource remoteCameraDatasource;
  final NetworkInfo networkInfo;

  CameraRepositoryImpl({
    @required this.localCameraDatasource,
    @required this.remoteCameraDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> savePicture(
    String jwt,
    String path,
    String userId,
  ) async {
    try {
      List<int> bytes = await localCameraDatasource.getFile(path).readAsBytes();
      String base64Data = base64Encode(bytes);
      PictureModel model = PictureModel(
        userId: userId,
        data: base64Data,
        lastModifyTime: DateTime.now().toUtc(),
      );
      try {
        if (await networkInfo.isConnected) {
          await remoteCameraDatasource.sendPicture(jwt, model);
          await localCameraDatasource.deleteFile(path);
          return Right(Unit);
        } else
          throw RemoteSavePictureException();
      } on RemoteSavePictureException {
        final result = await localCameraDatasource.savePicture(model);
        await localCameraDatasource.deleteFile(path);
        if (result == 0) return Left(SavePictureFailure());
        return Right(Unit);
      }
    } on GetFileException {
      return Left(GetFileFailure());
    } on DeleteFileException {
      return Left(DeleteFailure());
    }
  }
}
