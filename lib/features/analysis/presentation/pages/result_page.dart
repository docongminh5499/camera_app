import 'package:flutter/material.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';

class ResultPage extends StatelessWidget {
  final Color themeColor;
  const ResultPage({Key key, this.themeColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Constants.localizations;

    return DecorateTitleScaffold(
      color: themeColor,
      title: localizations.translate('result'),
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(localizations.translate('analysisSuccess'))],
      ),
    );
  }
}
