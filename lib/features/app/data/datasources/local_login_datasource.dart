import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/data/models/cached_jwt_model.dart';
import 'package:my_camera_app_demo/features/app/data/models/user_model.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/cached_jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalLoginDatasource {
  Future<bool> logout();
  Future<bool> cacheUser(UserModel model);
  Future<UserModel> getCachedUser();
  Future<CachedJWTModel> cachedJwt(UserModel model);
}

class LocalLoginDatasourceImplementation implements LocalLoginDatasource {
  final SharedPreferences preferences;
  final Database database;

  LocalLoginDatasourceImplementation({
    @required this.preferences,
    @required this.database,
  });

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

  Future<CachedJWTModel> cachedJwt(UserModel model) async {
    CachedJWTModel jwt = CachedJWTModel(jwt: model.jwt, userId: model.id);
    final id = await database.insert(
      CachedJWT.table,
      jwt.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return CachedJWTModel(jwt: model.jwt, id: id, userId: model.id);
  }
}
