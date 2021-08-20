import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/features/camera/data/models/picture_model.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalCameraDatasource {
  File getFile(String path);
  Future<void> deleteFile(String path);
  Future<int> savePicture(PictureModel model);
}

class LocalCameraDatasourceImpl implements LocalCameraDatasource {
  Database database;
  LocalCameraDatasourceImpl({@required this.database});

  @override
  Future<int> savePicture(PictureModel model) async {
    return await database.insert(
      Picture.table,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  File getFile(String path) {
    try {
      return File(path);
    } catch (error, stack) {
      print("$error $stack");
      throw GetFileException();
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      await File(path).delete();
    } catch (error, stack) {
      print("$error $stack");
      throw DeleteFileException();
    }
  }
}
