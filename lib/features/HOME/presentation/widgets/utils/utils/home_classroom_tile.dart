import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class HomeClassRoomTile extends StatelessWidget {
  final ClassModel classroom;

  const HomeClassRoomTile({
    Key key,
    this.classroom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.push(ClassroomMain(classroom: classroom));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        width: Gparam.width - 1.05 * Gparam.widthPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Gtheme.stext(
                  classroom.name,
                  weight: GFontWeight.B,
                )),
              ],
            ),
            if (classroom.hasTimeTable == 0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Gtheme.stext("No Timetable added yet",
                      size: GFontSize.XXXS,
                      weight: GFontWeight.N,
                      color: GColors.B2),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Gtheme.stext(" View Class ",
                        size: GFontSize.XXS,
                        weight: GFontWeight.N,
                        color: GColors.B),
                  ),
                ],
              ),
            SizedBox(
              height: 16,
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
                      .map((e) => Gtheme.stext(" " + e.value + " |",
                          size: GFontSize.XXXS,
                          weight: GFontWeight.N,
                          color: GColors.B2))
                      .toList(),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Gtheme.stext(" View Class ",
                        size: GFontSize.XXS,
                        weight: GFontWeight.N,
                        color: GColors.B),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
