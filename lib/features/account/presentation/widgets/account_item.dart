import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/presentation/pages/modify_account.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';

class AccountItem extends StatefulWidget {
  final Account account;
  final Function removeAccount;
  final Function updateParentPage;
  final Color themeColor;

  const AccountItem({
    Key key,
    @required this.account,
    @required this.removeAccount,
    @required this.themeColor,
    @required this.updateParentPage,
  }) : super(key: key);

  @override
  _AccountItemState createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.account.username,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.account.admin
                        ? localizations.translate('admin')
                        : localizations.translate('user'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            PopupMenuButton(
              color: getAppBlocState().setting.isDarkModeOn
                  ? Colors.grey[850]
                  : Colors.grey[50],
              icon: Icon(
                Icons.more_vert,
                size: 24,
                color: getAppBlocState().setting.isDarkModeOn
                    ? Colors.white
                    : Colors.grey[800],
              ),
              itemBuilder: (context) => ([
                PopupMenuItem(
                    child: Row(children: <Widget>[
                      Icon(Icons.create, color: Colors.blue),
                      Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            localizations.translate('modify'),
                          ))
                    ]),
                    value: 0),
                PopupMenuItem(
                    child: Row(children: <Widget>[
                      Icon(Icons.delete_sweep, color: Colors.red),
                      Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            localizations.translate('delete'),
                          ))
                    ]),
                    value: 1),
              ]),
              onSelected: (int value) {
                switch (value) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModifyAccountPage(
                          themeColor: widget.themeColor,
                          updateParent: widget.updateParentPage,
                          account: widget.account,
                        ),
                      ),
                    );
                    break;
                  case 1:
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            localizations.translate(
                              'confirmRemoveAccount',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                localizations.translate('ok'),
                                style: TextStyle(
                                  color: getAppBlocState().setting.isDarkModeOn
                                      ? Color(0xFFBB6122)
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () {
                                widget.removeAccount(widget.account.id);
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                localizations.translate('cancel'),
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
                    break;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
