import 'package:my_camera_app_demo/features/app/domain/entities/cached_jwt.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/domain/entities/deleted_items.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';

Future<void> initDatabase() async {
  Constants.database = await openDatabase(
    join(
      await getDatabasesPath(),
      'camera_app.db',
    ),
    onCreate: (Database db, int version) async {
      print("Creating Picture table");
      await db.execute(Picture.onCreate());
      print("Creating DeleteItem table");
      await db.execute(DeleteItem.onCreate());
      print("Creating CachedJWT table");
      await db.execute(CachedJWT.onCreate());
    },
    version: 1,
  );
  String dbpath = join(await getDatabasesPath(), 'camera_app.db');
  print("Database path: $dbpath");
}
