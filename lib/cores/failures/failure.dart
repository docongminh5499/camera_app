import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class LoginFailure extends Failure {}

class LogoutFailure extends Failure {}

class AutoLoginFailure extends Failure {}

class GetAccountFailure extends Failure {}

class CreateAccountFailure extends Failure {
  final int statusCode;
  CreateAccountFailure({@required this.statusCode});
  @override
  List<Object> get props => <dynamic>[statusCode];
}

class ModifyAccountFailure extends Failure {
  final int statusCode;
  ModifyAccountFailure({@required this.statusCode});
  @override
  List<Object> get props => <dynamic>[statusCode];
}

class RemoveAccountFailure extends Failure {
  final int statusCode;
  RemoveAccountFailure({@required this.statusCode});
  @override
  List<Object> get props => <dynamic>[statusCode];
}
