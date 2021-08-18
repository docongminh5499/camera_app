import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SavePictureParams extends Equatable {
  final String path;

  SavePictureParams({@required this.path});

  @override
  List<Object> get props => <dynamic>[path];
}
