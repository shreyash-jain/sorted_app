
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ClassTimeTableWidget extends StatelessWidget {
  final ClassModel classModel;
  const ClassTimeTableWidget({Key key, this.classModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Gparam.widthPadding / 2),
      child: (classModel.hasTimeTable == 0)
          ? Container(child: Gtheme.stext("Timetable not added"))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        color: Colors.grey.shade100,
                        child: Gtheme.stext("Day", weight: GFontWeight.B1)),
                    SizedBox(
                      height: 10,
                    ),
                    Gtheme.stext("Mon", weight: GFontWeight.N),
                    SizedBox(
                      height: 5,
                    ),
                    Gtheme.stext("Wed", weight: GFontWeight.L),
                    SizedBox(
                      height: 5,
                    ),
                    Gtheme.stext("Fri", weight: GFontWeight.N),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gtheme.stext("From", weight: GFontWeight.B1),
                    SizedBox(
                      height: 10,
                    ),
                    Gtheme.stext("7:00 AM", weight: GFontWeight.N),
                    SizedBox(
                      height: 5,
                    ),
                    Gtheme.stext("7:00 AM", weight: GFontWeight.L),
                    SizedBox(
                      height: 5,
                    ),
                    Gtheme.stext("7:00 AM", weight: GFontWeight.N),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gtheme.stext("To", weight: GFontWeight.B1),
                    SizedBox(
                      height: 10,
                    ),
                    Gtheme.stext("8:00 AM", weight: GFontWeight.N),
                    SizedBox(
                      height: 5,
                    ),
                    Gtheme.stext("8:00 AM", weight: GFontWeight.L),
                    SizedBox(
                      height: 5,
                    ),
                    Gtheme.stext("8:00 AM", weight: GFontWeight.N),
                  ],
                ),
              ],
            ),
    );
  }
}
