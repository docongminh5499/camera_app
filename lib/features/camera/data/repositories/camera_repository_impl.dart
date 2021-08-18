import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/features/camera/data/datasources/local_camera_datasource.dart';
import 'package:my_camera_app_demo/features/camera/domain/repositories/camera_repository.dart';

class CameraRepositoryImpl implements CameraRepository {
  final LocalCameraDatasource localCameraDatasource;

  CameraRepositoryImpl({@required this.localCameraDatasource});

  @override
  Future<bool> savePicture(String path) async {
    try {
      await localCameraDatasource.savePicture(path);
      return true;
    } on SavePictureException {
      return false;
    }
  }
}
