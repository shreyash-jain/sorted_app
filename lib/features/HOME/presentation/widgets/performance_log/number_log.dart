import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/slider_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';

class NumberLog extends StatefulWidget {
  final TrackPropertyModel property;
  final TrackPropertySettings settings;
  final TrackSummary summary;
  final Function(TrackLog log, TrackSummary prevSummaty) onLog;
  NumberLog({Key key, this.property, this.settings, this.summary, this.onLog})
      : super(key: key);

  @override
  _NumberLogState createState() => _NumberLogState();
}

class _NumberLogState extends State<NumberLog> {
  double value = 0;
  double initialValue = 0;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String unit = "";
  String statCondition = "";
  double myDouble;
  String goalString = "";
  TrackPropertyModel _property;
  TrackPropertySettings _settings;
  bool goalReached = false;
  double currentValue = 0;

  @override
  void initState() {
    super.initState();

    _property = widget.property;
    _settings = widget.settings;

    try {
      myDouble = double.parse(widget.summary?.currentValue ?? "0.0");
    } catch (e) {
      myDouble = 0.0;
    }

    if (_property.n_stat_condition == 1 &&
        widget.summary.last_log != null &&
        !sameDay(DateTime.now(), widget.summary.last_log)) myDouble = 0.0;

    if (myDouble is double) // 123.45
      initialValue = myDouble;
    else
      initialValue = 0.0;

    value = initialValue;
    currentValue = initialValue;

    if (widget.property.has_goal == 1) {
      if (_settings.track_id != 0) {
        switch (_property.n_aim_type) {
          case 1:
            goalString =
                "Your goal is for less than ${_settings.n_u_aim_start} ${_property.n_unit}";
            break;
          case 2:
            goalString =
                "Your goal is for more than ${_settings.n_u_aim_start} ${_property.n_unit}";
            break;
          case 3:
            goalString =
                "Your goal is for more than ${_settings.n_u_aim_start} ${_property.n_unit} and less than ${_settings.n_u_aim_end} ${_property.n_unit}";
            break;
          default:
        }
      }
    }
  }

  bool sameDay(DateTime d1, DateTime d2) {
    return (d1.year == d2.year && d1.month == d2.month && d1.day == d2.day);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(Gparam.widthPadding),
                  child: Gtheme.stext(
                      value.toStringAsFixed(widget.property.n_after_decimal) +
                          " " +
                          widget.property.n_unit +
                          " " +
                          getStatString(widget.property.n_stat_condition),
                      weight: GFontWeight.N,
                      size: GFontSize.M),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                  child: Gtheme.stext(_property.property_question,
                      size: GFontSize.XS, weight: GFontWeight.B1),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                  child: Gtheme.stext("Add ${widget.property.n_unit}",
                      size: GFontSize.XS, weight: GFontWeight.B1),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SliderNumberWidget(
                    fullWidth: true,
                    sliderHeight: 60,
                    initialValue:
                        (_property.n_stat_condition == 1) ? 0 : initialValue,
                    precision: widget.property.n_after_decimal,
                    unit: widget.property.n_unit,
                    onUpdate: (v) {
                      setState(() {
                        if (widget.property.n_stat_condition == 1)
                          value = initialValue + v * widget.property.n_max;
                        else if (widget.property.n_stat_condition == 2) {
                          if (v > initialValue)
                            value = v;
                          else
                            value = initialValue;
                        } else if (widget.property.n_stat_condition == 2) {
                          value = (v + initialValue) / 2;
                        }
                      });
                      checkForGoalReched(value);

                      widget.onLog(
                          TrackLog(
                              property_id: _property.id,
                              track_id: _property.track_id,
                              value: (widget.property.n_min +
                                      (widget.property.n_max -
                                              widget.property.n_min) *
                                          v)
                                  .toStringAsFixed(_property.n_after_decimal),
                              property_type: 2,
                              time: DateTime.now(),
                              id: DateTime.now().millisecondsSinceEpoch),
                          widget.summary);

                      print("jjhaja");
                    },
                    min: widget.property.n_min.toInt(),
                    max: widget.property.n_max.toInt(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget.property.has_goal == 1)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    child: Gtheme.stext(goalString,
                        size: GFontSize.XS, weight: GFontWeight.B1),
                  ),
                if (goalReached)
                  Container(
                      margin: EdgeInsets.all(Gparam.widthPadding),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent),
                      child: Gtheme.stext("Yay! Goal reached",
                          size: GFontSize.XS,
                          weight: GFontWeight.B1,
                          color: GColors.W1))
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getStatString(int statCondition) {
    switch (statCondition) {
      case 0:
        return "last logged";
        break;
      case 1:
        return "total today";
        break;
      case 2:
        return "average today";
        break;
      case 3:
        return "maximum today";
        break;
      default:
        return "";
    }
  }

  checkForGoalReched(double value) {
    if (_property.has_goal == 1) {
      double aim1 = _settings.n_u_aim_start;

      if (_property.n_aim_type == 1) {
        if (value < aim1) {
          setState(() {
            goalReached = true;
          });
        } else {
          setState(() {
            goalReached = false;
          });
        }
      } else if (_property.n_aim_type == 2) {
        if (_property.n_aim_type == 2) {
          if (value > aim1) {
            setState(() {
              goalReached = true;
            });
          } else {
            setState(() {
              goalReached = false;
            });
          }
        }
      } else if (_property.n_aim_type == 3) {
        double aim2 = _settings.n_u_aim_end;
        if (value > aim1 && value < aim2) {
          setState(() {
            goalReached = true;
          });
        } else {
          setState(() {
            goalReached = false;
          });
        }
      }
    } else {
      print("hello");
    }
  }
}
