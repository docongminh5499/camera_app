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
    if (json['id'] == 0
        || json['id'] == '0'
        || json['id'] == null
        || json['id'] == 'null')
      json['id'] = null;
    print("Picture id ${json['id']}");
    return PictureModel(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      serverId: json['serverId'],
      userId: json['userId'],
      data: json['data'],
      lastModifyTime: DateTime.parse(json['lastModifyTime']).toUtc(),
    );
  }

  Map<String, dynamic> toJson({bool notNull = false, parseString = false}) {
    Map<String, dynamic> json = {
      'id': this.id,
      'serverId': serverId,
      'userId': userId,
      'data': data,
      'lastModifyTime': lastModifyTime.toUtc().toString(),
    };

    if (json['id'] == 0) {
      json['id'] = null;
    }
    if (notNull) {
      json.removeWhere((key, value) => value == null);
    }
    if (parseString) {
      json['id'] = json['id'].toString();
    }
    return json;
  }
}
