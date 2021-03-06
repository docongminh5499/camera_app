import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:my_camera_app_demo/cores/network/network_info.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/utils/firebase_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_injection.dart' as login;
import 'app_injection.dart' as app;
import 'camera_injection.dart' as camera;
import 'home_injection.dart' as home;
import 'account_injection.dart' as account;
import 'analysis_picture.dart' as analysis;
import 'gallery_injection.dart' as gallery;
import 'notification_injection.dart' as notification;

final sl = GetIt.instance;

Future<void> init() async {
  //! App init
  app.init(sl);
  //! Login Init
  login.init(sl);
  //! Home Init
  home.init(sl);
  //! Account Init
  account.init(sl);
  //! Camera Init
  camera.init(sl);
  // ! Analysis Picture Init
  analysis.init(sl);
  // ! Gallery Init
  gallery.init(sl);
  // ! Notification Init
  notification.init(sl);
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(
    () => FirebaseHandler(
      preferences: sl(),
      client: sl(),
    ),
  );
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Constants.database);
}
