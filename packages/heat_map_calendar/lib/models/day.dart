import 'package:flutter/material.dart';

class Day {
  bool isActive;
  int numberOfEvents;
  int month;
  double opacity;
  bool isNotDay;
  Color color;
  Day({
    this.isActive = false,
    this.numberOfEvents = 0,
    this.month = -1,
    this.opacity = 1,
    this.isNotDay = false,
    this.color = Colors.greenAccent,
  });
  @override
  String toString() {
    return "[month = $month]";
  }
}
