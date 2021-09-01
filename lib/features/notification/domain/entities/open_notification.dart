import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class OpenNotificationStatus extends Equatable {
  final bool opened;
  OpenNotificationStatus({@required this.opened});

  @override
  List<Object> get props => <dynamic>[opened];
}
