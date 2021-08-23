import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Picture extends Equatable {
  final int id;
  final String userId;
  final String serverId;
  final String data;
  final DateTime lastModifyTime;

  Picture({
    this.id,
    this.serverId,
    @required this.userId,
    @required this.data,
    @required this.lastModifyTime,
  });

  static String table = "PICTURE";
  static String onCreate() {
    return """
    CREATE TABLE PICTURE (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      serverId TEXT,
      userId TEXT NOT NULL,
      data TEXT NOT NULL,
      lastModifyTime DATETIME NOT NULL
    )""";
  }

  @override
  List<Object> get props => <dynamic>[
        id,
        userId,
        serverId,
        data,
        lastModifyTime,
      ];
}
