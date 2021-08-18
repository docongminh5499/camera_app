import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/login/bloc/login_bloc.dart';
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
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.setState(() {
        _opacity = 1;
      });
    });
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

    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          minimum: EdgeInsets.all(15),
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(seconds: 1),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          localizations.translate("signIn"),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 50),
                        Padding(
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
                        Padding(
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
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (BuildContext context, LoginState state) {
                        if (state is NormalState) {
                          return Column(
                            children: [
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () => login(),
                                child: Text(localizations.translate("signIn")),
                              )
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
                              ElevatedButton(
                                onPressed: () => login(),
                                child: Text(localizations.translate("signIn")),
                              )
                            ],
                          );
                        }
                        successLogin();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
