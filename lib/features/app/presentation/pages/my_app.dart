import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/home/pages/home_page.dart';
import 'package:my_camera_app_demo/features/login/pages/login.dart';
import 'package:my_camera_app_demo/features/app/presentation/pages/splash_screen.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppBloc bloc = sl<AppBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) {
          Widget home;
          bool darkModeOn;

          if (state is LoadingState) {
            darkModeOn = Constants.defaultDarkmodeOn;
            home = SplashScreen();
          } else if (state is UnLoginState) {
            darkModeOn = state.setting.isDarkModeOn;
            Constants.navigatorKey.currentState.popUntil((route) {
              return route.isFirst;
            });
            home = LoginPage();
          } else if (state is LoggedInState) {
            darkModeOn = state.setting.isDarkModeOn;
            home = HomePage();
          }

          return MaterialApp(
            navigatorKey: Constants.navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: Constants.locales.map((item) => item['locale']),
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) locale = Localizations.localeOf(context);
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  bloc.add(CacheDefaultSettingEvent(
                      locale: supportedLocale,
                      isDarkOn: Constants.defaultDarkmodeOn));
                  return supportedLocale;
                }
              }
              bloc.add(CacheDefaultSettingEvent(
                  locale: supportedLocales.first,
                  isDarkOn: Constants.defaultDarkmodeOn));
              return supportedLocales.first;
            },
            theme: ThemeData(
              primarySwatch: darkModeOn ? Colors.brown : Colors.deepOrange,
              accentColor: Colors.brown,
              fontFamily: Constants.googleSansFamily,
              primaryColor: darkModeOn ? Colors.brown : Colors.deepOrange[400],
              disabledColor: Colors.grey,
              cardColor: darkModeOn ? Colors.black : Colors.white,
              canvasColor: darkModeOn ? Colors.grey[900] : Colors.grey[50],
              brightness: darkModeOn ? Brightness.dark : Brightness.light,
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  colorScheme:
                      darkModeOn ? ColorScheme.dark() : ColorScheme.light()),
              appBarTheme: AppBarTheme(
                elevation: 0.0,
              ),
            ),
            home: home,
          );
        },
      ),
    );
  }
}
