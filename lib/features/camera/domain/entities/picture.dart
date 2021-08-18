import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Picture extends Equatable {
  final String path;

  Picture({@required this.path});

  @override
  List<Object> get props => <dynamic>[path];

  bool isEmpty() => path == null || path.isEmpty;
}
