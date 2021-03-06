part of 'account_bloc.dart';

@immutable
abstract class AccountEvent extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class LoadAccountEvent extends AccountEvent {
  final String jwt;
  LoadAccountEvent({@required this.jwt});
  @override
  List<Object> get props => <dynamic>[jwt];
}

class CreateAccountEvent extends AccountEvent {
  final String jwt;
  final String username;
  final String password;
  final bool admin;

  CreateAccountEvent({
    @required this.jwt,
    @required this.username,
    @required this.password,
    @required this.admin,
  });
  @override
  List<Object> get props => <dynamic>[jwt, username, password, admin];
}

class ModifyAccountEvent extends AccountEvent {
  final String jwt;
  final String username;
  final String id;
  final bool admin;

  ModifyAccountEvent({
    @required this.jwt,
    @required this.username,
    @required this.admin,
    @required this.id,
  });
  @override
  List<Object> get props => <dynamic>[jwt, id, username, admin];
}

class RemoveAccountEvent extends AccountEvent {
  final String jwt;
  final String id;

  RemoveAccountEvent({
    @required this.jwt,
    @required this.id,
  });
  
  @override
  List<Object> get props => <dynamic>[jwt, id];
}
