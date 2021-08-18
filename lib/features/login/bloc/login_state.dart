part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class NormalState extends LoginState {}

class LoggingState extends LoginState {}

class ErrorLoginState extends LoginState {}

class SuccessLoginState extends LoginState {
  final User user;
  SuccessLoginState({@required this.user});
  @override
  List<Object> get props => <dynamic>[user];
}

