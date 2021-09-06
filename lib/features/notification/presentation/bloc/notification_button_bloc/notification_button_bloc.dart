import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/get_unopen_notification_number_usecase.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/open_all_notification_usecase.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/param.dart';

part 'notification_button_event.dart';
part 'notification_button_state.dart';

class NotificationButtonBloc
    extends Bloc<NotificationButtonEvent, NotificationButtonState> {
  final GetUnopenNotificationNumberUsecase getUnopenNotificationNumberUsecase;
  final OpenAllNotificationUsecase openAllNotificationUsecase;

  NotificationButtonBloc({
    @required this.getUnopenNotificationNumberUsecase,
    @required this.openAllNotificationUsecase,
  }) : super(NotificationButtonInitial());

  @override
  Stream<NotificationButtonState> mapEventToState(
      NotificationButtonEvent event) async* {
    // GetUnopenNotificationNumberEvent event
    if (event is GetUnopenNotificationNumberEvent) {
      final result = await getUnopenNotificationNumberUsecase(
        GetUnopenNotificationNumberParams(jwt: event.jwt),
      );
      if (result.numberOfNotification >= 0)
        yield NotificationGetUnopenSuccess(
          numberOfNotification: result.numberOfNotification,
          receiveTrigger: event.receiveTrigger,
        );
      else
        yield NotificationGetUnopenError();

      // OpenAllNotificationEvent event
    } else if (event is OpenAllNotificationEvent) {
      final result = await openAllNotificationUsecase(
        OpenAllNotificationParams(jwt: event.jwt),
      );
      if (result.opened)
        yield NotificationOpenSuccess(opened: result.opened);
      else
        yield NotificationOpenError();
    }
  }
}
