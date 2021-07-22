import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/HOME/data/models/client_model.dart';
import 'package:sorted/features/HOME/presentation/widgets/calendar/home_classroom_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/calendar/home_client_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/calendar/home_header.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  PageController _controller = PageController(initialPage: 50);
  DateTime today = DateTime.now();
  DateTime selectedDate;
  int datesFit;
  @override
  void initState() {
    datesFit = getOptimumDates();
    selectedDate = today;
    super.initState();
  }

  int getOptimumDates() {
    return (Gparam.width / 50).floor() - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Gparam.height,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Gparam.widthPadding / 2,
                  vertical: Gparam.widthPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Gtheme.stext("TODAY",
                      size: GFontSize.S, weight: GFontWeight.B2),
                  SizedBox(
                    height: 4,
                  ),
                  Gtheme.stext(DateFormat('MMM dd').format(today),
                      size: GFontSize.XS, weight: GFontWeight.N),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            BuildHomeHeader(
                controller: _controller,
                selectedDate: selectedDate,
                dateOnClick: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                today: today,
                datesFit: datesFit,
                context: context),
            Padding(
              padding: EdgeInsets.only(
                  left: Gparam.widthPadding / 2,
                  right: Gparam.widthPadding / 2,
                  top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gtheme.stext("Classes",
                      size: GFontSize.S, weight: GFontWeight.B2),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  HomeClassRoomTile(
                    classroom: ClassModel(
                      id: 1,
                      name: "Evening Yog Nindra",
                      description: "",
                      shareId: 84521,
                      type: 1,
                      hasTimeTable: 1,
                      timeTableWeekdays: "Mon,Wed,Fri",
                      topics: "Yog Nindra",
                    ),
                    time: "Today at 7 PM",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
