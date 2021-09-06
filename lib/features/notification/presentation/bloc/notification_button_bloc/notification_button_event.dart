part of 'notification_button_bloc.dart';

abstract class NotificationButtonEvent extends Equatable {
  const NotificationButtonEvent();
  @override
  List<Object> get props => [];
}

class GetUnopenNotificationNumberEvent extends NotificationButtonEvent {
  final String jwt;
  final bool receiveTrigger;
  GetUnopenNotificationNumberEvent({
    @required this.jwt,
    @required this.receiveTrigger,
  });
  @override
  List<Object> get props => [jwt, receiveTrigger];
}

class OpenAllNotificationEvent extends NotificationButtonEvent {
  final String jwt;
  OpenAllNotificationEvent({@required this.jwt});
  @override
  List<Object> get props => [jwt];
}
