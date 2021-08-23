import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DeleteItem extends Equatable {
  final String id;
  final String serverId;
  final DateTime deletedTime;

  DeleteItem({
    this.id,
    this.serverId,
    @required this.deletedTime,
  });

  static String table = "DELETE_ITEM";
  static String onCreate() {
    return """
    CREATE TABLE """ +
        DeleteItem.table +
        """ (
      id INTEGER PRIMARY KEY, 
      serverId TEXT,
      deletedTime DATETIME NOT NULL
    )""";
  }

  @override
  List<Object> get props => <dynamic>[id, serverId, deletedTime];
}
