import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/login_repository.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/params.dart';

class LoginUsecase extends Usecase<User, LoginParams> {
  final LoginRepository repository;

  LoginUsecase({this.repository});

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}
