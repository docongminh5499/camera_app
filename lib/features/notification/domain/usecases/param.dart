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

class GetNotificationParams extends Equatable {
  final String jwt;
  final int limit;
  final int skip;

  GetNotificationParams({
    @required this.jwt,
    @required this.limit,
    @required this.skip,
  });

  @override
  List<Object> get props => <dynamic>[jwt, limit, skip];
}
