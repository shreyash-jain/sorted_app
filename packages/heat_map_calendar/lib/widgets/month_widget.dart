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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 2 * margin,
          ),
          Container(
            height: textContainerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 2 * margin,
                ),
                SizedBox(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      monthsLabels[month.number],
                      style: TextStyle(
                          fontFamily: "Milliard",
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  width: margin,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2 * margin,
          ),
          Column(
            children: month.weeks.map((week) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
