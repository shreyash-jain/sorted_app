import 'package:flutter/material.dart';
import '../models/day.dart';

class SquareWidget extends StatelessWidget {
  final Day day;
  final Color activeColor;
  final Color inavtiveColor;
  final Color backgroundColor;
  final double squareSize;
  final double opacity;
  final double margin;
  SquareWidget({
    this.day,
    this.activeColor,
    this.inavtiveColor,
    this.margin,
    this.opacity,
    this.squareSize,
    this.backgroundColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: squareSize,
      width: squareSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(squareSize / 6),
        color: day.isNotDay
            ? Colors.transparent
            : day.isActive
                ? activeColor.withOpacity(opacity)
                : inavtiveColor,
      ),
      margin: EdgeInsets.all(margin),
    );
  }
}
