import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

typedef ProgressChanged<double> = void Function(double value);

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);

class CustomThreeLinearProgressBar extends StatefulWidget {
  final double radius;
  final double progress1;
  final double progress2;
  final double progress3;
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;

  const CustomThreeLinearProgressBar({
    Key key,
    @required this.radius,
    @required this.dotRadius,
    @required this.dotColor,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFF7F7FC),
    this.dotEdgeColor = const Color(0XFFF5F5FA),
    this.progress1,
    this.progress2,
    this.progress3,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CustomThreeLinearProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  bool isValidTouch = false;
  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.radius * 2.0;
    final size = new Size(width, 10);
    return GestureDetector(
      child: Container(
        alignment: FractionalOffset.center,
        child: CustomPaint(
          key: paintKey,
          size: size,
          painter: ProgressPainter(
              dotRadius: widget.dotRadius,
              shadowWidth: widget.shadowWidth,
              shadowColor: widget.shadowColor,
              ringColor: widget.ringColor,
              dotColor: widget.dotColor,
              dotEdgeColor: widget.dotEdgeColor,
              progress1: widget.progress1,
              progress2: widget.progress2,
              progress3: widget.progress3),
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;
  final double progress1;
  final double progress2;
  final double progress3;

  ProgressPainter({
    this.progress3,
    this.dotRadius,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFF7F7FC),
    this.dotColor,
    this.dotEdgeColor = const Color(0XFFF5F5FA),
    this.progress1,
    this.progress2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    final Offset offsetCenter = Offset(center, center);
    final double drawRadius = size.width * 0.5 - dotRadius;

    final double radiusOffset = dotRadius * 0.4;
    final double outerRadius = center - radiusOffset;
    final double innerRadius = center - dotRadius * 2 + radiusOffset;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withAlpha(60)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = (14);
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), ringPaint);

    final Color currentDotColor = Color.alphaBlend(dotColor, dotColor);

    // draw progress.
    if (progress1 > 0.0) {
      final progressWidth = outerRadius - innerRadius + radiusOffset;
      final double offset = asin(progressWidth * 0.5 / drawRadius);
      {
        canvas.save();
        //canvas.translate(0.0, size.width);
        //canvas.rotate(degToRad(-90.0));
        final Gradient gradient1 = new SweepGradient(
          endAngle: 54,
          colors: [
            currentDotColor,
            currentDotColor.withOpacity(.9),
          ],
        );
        final Gradient gradient2 = new SweepGradient(
          endAngle: 54,
          colors: [
            shadowColor,
            shadowColor,
          ],
        );
        final Rect arcRect =
            Rect.fromCircle(center: Offset(0, 0), radius: drawRadius);
        final progressPaint1 = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8
          ..shader = gradient1.createShader(arcRect);
        canvas.drawLine(
            Offset(0, 0), Offset(size.width * progress1, 0), progressPaint1);
        final progressPaint2 = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8
          ..shader = gradient2.createShader(arcRect);
        canvas.drawLine(Offset(size.width * progress1, 0),
            Offset(size.width * progress2, 0), progressPaint2);
        final progressPaint3 = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8
          ..color = ringColor;
        canvas.drawLine(Offset(size.width * progress2, 0),
            Offset(size.width * progress3, 0), progressPaint3);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
