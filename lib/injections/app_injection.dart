import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/local_login_datasource.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/local_setting_datasource.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/remote_login_datasource.dart';
import 'package:my_camera_app_demo/features/app/data/repositories/login_repository_impl.dart';
import 'package:my_camera_app_demo/features/app/data/repositories/setting_repository_impl.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/login_repository.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/setting_repository.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/auto_login.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/cache_default_setting.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/change_dark_mode.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/change_language.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/clear_setting.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/get_cached_setting.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/logout.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerLazySingleton(() => AppBloc(
      changeLanguageUsecase: sl(),
      changeDarkModeUsecase: sl(),
      clearSettingUsecase: sl(),
      getCachedSettingUsecase: sl(),
      autoLoginUsecase: sl(),
      logoutUsecase: sl(),
      cacheDefaultSettingUsecase: sl()));
  // * USECASE
  sl.registerLazySingleton(() => ChangeLanguageUsecase(repository: sl()));
  sl.registerLazySingleton(() => ChangeDarkModeUsecase(repository: sl()));
  sl.registerLazySingleton(() => ClearSettingUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCachedSettingUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => AutoLoginUsecase(repository: sl()));
  sl.registerLazySingleton(() => CacheDefaultSettingUsecase(repository: sl()));
  // * REPOSITORY
  sl.registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImplementation(dataSource: sl()));
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImplement(
        remoteLoginDatasource: sl(),
        localLoginDatasource: sl(),
        networkInfo: sl(),
        firebaseHandler: sl(),
      ));
  // * DATA SOURCE
  sl.registerLazySingleton<LocalSettingDataSource>(
      () => LocalSettingDataSourceImplementation(preferences: sl()));
  sl.registerLazySingleton<RemoteLoginDatasource>(
      () => RemoteLoginDataSourceImplmentation(client: sl()));
  sl.registerLazySingleton<LocalLoginDatasource>(
    () => LocalLoginDatasourceImplementation(
      preferences: sl(),
      database: sl(),
    ),
  );
}
