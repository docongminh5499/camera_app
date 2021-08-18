import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/setting_repository.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/params.dart';

class CacheDefaultSettingUsecase
    extends NoFailureUsecase<Setting, SettingParams> {
  SettingRepository repository;

  CacheDefaultSettingUsecase({@required this.repository});

  Future<Setting> call(SettingParams params) async {
    return await repository.cacheDefaultSetting(
      params.languageCode,
      params.countryCode,
      params.turnOn,
    );
  }
}
