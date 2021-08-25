import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/analysis/data/datasources/remote_analysis_datasource.dart';
import 'package:my_camera_app_demo/features/analysis/data/repositories/analysis_picture_repository_impl.dart';
import 'package:my_camera_app_demo/features/analysis/domain/repositories/analysis_picture_repository.dart';
import 'package:my_camera_app_demo/features/analysis/domain/usecases/analysis_picture_usecase.dart';
import 'package:my_camera_app_demo/features/analysis/presentation/bloc/analysis_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerFactory(() => AnalysisBloc(usecase: sl()));
  // * USECASE
  sl.registerLazySingleton(() => AnalysisPictureUsecase(repository: sl()));
  // * REPOSITORY
  sl.registerLazySingleton<AnalysisPictureRepository>(
    () => AnalysisPictureRepositoryImpl(
      datasource: sl(),
      networkInfo: sl(),
    ),
  );
  // * DATASOURCE
  sl.registerLazySingleton<RemoteAnalysisPictureDatasource>(
      () => RemoteAnalysisPictureDatasourceImpl(client: sl()));
}
