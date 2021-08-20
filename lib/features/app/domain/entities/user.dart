import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String password;
  final String jwt;
  final String role;

  User({
    @required this.id,
    @required this.username,
    @required this.password,
    @required this.jwt,
    @required this.role,
  });

  @override
  List<Object> get props => <dynamic>[id, username, password, jwt, role];

  bool isAdmin() => role == Constants.adminRole;
}
