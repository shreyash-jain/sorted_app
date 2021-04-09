import 'package:flutter/material.dart';
import '../models/month.dart';
import 'square_widget.dart';

class MonthWidget extends StatelessWidget {
  final Month month;
  final List<String> monthsLabels;
  final Color activeColor;
  final Color inavtiveColor;
  final Color backgroundColor;
  final double squareSize;
  final double margin;
  final double textContainerHeight;
  final TextStyle textStyle;
  MonthWidget({
    @required this.month,
    @required this.monthsLabels,
    this.activeColor,
    this.inavtiveColor,
    this.margin,
    this.squareSize,
    this.backgroundColor,
    this.textContainerHeight,
    this.textStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: textContainerHeight,
          child: Row(
            children: [
              SizedBox(
                width: 2 * margin,
              ),
              SizedBox(
                width: 3 * squareSize + 2 * margin,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    monthsLabels[month.number],
                    style: textStyle,
                  ),
                ),
              ),
              SizedBox(
                width: margin,
              ),
            ],
          ),
        ),
        Column(
          children: month.weeks.map((week) {
            return Row(
              children: week
                  .map(
                    (e) => SquareWidget(
                      day: e,
                      activeColor: activeColor,
                      backgroundColor: backgroundColor,
                      inavtiveColor: inavtiveColor,
                      margin: margin,
                      opacity: e.opacity,
                      squareSize: squareSize,
                    ),
                  )
                  .toList(),
            );
          }).toList(),
        ),
      ],
    );
  }
}
