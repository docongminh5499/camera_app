import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/domain/repositories/account_repository.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/param.dart';

class ModifyAccountUsecase extends Usecase<Account, ModifyAccountParams> {
  AccountRepository accountRepository;
  ModifyAccountUsecase({@required this.accountRepository});

  @override
  Future<Either<Failure, Account>> call(ModifyAccountParams params) async {
    return await accountRepository.modifyAccount(
      params.jwt,
      params.id,
      params.username,
      params.admin,
    );
  }
}
