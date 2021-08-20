import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/widgets/fade_widget.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/login/bloc/login_bloc.dart';
import 'package:my_camera_app_demo/features/login/widgets/login_painter.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  LoginBloc bloc = sl<LoginBloc>();
  String username;
  String password;

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  UnLoginState getCurrentBlocState() {
    AppBloc bloc = BlocProvider.of<AppBloc>(context);
    return bloc.state;
  }

  void successLogin() {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    SuccessLoginState successState = bloc.state;
    appBloc.add(LoginSuccessfulEvent(user: successState.user));
  }

  void login() {
    bloc.add(RemoteLoginEvent(username: username, password: password));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);
    bool darkmode = getCurrentBlocState().setting.isDarkModeOn;

    return DecoratedLoginContainer(
      darkmode: darkmode,
      body: BlocProvider(
        create: (BuildContext context) => bloc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeWidget(
                    delay: Duration(milliseconds: 250),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      localizations.translate("signIn"),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeWidget(
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      localizations.translate("welcomeBack"),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeWidget(
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autocorrect: false,
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: localizations.translate('username'),
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        onChanged: (value) {
                          username = value;
                        },
                      ),
                    ),
                  ),
                  FadeWidget(
                    delay: Duration(milliseconds: 700),
                    duration: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: passwordController,
                        autocorrect: false,
                        enableSuggestions: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: localizations.translate('password'),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: BlocListener(
                bloc: bloc,
                listener: (context, state) {
                  if (state is SuccessLoginState) {
                    successLogin();
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (BuildContext context, LoginState state) {
                    if (state is NormalState) {
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          FadeWidget(
                            delay: Duration(milliseconds: 900),
                            duration: Duration(milliseconds: 1000),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ElevatedButton(
                                onPressed: () => login(),
                                child: Text(localizations.translate("signIn")),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is LoggingState) {
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      );
                    } else if (state is ErrorLoginState) {
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          Text(
                            localizations.translate('errorSignIn'),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              onPressed: () => login(),
                              child: Text(localizations.translate("signIn")),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(height: 30),
                        Icon(
                          Icons.check_circle,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
