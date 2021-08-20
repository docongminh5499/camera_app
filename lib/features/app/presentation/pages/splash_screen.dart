import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/app/presentation/widgets/loading.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool firstMount = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstMount) {
      Future.delayed(Duration(seconds: 1), () {
        BlocProvider.of<AppBloc>(context).add(LoadingEvent());
        firstMount = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    Constants.localizations = localizations;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Text(
                    Constants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.yellow, Colors.pink],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds),
                    child: Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 60.0,
                    ),
                  ),
                ],
              ),
            ),
            Flex(
              direction: Axis.vertical,
              children: [
                Loading(),
                SizedBox(height: 50),
              ],
            ),
            Text(
              localizations.translate('powerBy'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 14,
              ),
            ),
            Text(
              localizations.translate("flutter"),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
