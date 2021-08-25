import 'package:flutter/material.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:sqflite/sqflite.dart';

class Constants {
  static String userRole = "USER";
  static String adminRole = "ADMIN";
  static String cacheUserKey = "CACHE_USER_KEY";
  static String cacheSettingKey = "CACHE_SETTING_KEY";
  static String cacheDefaultSettingKey = "CACHE_DEFAULT_SETTING_KEY";
  static String cachedTimeSyncKey = "CACHE_TIME_SYNC_KEY";

  static String appName = "Camera App";
  static bool defaultDarkmodeOn = false;
  static const String googleSansFamily = "GoogleSans";
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static String protocol = "http";
  static String server = "192.168.1.124:3000";
  // static String server = "docongminh-camera-app-server.herokuapp.com";

  static Map<String, String> urls = {
    "login": "$protocol://$server/login",
    "verifyToken": "$protocol://$server/verify-token",
    "getAccount": "$protocol://$server/get-account",
    "addAccount": "$protocol://$server/add-account",
    "modifyAccount": "$protocol://$server/modify-account",
    "removeAccount": "$protocol://$server/remove-account",
    "analysisImage": "$protocol://$server/analysis-image",
    "saveImage": "$protocol://$server/save-image",
  };

  static List<Map<String, dynamic>> locales = [
    {"locale": Locale('en', 'US'), "name": "English"},
    {"locale": Locale('vi', 'VN'), "name": "Tiếng việt"},
  ];

  static Database database;
  static int timeoutSecond = 15;
  static AppLocalizations localizations;
}
