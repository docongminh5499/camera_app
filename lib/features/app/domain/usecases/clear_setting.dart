import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/setting_repository.dart';

class ClearSettingUsecase extends NoFailureUsecase<bool, NoParams> {
  SettingRepository repository;

  ClearSettingUsecase({@required this.repository});

  Future<bool> call(NoParams params) async {
    return await repository.clearSetting();
  }
}
