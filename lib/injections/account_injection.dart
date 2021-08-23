import 'package:get_it/get_it.dart';
import 'package:my_camera_app_demo/features/account/data/datasources/remote_account_datasource.dart';
import 'package:my_camera_app_demo/features/account/data/repositories/account_repository_impl.dart';
import 'package:my_camera_app_demo/features/account/domain/repositories/account_repository.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/add_account.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/get_list_account.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/modify_account.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/remove_account.dart';
import 'package:my_camera_app_demo/features/account/presentation/bloc/account_bloc.dart';

void init(GetIt sl) {
  // * BLOC
  sl.registerFactory(() => AccountBloc(
        getListAccountUsecase: sl(),
        addAccountUsecase: sl(),
        modifyAccountUsecase: sl(),
        removeAccountUsecase: sl(),
      ));
  // * USECASE
  sl.registerLazySingleton(() => GetListAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddAccountUsecase(accountRepository: sl()));
  sl.registerLazySingleton(() => ModifyAccountUsecase(accountRepository: sl()));
  sl.registerLazySingleton(() => RemoveAccountUsecase(accountRepository: sl()));
  // * REPOSITORY
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(
        remoteAccountDatasource: sl(),
        networkInfo: sl(),
      ));
  // * DATASOURCE
  sl.registerLazySingleton<RemoteAccountDatasource>(
      () => RemoteAccountDatasourceImpl(client: sl()));
}
