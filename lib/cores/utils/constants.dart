import 'package:flutter/material.dart';

class Constants {
  static String userRole = "USER";
  static String adminRole = "ADMIN";
  static String cacheUserKey = "CACHE_USER_KEY";
  static String cacheSettingKey = "CACHE_SETTING_KEY";
  static String cacheDefaultSettingKey = "CACHE_DEFAULT_SETTING_KEY";

  static String appName = "Camera App";
  static bool defaultDarkmodeOn = false;
  static const String googleSansFamily = "GoogleSans";
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static String protocol = "http";
  static String host = "192.168.1.123";
  static String port = "3000";

  static Map<String, String> urls = {
    "login": "$protocol://$host:$port/login",
    "verifyToken": "$protocol://$host:$port/verify-token",
    "getAccount": "$protocol://$host:$port/get-account",
    "addAccount": "$protocol://$host:$port/add-account",
    "modifyAccount": "$protocol://$host:$port/modify-account",
    "removeAccount": "$protocol://$host:$port/remove-account",
    "analysisImage": "$protocol://$host:$port/analysis-image"
  };

  static List<Map<String, dynamic>> locales = [
    {"locale": Locale('en', 'US'), "name": "English"},
    {"locale": Locale('vi', 'VN'), "name": "Tiếng việt"},
  ];
}
