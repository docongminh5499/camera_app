import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/features/account/data/datasources/remote_account_datasource.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/features/account/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  RemoteAccountDatasource remoteAccountDatasource;
  AccountRepositoryImpl({@required this.remoteAccountDatasource});

  @override
  Future<Either<Failure, List<Account>>> getListAccount(String jwt) async {
    try {
      return Right(await remoteAccountDatasource.getListAccount(jwt));
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
      return Right(await remoteAccountDatasource.addAccount(
          jwt, username, password, admin));
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
      return Right(await remoteAccountDatasource.modifyAccount(
          jwt, id, username, admin));
    } on ModifyAccountException catch (error, _) {
      return Left(ModifyAccountFailure(statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, Account>> removeAccount(String jwt, String id) async {
    try {
      return Right(await remoteAccountDatasource.removeAccount(jwt, id));
    } on RemoveAccountException catch (error, _) {
      return Left(RemoveAccountFailure(statusCode: error.statusCode));
    }
  }
}
