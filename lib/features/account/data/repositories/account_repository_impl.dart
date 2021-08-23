import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/network/network_info.dart';
import 'package:my_camera_app_demo/features/account/data/datasources/remote_account_datasource.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/features/account/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  RemoteAccountDatasource remoteAccountDatasource;
  final NetworkInfo networkInfo;

  AccountRepositoryImpl({
    @required this.remoteAccountDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Account>>> getListAccount(String jwt) async {
    try {
      if (await networkInfo.isConnected)
        return Right(await remoteAccountDatasource.getListAccount(jwt));
      throw RemoteAccountException();
    } on RemoteAccountException {
      return Left(GetAccountFailure());
    }
  }

  @override
  Future<Either<Failure, Account>> addAccount(
    String jwt,
    String username,
    String password,
    bool admin,
  ) async {
    try {
      if (await networkInfo.isConnected)
        return Right(await remoteAccountDatasource.addAccount(
            jwt, username, password, admin));
      throw CreateAccountException(statusCode: 500);
    } on CreateAccountException catch (error, _) {
      return Left(CreateAccountFailure(statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, Account>> modifyAccount(
    String jwt,
    String id,
    String username,
    bool admin,
  ) async {
    try {
      if (await networkInfo.isConnected)
        return Right(await remoteAccountDatasource.modifyAccount(
            jwt, id, username, admin));
      throw ModifyAccountException(statusCode: 500);
    } on ModifyAccountException catch (error, _) {
      return Left(ModifyAccountFailure(statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, Account>> removeAccount(String jwt, String id) async {
    try {
      if (await networkInfo.isConnected)
        return Right(await remoteAccountDatasource.removeAccount(jwt, id));
      throw RemoveAccountException(statusCode: 500);
    } on RemoveAccountException catch (error, _) {
      return Left(RemoveAccountFailure(statusCode: error.statusCode));
    }
  }
}
