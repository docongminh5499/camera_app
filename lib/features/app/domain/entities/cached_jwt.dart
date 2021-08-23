import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CachedJWT extends Equatable {
  final int id;
  final String userId;
  final String jwt;

  CachedJWT({
    this.id,
    @required this.userId,
    @required this.jwt,
  });

  static String table = "JWT";
  static String onCreate() {
    return """
    CREATE TABLE JWT (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      userId TEXT NOT NULL,
      jwt TEXT NOT NULL,
    )""";
  }

  @override
  List<Object> get props => <dynamic>[id, userId, jwt];
}
