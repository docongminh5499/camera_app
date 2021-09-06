import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/network/network_info.dart';
import 'package:my_camera_app_demo/features/camera/data/models/picture_model.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/data/datasources/local_gallery_datasource.dart';
import 'package:my_camera_app_demo/features/gallery/data/datasources/remote_gallery_datasource.dart';
import 'package:my_camera_app_demo/features/gallery/data/models/deleted_items_model.dart';
import 'package:my_camera_app_demo/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final LocalGalleryDatasource localDatasource;
  final RemoteGalleryDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  GalleryRepositoryImpl({
    @required this.localDatasource,
    @required this.remoteDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> sendSync(String jwt, String userId) async {
    if (!(await networkInfo.isConnected)) return Right(Unit);

    DateTime currentSyncTime = localDatasource.getCurrentSyncTime();
    DateTime newSyncTime = DateTime.now().toUtc();
    await localDatasource.setSyncTime(newSyncTime);

    final result = await Future.wait([
      remoteDatasource.requireSyncCreate(
        jwt,
        currentSyncTime,
        newSyncTime,
      ),
      remoteDatasource.requireSyncDelete(
        jwt,
        currentSyncTime,
        newSyncTime,
      ),
      localDatasource.getCreatedPicture(
        userId,
        currentSyncTime,
        newSyncTime,
      ),
      localDatasource.getDeletedPicture(
        userId,
        currentSyncTime,
        newSyncTime,
      ),
    ]);

    List<PictureModel> requiredCreate = result[0];
    List<DeletedItemModel> requiredDelete = result[1];
    List<PictureModel> created = result[2];
    List<DeletedItemModel> deleted = result[3];

    await Future.wait([
      Future.wait(requiredCreate.map((element) async {
        try {
          await localDatasource.savePicture(element);
        } catch (error, _) {
          print("$error $_");
        }
      })),
      Future.wait(requiredDelete.map((element) async {
        try {
          await localDatasource.deleteDeletedItem(element);
          await localDatasource.deletePicture(element.serverId);
        } catch (error, _) {
          print("$error $_");
        }
      })),
      Future.wait(created.map((element) async {
        try {
          final result = await remoteDatasource.syncCreate(jwt, element);
          await localDatasource.updateServerId(result);
        } catch (error, _) {
          print("Sync create error");
          print("$error $_");
        }
      })),
      Future.wait(deleted.map((element) async {
        try {
          final result = await remoteDatasource.syncDelete(jwt, element);
          await localDatasource.deleteDeletedItem(result);
        } catch (error, _) {
          print("$error $_");
        }
      })),
    ]);
    return Right(Unit);
  }

  @override
  Future<Either<Failure, List<Picture>>> getPicture(
    String jwt,
    String userId,
    int limit,
    int skip,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getPicture(jwt, limit, skip);
        final savedResult = await Future.wait(result.map((data) async {
          DateTime currentSyncTime = localDatasource.getCurrentSyncTime();
          DateTime lastModifyTime = data.lastModifyTime;
          if (lastModifyTime.isBefore(currentSyncTime))
            return localDatasource.insertOrAbort(data);
          return data;
        }));
        return Right(savedResult);
      } on RemoteGalleryException {
        return Left(RemoteGalleryFailure());
      }
    }
    return Right(await localDatasource.getPicture(userId, limit, skip));
  }

  @override
  Future<bool> exportPicture(List<Picture> pictures) async {
    if (await Permission.storage.status.isGranted) {
      final result = await Future.wait(pictures.map((element) async {
        return await localDatasource.exportPicture(element);
      }));
      return !result.any((element) => element == false);
    } else if (await Permission.storage.status.isDenied) {
      PermissionStatus result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        final result = await Future.wait(pictures.map((element) async {
          return await localDatasource.exportPicture(element);
        }));
        return !result.any((element) => element == false);
      }
    }
    return false;
  }
}
