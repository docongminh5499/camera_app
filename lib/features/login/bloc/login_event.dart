part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class RemoteLoginEvent extends LoginEvent {
  final String username;
  final String password;

  RemoteLoginEvent({@required this.username, @required this.password});

  @override
  List<Object> get props => <dynamic>[username, password];
}
