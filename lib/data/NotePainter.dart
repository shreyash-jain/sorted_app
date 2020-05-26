import 'package:flutter/material.dart';
//1
class NotePainter extends CustomPainter {
  //2
  NotePainter({@required this.title});

  //3
  final String title;

  //4
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final textSpan = TextSpan(
      text: 'Hello, world.',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(50, 100);
    textPainter.paint(canvas, offset);


  }

  //5
  @override
  bool shouldRepaint(NotePainter oldDelegate) {
    return title != oldDelegate.title;
  }
}