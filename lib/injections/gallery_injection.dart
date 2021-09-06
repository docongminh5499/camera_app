import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/gallery/data/datasources/local_gallery_datasource.dart';
import 'package:my_camera_app_demo/features/gallery/data/datasources/remote_gallery_datasource.dart';
import 'package:my_camera_app_demo/features/gallery/data/repositories/gallery_repository_impl.dart';
import 'package:my_camera_app_demo/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/delete_picture_usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/export_picture_usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/get_picture_usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/send_sync_usecase.dart';
import 'package:my_camera_app_demo/features/gallery/presentation/bloc/gallery_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerFactory(() => GalleryBloc(
        sendSyncUsecase: sl(),
        getPictureUsecase: sl(),
        exportPictureUsecase: sl(),
        deletePictureUsecase: sl(),
      ));
  // * USECASE
  sl.registerLazySingleton(() => SendSyncUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetPictureUsecase(repository: sl()));
  sl.registerLazySingleton(() => ExportPictureUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeletePictureUsecase(repository: sl()));
  // * REPOSITORY
  sl.registerLazySingleton<GalleryRepository>(
    () => GalleryRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  // * DATASOURCE
  sl.registerLazySingleton<LocalGalleryDatasource>(
    () => LocalGalleryDatasourceImpl(
      preferences: sl(),
      database: sl(),
    ),
  );
  sl.registerLazySingleton<RemoteGalleryDatasource>(
    () => RemoteGalleryDatasourceImpl(
      client: sl(),
    ),
  );
}
