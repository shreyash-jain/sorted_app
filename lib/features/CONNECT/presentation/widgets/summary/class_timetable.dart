
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/summary/timetable_day_widget_view.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ClassTimeTableWidget extends StatelessWidget {
  final ClassModel classModel;
  final List<WeekdayClass> days;
  const ClassTimeTableWidget({Key key, this.classModel, this.days})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Gparam.widthPadding / 6),
      child: (classModel.hasTimeTable == 0)
          ? Container(child: Gtheme.stext("Timetable not added"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...days
                    .asMap()
                    .entries
                    .map((e) => TimeTableViewWidget(
                          day: e.value,
                        ))
                    .toList()
              ],
            ),
    );
  }
}



