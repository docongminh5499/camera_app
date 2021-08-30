import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SendSyncParams extends Equatable {
  final String jwt;
  final String userId;
  SendSyncParams({
    @required this.jwt,
    @required this.userId,
  });

  @override
  List<Object> get props => <dynamic>[jwt, userId];
}

class GetPictureParams extends Equatable {
  final String jwt;
  final String userId;
  final int limit;
  final int skip;

  GetPictureParams({
    @required this.jwt,
    @required this.userId,
    @required this.limit,
    @required this.skip,
  });

  @override
  List<Object> get props => <dynamic>[jwt, userId, limit, skip];
}
