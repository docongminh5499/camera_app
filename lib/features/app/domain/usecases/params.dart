import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class LanguageParams extends Equatable {
  final String languageCode;
  final String countryCode;
  LanguageParams({@required this.languageCode, @required this.countryCode});
  @override
  List<Object> get props => <dynamic>[languageCode, countryCode];
}

class DarkModeParams extends Equatable {
  final bool turnOn;
  DarkModeParams({@required this.turnOn});
  @override
  List<Object> get props => <dynamic>[turnOn];
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  LoginParams({@required this.username, @required this.password});
  @override
  List<Object> get props => <dynamic>[];
}

class SettingParams extends Equatable {
  final String languageCode;
  final String countryCode;
  final bool turnOn;

  SettingParams({
    @required this.languageCode,
    @required this.countryCode,
    @required this.turnOn,
  });
  @override
  List<Object> get props => <dynamic>[languageCode, countryCode, turnOn];
}
