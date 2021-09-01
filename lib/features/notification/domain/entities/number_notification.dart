import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class NotificationNumber extends Equatable {
  final int numberOfNotification;
  NotificationNumber({@required this.numberOfNotification});

  @override
  List<Object> get props => <dynamic>[numberOfNotification];
}
