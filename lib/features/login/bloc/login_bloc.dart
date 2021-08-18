import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/login.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/params.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  LoginBloc({@required this.loginUsecase}) : super(NormalState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is RemoteLoginEvent) {
      yield LoggingState();
      final result = await loginUsecase(
        LoginParams(
          username: event.username,
          password: event.password,
        ),
      );
      yield result.fold(
        (failure) => ErrorLoginState(),
        (user) => SuccessLoginState(user: user),
      );
    }
  }
}
