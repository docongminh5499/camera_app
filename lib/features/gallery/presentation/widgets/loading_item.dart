import 'package:flutter/material.dart';

class GalleryLoadingItem extends StatelessWidget {
  final Color themeColor;
  const GalleryLoadingItem({
    @required this.themeColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
      ],
    );
  }
}
