import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/features/notification/data/datasources/remote_notification_datasource.dart';
import 'package:my_camera_app_demo/features/notification/data/models/open_notification_model.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/number_notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/open_notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  RemoteNotificationDatasource remoteNotificationDatasource;
  NotificationRepositoryImpl({@required this.remoteNotificationDatasource});

  @override
  Future<NotificationNumber> getUnopenNotificationNumber(String jwt) async {
    try {
      return await remoteNotificationDatasource
          .getUnopenNotificationNumber(jwt);
    } on GetUnopenNotificationException {
      return NotificationNumber(numberOfNotification: -1);
    }
  }

  @override
  Future<OpenNotificationStatus> openAllNotification(String jwt) async {
    try {
      return await remoteNotificationDatasource.openAllNotification(jwt);
    } on OpenAlNotificationException {
      return OpenNotificationStatus(opened: false);
    }
  }
}
