import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/camera/data/models/picture_model.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/data/models/deleted_items_model.dart';
import 'package:my_camera_app_demo/features/gallery/domain/entities/deleted_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalGalleryDatasource {
  DateTime getCurrentSyncTime();
  Future<bool> setSyncTime(DateTime time);
  Future<List<PictureModel>> getCreatedPicture(
    String userId,
    DateTime start,
    DateTime end,
  );
  Future<List<DeletedItemModel>> getDeletedPicture(
    String userId,
    DateTime start,
    DateTime end,
  );
  Future<void> clearData(String userId);
  Future<PictureModel> savePicture(PictureModel model);
  Future<void> deletePicture(String serverId);
  Future<List<PictureModel>> getPicture(String userId, int limit, int skip);
  Future<void> updateServerId(PictureModel model);
  Future<PictureModel> insertOrAbort(PictureModel model);
  Future<void> deleteDeletedItem(DeletedItemModel model);
}

class LocalGalleryDatasourceImpl implements LocalGalleryDatasource {
  final SharedPreferences preferences;
  final Database database;

  LocalGalleryDatasourceImpl({
    @required this.preferences,
    @required this.database,
  });

  @override
  DateTime getCurrentSyncTime() {
    String sSyncDate = preferences.getString(Constants.cachedTimeSyncKey);
    if (sSyncDate == null || sSyncDate.length == 0) return null;
    return DateTime.parse(sSyncDate);
  }

  @override
  Future<bool> setSyncTime(DateTime time) async {
    return await preferences.setString(
      Constants.cachedTimeSyncKey,
      time.toUtc().toString(),
    );
  }

  @override
  Future<List<PictureModel>> getCreatedPicture(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    if (start == null) {
      final result = await database.query(
        Picture.table,
        where: """
        lastModifyTime < ? 
        AND serverId IS NULL
        AND userId = ?""",
        whereArgs: [
          end.toUtc().toString(),
          userId,
        ],
      );
      return List.generate(result.length, (index) {
        return PictureModel.fromJson(result[index]);
      });
    }

    final result = await database.query(
      Picture.table,
      where: """
      lastModifyTime >= ? 
      AND lastModifyTime < ? 
      AND serverId IS NULL
      AND userId = ?""",
      whereArgs: [
        start.toUtc().toString(),
        end.toUtc().toString(),
        userId,
      ],
    );

    return List.generate(result.length, (index) {
      return PictureModel.fromJson(result[index]);
    });
  }

  @override
  Future<List<DeletedItemModel>> getDeletedPicture(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    if (start == null) {
      final result = await database.query(
        DeleteItem.table,
        where: "deletedTime < ? AND userId = ?",
        whereArgs: [end.toUtc().toString(), userId],
      );
      return List.generate(result.length, (index) {
        return DeletedItemModel.fromJson(result[index]);
      });
    }

    final result = await database.query(
      DeleteItem.table,
      where: """
      deletedTime >= ? 
      AND deletedTime < ?
      AND userId = ?""",
      whereArgs: [
        start.toUtc().toString(),
        end.toUtc().toString(),
        userId,
      ],
    );
    return List.generate(result.length, (index) {
      return DeletedItemModel.fromJson(result[index]);
    });
  }

  @override
  Future<void> clearData(String userId) async {
    return await Future.wait([
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
    ]);
  }

  @override
  Future<List<PictureModel>> getPicture(
    String userId,
    int limit,
    int skip,
  ) async {
    final result = await database.query(
      Picture.table,
      where: "userId = ?",
      whereArgs: [userId],
      orderBy: "lastModifyTime DESC",
      limit: limit,
      offset: skip,
    );
    return List.generate(
      result.length,
      (index) => PictureModel.fromJson(result[index]),
    );
  }

  @override
  Future<PictureModel> savePicture(PictureModel model) async {
    final id = await database.insert(
      Picture.table,
      model.toJson(notNull: true),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    if (id == 0) throw RemoteGalleryException();
    return PictureModel(
      id: id,
      serverId: model.serverId,
      userId: model.userId,
      data: model.data,
      lastModifyTime: model.lastModifyTime,
    );
  }

  @override
  Future<void> deletePicture(String serverId) async {
    return await database.delete(
      Picture.table,
      where: "serverId = ?",
      whereArgs: [serverId],
    );
  }

  @override
  Future<void> deleteDeletedItem(DeletedItemModel model) async {
    return await database.delete(
      DeleteItem.table,
      where: "serverId = ?",
      whereArgs: [model.serverId],
    );
  }

  @override
  Future<void> updateServerId(PictureModel model) async {
    final result =  await database.update(
      Picture.table,
      {'serverId': model.serverId},
      where: "id = ?",
      whereArgs: [model.id],
    );
    print("Update serverId $result records");
  }

  @override
  Future<PictureModel> insertOrAbort(PictureModel model) async {
    final result = await database.query(
      Picture.table,
      where: "serverId = ?",
      whereArgs: [model.serverId],
    );
    if (result.length > 0)
      return PictureModel.fromJson(result[0]);
    else
      return savePicture(model);
  }
}
