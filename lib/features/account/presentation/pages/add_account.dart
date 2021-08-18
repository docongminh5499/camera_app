import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/account/presentation/bloc/account_bloc.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class AddAccountPage extends StatefulWidget {
  final Color themeColor;
  final Function updateParent;

  AddAccountPage({
    Key key,
    this.themeColor,
    this.updateParent,
  }) : super(key: key);

  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  bool admin = false;
  String username = '';
  String password = '';
  String confirmPassword = '';
  AccountBloc bloc;
  String errorMessage = '';

  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  FocusNode _usernameFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _confirmPasswordFocusNode;

  Color currentUsernameColor;
  Color currentPasswordColor;
  Color currentConfirmPasswordColor;

  void onAddAccountHandler() {
    this.setState(() {
      errorMessage = "";
    });

    AppLocalizations localizations = AppLocalizations.of(context);

    if (username.length == 0 ||
        password.length == 0 ||
        confirmPassword.length == 0) {
      return this.setState(() {
        errorMessage = localizations.translate('requireError');
      });
    }

    if (password != confirmPassword) {
      return this.setState(() {
        errorMessage = localizations.translate('confirmPasswordError');
      });
    }

    bloc.add(CreateAccountEvent(
      jwt: getAppBlocState().currentUser.jwt,
      username: username,
      password: password,
      admin: admin,
      localizations: localizations,
    ));
  }

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    _usernameFocusNode.addListener(() {
      if (currentUsernameColor == Colors.grey)
        currentUsernameColor = widget.themeColor;
      else
        currentUsernameColor = Colors.grey;
      this.setState(() {});
    });
    _passwordFocusNode.addListener(() {
      if (currentPasswordColor == Colors.grey)
        currentPasswordColor = widget.themeColor;
      else
        currentPasswordColor = Colors.grey;
      this.setState(() {});
    });
    _confirmPasswordFocusNode.addListener(() {
      if (currentConfirmPasswordColor == Colors.grey)
        currentConfirmPasswordColor = widget.themeColor;
      else
        currentConfirmPasswordColor = Colors.grey;
      this.setState(() {});
    });
    currentUsernameColor = Colors.grey;
    currentPasswordColor = Colors.grey;
    currentConfirmPasswordColor = Colors.grey;
    bloc = sl<AccountBloc>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return DecorateTitleScaffold(
      color: widget.themeColor,
      title: localizations.translate('addAccount'),
      body: Column(
        children: [
          SizedBox(height: 70),
          Text(
            localizations.translate('accountInfo'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: widget.themeColor,
                      selectionColor: widget.themeColor,
                      selectionHandleColor: widget.themeColor,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      focusNode: _usernameFocusNode,
                      autocorrect: false,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: currentUsernameColor,
                            width: 2.0,
                          ),
                        ),
                        labelText: localizations.translate('username'),
                        labelStyle: TextStyle(color: currentUsernameColor),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: currentUsernameColor,
                        ),
                      ),
                      onChanged: (value) {
                        username = value;
                      },
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: widget.themeColor,
                      selectionColor: widget.themeColor,
                      selectionHandleColor: widget.themeColor,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: currentPasswordColor,
                            width: 2.0,
                          ),
                        ),
                        labelText: localizations.translate('password'),
                        labelStyle: TextStyle(color: currentPasswordColor),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: currentPasswordColor,
                        ),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: widget.themeColor,
                      selectionColor: widget.themeColor,
                      selectionHandleColor: Colors.blue,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      focusNode: _confirmPasswordFocusNode,
                      controller: _confirmPasswordController,
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusColor: Colors.red,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: currentConfirmPasswordColor,
                            width: 2.0,
                          ),
                        ),
                        labelText: localizations.translate('confirmPassword'),
                        labelStyle:
                            TextStyle(color: currentConfirmPasswordColor),
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: currentConfirmPasswordColor,
                        ),
                      ),
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(localizations.translate('admin')),
                //     Switch(
                //       onChanged: (value) {
                //         this.setState(() {
                //           admin = value;
                //         });
                //       },
                //       value: admin,
                //       activeColor: Colors.grey[100],
                //       activeTrackColor: widget.themeColor,
                //       inactiveThumbColor: Colors.grey[100],
                //       inactiveTrackColor: Colors.grey[700],
                //     ),
                //   ],
                // ),
                SizedBox(height: 10),
                BlocListener(
                  bloc: bloc,
                  listener: (context, state) {
                    if (state is SuccessCreateAccount) {
                      Future.delayed(Duration(milliseconds: 200), () {
                        Navigator.of(context).pop();
                        widget.updateParent();
                      });
                    }
                  },
                  child: BlocProvider(
                    create: (BuildContext context) => bloc,
                    child: BlocBuilder<AccountBloc, AccountState>(
                        builder: (BuildContext context, AccountState state) {
                      if (state is ErrorCreateAccount) {
                        return Column(
                          children: [
                            Text(state.message, textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: onAddAccountHandler,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  widget.themeColor,
                                ),
                              ),
                              child:
                                  Text(localizations.translate('addAccount')),
                            )
                          ],
                        );
                      } else if (state is SuccessCreateAccount) {
                        return Column(
                          children: [
                            SizedBox(height: 30),
                            Icon(
                              Icons.check_circle,
                              size: 40,
                              color: widget.themeColor,
                            ),
                          ],
                        );
                      } else if (state is CreatingAccount) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.themeColor,
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Text(errorMessage, textAlign: TextAlign.center),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: onAddAccountHandler,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                widget.themeColor,
                              ),
                            ),
                            child: Text(localizations.translate('addAccount')),
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
