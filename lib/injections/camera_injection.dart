import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/camera/data/datasources/local_camera_datasource.dart';
import 'package:my_camera_app_demo/features/camera/data/repositories/camera_repository_impl.dart';
import 'package:my_camera_app_demo/features/camera/domain/repositories/camera_repository.dart';
import 'package:my_camera_app_demo/features/camera/domain/usecases/save_picture.dart';
import 'package:my_camera_app_demo/features/camera/presentation/bloc/camera_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerFactory(() => CameraBloc(
        savePictureUsecase: sl(),
      ));
  // * USECASE
  sl.registerLazySingleton(() => SavePictureUsecase(repository: sl()));
  // * REPOSITORY
  sl.registerLazySingleton<CameraRepository>(
      () => CameraRepositoryImpl(localCameraDatasource: sl()));
  // * DATA SOURCE
  sl.registerLazySingleton<LocalCameraDatasource>(
      () => LocalCameraDatasourceImpl());
}
