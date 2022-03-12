import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/workout/activity_tile_view.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';

class DayActivityWidget extends StatelessWidget {
  final DayWorkout dayWorkout;
  const DayActivityWidget({Key key, this.dayWorkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Gparam.width,
      child: ExpansionTile(
        iconColor: Theme.of(context).primaryColor,
        initiallyExpanded: true,
        tilePadding: EdgeInsets.only(right: Gparam.widthPadding),
        childrenPadding: EdgeInsets.all(0),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Gtheme.stext(dayWorkout.daySubTitle,
                      size: GFontSize.XS, weight: GFontWeight.N),
                ],
              ),
            ],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
                  child: Gtheme.stext("Exercises",
                      size: GFontSize.S, weight: GFontWeight.L),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                ...dayWorkout.dayActivities
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.all(Gparam.widthPadding / 2),
                        child: ActivityTileView(
                          workout: e.value,
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
