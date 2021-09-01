part of 'notification_button_bloc.dart';

abstract class NotificationButtonEvent extends Equatable {
  const NotificationButtonEvent();
  @override
  List<Object> get props => [];
}

class GetUnopenNotificationNumberEvent extends NotificationButtonEvent {
  final String jwt;
  GetUnopenNotificationNumberEvent({@required this.jwt});
  @override
  List<Object> get props => [jwt];
}


class OpenAllNotificationEvent extends NotificationButtonEvent {
  final String jwt;
  OpenAllNotificationEvent({@required this.jwt});
  @override
  List<Object> get props => [jwt];
}
