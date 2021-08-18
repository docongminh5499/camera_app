import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/domain/repositories/account_repository.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/param.dart';

class RemoveAccountUsecase extends Usecase<Account, RemoveAccountParams> {
  AccountRepository accountRepository;
  RemoveAccountUsecase({@required this.accountRepository});

  @override
  Future<Either<Failure, Account>> call(RemoveAccountParams params) async {
    return await accountRepository.removeAccount(params.jwt, params.id);
  }
}
