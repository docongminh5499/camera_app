import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/presentation/bloc/account_bloc.dart';
import 'package:my_camera_app_demo/features/account/presentation/pages/add_account.dart';
import 'package:my_camera_app_demo/features/account/presentation/widgets/account_item.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class AccountPage extends StatefulWidget {
  final Color themeColor;
  AccountPage({Key key, this.themeColor}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AccountBloc bloc = sl<AccountBloc>();
  List<Account> accounts;
  bool modelOpen;

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  void fetchAccount() {
    bloc.add(LoadAccountEvent(jwt: getAppBlocState().currentUser.jwt));
  }

  void removeAccount(String id) {
    bloc.add(RemoveAccountEvent(
      jwt: getAppBlocState().currentUser.jwt,
      id: id,
    ));
  }

  void showDialogHandler(dynamic state) {
    AppLocalizations localizations = Constants.localizations;

    if (modelOpen) {
      Navigator.of(context).pop();
      modelOpen = false;
    }
    if (state is RemovingAccount) {
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
      modelOpen = true;
    } else if (state is ErrorRemoveAccount) {
      ErrorRemoveAccount errorState = state;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(errorState.message),
            actions: [
              TextButton(
                child: Text(
                  localizations.translate('close'),
                  style: TextStyle(
                    color: getAppBlocState().setting.isDarkModeOn
                        ? Color(0xFFBB6122)
                        : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (state is SuccessRemoveAccount) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(localizations.translate('removeSuccess')),
            actions: [
              TextButton(
                child: Text(
                  localizations.translate('close'),
                  style: TextStyle(
                    color: getAppBlocState().setting.isDarkModeOn
                        ? Color(0xFFBB6122)
                        : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    modelOpen = false;
    Future.delayed(Duration(milliseconds: 500), fetchAccount);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Constants.localizations;

    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: DecorateTitleScaffold(
        color: widget.themeColor,
        title: localizations.translate('account'),
        body: Column(
          children: [
            SizedBox(height: 50),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(widget.themeColor),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAccountPage(
                    themeColor: widget.themeColor,
                    updateParent: fetchAccount,
                  ),
                ),
              ),
              child: Text(localizations.translate('addAccount')),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: getAppBlocState().setting.isDarkModeOn
                        ? Colors.white
                        : Colors.black87,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                localizations.translate('accountList'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            BlocListener(
              bloc: bloc,
              listener: (BuildContext context, AccountState state) {
                if (!(state is LoadingAccount &&
                    state is ErrorLoadingAccount)) {
                  showDialogHandler(state);
                }
              },
              child: BlocBuilder<AccountBloc, AccountState>(
                builder: (BuildContext context, AccountState state) {
                  if (state is LoadingAccount) {
                    return Expanded(
                      child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.themeColor,
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (state is ErrorLoadingAccount) {
                    return Expanded(
                      child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            localizations.translate('errorLoadAccount'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: fetchAccount,
                            child: Text(localizations.translate('tryAgain')),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                widget.themeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    LoadedAccount currentState = state;
                    accounts = currentState.accounts;

                    if (currentState.accounts.length == 0) {
                      return Expanded(
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              localizations.translate('noAccount'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    List<Widget> accountWidgets = currentState.accounts
                        .map((account) => AccountItem(
                              account: account,
                              removeAccount: removeAccount,
                              themeColor: widget.themeColor,
                              updateParentPage: fetchAccount,
                            ))
                        .toList();

                    return Expanded(
                      child: Container(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(8),
                          children: accountWidgets,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
