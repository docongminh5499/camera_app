import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/login_repository.dart';

class AutoLoginUsecase extends Usecase<User, NoParams> {
  final LoginRepository repository;

  AutoLoginUsecase({this.repository});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.autoLogin();
  }
}
