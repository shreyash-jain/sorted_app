import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heat_map_calendar/heat_map_calendar.dart';
import 'package:intl/intl.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';

class PropertySetGoal extends StatefulWidget {
  final TrackModel track;

  final TrackPropertyModel property;
  final TrackPropertySettings propertySettings;
  final ScrollController controller;
  PropertySetGoal(
      {Key key,
      this.track,
      this.property,
      this.controller,
      this.propertySettings})
      : super(key: key);

  @override
  _PropertySetGoalState createState() => _PropertySetGoalState();
}

class _PropertySetGoalState extends State<PropertySetGoal> {
  DateFormat formatterDate = DateFormat('dd MMMM');
  DateFormat formatterTime = DateFormat('jm');
  int tracktype;
  int stattype;

  @override
  void initState() {
    tracktype = widget.property.property_type;
    stattype = widget.property.n_stat_condition;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Gparam.heightPadding * 1.5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    child: Gtheme.stext(
                        "Set your ${stattype != 0 ? "daily " : ""}goal in ${widget.property.property_type == 4 ? "mins" : ""} ${widget.property.n_unit}",
                        size: GFontSize.S,
                        weight: GFontWeight.N),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Gtheme.stext("Set your Daily Goal",
                        size: GFontSize.S, weight: GFontWeight.N),
                    Gtheme.stext("  coming soon",
                        size: GFontSize.XXS, weight: GFontWeight.L),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
