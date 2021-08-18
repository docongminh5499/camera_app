import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/setting_repository.dart';
import 'package:my_camera_app_demo/features/app/domain/usecases/params.dart';

class ChangeDarkModeUsecase extends NoFailureUsecase<Setting, DarkModeParams> {
  SettingRepository repository;

  ChangeDarkModeUsecase({@required this.repository});

  Future<Setting> call(DarkModeParams params) async {
    return await repository.changeDarkMode(params.turnOn);
  }
}
