import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';

class SettingPage extends StatefulWidget {
  final Color themeColor;
  final Function logout;
  SettingPage({Key key, this.themeColor, this.logout}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppBloc getCurrentBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getCurrentBlocState() {
    AppBloc bloc = getCurrentBloc();
    return bloc.state;
  }

  void toggleDarkmode() {
    bool currentDarkMode = getCurrentBlocState().setting.isDarkModeOn;
    getCurrentBloc().add(ChangeDarkModeEvent(turnOn: !currentDarkMode));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Constants.localizations;
    Locale locale = localizations.currentLocale;

    Map<String, dynamic> currentLanguage = Constants.locales.firstWhere(
        (element) =>
            locale.countryCode == element['locale'].countryCode &&
            locale.languageCode == element['locale'].languageCode);
    String language = currentLanguage['name'];

    return DecorateTitleScaffold(
      color: widget.themeColor,
      title: localizations.translate('setting'),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(15),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.language,
                    size: 35,
                    color: Colors.grey[700],
                  ),
                  SizedBox(width: 15),
                  Text(
                    localizations.translate('language'),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 15),
                  DropdownButton<String>(
                    dropdownColor: getCurrentBlocState().setting.isDarkModeOn
                        ? Colors.grey[850]
                        : Colors.grey[50],
                    value: language,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: getCurrentBlocState().setting.isDarkModeOn
                          ? Colors.white
                          : Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      Map<String, dynamic> chooseLanguage = Constants.locales
                          .firstWhere((element) => element['name'] == newValue);
                      localizations.load(chooseLanguage['locale']);
                      getCurrentBloc().add(ChangeLanguageEvent(
                        languageCode: chooseLanguage['locale'].languageCode,
                        countryCode: chooseLanguage['locale'].countryCode,
                      ));
                    },
                    items: Constants.locales
                        .map<DropdownMenuItem<String>>(
                          (element) => DropdownMenuItem<String>(
                            value: element['name'],
                            child: Text(
                              element['name'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: toggleDarkmode,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outlined,
                        size: 35,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              localizations.translate('darkMode'),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: widget.logout,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 35,
                        color: Colors.red,
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              localizations.translate('signOut'),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
