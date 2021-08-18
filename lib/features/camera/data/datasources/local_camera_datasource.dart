import 'dart:io';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';

abstract class LocalCameraDatasource {
  Future<void> savePicture(String path);
}

class LocalCameraDatasourceImpl implements LocalCameraDatasource {
  @override
  Future<void> savePicture(String path) async {
    try {
      dynamic result = await ImageGallerySaver.saveFile(path);
      print(result);
      await File(path).delete();
    } catch (error, stack) {
      print("$error $stack");
      throw SavePictureException();
    }
  }
}
