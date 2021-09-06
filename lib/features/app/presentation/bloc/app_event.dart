part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class CacheDefaultSettingEvent extends AppEvent {
  final Locale locale;
  final bool isDarkOn;

  CacheDefaultSettingEvent({@required this.locale, @required this.isDarkOn});
  @override
  List<Object> get props => <dynamic>[
        locale.countryCode,
        locale.languageCode,
        isDarkOn,
      ];
}

class LoadingEvent extends AppEvent {}

class LoginSuccessfulEvent extends AppEvent {
  final User user;
  LoginSuccessfulEvent({@required this.user});
  @override
  List<Object> get props => <dynamic>[user];
}

class LogoutEvent extends AppEvent {
  final String jwt;
  final String userId;

  LogoutEvent({
    @required this.jwt,
    @required this.userId,
  });
  @override
  List<Object> get props => <dynamic>[jwt, userId];
}

class ChangeDarkModeEvent extends AppEvent {
  final bool turnOn;
  ChangeDarkModeEvent({@required this.turnOn});
  @override
  List<Object> get props => <dynamic>[turnOn];
}

class ChangeLanguageEvent extends AppEvent {
  final String languageCode;
  final String countryCode;
  ChangeLanguageEvent({
    @required this.languageCode,
    @required this.countryCode,
  });
  @override
  List<Object> get props => <dynamic>[languageCode, countryCode];
}
