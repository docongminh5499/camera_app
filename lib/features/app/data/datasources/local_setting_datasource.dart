import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/data/models/setting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalSettingDataSource {
  Future<bool> clearSetting();
  Future<SettingModel> getCachedSetting(String key);
  Future<bool> cachedSetting(String key, SettingModel settingModel);
}

class LocalSettingDataSourceImplementation implements LocalSettingDataSource {
  final SharedPreferences preferences;

  LocalSettingDataSourceImplementation({@required this.preferences});

  Future<bool> clearSetting() {
    return preferences.remove(Constants.cacheSettingKey);
  }

  Future<SettingModel> getCachedSetting(String key) async {
    final setting = preferences.getString(key);
    if (setting != null) return SettingModel.fromJson(json.decode(setting));
    throw CacheException();
  }

  Future<bool> cachedSetting(String key, SettingModel model) {
    return preferences.setString(key, json.encode(model.toJson()));
  }
}
