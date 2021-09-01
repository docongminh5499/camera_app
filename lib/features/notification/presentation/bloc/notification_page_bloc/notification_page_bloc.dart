import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/notification.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:my_camera_app_demo/features/notification/domain/usecases/param.dart';

part 'notification_page_event.dart';
part 'notification_page_state.dart';

class NotificationPageBloc
    extends Bloc<NotificationPageEvent, NotificationPageState> {
  final GetNotificationUsecase getNotificationUsecase;
  NotificationPageBloc({
    @required this.getNotificationUsecase,
  }) : super(NotificationPageLoading());

  @override
  Stream<NotificationPageState> mapEventToState(
    NotificationPageEvent event,
  ) async* {
    if (event is NotificationLoadingEvent) {
      yield NotificationPageLoading();
      final result = await getNotificationUsecase(GetNotificationParams(
        jwt: event.jwt,
        limit: event.limit,
        skip: event.skip,
      ));
      yield result.fold(
        (failure) => NotificationPageError(),
        (data) => NotificationPageSuccess(
          items: data,
          endOfList: data.length < Constants.limitNotificationPerRequest,
        ),
      );
    } else if (event is NotificationContinueEvent) {
      final result = await getNotificationUsecase(GetNotificationParams(
        jwt: event.jwt,
        limit: event.limit,
        skip: event.skip,
      ));
      yield result.fold(
        (failure) => NotificationPageContinueError(),
        (data) => NotificationPageContinueSuccess(
          items: data,
          endOfList: data.length < Constants.limitNotificationPerRequest,
        ),
      );
    } else if (event is NotificationRefreshEvent) {
      final result = await getNotificationUsecase(GetNotificationParams(
        jwt: event.jwt,
        limit: event.limit,
        skip: event.skip,
      ));

      Random random = new Random();
      yield result.fold(
        (failure) => NotificationPageRefreshError(),
        (data) => NotificationPageRefreshSuccess(
          id: random.nextInt(100),
          items: data,
          endOfList: data.length < Constants.limitNotificationPerRequest,
        ),
      );
    }
  }
}
