part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationSendEvent extends NotificationEvent {
  final String jwt;
  final String receiverId;
  final String message;
  NotificationSendEvent({
    @required this.jwt,
    @required this.receiverId,
    @required this.message,
  });
  @override
  List<Object> get props => [jwt, receiverId, message];
}
