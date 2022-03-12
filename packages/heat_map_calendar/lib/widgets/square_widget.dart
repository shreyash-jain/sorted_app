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
                  ? day.color
                  : inavtiveColor,
        ),
        margin: EdgeInsets.all(margin),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (day.opacity != 0 && day.day != null)
              Text(
                day.opacity.toStringAsFixed(1).toString(),
                style: TextStyle(
                    fontFamily: "Milliard",
                    shadows: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        spreadRadius: 8,
                      )
                    ],
                    fontSize:
                        (day.opacity.toStringAsFixed(1).toString().length > 3)
                            ? 9
                            : 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            if (day.day != null)
              Text(
                day.day.toString(),
                style: TextStyle(
                    fontFamily: "Milliard",
                    fontSize: 10,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              )
          ],
        )));
  }
}
