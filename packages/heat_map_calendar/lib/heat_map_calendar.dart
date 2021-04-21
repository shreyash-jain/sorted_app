library heat_map_calendar;

import 'package:flutter/material.dart';
import './widgets/month_widget.dart';

import 'models/day.dart';
import 'models/month.dart';

class HeatMapCalendar extends StatefulWidget {
  /// the first day in the heatmap calendar
  final DateTime dateFrom;

  /// the last day in the heatmap calendar
  final DateTime dateTo;

  /// If it is true then the heatmap calendar will start from the first of the month
  final bool alwaysIncludeTheFirstDayOfTheMonth;

  /// Width and height of the square
  final double squareSize;

  /// How many square between two months
  final int spaceBetweenMonths;

  /// The margin of on square from all sides
  final double squareMargin;

  /// The color of the background
  final Color backgroundColor;

  /// inactive square color
  final Color inactiveSquareColor;

  /// a list of labels for each month
  final List<String> monthsLabels;

  /// color for active squares
  final Color activeColor;

  /// for each date we assign the intensity of that date
  /// use the Util.fromTimeToString method to convert your dates to string
  final Map<String, double> events;

  /// events colors
  final Map<String, Color> colors;

  /// the height of the container that contains the labels of the months
  final double textContainerHeight;

  /// text styling for months and week days
  final TextStyle textStyle;

  const HeatMapCalendar({
    @required this.dateFrom,
    @required this.dateTo,
    this.alwaysIncludeTheFirstDayOfTheMonth = true,
    this.squareSize = 30,
    this.spaceBetweenMonths = 2,
    this.squareMargin = 2,
    this.backgroundColor = Colors.white,
    this.inactiveSquareColor = Colors.grey,
    this.monthsLabels = Util.monthsLabels,
    this.activeColor = Colors.greenAccent,
    this.events,
    this.textContainerHeight = 20,
    this.textStyle = const TextStyle(color: Colors.black),
    this.colors,
  });

  @override
  _HeatMapCalendarState createState() => _HeatMapCalendarState();
}

class _HeatMapCalendarState extends State<HeatMapCalendar> {
  DateTime from = DateTime.now().subtract(Duration(days: 310));

  DateTime to = DateTime.now();

  Map<String, double> events;
  Map<String, Color> colors;
  int spaceBetweenMonths = 0;
  Map<int, Color> limitColors;
  List<List<Day>> weeks = [];
  List<Month> months = [];
  @override
  void initState() {
    spaceBetweenMonths = widget.spaceBetweenMonths;
    colors = widget.colors == null ? Map<String, Color>() : widget.colors;
    events = widget.events == null ? Map<String, double>() : widget.events;
    from = widget.dateFrom;
    to = widget.dateTo;
    if (widget.alwaysIncludeTheFirstDayOfTheMonth) {
      while (from.day != 1) {
        from = from.subtract(Duration(days: 1));
      }
    }
    DateTime currentTime = from;
    bool newWeek = true;
    int currentWeek = -1;
    while (true) {
      String stringCurrentTime = Util.fromTimeToString(currentTime);
      if (newWeek) {
        weeks.add(List<Day>(7).map((e) => Day(isNotDay: true)).toList());
        currentWeek++;
        newWeek = false;
      }
      weeks[currentWeek][(currentTime.weekday - 1 + 7) % 7] = Day(
        isActive: events.containsKey(stringCurrentTime),
        opacity: events.containsKey(stringCurrentTime)
            ? events[stringCurrentTime]
            : 0,
        color: events.containsKey(stringCurrentTime)
            ? colors[stringCurrentTime]
            : widget.inactiveSquareColor,
        month: currentTime.month - 1,
      );
      currentTime = currentTime.add(Duration(days: 1));
      // we stop when we reach the last day
      if (currentTime.isAfter(to)) {
        break;
      }
      // add space between months
      if (currentTime.day == 1) {
        for (int i = 0; i < spaceBetweenMonths; i++) {
          currentWeek++;
          weeks.add(List<Day>(7)
              .map((e) => Day(
                    isNotDay: true,
                  ))
              .toList());
        }
      }
      if (currentTime.weekday == 1) {
        newWeek = true;
      }
    }
    _buildMonths();

    super.initState();
  }

  void _buildMonths() {
    Month month = Month(
      number: -1,
      weeks: [],
    );
    int oldMonth = -2;
    weeks.forEach((week) {
      int newMonth = -1;
      for (int i = 0; i < 7; i++) {
        if (week[i].month != -1) {
          newMonth = week[i].month;
        }
      }
      if (oldMonth == -2) oldMonth = newMonth;
      if (newMonth == -1) {
        month.weeks.add(week);
      } else {
        if (newMonth == oldMonth) {
          month.number = newMonth;
          month.weeks.add(week);
        } else {
          months.add(month);
          month = Month(number: newMonth, weeks: [week]);
          oldMonth = newMonth;
        }
      }
    });
    months.add(month);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      height: 7 * (widget.squareSize + 2 * widget.squareMargin) +
          widget.textContainerHeight,
      child: ListView.builder(
        itemCount: months.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return _buildWeekDays(widget.squareMargin, widget.squareSize);
          }
          return MonthWidget(
            month: months[i - 1],
            monthsLabels: widget.monthsLabels,
            activeColor: widget.activeColor,
            inavtiveColor: widget.inactiveSquareColor,
            margin: widget.squareMargin,
            squareSize: widget.squareSize,
            backgroundColor: widget.backgroundColor,
            textContainerHeight: widget.textContainerHeight,
            textStyle: widget.textStyle,
          );
        },
      ),
    );
  }

  Widget _buildWeekDays(double margin, double squareSize) {
    return Column(
      children: [
        SizedBox(
          height: margin * 2,
        ),
        Row(
          children: [
            SizedBox(width: 6 * margin + 3 * squareSize),
            _buildWeekDay("Mon", squareSize),
            SizedBox(width: 2 * margin),
            _buildWeekDay("Tue", squareSize),
            SizedBox(width: 2 * margin),
            _buildWeekDay("Wed", squareSize),
            SizedBox(width: 2 * margin),
            _buildWeekDay("Thu", squareSize),
            SizedBox(width: 2 * margin),
            _buildWeekDay("Fri", squareSize),
            SizedBox(width: 2 * margin),
            _buildWeekDay("Sat", squareSize),
            SizedBox(width: 2 * margin),
            _buildWeekDay("Sun", squareSize),
            SizedBox(width: 2 * margin),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekDay(
    String day,
    double squareSize,
  ) {
    return Container(
      width: squareSize,
      child: Center(
        child: Text(
          day,
          style: widget.textStyle.copyWith(
              fontWeight: FontWeight.w300, fontSize: squareSize * 0.45),
        ),
      ),
    );
  }
}

class Util {
  static const List<String> monthsLabels = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static String fromTimeToString(DateTime date) {
    return date.day.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.year.toString();
  }
}
