import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class HomeClassRoomTile extends StatelessWidget {
  final ClassModel classroom;

  final String time;
  const HomeClassRoomTile({Key key, this.classroom, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: EdgeInsets.only(bottom: 30),
        width: Gparam.width - 1.05 * Gparam.widthPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gtheme.stext(classroom.name, weight: GFontWeight.N),
            SizedBox(
              height: 6,
            ),
            if (classroom.hasTimeTable == 0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Gtheme.stext(
                    "No Timetable added yet",
                    size: GFontSize.XXXS,
                    weight: GFontWeight.N,
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(5)),
                    child: Gtheme.stext(
                      " Add Students ",
                      size: GFontSize.XXS,
                      weight: GFontWeight.N,
                    ),
                  ),
                ],
              ),
            if (classroom.hasTimeTable == 1)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    MdiIcons.timetable,
                    size: 20,
                    color: Colors.black45,
                  ),
                  ...classroom.timeTableWeekdays
                      .split(",")
                      .asMap()
                      .entries
                      .map((e) => Gtheme.stext(
                            " " + e.value + " |",
                            size: GFontSize.XXXS,
                            weight: GFontWeight.N,
                          ))
                      .toList(),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(5)),
                    child: Gtheme.stext(
                      time,
                      size: GFontSize.XS,
                      weight: GFontWeight.B,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
