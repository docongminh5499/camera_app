import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, User>> autoLogin();
  Future<Either<Failure, void>> logout();
}
