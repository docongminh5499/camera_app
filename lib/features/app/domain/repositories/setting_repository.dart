import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';

abstract class SettingRepository {
  Future<Setting> changeLanguage(String languageCode, String countryCode);

  Future<Setting> changeDarkMode(bool turnOn);

  Future<bool> clearSetting();

  Future<Setting> getCachedSetting();

  Future<Setting> cacheDefaultSetting(
    String languageCode,
    String countryCode,
    bool turnOn,
  );
}
