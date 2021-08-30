import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DeleteItem extends Equatable {
  final int id;
  final String serverId;
  final String userId;
  final DateTime deletedTime;

  DeleteItem({
    @required this.id,
    @required this.serverId,
    @required this.userId,
    @required this.deletedTime,
  });

  static String table = "DELETE_ITEM";
  static String onCreate() {
    return """
    CREATE TABLE """ +
        DeleteItem.table +
        """ (
      id INTEGER PRIMARY KEY, 
      serverId TEXT NOT NULL,
      userId TEXT NOT NULL,
      deletedTime DATETIME NOT NULL
    )""";
  }

  @override
  List<Object> get props => <dynamic>[id, userId, serverId, deletedTime];
}
