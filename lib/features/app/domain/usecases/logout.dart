import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/login_repository.dart';

class LogoutUsecase extends Usecase<void, NoParams> {
  final LoginRepository repository;

  LogoutUsecase({this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
