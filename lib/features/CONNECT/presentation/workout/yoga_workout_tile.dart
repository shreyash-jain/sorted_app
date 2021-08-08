import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';

class WorkoutTile extends StatelessWidget {
  final WorkoutModel activity;
  const WorkoutTile({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          if (activity.activity.image_url != null &&
              activity.activity.image_url != "")
            CachedNetworkImage(
              imageUrl: activity.activity.image_url,
              width: 50,
              height: 50,
            ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gtheme.stext(activity.activity.exercise_name,
                  size: GFontSize.S, weight: GFontWeight.B1),
              SizedBox(
                height: 6,
              ),
            ],
          )
        ],
      ),
    );
  }
}
