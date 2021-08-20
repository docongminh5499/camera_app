import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SavePictureParams extends Equatable {
  final String path;
  final String jwt;
  final String userId;

  SavePictureParams({
    @required this.path,
    @required this.jwt,
    @required this.userId,
  });

  @override
  List<Object> get props => <dynamic>[path, jwt, userId];
}
