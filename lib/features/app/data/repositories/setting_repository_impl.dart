import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/data/datasources/local_setting_datasource.dart';
import 'package:my_camera_app_demo/features/app/data/models/setting_model.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';
import 'package:my_camera_app_demo/features/app/domain/repositories/setting_repository.dart';

class SettingRepositoryImplementation implements SettingRepository {
  final LocalSettingDataSource dataSource;

  SettingRepositoryImplementation({@required this.dataSource});

  Future<Setting> changeLanguague(
    String languageCode,
    String countryCode,
  ) async {
    Setting oldSetting = await getCachedSetting();
    SettingModel newSetting = SettingModel(
        currentCountryCode: countryCode,
        currentLanguageCode: languageCode,
        isDarkModeOn: oldSetting.isDarkModeOn);
    await dataSource.cachedSetting(Constants.cacheSettingKey, newSetting);
    return newSetting;
  }

  Future<Setting> changeDarkMode(bool turnOn) async {
    Setting oldSetting = await getCachedSetting();
    SettingModel newSetting = SettingModel(
        currentCountryCode: oldSetting.currentCountryCode,
        currentLanguageCode: oldSetting.currentLanguageCode,
        isDarkModeOn: turnOn);
    await dataSource.cachedSetting(Constants.cacheSettingKey, newSetting);
    return newSetting;
  }

  Future<bool> clearSetting() async {
    try {
      return await dataSource.clearSetting();
    } catch (error, stack) {
      print("$error $stack");
      return false;
    }
  }

  Future<Setting> getCachedSetting() async {
    try {
      return await dataSource.getCachedSetting(Constants.cacheSettingKey);
    } on CacheException {
      return await dataSource.getCachedSetting(
        Constants.cacheDefaultSettingKey,
      );
    }
  }

  Future<Setting> cacheDefaultSetting(
    String languageCode,
    String countryCode,
    bool turnOn,
  ) async {
    SettingModel setting = SettingModel(
      currentCountryCode: countryCode,
      currentLanguageCode: languageCode,
      isDarkModeOn: turnOn,
    );
    await dataSource.cachedSetting(Constants.cacheDefaultSettingKey, setting);
    return setting;
  }
}
