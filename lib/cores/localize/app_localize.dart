import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';

class AppLocalizations {
  Locale currentLocale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
  Map<String, String> _localizedString;

  Future<bool> load(Locale locale) async {
    if (currentLocale != null &&
        locale.countryCode == currentLocale.countryCode &&
        locale.languageCode == currentLocale.languageCode) return true;

    String path = 'assets/lang/${locale.languageCode}.json';
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedString = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    currentLocale = locale;
    return true;
  }

  String translate(String key) {
    return _localizedString[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    List<dynamic> supportedLanguageCode = Constants.locales.map((item) {
      return item['locale'].languageCode;
    }).toList();
    return supportedLanguageCode.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations();
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
