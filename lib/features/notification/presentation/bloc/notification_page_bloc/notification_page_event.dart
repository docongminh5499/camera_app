part of 'notification_page_bloc.dart';

abstract class NotificationPageEvent extends Equatable {
  const NotificationPageEvent();

  @override
  List<Object> get props => [];
}

class NotificationLoadingEvent extends NotificationPageEvent {
  final String jwt;
  final int limit;
  final int skip;

  NotificationLoadingEvent({
    @required this.jwt,
    @required this.limit,
    @required this.skip,
  });

  @override
  List<Object> get props => [jwt, limit, skip];
}

class NotificationContinueEvent extends NotificationPageEvent {
  final String jwt;
  final int limit;
  final int skip;

  NotificationContinueEvent({
    @required this.jwt,
    @required this.limit,
    @required this.skip,
  });

  @override
  List<Object> get props => [jwt, limit, skip];
}

class NotificationRefreshEvent extends NotificationPageEvent {
  final String jwt;
  final int limit;
  final int skip;

  NotificationRefreshEvent({
    @required this.jwt,
    @required this.limit,
    @required this.skip,
  });

  @override
  List<Object> get props => [jwt, limit, skip];
}

