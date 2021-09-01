part of 'notification_page_bloc.dart';

abstract class NotificationPageState extends Equatable {
  const NotificationPageState();

  @override
  List<Object> get props => [];
}

class NotificationPageLoading extends NotificationPageState {}

class NotificationPageError extends NotificationPageState {}

class NotificationPageSuccess extends NotificationPageState {
  final List<NotificationEntity> items;
  final bool endOfList;
  NotificationPageSuccess({
    @required this.items,
    @required this.endOfList,
  });

  @override
  List<Object> get props => [items, endOfList];
}

class NotificationPageContinueError extends NotificationPageState {}

class NotificationPageContinueSuccess extends NotificationPageState {
  final List<NotificationEntity> items;
  final bool endOfList;
  NotificationPageContinueSuccess({
    @required this.items,
    @required this.endOfList,
  });

  @override
  List<Object> get props => [items, endOfList];
}

class NotificationPageRefreshError extends NotificationPageState {}

class NotificationPageRefreshSuccess extends NotificationPageState {
  final int id;
  final List<NotificationEntity> items;
  final bool endOfList;
  NotificationPageRefreshSuccess({
    @required this.id,
    @required this.items,
    @required this.endOfList,
  });

  @override
  List<Object> get props => [id, items, endOfList];
}
