import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetListAccountParams extends Equatable {
  final String jwt;
  GetListAccountParams({@required this.jwt});
  @override
  List<Object> get props => <dynamic>[jwt];
}

class AddAccountParams extends Equatable {
  final String jwt;
  final String username;
  final String password;
  final bool admin;
  AddAccountParams({
    @required this.jwt,
    @required this.username,
    @required this.password,
    @required this.admin,
  });
  @override
  List<Object> get props => <dynamic>[jwt, username, password, admin];
}

class ModifyAccountParams extends Equatable {
  final String jwt;
  final String id;
  final String username;
  final bool admin;
  ModifyAccountParams({
    @required this.jwt,
    @required this.id,
    @required this.username,
    @required this.admin,
  });
  @override
  List<Object> get props => <dynamic>[jwt, id, username, admin];
}

class RemoveAccountParams extends Equatable {
  final String jwt;
  final String id;
  RemoveAccountParams({
    @required this.jwt,
    @required this.id,
  });
  @override
  List<Object> get props => <dynamic>[jwt, id];
}
