import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
        size.centerLeft(Offset.zero), size.centerRight(Offset.zero), paint);

    paint.color = color;

    canvas.drawLine(
        size.centerLeft(Offset.zero),
        size.centerLeft(Offset.zero) +
            (size.centerRight(Offset.zero) - size.centerLeft(Offset.zero)) *
                (1.0 - animation.value),
        paint);

    paint.color = color;
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
