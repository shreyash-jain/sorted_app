import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';

class ActivityTileView extends StatelessWidget {
  final WorkoutModel workout;
  final int listId;
  final Function(WorkoutModel, int) addSet;
  const ActivityTileView({Key key, this.workout, this.addSet, this.listId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (workout.activity.image_url != "")
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: workout.activity.image_url,
                    placeholder: (context, url) => ImagePlaceholderWidget(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.grey,
                    ),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              if (workout.activity.image_url != "")
                SizedBox(
                  width: 20,
                ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gtheme.stext(workout.activity.exercise_name,
                        size: GFontSize.S, weight: GFontWeight.B1),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      height: 38,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Gtheme.stext(
                                workout.activity.calorie_burn.toString() +
                                    " cal burn",
                                size: GFontSize.XXS),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                height: 70,
                width: Gparam.width * .8,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5)),
                          child: Gtheme.stext("Reps", size: GFontSize.XXS),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5)),
                          child: Gtheme.stext("Rest", size: GFontSize.XXS),
                        ),
                      ],
                    ),
                    ...workout.sequence
                        .asMap()
                        .entries
                        .map((e) => Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Gtheme.stext(
                                      e.value.toString() + " reps",
                                      size: GFontSize.XXS),
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Gtheme.stext(
                                      (workout.restTime[e.key]?.toString() ??
                                              "35") +
                                          " secs",
                                      size: GFontSize.XXS),
                                )
                              ],
                            ))
                        .toList(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
