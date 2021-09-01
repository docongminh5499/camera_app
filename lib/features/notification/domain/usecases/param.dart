import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetUnopenNotificationNumberParams extends Equatable {
  final String jwt;
  GetUnopenNotificationNumberParams({@required this.jwt});

  @override
  List<Object> get props => <dynamic>[jwt];
}


class OpenAllNotificationParams extends Equatable {
  final String jwt;
  OpenAllNotificationParams({@required this.jwt});

  @override
  List<Object> get props => <dynamic>[jwt];
}
