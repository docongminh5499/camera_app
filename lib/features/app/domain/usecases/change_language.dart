import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/setting_repository.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/params.dart';

class ChangeLanguageUsecase extends NoFailureUsecase<Setting, LanguageParams> {
  SettingRepository repository;

  ChangeLanguageUsecase({@required this.repository});

  Future<Setting> call(LanguageParams params) async {
    return await repository.changeLanguague(
        params.languageCode, params.countryCode);
  }
}
