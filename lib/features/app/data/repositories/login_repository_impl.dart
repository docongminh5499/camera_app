import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/network/network_info.dart';
import 'package:my_camera_app_demo/cores/utils/firebase_handler.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/local_login_datasource.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/remote_login_datasource.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/login_repository.dart';
import 'package:my_camera_app_demo/features/gallery/domain/repositories/gallery_repository.dart';

class LoginRepositoryImplement implements LoginRepository {
  final GalleryRepository galleryRepository;
  final RemoteLoginDatasource remoteLoginDatasource;
  final LocalLoginDatasource localLoginDatasource;
  final NetworkInfo networkInfo;
  final FirebaseHandler firebaseHandler;

  LoginRepositoryImplement({
    @required this.remoteLoginDatasource,
    @required this.localLoginDatasource,
    @required this.networkInfo,
    @required this.firebaseHandler,
    @required this.galleryRepository,
  });

  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteLoginDatasource.login(username, password);
        await Future.wait([
          localLoginDatasource.cacheUser(user),
          localLoginDatasource.cachedSyncTime(),
          galleryRepository.syncPrevData(),
        ]);
        localLoginDatasource.cachedJwt(user);
        firebaseHandler.firebaseConfig(user);
        firebaseHandler.attachMessageOpenAppListener();
        return Right(user);
      }
      throw LoginException();
    } on LoginException {
      return Left(LoginFailure());
    }
  }

  Future<Either<Failure, User>> autoLogin() async {
    try {
      final user = await localLoginDatasource.getCachedUser();
      firebaseHandler.firebaseConfig(user);
      firebaseHandler.attachMessageOpenAppListener();
      return Right(user);
      // final result = await remoteLoginDatasource.verifyJWT(user);
      // if (result) return Right(user);
      // throw CacheException();
    } on CacheException {
      return Left(AutoLoginFailure());
    }
  }

  Future<Either<Failure, void>> logout(String jwt, String userId) async {
    try {
      final results = await Future.wait([
        networkInfo.isConnected,
        localLoginDatasource.logout(),
        localLoginDatasource.getCachedFirebaseToken(),
      ]);

      final bool hasConnection = results[0] ;
      final bool clearsUser = results[1];
      final String prevToken = results[2];

      if (clearsUser == false) {
        return Left(LogoutFailure());
      }

      Future<bool> clearLocalData;
      Future<bool> localClearToken;

      // Clear Firebase-Token
      if (prevToken != null) {
        if (hasConnection)
          await remoteLoginDatasource.removeFirebaseToken(jwt, prevToken);
        localClearToken = localLoginDatasource.clearFirebaseKey();
      }

      // Clear-User-Data
      if (hasConnection) {
        await galleryRepository.sendSync(jwt, userId);
        clearLocalData = localLoginDatasource.clearAllData(userId);
      } else {
        DateTime currentSyncTime = localLoginDatasource.getCurrentSyncTime();
        clearLocalData = localLoginDatasource.clearSynedData(userId, currentSyncTime);
      }

      await Future.wait([
        clearLocalData,
        localClearToken,
      ]);

      // Clear-Sync-Time
      await localLoginDatasource.clearSyncTime();
      return Right(Unit);
    } catch (error, stack) {
      print("$error $stack");
      return Left(LogoutFailure());
    }
  }
}
