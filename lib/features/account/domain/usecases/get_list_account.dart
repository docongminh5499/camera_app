import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/domain/repositories/account_repository.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/param.dart';

class GetListAccountUsecase
    extends Usecase<List<Account>, GetListAccountParams> {
  AccountRepository repository;
  GetListAccountUsecase({@required this.repository});

  Future<Either<Failure, List<Account>>> call(
    GetListAccountParams params,
  ) async {
    return await repository.getListAccount(params.jwt);
  }
}
