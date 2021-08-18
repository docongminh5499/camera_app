import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/network/network_info.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/local_login_datasource.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/remote_login_datasource.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/login_repository.dart';

class LoginRepositoryImplement implements LoginRepository {
  final RemoteLoginDatasource remoteLoginDatasource;
  final LocalLoginDatasource localLoginDatasource;
  final NetworkInfo networkInfo;

  LoginRepositoryImplement(
      {@required this.remoteLoginDatasource,
      @required this.localLoginDatasource,
      @required this.networkInfo});

  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteLoginDatasource.login(username, password);
        await localLoginDatasource.cacheUser(user);
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
      final result = await remoteLoginDatasource.verifyJWT(user);
      if (result) return Right(user);
      throw CacheException();
    } on CacheException {
      return Left(AutoLoginFailure());
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      final result = await localLoginDatasource.logout();
      if (result == false) return Left(LogoutFailure());
      return Right(Unit);
    } catch (error, stack) {
      print("$error $stack");
      return Left(LogoutFailure());
    }
  }
}
