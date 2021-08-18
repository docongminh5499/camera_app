import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/home/bloc/home_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerFactory(() => HomeBloc(appBloc: sl()));
}
