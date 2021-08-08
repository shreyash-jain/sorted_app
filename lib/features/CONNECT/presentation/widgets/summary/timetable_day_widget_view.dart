
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class TimeTableViewWidget extends StatefulWidget {
  final WeekdayClass day;

  TimeTableViewWidget({Key key, this.day}) : super(key: key);

  @override
  TimeTableViewWidgetState createState() => TimeTableViewWidgetState();
}

class TimeTableViewWidgetState extends State<TimeTableViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
        child: Column(
          children: [
            if (widget.day.isEnabled == 1)
              Divider(
                color: Colors.grey.shade300,
              ),
            if (widget.day.isEnabled == 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: null,
                    child: Column(
                      children: [
                        Gtheme.stext("From", size: GFontSize.XXS),
                        SizedBox(
                          height: 12,
                        ),
                        Gtheme.stext(widget.day.fromTime, size: GFontSize.XXS),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: null,
                    child: Column(
                      children: [
                        Gtheme.stext("To", size: GFontSize.XXS),
                        SizedBox(
                          height: 12,
                        ),
                        Gtheme.stext(widget.day.toTime, size: GFontSize.XXS),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ));
  }
}


class WeekdayClass {
  final int id;
  final String day;
  final int isEnabled;
  final String fromTime;
  final String toTime;

  WeekdayClass(this.id, {this.day, this.isEnabled, this.fromTime, this.toTime});
}
