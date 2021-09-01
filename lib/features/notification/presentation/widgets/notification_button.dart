import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/utils/firebase_handler.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/notification/presentation/bloc/notification_button_bloc/notification_button_bloc.dart';
import 'package:my_camera_app_demo/features/notification/presentation/pages/notification_page.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class NotificationButton extends StatefulWidget {
  final Color themeColor;

  NotificationButton({
    @required this.themeColor,
    Key key,
  }) : super(key: key);

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton>
    with WidgetsBindingObserver {
  FirebaseHandler firebaseHandler;
  NotificationButtonBloc bloc;
  int numberOfNotification;

  void onReceiveNotification() {
    bloc.add(GetUnopenNotificationNumberEvent(
      jwt: gerAppBlocState().currentUser.jwt,
    ));
  }

  String getCurrentNotification() {
    if (numberOfNotification > 9) return "9+";
    return numberOfNotification.toString();
  }

  void onRefreshNotificationPage() {
    print("Update notification button");
    bloc.add(OpenAllNotificationEvent(
      jwt: gerAppBlocState().currentUser.jwt,
    ));
  }

  void onPressButtonHandler() {
    bloc.add(OpenAllNotificationEvent(
      jwt: gerAppBlocState().currentUser.jwt,
    ));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotificationPage(
          themeColor: widget.themeColor,
          parentRefresh: onRefreshNotificationPage,
        ),
      ),
    );
  }

  AppBloc gerAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState gerAppBlocState() {
    AppBloc bloc = gerAppBloc();
    return bloc.state;
  }

  @override
  void initState() {
    super.initState();
    firebaseHandler = sl<FirebaseHandler>();
    bloc = sl<NotificationButtonBloc>();
    numberOfNotification = 0;
    firebaseHandler.addListener(onReceiveNotification);
    WidgetsBinding.instance.addObserver(this);
    onReceiveNotification();
  }

  @override
  void dispose() {
    firebaseHandler.removeListener(onReceiveNotification);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onReceiveNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener(
        bloc: bloc,
        listener: (context, state) {
          if (state is NotificationGetUnopenSuccess) {
            numberOfNotification = state.numberOfNotification;
          } else if (state is NotificationOpenSuccess) {
            numberOfNotification = 0;
          }
        },
        child: BlocBuilder<NotificationButtonBloc, NotificationButtonState>(
          builder: (context, state) {
            if (numberOfNotification == 0) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.circle_notifications),
                    iconSize: 34,
                    tooltip: 'Notification',
                    onPressed: onPressButtonHandler,
                  ),
                ],
              );
            }
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.circle_notifications),
                  iconSize: 34,
                  tooltip: 'Notification',
                  onPressed: onPressButtonHandler,
                ),
                Positioned(
                  right: 2.0,
                  top: 2.0,
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      color: widget.themeColor,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getCurrentNotification(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
