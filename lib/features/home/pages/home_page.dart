import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/account/presentation/pages/account_page.dart';
import 'package:my_camera_app_demo/features/analysis/presentation/pages/analysis_page.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/camera/presentation/pages/camera_page.dart';
import 'package:my_camera_app_demo/features/home/bloc/home_bloc.dart';
import 'package:my_camera_app_demo/features/home/widgets/my_container.dart';
import 'package:my_camera_app_demo/features/setting/pages/setting.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc bloc = sl<HomeBloc>();

  void logout() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    bloc.add(PrepareLogoutEvent());
  }

  AppBloc getCurrentBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getCurrentBlocState() {
    AppBloc bloc = getCurrentBloc();
    return bloc.state;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    Constants.localizations = localizations;
    
    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: DecorateTitleScaffold(
        title: localizations.translate('homeTitle'),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, HomeState state) {
            if (state is PrepareLogoutState) {
              Future.microtask(() {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ),
                    );
                  },
                );
              });
            }
            return Column(
              children: [
                Text(
                  localizations.translate("hi") +
                      ", " +
                      getCurrentBlocState().currentUser.username,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 50),
                getCurrentBlocState().currentUser.isAdmin()
                    ? MyContainer(
                        subText: localizations.translate('subTextAccount'),
                        text: localizations.translate("account"),
                        color: getCurrentBlocState().setting.isDarkModeOn
                            ? Color(0xFF215E6C)
                            : Color(0xFF4CC181),
                        icon: Icons.account_box,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountPage(
                              themeColor:
                                  getCurrentBlocState().setting.isDarkModeOn
                                      ? Color(0xFF215E6C)
                                      : Color(0xFF4CC181),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                MyContainer(
                  subText: localizations.translate('subTextCamera'),
                  text: localizations.translate("camera"),
                  color: getCurrentBlocState().setting.isDarkModeOn
                      ? Color(0xFFA61D24)
                      : Color(0xFFFD4140),
                  icon: Icons.camera_alt,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  ),
                ),
                MyContainer(
                  subText: localizations.translate('subTextAnalysis'),
                  text: localizations.translate("analysis"),
                  color: getCurrentBlocState().setting.isDarkModeOn
                      ? Color(0xFF6C3C14)
                      : Color(0xFFE5924A),
                  icon: Icons.analytics,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalysisPage(
                        themeColor: getCurrentBlocState().setting.isDarkModeOn
                            ? Color(0xFF6C3C14)
                            : Color(0xFFE5924A),
                      ),
                    ),
                  ),
                ),
                MyContainer(
                  subText: localizations.translate('subTextSetting'),
                  text: localizations.translate("setting"),
                  color: getCurrentBlocState().setting.isDarkModeOn
                      ? Color(0xFF4B5094)
                      : Color(0xFF25ADC5),
                  icon: Icons.settings,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(
                        logout: logout,
                        themeColor: getCurrentBlocState().setting.isDarkModeOn
                            ? Color(0xFF4B5094)
                            : Color(0xFF25ADC5),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
