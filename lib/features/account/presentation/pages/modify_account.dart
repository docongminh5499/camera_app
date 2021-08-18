import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/presentation/bloc/account_bloc.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class ModifyAccountPage extends StatefulWidget {
  final Color themeColor;
  final Function updateParent;
  final Account account;

  ModifyAccountPage({
    Key key,
    this.themeColor,
    this.updateParent,
    @required this.account,
  }) : super(key: key);

  @override
  _ModifyAccountPageState createState() => _ModifyAccountPageState();
}

class _ModifyAccountPageState extends State<ModifyAccountPage> {
  String errorMessage;
  String username;
  bool admin;
  TextEditingController _usernameController;
  FocusNode _usernameFocusNode;
  Color currentUsernameColor;
  AccountBloc bloc;

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  void onModifyAccount() {
    this.setState(() {
      errorMessage = "";
    });

    AppLocalizations localizations = AppLocalizations.of(context);
    if (username.length == 0) {
      return this.setState(() {
        errorMessage = localizations.translate('requireError');
      });
    }

    bloc.add(ModifyAccountEvent(
      jwt: getAppBlocState().currentUser.jwt,
      username: username,
      admin: admin,
      id: widget.account.id,
      localizations: localizations,
    ));
  }

  @override
  void initState() {
    super.initState();
    username = widget.account.username;
    admin = widget.account.admin;
    errorMessage = '';
    _usernameController = TextEditingController(text: username);
    _usernameFocusNode = FocusNode();
    _usernameFocusNode.addListener(() {
      if (currentUsernameColor == Colors.grey)
        currentUsernameColor = widget.themeColor;
      else
        currentUsernameColor = Colors.grey;
    });
    currentUsernameColor = Colors.grey;
    bloc = sl<AccountBloc>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return DecorateTitleScaffold(
      color: widget.themeColor,
      title: localizations.translate('modifyAccount'),
      body: Column(
        children: [
          SizedBox(height: 70),
          Text(
            localizations.translate('modifyAccount'),
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
                BlocListener(bloc: bloc, listener:  (context, state) {
                  if (state is SuccessModifyAccount) {
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.of(context).pop();
                      widget.updateParent();
                    });
                  }
                }, child: BlocProvider(
                  create: (BuildContext context) => bloc,
                  child: BlocBuilder<AccountBloc, AccountState>(
                      builder: (BuildContext context, AccountState state) {
                        if (state is ErrorModifyAccount) {
                          return Column(
                            children: [
                              Text(state.message, textAlign: TextAlign.center),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: onModifyAccount,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    widget.themeColor,
                                  ),
                                ),
                                child: Text(localizations.translate('save')),
                              )
                            ],
                          );
                        } else if (state is SuccessModifyAccount) {
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
                        } else if (state is ModifyingAccount) {
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
                              onPressed: onModifyAccount,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  widget.themeColor,
                                ),
                              ),
                              child: Text(localizations.translate('save')),
                            )
                          ],
                        );
                      }),
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
