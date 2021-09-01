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

class GetFileFailure extends Failure {}

class DeleteFailure extends Failure {}

class SavePictureFailure extends Failure {}

class AnalysisPictureFailure extends Failure {
  final int statusCode;
  AnalysisPictureFailure({@required this.statusCode});
  @override
  List<Object> get props => <dynamic>[statusCode];
}

class RemoteGalleryFailure extends Failure {}

class GetSyncTimeFailure extends Failure {}

class GetNotificationFailure extends Failure {}
