import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';

class ChooseGalleryItem extends StatefulWidget {
  final Picture data;
  final Function onChoosePicture;

  const ChooseGalleryItem({
    @required this.data,
    @required this.onChoosePicture,
    Key key,
  }) : super(key: key);

  @override
  _ChooseGalleryItemState createState() => _ChooseGalleryItemState();
}

class _ChooseGalleryItemState extends State<ChooseGalleryItem> {
  void onTapHandler() {
    widget.onChoosePicture(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapHandler,
      child: Stack(
        children: [
          Image.memory(
            base64Decode(widget.data.data),
            gaplessPlayback: true,
          ),
        ],
      ),
    );
  }
}
