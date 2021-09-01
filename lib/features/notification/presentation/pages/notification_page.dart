import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/notification/presentation/bloc/notification_page_bloc/notification_page_bloc.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class NotificationPage extends StatefulWidget {
  final Color themeColor;
  NotificationPage({
    Key key,
    @required this.themeColor,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationPageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = sl<NotificationPageBloc>();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => bloc,
      child: DecorateTitleScaffold(
        color: widget.themeColor,
        title: localizations.translate('notificationTitle'),
        body: BlocListener(
          bloc: bloc,
          listener: (context, state) {},
          child: BlocBuilder<NotificationPageBloc, NotificationPageState>(
            builder: (context, state) {
              return Text("A");
            },
          ),
        ),
      ),
    );
  }
}
