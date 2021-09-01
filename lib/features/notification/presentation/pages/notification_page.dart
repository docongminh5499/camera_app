import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/notification.dart';
import 'package:my_camera_app_demo/features/notification/presentation/bloc/notification_page_bloc/notification_page_bloc.dart';
import 'package:my_camera_app_demo/features/notification/presentation/widgets/loading_item.dart';
import 'package:my_camera_app_demo/features/notification/presentation/widgets/notification_item.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class NotificationPage extends StatefulWidget {
  final Color themeColor;
  final Function parentRefresh;
  NotificationPage({
    Key key,
    @required this.themeColor,
    @required this.parentRefresh,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationPageBloc bloc;
  bool firstMount;
  bool endOfList;
  bool refreshing;
  double scrollThreshold;
  List<NotificationEntity> items;
  ScrollController controller;
  ScrollPhysics physics;

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  void firstLoading() {
    bloc.add(NotificationLoadingEvent(
      jwt: getAppBlocState().currentUser.jwt,
      limit: Constants.limitNotificationPerRequest,
      skip: items.length,
    ));
  }

  Future<void> onRefreshNotification() async {
    refreshing = true;
    bloc.add(NotificationRefreshEvent(
      jwt: getAppBlocState().currentUser.jwt,
      limit: Constants.limitNotificationPerRequest,
      skip: 0,
    ));
    while (refreshing) {
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void onScrollEnd() {
    final extentAfter = controller.position.extentAfter;
    if (extentAfter < scrollThreshold && !endOfList) {
      bloc.add(NotificationContinueEvent(
        jwt: getAppBlocState().currentUser.jwt,
        limit: Constants.limitNotificationPerRequest,
        skip: items.length,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = sl<NotificationPageBloc>();
    firstMount = true;
    endOfList = false;
    refreshing = false;
    scrollThreshold = 20.0;
    items = [];
    controller = new ScrollController();
    physics = ClampingScrollPhysics();
    controller.addListener(onScrollEnd);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstMount) {
      firstLoading();
      firstMount = false;
    }
  }

  @override
  void dispose() {
    controller.removeListener(onScrollEnd);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => bloc,
      child: DecorateTitleScaffold(
        color: widget.themeColor,
        title: localizations.translate('notificationTitle'),
        body: Padding(
          padding: EdgeInsets.only(top: 50),
          child: BlocListener(
            bloc: bloc,
            listener: (context, state) {
              if (state is NotificationPageSuccess) {
                items = state.items;
                endOfList = state.endOfList;
              } else if (state is NotificationPageContinueSuccess) {
                items.addAll(state.items);
                endOfList = state.endOfList;
              } else if (state is NotificationPageRefreshSuccess) {
                refreshing = false;
                items = state.items;
                endOfList = state.endOfList;
                widget.parentRefresh();
              } else if (state is NotificationPageRefreshError) {
                refreshing = false;
              }
            },
            child: BlocBuilder<NotificationPageBloc, NotificationPageState>(
              builder: (context, state) {
                if (state is NotificationPageLoading) {
                  return Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  );
                } else if (state is NotificationPageError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('getNotificationError'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            widget.themeColor,
                          ),
                        ),
                        onPressed: firstLoading,
                        child: Text(localizations.translate('tryAgain')),
                      ),
                    ],
                  );
                }

                if (items.isEmpty) {
                  return Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('notificationEmpty'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: onRefreshNotification,
                  child: ListView.builder(
                    physics: physics,
                    controller: controller,
                    itemCount: endOfList ? items.length : items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == items.length)
                        return NotificationLoadingWidget(
                          themeColor: widget.themeColor,
                        );
                      return NotificationItem(
                        key: ValueKey(items[index].id),
                        data: items[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
