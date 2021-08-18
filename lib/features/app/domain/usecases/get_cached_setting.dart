import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/setting_repository.dart';

class GetCachedSettingUsecase extends NoFailureUsecase<Setting, NoParams> {
  SettingRepository repository;

  GetCachedSettingUsecase({@required this.repository});

  Future<Setting> call(NoParams params) async {
    return await repository.getCachedSetting();
  }
}
