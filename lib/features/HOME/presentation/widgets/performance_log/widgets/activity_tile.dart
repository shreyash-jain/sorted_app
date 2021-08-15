import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';

class ActivityTile extends StatelessWidget {
  final WorkoutModel workout;

  final Function(WorkoutModel) addSet;
  const ActivityTile({Key key, this.workout, this.addSet}) : super(key: key);

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
                      width: double.maxFinite,
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
                    SizedBox(
                      height: 6,
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
                width: Gparam.width - 88,
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
                                      e.value.toString() +
                                          ((workout.activityType == 0)
                                              ? " reps"
                                              : " mins"),
                                      size: GFontSize.XXS),
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(5)),
                                  child:
                                      Gtheme.stext("Rest", size: GFontSize.XXS),
                                )
                              ],
                            ))
                        .toList(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (addSet != null) addSet(workout);
                            },
                            child: Container(
                              height: 54,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Gtheme.stext("+", size: GFontSize.L),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Gtheme.stext(
              (workout.activity.calorie_burn * workout.sequence.length)
                      .toString() +
                  " Calories Burnt ",
              size: GFontSize.S,
              weight: GFontWeight.B1),
        ],
      ),
    );
  }
}
