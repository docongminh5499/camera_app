import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';

class GalleryItem extends StatefulWidget {
  final Picture data;
  final bool chooseMode;
  final Function changeChooseModeFunc;
  final Function addImageFunc;
  final Function removeImageFunc;
  final ChangeNotifier listener;

  const GalleryItem({
    @required this.data,
    @required this.chooseMode,
    @required this.changeChooseModeFunc,
    @required this.addImageFunc,
    @required this.removeImageFunc,
    @required this.listener,
    Key key,
  }) : super(key: key);

  @override
  _GalleryItemState createState() => _GalleryItemState();
}

class _GalleryItemState extends State<GalleryItem> {
  bool selected = false;

  void onLongPressHandler() {
    if (!widget.chooseMode) {
      widget.changeChooseModeFunc(true);
      widget.addImageFunc(widget.data);
      this.setState(() {
        selected = true;
      });
    }
  }

  void onTapHandler() {
    if (widget.chooseMode) {
      if (selected)
        widget.removeImageFunc(widget.data);
      else
        widget.addImageFunc(widget.data);
      this.setState(() {
        selected = !selected;
      });
    }
  }

  void clearData() {
    this.setState(() {
      selected = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.listener.addListener(clearData);
  }

  @override
  void dispose() {
    widget.listener.removeListener(clearData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chooseMode) {
      return GestureDetector(
        onLongPress: onLongPressHandler,
        onTap: onTapHandler,
        child: Stack(
          children: [
            Image.memory(
              base64Decode(widget.data.data),
              gaplessPlayback: true,
            ),
            Positioned(
              child: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.all(Colors.blue),
                value: selected,
                onChanged: (bool value) => onTapHandler(),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onLongPress: onLongPressHandler,
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
