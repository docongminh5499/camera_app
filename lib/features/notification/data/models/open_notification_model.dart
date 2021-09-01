import 'package:my_camera_app_demo/features/notification/domain/entities/open_notification.dart';

class OpenNotificationStatusModel extends OpenNotificationStatus {
  OpenNotificationStatusModel({bool opened}) : super(opened: opened);

  factory OpenNotificationStatusModel.fromJson(Map<String, dynamic> json) {
    return OpenNotificationStatusModel(opened: json['status']);
  }

  Map<String, dynamic> toJson({bool notNull = false, parseString = false}) {
    Map<String, dynamic> json = {
      'status': opened,
    };
    if (notNull) {
      json.removeWhere((key, value) => value == null);
    }
    if (parseString) {
      json['status'] = json['status'].toString();
    }
    return json;
  }
}
