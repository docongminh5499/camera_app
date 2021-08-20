import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/domain/entities/deleted_items.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';

Future<void> initDatabase() async {
  List<dynamic> modelSQLClass = [Picture, DeleteItem];

  Constants.database = await openDatabase(
    join(
      await getDatabasesPath(),
      'camera_app.db',
    ),
    onCreate: (db, version) {
      return modelSQLClass.forEach(
        (model) async => await db.execute(model.onCreate()),
      );
    },
    version: 1,
  );
}
