import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heat_map_calendar/heat_map_calendar.dart';
import 'package:intl/intl.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/presentation/bloc/track_analysis_bloc.dart';

class PropertySetSlider extends StatefulWidget {
  final TrackModel track;

  final TrackPropertyModel property;
  final TrackPropertySettings propertySettings;
  final ScrollController controller;

  PropertySetSlider(
      {Key key,
      this.track,
      this.property,
      this.controller,
      this.propertySettings})
      : super(key: key);

  @override
  _PropertySetSliderState createState() => _PropertySetSliderState();
}

class _PropertySetSliderState extends State<PropertySetSlider> {
  DateFormat formatterDate = DateFormat('dd MMMM');
  DateFormat formatterTime = DateFormat('jm');
  int tracktype;
  int stattype;
  int aimtype = 1;
  num aim1;
  num aim2;
  num min;
  num max;
  num initialAim1;
  num initialAim2;
  bool showSave = false;

  @override
  void initState() {
    tracktype = widget.property.property_type;
    stattype = widget.property.n_stat_condition;

    if (widget.property.property_type == 2) {
      aimtype = widget.property.n_aim_type;
      min = widget.property.n_min;
      max = widget.property.n_max;
    } else if (widget.property.property_type == 3) {
      min = widget.property.r_min.toDouble();
      max = widget.property.r_max.toDouble();
    } else {
      aimtype = widget.property.n_aim_type;
      min = 0;
      max = 24;
    }

    if (widget.propertySettings != null) {
      initialAim1 = widget.propertySettings.n_u_aim_start;

      initialAim2 = widget.propertySettings.n_u_aim_end;
    }

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (aimtype == 1)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey,
                  inactiveTrackColor: Colors.black.withOpacity(.2),
                  trackHeight: 8.0,
                  thumbColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  overlayColor: Colors.black.withOpacity(.4),
                  valueIndicatorColor: Colors.transparent,
                  activeTickMarkColor: Colors.black54,
                  inactiveTickMarkColor: Colors.blue.withOpacity(.7),
                ),
                child: Slider(
                    value: initialAim1,
                    max: max.toDouble(),
                    min: min.toDouble(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey.shade300,
                    onChanged: (v) {
                      setState(() {
                        showSave = true;
                        initialAim1 = v;
                      });
                    }),
              )
            else if (aimtype == 2)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey,
                  inactiveTrackColor: Colors.black.withOpacity(.2),
                  trackHeight: 8.0,
                  thumbColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  overlayColor: Colors.black.withOpacity(.4),
                  valueIndicatorColor: Colors.transparent,
                  activeTickMarkColor: Colors.black54,
                  inactiveTickMarkColor: Colors.blue.withOpacity(.7),
                ),
                child: Slider(
                    value: initialAim1,
                    inactiveColor: Theme.of(context).primaryColor,
                    activeColor: Colors.grey.shade300,
                    max: max.toDouble(),
                    min: min.toDouble(),
                    onChanged: (v) {
                      setState(() {
                        showSave = true;
                        initialAim1 = v;
                      });
                    }),
              )
            else
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey,
                  inactiveTrackColor: Colors.black.withOpacity(.2),
                  trackHeight: 8.0,
                  thumbColor: Colors.white,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  overlayColor: Colors.black.withOpacity(.4),
                  valueIndicatorColor: Colors.black,
                  activeTickMarkColor: Colors.black54,
                  inactiveTickMarkColor: Colors.blue.withOpacity(.7),
                ),
                child: RangeSlider(
                    values: RangeValues(initialAim1, initialAim2),
                    max: max.toDouble(),
                    min: min.toDouble(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Colors.grey.shade300,
                    onChanged: (r) {
                      setState(() {
                        showSave = true;
                        initialAim1 = r.start;
                        initialAim2 = r.end;
                      });
                    }),
              )
          ],
        ),
        if (widget.property.property_type == 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: min.toString() + " ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Milliard",
                          fontSize: 16),
                      children: <TextSpan>[
                    TextSpan(
                        text: widget.property.n_unit,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                  ])),
              RichText(
                  text: TextSpan(
                      text: max.toString() + " ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Milliard",
                          fontSize: 16),
                      children: <TextSpan>[
                    TextSpan(
                        text: widget.property.n_unit,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                  ])),
            ],
          ),
        if (widget.property.property_type == 4)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: '0 ',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Milliard",
                          fontSize: 16),
                      children: <TextSpan>[
                    TextSpan(
                        text: "Hours",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                  ])),
              RichText(
                  text: TextSpan(
                      text: '24 ',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Milliard",
                          fontSize: 16),
                      children: <TextSpan>[
                    TextSpan(
                        text: "Hours",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                  ])),
            ],
          ),
        SizedBox(
          height: 16,
        ),
        if (aimtype == 1)
          Row(
            children: [
              Flexible(
                child: RichText(
                    text: TextSpan(
                        text: 'My daily goal for ',
                        style: TextStyle(
                            color: Colors.black54,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Milliard",
                            fontSize: 16),
                        children: <TextSpan>[
                      TextSpan(
                          text: widget.track.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                      TextSpan(
                          text: " is for less than ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                      if (tracktype == 2)
                        TextSpan(
                            text: initialAim1.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                " " +
                                widget.property.n_unit,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      if (tracktype == 4)
                        TextSpan(
                            text: initialAim1.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                " hrs",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            )),
                    ])),
              ),
            ],
          ),
        if (aimtype == 2)
          Row(
            children: [
              Flexible(
                child: RichText(
                    text: TextSpan(
                        text: 'My daily goal for ',
                        style: TextStyle(
                            color: Colors.black54,
                            height: 1.5,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Milliard",
                            fontSize: 16),
                        children: <TextSpan>[
                      TextSpan(
                          text: widget.track.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                      TextSpan(
                          text: " is for more than ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                      if (tracktype == 2)
                        TextSpan(
                            text: initialAim1.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                " " +
                                widget.property.n_unit,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      if (tracktype == 4)
                        TextSpan(
                            text: initialAim1.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                " hrs",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            )),
                    ])),
              ),
            ],
          ),
        if (aimtype == 3)
          Row(
            children: [
              Flexible(
                child: RichText(
                    text: TextSpan(
                        text: 'My daily goal for ',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            fontFamily: "Milliard",
                            fontSize: 16),
                        children: <TextSpan>[
                      TextSpan(
                          text: widget.track.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                      TextSpan(
                          text: " is for more than ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                      if (tracktype == 2)
                        TextSpan(
                            text: initialAim1.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                " " +
                                widget.property.n_unit,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      if (tracktype == 4)
                        TextSpan(
                            text: initialAim1.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                " hrs",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      TextSpan(
                          text: " and less than ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                      if (tracktype == 2)
                        TextSpan(
                            text: initialAim2.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                widget.property.n_unit,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      if (tracktype == 4)
                        TextSpan(
                            text: initialAim2.toStringAsFixed(
                                    widget.property.n_after_decimal) +
                                " hrs",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                    ])),
              ),
            ],
          ),
        SizedBox(
          height: 16,
        ),
        if (showSave)
          OutlinedButton(
              onPressed: () {
                if (widget.propertySettings != null) {
                  BlocProvider.of<TrackAnalysisBloc>(context).add(
                      UpdateTrackPropertySettings(widget.propertySettings
                          .copyWith(
                              n_u_aim_start:
                                  num.parse(initialAim1.toStringAsFixed(2)) ??
                                      0,
                              n_u_aim_end:
                                  num.parse(initialAim2.toStringAsFixed(2)) ??
                                      0)));
                  setState(() {
                    showSave = false;
                  });
                }
              },
              child: Gtheme.stext("Save"))
      ],
    );
  }
}
