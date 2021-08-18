import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Setting extends Equatable {
  final String currentLanguageCode;
  final String currentCountryCode;
  final bool isDarkModeOn;

  Setting({
    @required this.currentCountryCode,
    @required this.currentLanguageCode,
    @required this.isDarkModeOn,
  });

  @override
  List<Object> get props =>
      <dynamic>[currentLanguageCode, currentCountryCode, isDarkModeOn];
}
