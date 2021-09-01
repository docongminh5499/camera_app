import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/repositories/notification_repository.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/param.dart';

class GetNotificationUsecase
    extends Usecase<List<NotificationEntity>, GetNotificationParams> {
  final NotificationRepository repository;
  GetNotificationUsecase({@required this.repository});

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      GetNotificationParams params) async {
    return await repository.getNotification(
      params.jwt,
      params.limit,
      params.skip,
    );
  }
}
