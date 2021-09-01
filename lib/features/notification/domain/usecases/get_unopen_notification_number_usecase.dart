import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/number_notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/repositories/notification_repository.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/param.dart';

class GetUnopenNotificationNumberUsecase extends NoFailureUsecase<
    NotificationNumber, GetUnopenNotificationNumberParams> {
  NotificationRepository repository;
  GetUnopenNotificationNumberUsecase({@required this.repository});
  
  @override
  Future<NotificationNumber> call(
      GetUnopenNotificationNumberParams params) async {
    return await repository.getUnopenNotificationNumber(params.jwt);
  }
}
