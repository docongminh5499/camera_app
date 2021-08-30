import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';

class GalleryItem extends StatelessWidget {
  final Picture data;
  const GalleryItem({
    @required this.data,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Image.memory(
        base64Decode(data.data),
        gaplessPlayback: true,
      ),
    );
  }
}
