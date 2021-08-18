import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/setting.dart';

class SettingModel extends Setting {
  SettingModel(
      {@required String currentLanguageCode,
      @required String currentCountryCode,
      @required bool isDarkModeOn})
      : super(
            currentLanguageCode: currentLanguageCode,
            currentCountryCode: currentCountryCode,
            isDarkModeOn: isDarkModeOn);

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
        currentLanguageCode: json['currentLanguageCode'],
        currentCountryCode: json['currentCountryCode'],
        isDarkModeOn: json['isDarkModeOn']);
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLanguageCode': currentLanguageCode,
      'currentCountryCode': currentCountryCode,
      'isDarkModeOn': isDarkModeOn,
    };
  }
}
