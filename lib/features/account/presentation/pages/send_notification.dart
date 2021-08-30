import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/account/domain/entities/account.dart';
import 'package:my_camera_app_demo/features/account/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class SendNotificationPage extends StatefulWidget {
  final Color themeColor;
  final Account receiver;
  SendNotificationPage({
    Key key,
    @required this.themeColor,
    @required this.receiver,
  }) : super(key: key);

  @override
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  NotificationBloc bloc;
  TextEditingController controller;
  FocusNode contentFocusNode;
  String content;
  Color currentColor;

  @override
  void initState() {
    super.initState();
    bloc = sl<NotificationBloc>();
    controller = TextEditingController();
    content = "";
    contentFocusNode = FocusNode();
    currentColor = Colors.grey;

    contentFocusNode.addListener(() {
      if (currentColor == Colors.grey)
        currentColor = widget.themeColor;
      else
        currentColor = Colors.grey;
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  void sendNotification() {
    bloc.add(NotificationSendEvent(
      jwt: getAppBlocState().currentUser.jwt,
      receiverId: widget.receiver.id,
      message: content,
    ));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: DecorateTitleScaffold(
        color: widget.themeColor,
        title: localizations.translate('notification'),
        body: Column(
          children: [
            SizedBox(height: 80),
            Text(
              localizations.translate('notification'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.translate('receiver') + ": ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  widget.receiver.username,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              localizations.translate('content'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: widget.themeColor,
                  selectionColor: widget.themeColor,
                  selectionHandleColor: widget.themeColor,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  focusNode: contentFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: currentColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  controller: controller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (changedText) {
                    this.setState(() {
                      content = changedText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            BlocListener(
              bloc: bloc,
              listener: (BuildContext context, NotificationState state) {
                if (state is NotificationSuccess) {
                  Navigator.of(context).pop();
                }
              },
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationInitial) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          widget.themeColor,
                        ),
                      ),
                      onPressed: sendNotification,
                      child: Text(localizations.translate('notification')),
                    );
                  } else if (state is NotificationError) {
                    return Column(
                      children: [
                        Text(
                          localizations.translate('sendNotificationError'),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              widget.themeColor,
                            ),
                          ),
                          onPressed: sendNotification,
                          child: Text(localizations.translate('notification')),
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
                        color: widget.themeColor,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
