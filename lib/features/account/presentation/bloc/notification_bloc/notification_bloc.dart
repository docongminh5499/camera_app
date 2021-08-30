import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/param.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/send_notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SendNotificationUsecase sendNotificationUsecase;
  NotificationBloc({
    @required this.sendNotificationUsecase,
  }) : super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationSendEvent) {
      yield NotificationLoading();
      final result = await sendNotificationUsecase(SendNotificationParams(
        jwt: event.jwt,
        receiverId: event.receiverId,
        message: event.message,
      ));
      if (result) {
        yield NotificationSuccess();
      } else
        yield NotificationError();
    }
  }
}
