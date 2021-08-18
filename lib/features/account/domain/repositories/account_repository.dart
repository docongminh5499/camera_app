import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<Account>>> getListAccount(String jwt);
  Future<Either<Failure, Account>> addAccount(
    String jwt,
    String username,
    String password,
    bool admin,
  );
  Future<Either<Failure, Account>> modifyAccount(
    String jwt,
    String id,
    String username,
    bool admin,
  );
  Future<Either<Failure, Account>> removeAccount(
    String jwt,
    String id,
  );
}
