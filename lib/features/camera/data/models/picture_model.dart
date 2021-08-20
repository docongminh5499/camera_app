import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';

class PictureModel extends Picture {
  PictureModel({
    int id,
    String serverId,
    @required String userId,
    @required String data,
    @required DateTime lastModifyTime,
  }) : super(
          id: id,
          serverId: serverId,
          userId: userId,
          data: data,
          lastModifyTime: lastModifyTime,
        );

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    return PictureModel(
      id: json['id'],
      serverId: json['serverId'],
      userId: json['userId'],
      data: json['data'],
      lastModifyTime: DateTime.parse(json['lastModifyTime']).toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'serverId': serverId,
      'userId': userId,
      'data': data,
      'lastModifyTime': lastModifyTime.toUtc().toString()
    };
  }
}
