import 'package:my_camera_app_demo/features/notification/domain/entities/number_notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/open_notification.dart';

abstract class NotificationRepository {
  Future<NotificationNumber> getUnopenNotificationNumber(String jwt);
  Future<OpenNotificationStatus> openAllNotification(String jwt);
}
