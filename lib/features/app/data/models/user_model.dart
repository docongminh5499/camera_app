import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    @required id,
    @required username,
    @required password,
    @required jwt,
    @required role,
  }) : super(
          id: id,
          username: username,
          password: password,
          jwt: jwt,
          role: role,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String role;
    if (json.containsKey('role'))
      role = json['role'];
    else if (json.containsKey('admin')) {
      if (json['admin'])
        role = Constants.adminRole;
      else
        role = Constants.userRole;
    }

    return UserModel(
        id: json['_id'],
        username: json['username'],
        password: json['password'],
        jwt: json['jwt'],
        role: role);
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      'username': username,
      'password': password,
      'jwt': jwt,
      'role': role
    };
  }
}
