import 'package:flutter/material.dart';
import 'dart:math' as math;

class HalfCircle extends StatelessWidget {
  final double diameter;
  final bool left;
  final Color color;
  const HalfCircle({
    Key key,
    this.diameter = 200,
    this.left = true,
    this.color = Colors.blueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(
        color: color,
        left: left,
      ),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  final Color color;
  final bool left;
  MyPainter({
    this.color,
    this.left,
  });
  @override
  void paint(Canvas canvas, Size size) {
    double xcenter = left ? 0 : size.width;
    double startAngle = left ? math.pi / 2 * 3 : math.pi / 2;
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(xcenter, size.height / 2),
        height: size.height,
        width: size.width,
      ),
      startAngle,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
