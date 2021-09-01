import 'package:my_camera_app_demo/features/notification/domain/entities/number_notification.dart';

class NotificationNumberModel extends NotificationNumber {
  NotificationNumberModel({int numberOfNotification})
      : super(numberOfNotification: numberOfNotification);

  factory NotificationNumberModel.fromJson(Map<String, dynamic> json) {
    return NotificationNumberModel(
        numberOfNotification: json['count']);
  }

  Map<String, dynamic> toJson({bool notNull = false, parseString = false}) {
    Map<String, dynamic> json = {
      'count': numberOfNotification,
    };
    if (notNull) {
      json.removeWhere((key, value) => value == null);
    }
    if (parseString) {
      json['count'] = json['count'].toString();
    }
    return json;
  }
}
