import 'package:flutter/material.dart';
import 'dart:ui';

class LoginPainter extends CustomPainter {
  final bool darkmode;
  LoginPainter({
    Listenable repaint,
    @required this.darkmode,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    paint.shader = LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        darkmode ? Colors.brown[300] : Colors.orange[300],
        darkmode ? Colors.brown[800] : Colors.orange[800],
      ],
    ).createShader(Rect.fromLTWH(0, 0, width, height));

    Path curve = Path();
    curve.lineTo(0, height * 0.4);

    curve.quadraticBezierTo(
      width * 0.05,
      height * 0.35,
      width * 0.3,
      height * 0.35,
    );

    curve.lineTo(
      width * 0.7,
      height * 0.35,
    );

    curve.quadraticBezierTo(
      width * 0.95,
      height * 0.35,
      width,
      height * 0.4,
    );
    curve.lineTo(width, 0);
    curve.close();
    canvas.drawPath(curve, paint);

    Paint paintCircle = Paint();
    paintCircle.color = Colors.white10;
    canvas.drawCircle(
      Offset(width * 0.8, height * 0.1),
      width * 0.15,
      paintCircle,
    );
    paintCircle.color = Colors.white12;
    canvas.drawCircle(
      Offset(width * 0.15, height * 0.25),
      width * 0.1,
      paintCircle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class DecoratedLoginContainer extends StatelessWidget {
  final Widget body;
  final bool darkmode;
  const DecoratedLoginContainer({
    Key key,
    this.body,
    this.darkmode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Theme.of(context).canvasColor),
        child: CustomPaint(
          painter: LoginPainter(darkmode: darkmode),
          child: body,
        ),
      ),
    );
  }
}
