import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_page_event.dart';
part 'notification_page_state.dart';

class NotificationPageBloc extends Bloc<NotificationPageEvent, NotificationPageState> {
  NotificationPageBloc() : super(NotificationPageInitial());

  @override
  Stream<NotificationPageState> mapEventToState(
    NotificationPageEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
