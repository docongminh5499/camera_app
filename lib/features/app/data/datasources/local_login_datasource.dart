import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/data/models/cached_jwt_model.dart';
import 'package:my_camera_app_demo/features/app/data/models/user_model.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/cached_jwt.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/domain/entities/deleted_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalLoginDatasource {
  Future<bool> clearFirebaseKey();
  Future<bool> logout();
  Future<bool> cacheUser(UserModel model);
  Future<UserModel> getCachedUser();
  Future<CachedJWTModel> cachedJwt(UserModel model);
  Future<void> cachedSyncTime();
  Future<String> getCachedFirebaseToken();
  Future<void> clearAllData(String jwt, String userId);
  Future<void> clearSynedData(String jwt, String userId);
  DateTime getCurrentSyncTime();
  Future<void> clearSyncTime();
}

class LocalLoginDatasourceImplementation implements LocalLoginDatasource {
  final SharedPreferences preferences;
  final Database database;

  LocalLoginDatasourceImplementation({
    @required this.preferences,
    @required this.database,
  });

  @override
  Future<bool> logout() async {
    bool result = await preferences.remove(Constants.cacheUserKey);
    return result;
  }

  @override
  Future<bool> cacheUser(UserModel model) {
    return preferences.setString(
        Constants.cacheUserKey, json.encode(model.toJson()));
  }

  @override
  Future<UserModel> getCachedUser() async {
    final user = preferences.getString(Constants.cacheUserKey);
    if (user != null) return UserModel.fromJson(json.decode(user));
    throw CacheException();
  }

  @override
  Future<CachedJWTModel> cachedJwt(UserModel model) async {
    CachedJWTModel jwt = CachedJWTModel(jwt: model.jwt, userId: model.id);
    final id = await database.insert(
      CachedJWT.table,
      jwt.toJson(notNull: true),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return CachedJWTModel(jwt: model.jwt, id: id, userId: model.id);
  }

  @override
  Future<void> cachedSyncTime() async {
    String syncTime = preferences.getString(Constants.cachedTimeSyncKey);
    if (syncTime == null) {
      DateTime now = DateTime.now();
      await preferences.setString(
        Constants.cachedTimeSyncKey,
        now.toUtc().toString(),
      );
    }
  }

  @override
  Future<bool> clearFirebaseKey() {
    return preferences.remove(Constants.firebaseKey);
  }

  @override
  Future<String> getCachedFirebaseToken() async {
    return preferences.getString(Constants.firebaseKey);
  }

  @override
  Future<void> clearAllData(String jwt, String userId) async {
    await Future.wait([
      database.delete(
        Picture.table,
        where: "userId = ?",
        whereArgs: [userId],
      ),
      database.delete(
        DeleteItem.table,
        where: "userId = ?",
        whereArgs: [userId],
      ),
      database.delete(
        CachedJWT.table,
        where: "userId = ?",
        whereArgs: [userId],
      ),
    ]);
  }

  @override
  Future<void> clearSynedData(String jwt, String userId) async {
    DateTime currentSyncTime = getCurrentSyncTime();
    await Future.wait([
      database.delete(
        Picture.table,
        where: "userId = ? AND lastModifyTime < ? ",
        whereArgs: [userId, currentSyncTime.toUtc().toString()],
      ),
      database.delete(
        DeleteItem.table,
        where: "userId = ? AND deletedTime < ?",
        whereArgs: [userId, currentSyncTime.toUtc().toString()],
      ),
    ]);
  }

  @override
  DateTime getCurrentSyncTime() {
    String sSyncDate = preferences.getString(Constants.cachedTimeSyncKey);
    if (sSyncDate == null || sSyncDate.length == 0) return null;
    return DateTime.parse(sSyncDate);
  }

  @override
  Future<void> clearSyncTime() {
    return preferences.remove(Constants.cachedTimeSyncKey);
  }
}
