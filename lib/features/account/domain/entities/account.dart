import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Account extends Equatable {
  final String id;
  final String username;
  final bool admin;

  Account({
    @required this.id,
    @required this.username,
    @required this.admin,
  });

  @override
  List<Object> get props => <dynamic>[id, username, admin];
}
