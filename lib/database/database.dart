import 'package:my_camera_app_demo/database/model_sql.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';

Future<void> initDatabase() async {
  List<ModelSQL> modelSQL = [];

  Constants.database = await openDatabase(
    join(
      await getDatabasesPath(),
      'camera_app.db',
    ),
    onCreate: (db, version) {
      return modelSQL.forEach(
        (model) async => await db.execute(model.onCreate()),
      );
    },
  );
}
