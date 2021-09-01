import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/open_notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/repositories/notification_repository.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/param.dart';

class OpenAllNotificationUsecase extends NoFailureUsecase<
    OpenNotificationStatus, OpenAllNotificationParams> {
  final NotificationRepository repository;
  OpenAllNotificationUsecase({@required this.repository});

  @override
  Future<OpenNotificationStatus> call(OpenAllNotificationParams params) async {
    return await repository.openAllNotification(params.jwt);
  }
}
