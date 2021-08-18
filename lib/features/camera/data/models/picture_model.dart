import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';

class PictureModel extends Picture {
  PictureModel({@required String path}) : super(path: path);

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    return PictureModel(path: json['path']);
  }

  Map<String, dynamic> toJson() {
    return {'path': path};
  }
}
