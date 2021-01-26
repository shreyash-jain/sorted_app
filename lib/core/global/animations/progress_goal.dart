import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

typedef ProgressChanged<double> = void Function(double value);

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);

class CustomLinearProgressBar extends StatefulWidget {
  final double radius;
  final double progress;
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;

  final ProgressChanged progressChanged;

  const CustomLinearProgressBar({
    Key key,
    @required this.radius,
    @required this.dotRadius,
    @required this.dotColor,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFF7F7FC),
    this.dotEdgeColor = const Color(0XFFF5F5FA),
    this.progress,
    this.progressChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CustomLinearProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  bool isValidTouch = false;
  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    progressController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    if (widget.progress != null) progressController.value = widget.progress;
    progressController.addListener(() {
      if (widget.progressChanged != null)
        widget.progressChanged(progressController.value);
      setState(() {});
    });
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.radius * 2.0;
    final size = new Size(width, 10);
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
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
              progress: progressController.value),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox getBox = paintKey.currentContext.findRenderObject();
    Offset local = getBox.globalToLocal(details.globalPosition);
    isValidTouch = _checkValidTouch(local);
    if (!isValidTouch) {
      return;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isValidTouch) {
      return;
    }
    RenderBox getBox = paintKey.currentContext.findRenderObject();
    Offset local = getBox.globalToLocal(details.globalPosition);
    final double x = local.dx;
    final double y = local.dy;
    final double center = widget.radius;
    double radians = atan((x - center) / (center - y));
    if (y > center) {
      radians = radians + degToRad(180.0);
    } else if (x < center) {
      radians = radians + degToRad(360.0);
    }
    progressController.value = radians / degToRad(360.0);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!isValidTouch) {
      return;
    }
  }

  bool _checkValidTouch(Offset pointer) {
    print(pointer);
    final double validInnerRadius = widget.radius - widget.dotRadius * 3;
    final double dx = pointer.dx;
    final double dy = pointer.dy;
    final double distanceToCenter =
        sqrt(pow(dx - widget.radius, 2) + pow(dy - widget.radius, 2));
    if (distanceToCenter < validInnerRadius ||
        distanceToCenter > widget.radius) {
      return false;
    }
    return true;
  }
}

class ProgressPainter extends CustomPainter {
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotColor;
  final Color dotEdgeColor;
  final Color ringColor;
  final double progress;

  ProgressPainter({
    this.dotRadius,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFF7F7FC),
    this.dotColor,
    this.dotEdgeColor = const Color(0XFFF5F5FA),
    this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    final Offset offsetCenter = Offset(center, center);
    final double drawRadius = size.width * 0.5 - dotRadius;
    final angle = 360.0 * progress;
    final double radians = degToRad(angle);

    final double radiusOffset = dotRadius * 0.4;
    final double outerRadius = center - radiusOffset;
    final double innerRadius = center - dotRadius * 2 + radiusOffset;
    final textStyle = TextStyle(
      color: Colors.black,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
      fontSize: Gparam.textVerySmall,
    );
    final textSpan = TextSpan(
      text: '36 % completed',
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
    final offset = Offset(0, 0);
    //textPainter.paint(canvas, offset);

    // draw shadow.
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = shadowColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth =1.5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowWidth);
    //canvas.drawLine(Offset(0,0), Offset(size.width*progress,0), shadowPaint);
    //canvas.drawCircle(offsetCenter, innerRadius, shadowPaint);

    
     var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width*progress, 0);
     canvas.drawPath(path, shadowPaint);

    
  

    //canvas.drawShadow(path, Colors.amber,1, true);

    // draw ring.
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = ringColor
      ..strokeWidth = (6);
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), ringPaint);

    final Color currentDotColor = Color.alphaBlend(
        dotColor.withOpacity(0.7 + (0.3 * progress)), Colors.white);

    // draw progress.
    if (progress > 0.0) {
      final progressWidth = outerRadius - innerRadius + radiusOffset;
      final double offset = asin(progressWidth * 0.5 / drawRadius);
      if (radians > offset) {
        canvas.save();
        //canvas.translate(0.0, size.width);
        //canvas.rotate(degToRad(-90.0));
        final Gradient gradient = new SweepGradient(
          endAngle: 54,
          colors: [
            currentDotColor,
            currentDotColor.withOpacity(.9),
          ],
        );
        final Rect arcRect =
            Rect.fromCircle(center: Offset(0, 0), radius: drawRadius);
        final progressPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 6
          ..shader = gradient.createShader(arcRect);
        canvas.drawLine(
            Offset(0, 0), Offset(size.width * progress, 0), progressPaint);
        canvas.restore();
      }
    }

    // draw dot.
    final double dx = center + drawRadius * sin(radians);
    final double dy = center - drawRadius * cos(radians);
    final dotPaint = Paint()..color = currentDotColor;
    //canvas.drawCircle(new Offset(size.width*progress,0), dotRadius, dotPaint);
    dotPaint
      ..color = dotEdgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = dotRadius * 0.3;
    //canvas.drawCircle(new Offset(size.width*progress,0), dotRadius, dotPaint);

//    canvas.drawLine(
//        Offset(center, 0.0),
//        Offset(center, size.height),
//        Paint()
//          ..strokeWidth = 1.0
//          ..color = Colors.black);  // 测试基准线
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
