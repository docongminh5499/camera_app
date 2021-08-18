import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';

class AccountModel extends Account {
  AccountModel({
    @required String id,
    @required String username,
    @required bool admin,
  }) : super(id: id, username: username, admin: admin);

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['_id'],
      username: json['username'],
      admin: json['admin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': this.id,
      'username': username,
      'admin': admin,
    };
  }
}
