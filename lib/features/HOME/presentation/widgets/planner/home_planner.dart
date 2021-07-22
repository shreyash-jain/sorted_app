import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/HOME/presentation/widgets/heading.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/home_classroom_tile.dart';

class HomePlanner extends StatefulWidget {
  HomePlanner({Key key}) : super(key: key);

  @override
  _HomePlannerState createState() => _HomePlannerState();
}

class _HomePlannerState extends State<HomePlanner> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeading(
          heading: "Today",
          subHeading: "Your personalized Fitness planner",
        ),
        Container(
          child: null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child: Row(
            children: [
              Gtheme.stext("Daily Challenge",
                  size: GFontSize.S, weight: GFontWeight.B),
              SizedBox(
                width: 12,
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child: Row(
            children: [
              Gtheme.stext("Workout Plan",
                  size: GFontSize.S, weight: GFontWeight.B),
              SizedBox(
                width: 12,
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child: Row(
            children: [
              Gtheme.stext("Diet Plan",
                  size: GFontSize.S, weight: GFontWeight.B),
              SizedBox(
                width: 12,
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child:
              Gtheme.stext("Classes", size: GFontSize.S, weight: GFontWeight.B),
        ),
        Padding(
          padding: EdgeInsets.all(Gparam.widthPadding),
          child: HomeClassRoomTile(
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
          ),
        )
      ],
    );
  }
}
