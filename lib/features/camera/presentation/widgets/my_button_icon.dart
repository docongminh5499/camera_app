import 'package:flutter/material.dart';

class MyButtonIcon extends StatefulWidget {
  final Function onPress;
  final IconData icon;
  final double iconSize;

  MyButtonIcon({
    Key key,
    @required this.onPress,
    @required this.icon,
    @required this.iconSize,
  }) : super(key: key);

  @override
  _MyButtonIconState createState() => _MyButtonIconState();
}

class _MyButtonIconState extends State<MyButtonIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _sizeAnimation;
  final double speed = 0.05;
  final double scaleRatio = 0.7;

  @override
  void initState() {
    super.initState();

    int duration = (widget.iconSize * (1 - scaleRatio) ~/ speed);
    _controller = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );
    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween:
              Tween(begin: widget.iconSize, end: widget.iconSize * scaleRatio),
          weight: 50),
      TweenSequenceItem<double>(
          tween:
              Tween(begin: widget.iconSize * scaleRatio, end: widget.iconSize),
          weight: 50)
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onPress() {
    _controller.reset();
    _controller.forward();
    widget.onPress();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 12.0;
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.iconSize + padding * 2,
        minWidth: widget.iconSize + padding * 2,
      ),
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(999)),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            iconSize: _sizeAnimation.value,
            padding: EdgeInsets.all(padding),
            onPressed: onPress,
            icon: Icon(
              widget.icon,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}
