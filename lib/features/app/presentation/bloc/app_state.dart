part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class LoadingState extends AppState {}

class UnLoginState extends AppState {
  final Setting setting;
  UnLoginState({@required this.setting});
  @override
  List<Object> get props => <dynamic>[setting];
}

class LoggedInState extends AppState {
  final Setting setting;
  final User currentUser;
  LoggedInState({
    @required this.setting,
    @required this.currentUser,
  });
  @override
  List<Object> get props => <dynamic>[setting, currentUser];
}
