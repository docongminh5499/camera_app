import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/auto_login.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/cache_default_setting.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/change_dark_mode.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/change_language.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/clear_setting.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/get_cached_setting.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/logout.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/params.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final ChangeLanguageUsecase changeLanguageUsecase;
  final ChangeDarkModeUsecase changeDarkModeUsecase;
  final ClearSettingUsecase clearSettingUsecase;
  final GetCachedSettingUsecase getCachedSettingUsecase;
  final AutoLoginUsecase autoLoginUsecase;
  final LogoutUsecase logoutUsecase;
  final CacheDefaultSettingUsecase cacheDefaultSettingUsecase;
  AppBloc(
      {@required ChangeLanguageUsecase changeLanguageUsecase,
      @required ChangeDarkModeUsecase changeDarkModeUsecase,
      @required ClearSettingUsecase clearSettingUsecase,
      @required GetCachedSettingUsecase getCachedSettingUsecase,
      @required AutoLoginUsecase autoLoginUsecase,
      @required LogoutUsecase logoutUsecase,
      @required CacheDefaultSettingUsecase cacheDefaultSettingUsecase})
      : this.changeLanguageUsecase = changeLanguageUsecase,
        this.changeDarkModeUsecase = changeDarkModeUsecase,
        this.clearSettingUsecase = clearSettingUsecase,
        this.getCachedSettingUsecase = getCachedSettingUsecase,
        this.autoLoginUsecase = autoLoginUsecase,
        this.logoutUsecase = logoutUsecase,
        this.cacheDefaultSettingUsecase = cacheDefaultSettingUsecase,
        super(LoadingState());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    AppLocalizations localizations = Constants.localizations;

    if (event is LoadingEvent) {
      // Load setting
      Setting setting = await getCachedSettingUsecase(NoParams());
      await localizations.load(Locale(
        setting.currentLanguageCode,
        setting.currentCountryCode,
      ));
      // Autologin
      final result = await autoLoginUsecase(NoParams());
      yield result.fold(
        (failure) => UnLoginState(setting: setting),
        (user) => LoggedInState(currentUser: user, setting: setting),
      );
    } else if (event is CacheDefaultSettingEvent) {
      await cacheDefaultSettingUsecase(SettingParams(
          countryCode: event.locale.countryCode,
          languageCode: event.locale.languageCode,
          turnOn: event.isDarkOn));
      yield state;
    } else if (event is LoginSuccessfulEvent) {
      Setting setting = await getCachedSettingUsecase(NoParams());
      yield LoggedInState(
        setting: setting,
        currentUser: event.user,
      );
    } else if (event is LogoutEvent) {
      await logoutUsecase(LogoutParams(jwt: event.jwt));
      //await clearSettingUsecase(NoParams());
      yield UnLoginState(
        setting: await getCachedSettingUsecase(NoParams()),
      );
    } else if (event is ChangeDarkModeEvent) {
      Setting setting = await changeDarkModeUsecase(
        DarkModeParams(turnOn: event.turnOn),
      );
      LoggedInState currentState = state;
      yield LoggedInState(
        setting: setting,
        currentUser: currentState.currentUser,
      );
    } else if (event is ChangeLanguageEvent) {
      await changeLanguageUsecase(LanguageParams(
        languageCode: event.languageCode,
        countryCode: event.countryCode,
      ));
      if (state is LoggedInState) {
        LoggedInState currentState = state;
        Setting setting = await getCachedSettingUsecase(NoParams());
        yield LoggedInState(
          setting: setting,
          currentUser: currentState.currentUser,
        );
      } else {
        yield UnLoginState(setting: await getCachedSettingUsecase(NoParams()));
      }
    }
  }
}
