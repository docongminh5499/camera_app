import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/util_function.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/notification.dart';

class NotificationItem extends StatefulWidget {
  final NotificationEntity data;
  NotificationItem({
    @required this.data,
    Key key,
  }) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  void onTapHandler() {}

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  Color getHightlightColor() {
    if (getAppBlocState().setting.isDarkModeOn) return Colors.white10;
    return Colors.black12;
  }

  String getTitleString() {
    AppLocalizations localizations = AppLocalizations.of(context);
    return widget.data.senderUsername +
        ' ' +
        localizations.translate('sendYou');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapHandler,
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTitleString(),
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  widget.data.message,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                Utils.getTimeString(widget.data.sendTime),
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
