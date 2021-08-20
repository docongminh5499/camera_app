import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/database/model_sql.dart';

class Picture extends Equatable implements ModelSQL {
  final int id;
  final String serverId;
  final String data;
  final DateTime lastModifyTime;

  Picture({
    @required this.id,
    this.serverId,
    @required this.data,
    @required this.lastModifyTime,
  });

  @override
  String onCreate() {
    return """
    CREATE TABLE PICTURE (
      id INTEGER PRIMARY KEY, 
      serverId TEXT,
      data TEXT NOT NULL,
      lastModifyTime DATETIME
    )""";
  }

  @override
  List<Object> get props => <dynamic>[id, serverId, data, lastModifyTime];
}
