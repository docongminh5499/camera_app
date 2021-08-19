import 'package:flutter/material.dart';
import 'package:my_camera_app_demo/features/app/presentation/pages/my_app.dart';
import 'injections/injection.dart' as di;
import 'database/database.dart' as database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.initDatabase();
  await di.init();
  runApp(MyApp());
}
