import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/gallery/domain/entities/deleted_items.dart';

class DeletedItemModel extends DeleteItem {
  DeletedItemModel({
    @required int id,
    @required String serverId,
    @required String userId,
    @required DateTime deletedTime,
  }) : super(
          id: id,
          serverId: serverId,
          userId: userId,
          deletedTime: deletedTime,
        );

  factory DeletedItemModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == 0
        || json['id'] == '0'
        || json['id'] == null
        || json['id'] == 'null')
      json['id'] = null;

    return DeletedItemModel(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      serverId: json['serverId'],
      userId: json['userId'],
      deletedTime: DateTime.parse(json['deletedTime']).toUtc(),
    );
  }

  Map<String, dynamic> toJson({bool notNull = false, parseString = false}) {
    Map<String,dynamic> json =  {
      'id': this.id,
      'serverId': serverId,
      'userId': userId,
      'deletedTime': deletedTime.toUtc().toString(),
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
