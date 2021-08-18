import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalLoginDatasource {
  Future<bool> logout();
  Future<bool> cacheUser(UserModel model);
  Future<UserModel> getCachedUser();
}

class LocalLoginDatasourceImplementation implements LocalLoginDatasource {
  final SharedPreferences preferences;

  LocalLoginDatasourceImplementation({@required this.preferences});

  Future<bool> logout() async {
    bool result = await preferences.remove(Constants.cacheUserKey);
    return result;
  }

  Future<bool> cacheUser(UserModel model) {
    return preferences.setString(
        Constants.cacheUserKey, json.encode(model.toJson()));
  }

  Future<UserModel> getCachedUser() async {
    final user = preferences.getString(Constants.cacheUserKey);
    if (user != null) return UserModel.fromJson(json.decode(user));
    throw CacheException();
  }
}
