import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  FadeWidget({
    @required this.duration,
    this.delay,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  _FadeWidgetState createState() => _FadeWidgetState();
}

class _FadeWidgetState extends State<FadeWidget> {
  bool visible = false;
  bool firstMount = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstMount) {
      if (widget.delay == null)
        this.setState(() {
          visible = true;
          firstMount = false;
        });
      else {
        Future.delayed(widget.delay, () {
          this.setState(() {
            visible = true;
            firstMount = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: widget.duration,
      child: widget.child,
    );
  }
}
