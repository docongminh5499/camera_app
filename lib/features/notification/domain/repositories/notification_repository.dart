import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/number_notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/open_notification.dart';

abstract class NotificationRepository {
  Future<NotificationNumber> getUnopenNotificationNumber(String jwt);
  Future<OpenNotificationStatus> openAllNotification(String jwt);
  Future<Either<Failure, List<NotificationEntity>>> getNotification(
    String jwt,
    int limit,
    int skip,
  );
}
