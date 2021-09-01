part of 'notification_button_bloc.dart';

abstract class NotificationButtonState extends Equatable {
  const NotificationButtonState();
  
  @override
  List<Object> get props => [];
}

class NotificationButtonInitial extends NotificationButtonState {}

class NotificationGetUnopenSuccess extends NotificationButtonState {
  final int numberOfNotification;
  NotificationGetUnopenSuccess({@required this.numberOfNotification});
  @override 
  List<Object> get props => <dynamic>[numberOfNotification];
}

class NotificationGetUnopenError extends NotificationButtonState {}

class NotificationOpenSuccess extends NotificationButtonState {
  final bool opened;
  NotificationOpenSuccess({@required this.opened});
  @override 
  List<Object> get props => <dynamic>[opened];
}

class NotificationOpenError extends NotificationButtonState {}