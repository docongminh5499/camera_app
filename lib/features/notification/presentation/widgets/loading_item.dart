import 'package:flutter/material.dart';

class NotificationLoadingWidget extends StatelessWidget {
  final Color themeColor;
  const NotificationLoadingWidget({
    @required this.themeColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
          ),
        ],
      ),
    );
  }
}
