import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/global/constants/constants.dart';
import '../../../domain/entities/track.dart';
import '../../../domain/entities/track_goal.dart';
import '../../../domain/entities/track_property.dart';
import '../../../../COMMON/constants/enum_constants.dart';
import '../../bloc/single_track/single_track_bloc.dart';

class SelfTrackingPopup extends StatefulWidget {
  Track track;
  List<TrackGoal> trackGoals;
  List<TrackProperty> props;
  final SingleTrackBloc bloc;
  SelfTrackingPopup({
    @required this.track,
    @required this.trackGoals,
    @required this.bloc,
    @required this.props,
  });

  @override
  _SelfTrackingPopupState createState() => _SelfTrackingPopupState();
}

class _SelfTrackingPopupState extends State<SelfTrackingPopup> {
  List<String> weekDays = ["S", "M", "T", "W", "T", "F", "S"];
  List<bool> weekDaysValues = List.generate(7, (index) => true);
  bool _switchValue = false;
  bool _checkValueAt = false;
  bool _checkValueFromto = false;
  int day_start_ts;
  int day_end_ts;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: Gparam.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Gparam.heightPadding / 2,
            ),
            _buildTitle("Duration", "icon 1"),
            _buildDuration(),
            _buildTitle("Remainder", "icon 2"),
            _buildRemainder(),
            _buildTitle("Set diet goal", "icon 3"),
            _buildGoals(),
            SizedBox(
              height: Gparam.heightPadding,
            ),
            _buildSumbit(),
            SizedBox(
              height: Gparam.heightPadding,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, String icon) {
    return Container(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: Gparam.widthPadding,
          ),
          Container(
            child: Text(icon),
          ),
          SizedBox(
            width: Gparam.widthPadding / 2,
          ),
          Container(
            child: Text(
              title,
              style: Gtheme.textBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuration() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: TrackDuration.values.length * 2 + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return SizedBox(
              width: Gparam.widthPadding,
            );
          }
          if (i % 2 == 0) {
            return SizedBox(
              width: Gparam.widthPadding / 2,
            );
          }
          int index = i ~/ 2;
          return DurationItem(
            description: TrackDuration.values[index].description,
            icon: TrackDuration.values[index].icon,
            isSelected: (widget.track?.ts_default_sub_days ?? 0) == index,
          );
        },
      ),
    );
  }

  Widget _buildRemainder() {
    int reminder_state = widget.track.ts_reminder_state;
    // if (TrackReminder.values[reminder_state] == TrackReminder.daily) {
    //   return _buildDailyReminder(TrackReminder.daily);
    // }
    // if (TrackReminder.values[reminder_state] == TrackReminder.weekly) {
    //   return _buildWeeklyReminder (TrackReminder.weekly);
    // }
    // if (TrackReminder.values[reminder_state] == TrackReminder.monthly) {
    //   return _buildMonthlyReminder(TrackReminder.monthly);
    // }

    return _buildWeeklyReminder(TrackReminder.weekly);
    return _buildMonthlyReminder(TrackReminder.monthly);
  }

  Widget _buildDailyReminder(TrackReminder trackReminder) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: Gparam.widthPadding,
            ),
            Text(
              trackReminder.description,
              style: Gtheme.textNormal,
            ),
            Expanded(child: Container()),
            Switch(
              value: _switchValue,
              onChanged: (val) {
                setState(() {
                  _switchValue = val;
                });
              },
            ),
            SizedBox(
              width: Gparam.widthPadding / 2,
            ),
          ],
        ),
        Visibility(
          visible: _switchValue,
          child: Row(
            children: [
              SizedBox(
                width: Gparam.widthPadding,
              ),
              Checkbox(
                value: _checkValueAt,
                onChanged: (newValue) {
                  setState(() {
                    _checkValueAt = newValue;
                  });
                },
              ),
              RichText(
                text: TextSpan(
                  text: 'Daily reminder at ',
                  style: Gtheme.textNormal.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.track.ts_reminder_day_start_ts,
                        ),
                      ),
                      style: Gtheme.textBold,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('change!');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _switchValue,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Gparam.widthPadding,
              ),
              Checkbox(
                value: _checkValueFromto,
                onChanged: (newValue) {
                  setState(() {
                    _checkValueFromto = newValue;
                  });
                },
              ),
              RichText(
                text: TextSpan(
                  text: 'Daily reminder in every',
                  style: Gtheme.textNormal.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' 2 ',
                      style: Gtheme.textBold,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('change!!');
                        },
                    ),
                    TextSpan(
                      text: 'hours\n',
                      style: Gtheme.textNormal,
                    ),
                    TextSpan(
                      text: 'From ',
                      style: Gtheme.textNormal,
                    ),
                    TextSpan(
                      text: DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.track.ts_reminder_day_start_ts,
                        ),
                      ),
                      style: Gtheme.textBold,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('change!!');
                        },
                    ),
                    TextSpan(
                      text: ' to ',
                    ),
                    TextSpan(
                      text: DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.track.ts_reminder_day_end_ts,
                        ),
                      ),
                      style: Gtheme.textBold,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('change!!');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyReminder(TrackReminder trackReminder) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: Gparam.widthPadding,
            ),
            Text(
              trackReminder.description,
              style: Gtheme.textNormal,
            ),
            Expanded(child: Container()),
            Switch(
              value: _switchValue,
              onChanged: (val) {
                setState(() {
                  _switchValue = val;
                });
              },
            ),
            SizedBox(
              width: Gparam.widthPadding / 2,
            ),
          ],
        ),
        Visibility(
          visible: _switchValue,
          child: Container(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: Gparam.widthPadding,
                ),
                ...weekDays.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    String day = entry.value;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          weekDaysValues[index] = !weekDaysValues[index];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: weekDaysValues[index]
                              ? Theme.of(context).backgroundColor
                              : Theme.of(context).cardColor,
                        ),
                        child: Center(
                          child: Text(day),
                        ),
                      ),
                    );
                  },
                ).toList(),
                SizedBox(
                  width: Gparam.widthPadding / 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyReminder(TrackReminder trackReminder) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: Gparam.widthPadding,
            ),
            Text(
              trackReminder.description,
              style: Gtheme.textNormal,
            ),
            Expanded(child: Container()),
            Switch(
              value: _switchValue,
              onChanged: (val) {
                setState(() {
                  _switchValue = val;
                });
              },
            ),
            SizedBox(
              width: Gparam.widthPadding / 2,
            ),
          ],
        ),
        Visibility(
          visible: _switchValue,
          child: Row(
            children: [
              SizedBox(
                width: Gparam.widthPadding,
              ),
              Checkbox(
                value: _checkValueAt,
                onChanged: (newValue) {
                  setState(() {
                    _checkValueAt = newValue;
                  });
                },
              ),
              RichText(
                text: TextSpan(
                  style: Gtheme.textNormal.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                  text: 'in every ',
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.track.ts_reminder_interval_days.toString(),
                      style: Gtheme.textBold,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('change!');
                        },
                    ),
                    TextSpan(
                      text: ' days. At ',
                    ),
                    TextSpan(
                      text: DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.track.ts_reminder_day_end_ts,
                        ),
                      ),
                      style: Gtheme.textBold,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('change!');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoals() {
    return Container(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.trackGoals.length * 2 + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return SizedBox(
              width: Gparam.widthPadding,
            );
          }
          if (i % 2 == 0) {
            return SizedBox(
              width: Gparam.widthPadding / 2,
            );
          }
          return GoalItem(trackGoal: widget.trackGoals[i ~/ 2]);
        },
      ),
    );
  }

  Widget _buildSumbit() {
    return FlatButton(
      color: Theme.of(context).backgroundColor,
      onPressed: () {
        Track track = _updateTrack(widget.track);

        widget.bloc.add(
          SubscribeToTrackEvent(
            track: track,
            trackProps: widget.props,
          ),
        );
        Navigator.pop(context);
      },
      child: Text(
        "Start tracking",
        style: Gtheme.textBold,
      ),
    );
  }

  Track _updateTrack(Track track) {
    track.u_active_state = 1;
    return track;
  }
  // end of class
}

class DurationItem extends StatelessWidget {
  final String icon;
  final String description;
  final bool isSelected;
  DurationItem(
      {@required this.description,
      @required this.icon,
      this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Gparam.widthPadding / 2, right: Gparam.widthPadding),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: isSelected ? 2 : 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(icon),
          SizedBox(
            width: Gparam.widthPadding / 2,
          ),
          Text(
            description ?? 'description',
            style: Gtheme.textNormal,
          ),
        ],
      ),
    );
  }
}

class GoalItem extends StatelessWidget {
  final TrackGoal trackGoal;
  final bool isSelected;
  GoalItem({
    @required this.trackGoal,
    this.isSelected = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Gparam.widthPadding / 3, right: Gparam.widthPadding / 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: isSelected ? 2 : 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            child: CachedNetworkImage(
              imageUrl: trackGoal.icon_url,
            ),
          ),
          SizedBox(
            width: Gparam.widthPadding / 4,
          ),
          Text(
            trackGoal.goal_name ?? 'goal name',
            style: Gtheme.textNormal.copyWith(fontSize: Gparam.textExtraSmall),
          ),
        ],
      ),
    );
  }
}
