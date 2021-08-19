import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  final BuildContext context;
  final Color color;

  MyCustomPainter({
    Listenable repaint,
    @required this.context,
    this.color,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    final inflectionWidth = 0.5 * width;
    final inflectionHeight = 0.1 * height;

    Path curve = Path();
    curve.quadraticBezierTo(inflectionWidth, inflectionHeight, width, 0);
    curve.close();
    if (color == null)
      paint.color = Theme.of(context).primaryColor;
    else
      paint.color = color;
    canvas.drawPath(curve, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class DecorateTitleScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Color color;
  const DecorateTitleScaffold({Key key, this.title, this.body, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            backgroundColor: color,
          ),
          body: CustomPaint(
            painter: MyCustomPainter(context: context, color: color),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
