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

class ListAnalysis extends StatefulWidget {
  final TrackModel track;
  final List<List<TrackLog>> logs;
  final TrackPropertySettings settings;
  final TrackPropertyModel property;
  final ScrollController controller;
  ListAnalysis(
      {Key key,
      this.track,
      this.logs,
      this.property,
      this.controller,
      this.settings})
      : super(key: key);

  @override
  _ListAnalysisState createState() => _ListAnalysisState();
}

class _ListAnalysisState extends State<ListAnalysis> {
  DateFormat formatterDate = DateFormat('dd MMMM');
  DateFormat formatterTime = DateFormat('jm');
  int tracktype;
  int stattype;
  LinkedHashMap<DateTime, List<TrackLog>> datelogmap;
  LinkedHashMap<DateTime, double> valuelogmap;
  List<DateTime> filledDays;
  Map<String, double> calendarEvents;
  Map<String, Color> daycolors;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController = widget.controller;
    datelogmap = new LinkedHashMap();
    valuelogmap = new LinkedHashMap();
    calendarEvents = new Map();
    daycolors = new Map();
    tracktype = widget.property.property_type;
    stattype = widget.property.n_stat_condition;

    if (tracktype == 3) stattype = 2;
    if (tracktype == 4) stattype = 1;

    listToMap(widget.logs);
    convergeDataFromMap(stattype);
    transformMap();

    filledDays = valuelogmap.keys.toList()..sort();
    print("filledDays " + filledDays.toString());

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
                    child: Gtheme.stext("🗓️ Monthly analysis",
                        size: GFontSize.S, weight: GFontWeight.N),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        if (filledDays.length > 0)
          HeatMapCalendar(
              dateFrom: filledDays[0],
              squareSize: Gparam.width / 10,
              events: calendarEvents,
              colors: daycolors,
              textStyle: Gtheme.blackShadowBold32,
              inactiveSquareColor: Colors.grey.shade200,
              dateTo: filledDays[filledDays.length - 1])
      ],
    );
  }

  listToMap(List<List<TrackLog>> data) {
    print("data in list  " + data.toString());

    if (data.length == 0) return;

    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < data[i].length; j++) {
        DateTime thisLogTime = data[i][j].time;
        var correctedDate =
            DateTime(thisLogTime.year, thisLogTime.month, thisLogTime.day);

        if (datelogmap.containsKey(correctedDate)) {
          List<TrackLog> datedata = datelogmap[correctedDate];
          datedata.add(data[i][j]);
          datelogmap[correctedDate] = datedata;
        } else {
          datelogmap[correctedDate] = [data[i][j]];
        }
      }
    }
  }

  convergeDataFromMap(int stattype) {
    for (var i = 0; i < datelogmap.entries.length; i++) {
      List<TrackLog> daylogs = datelogmap.entries.elementAt(i).value;
      double dayValue = 0;
      if (stattype == 0) {
        if (daylogs.length > 0) {
          try {
            dayValue = double.parse(daylogs[daylogs.length - 1].value);
          } catch (e) {
            dayValue = 0;
          }
        }
      } else if (stattype == 1) {
        dayValue = 0;

        if (daylogs.length > 0) {
          try {
            for (TrackLog e in daylogs) {
              try {
                dayValue += double.parse(e.value);
              } catch (e) {
                dayValue += 0;
              }
            }
          } catch (e) {
            dayValue = 0;
          }
        }
      } else if (stattype == 2) {
        if (daylogs.length > 0) {
          double daysum = 0;
          dayValue = 0;
          try {
            for (TrackLog e in daylogs) {
              try {
                daysum += double.parse(e.value);
              } catch (e) {
                daysum += 0;
              }
            }
            dayValue = daysum / (daylogs.length);
          } catch (e) {
            dayValue = 0;
          }
        }
      }

      valuelogmap[datelogmap.entries.elementAt(i).key] = dayValue;
    }
  }

  transformMap() {
    for (var i = 0; i < valuelogmap.length; i++) {
      calendarEvents[
              Util.fromTimeToString(valuelogmap.entries.elementAt(i).key)] =
          valuelogmap.entries.elementAt(i).value;
      daycolors[Util.fromTimeToString(valuelogmap.entries.elementAt(i).key)] =
          getDayColor(valuelogmap.entries.elementAt(i).value);
    }
  }

  Color getDayColor(double value) {
    int hasGoal = widget.property.has_goal;
    if (hasGoal == 0) return Color(0xFF21739d);
    int aimtype = widget.property.n_aim_type;
    if (widget.settings != null) {
      switch (aimtype) {
        case 2:
          if (widget.settings.n_u_aim_start <= value) {
            if (widget.property.property_type == 2 && widget.property.n_max > 0)
              return Colors.greenAccent
                  .withOpacity(value / widget.property.n_max);
            else if (widget.property.property_type == 4)
              return Colors.greenAccent.withOpacity(value / 24);
            else
              return Color(0xFF21739d);
          } else if (widget.settings.n_u_aim_start > value) {
            if (widget.property.property_type == 2 && widget.property.n_max > 0)
              return Colors.redAccent.withOpacity(
                  (widget.property.n_max - value) / widget.property.n_max);
            else if (widget.property.property_type == 4)
              return Colors.redAccent.withOpacity(24 - value / 24);
            else
              return Color(0xFF21739d);
          }
          break;
        case 1:
          if (widget.settings.n_u_aim_start > value) {
            if (widget.property.property_type == 2 && widget.property.n_max > 0)
              return Colors.greenAccent.withOpacity(
                  (widget.property.n_max - value) / widget.property.n_max);
            else if (widget.property.property_type == 4)
              return Colors.greenAccent.withOpacity(24 - value / 24);
            else
              return Color(0xFF21739d);
          } else if (widget.settings.n_u_aim_start <= value) {
            if (widget.property.property_type == 2 && widget.property.n_max > 0)
              return Colors.redAccent
                  .withOpacity((value) / widget.property.n_max);
            else if (widget.property.property_type == 4)
              return Colors.redAccent.withOpacity(value / 24);
            else
              return Color(0xFF21739d);
          }
          break;
        case 3:
          if (widget.settings.n_u_aim_end >= value &&
              widget.settings.n_u_aim_start <= value) {
            if (widget.property.property_type == 2 && widget.property.n_max > 0)
              return Colors.greenAccent;
            else if (widget.property.property_type == 4)
              return Colors.greenAccent;
            else
              return Color(0xFF21739d);
          } else if (widget.settings.n_u_aim_start > value) {
            if (widget.property.property_type == 2 && widget.property.n_max > 0)
              return Colors.redAccent.withOpacity(
                  (widget.property.n_max - value) / widget.property.n_max);
            else if (widget.property.property_type == 4)
              return Colors.redAccent.withOpacity(24 - value / 24);
            else
              return Color(0xFF21739d);
          } else {
            if (widget.property.property_type == 2 && widget.property.n_max > 0)
              return Colors.redAccent
                  .withOpacity((value) / widget.property.n_max);
            else if (widget.property.property_type == 4)
              return Colors.redAccent.withOpacity(value / 24);
            else
              return Color(0xFF21739d);
          }
          break;

        default:
      }
    } else
      return Color(0xFF21739d);
  }

  bool isSameDate(DateTime thisDate, DateTime other) {
    return thisDate.year == other.year &&
        thisDate.month == other.month &&
        thisDate.day == other.day;
  }
}
