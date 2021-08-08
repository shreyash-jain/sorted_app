import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class PackageWeekFrequecy extends StatelessWidget {
  final List<int> selectedDays;
  final Function(int day) toggleDay;
  const PackageWeekFrequecy({Key key, this.selectedDays, this.toggleDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 28,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: Gparam.widthPadding,
            ),
            if ((selectedDays.contains(0)))
              InkWell(
                onTap: () {
                  if (toggleDay != null) {
                    toggleDay(0);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Gtheme.stext("Mon",
                      size: GFontSize.XXXS, weight: GFontWeight.N),
                ),
              ),
            if ((selectedDays.contains(1)))
              InkWell(
                onTap: () {
                  if (toggleDay != null) {
                    toggleDay(1);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Gtheme.stext("Tue",
                      size: GFontSize.XXXS, weight: GFontWeight.N),
                ),
              ),
            if ((selectedDays.contains(2)))
              InkWell(
                onTap: () {
                  if (toggleDay != null) {
                    toggleDay(2);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Gtheme.stext("Wed",
                      size: GFontSize.XXXS, weight: GFontWeight.N),
                ),
              ),
            if ((selectedDays.contains(3)))
              InkWell(
                onTap: () {
                  if (toggleDay != null) {
                    toggleDay(3);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Gtheme.stext("Thu",
                      size: GFontSize.XXXS, weight: GFontWeight.N),
                ),
              ),
            if ((selectedDays.contains(4)))
              InkWell(
                onTap: () {
                  if (toggleDay != null) {
                    toggleDay(4);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Gtheme.stext("Fri",
                      size: GFontSize.XXXS, weight: GFontWeight.N),
                ),
              ),
            if ((selectedDays.contains(5)))
              InkWell(
                onTap: () {
                  if (toggleDay != null) {
                    toggleDay(5);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Gtheme.stext("Sat",
                      size: GFontSize.XXXS, weight: GFontWeight.N),
                ),
              ),
            if ((selectedDays.contains(6)))
              InkWell(
                onTap: () {
                  if (toggleDay != null) {
                    toggleDay(6);
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Gtheme.stext("Sun",
                      size: GFontSize.XXXS, weight: GFontWeight.N),
                ),
              ),
          ],
        ));
  }
}
