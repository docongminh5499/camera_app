import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/login.dart';
import 'package:my_camera_app_demo/features/login/bloc/login_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerFactory(() => LoginBloc(loginUsecase: sl()));
  // * USECASE
  sl.registerLazySingleton(() => LoginUsecase(repository: sl()));
}
