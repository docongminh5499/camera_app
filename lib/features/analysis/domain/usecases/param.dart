import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AnalysisPictureParams extends Equatable {
  final String jwt;
  final String userId;
  final String data;
  final DateTime analysisTime;

  AnalysisPictureParams({
    @required this.jwt,
    @required this.userId,
    @required this.data,
    @required this.analysisTime,
  });

  @override
  List<Object> get props => <dynamic>[jwt, userId, data, analysisTime];
}
