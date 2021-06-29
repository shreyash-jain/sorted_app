import 'package:flutter/material.dart';
import 'package:sorted/features/HOME/presentation/widgets/heading.dart';

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
        HomeHeading(heading: "Today",subHeading: "Your personalized Fitness planner",),
        Container(
           child: null,
        ),
      ],
    );
  }
}