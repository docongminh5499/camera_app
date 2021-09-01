import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/notification/data/datasources/remote_notification_datasource.dart';
import 'package:my_camera_app_demo/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:my_camera_app_demo/features/notification/domain/repositories/notification_repository.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/get_unopen_notification_number_usecase.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/open_all_notification_usecase.dart';
import 'package:my_camera_app_demo/features/notification/presentation/bloc/notification_button_bloc/notification_button_bloc.dart';
import 'package:my_camera_app_demo/features/notification/presentation/bloc/notification_page_bloc/notification_page_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerFactory(() => NotificationButtonBloc(
        getUnopenNotificationNumberUsecase: sl(),
        openAllNotificationUsecase: sl(),
      ));
  sl.registerFactory(() => NotificationPageBloc());
  // * USECASE
  sl.registerLazySingleton(
      () => GetUnopenNotificationNumberUsecase(repository: sl()));
  sl.registerLazySingleton(() => OpenAllNotificationUsecase(repository: sl()));
  // * REPOSITORY
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(
            remoteNotificationDatasource: sl(),
          ));
  // * DATASOURCE
  sl.registerLazySingleton<RemoteNotificationDatasource>(
    () => RemoteNotificationDatasourceImpl(client: sl()),
  );
}
