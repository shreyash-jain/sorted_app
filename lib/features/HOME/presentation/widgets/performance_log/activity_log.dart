import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/CONNECT/presentation/workout/activity_tile_view.dart';
import 'package:sorted/features/HOME/presentation/home_stories_bloc/home_stories_bloc.dart';
import 'package:sorted/features/HOME/presentation/track_log_bloc/track_log_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/widgets/activity_log_view.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/widgets/activity_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/search_bars/activity_search_bar.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_data.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_property_data.dart';

class ActivityLogPage extends StatefulWidget {
  final HomeStoriesBloc homeBloc;
  final ActivityLogSummary summary;
  ActivityLogPage({Key key, this.homeBloc, this.summary}) : super(key: key);

  @override
  _ActivityLogPageState createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  PerformanceLogBloc performanceLogBloc;

  @override
  void initState() {
    performanceLogBloc =
        PerformanceLogBloc(sl(), homeStoriesBloc: widget.homeBloc)
          ..add(LoadActivityStory(widget.summary));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(children: [
            BlocProvider(
              create: (context) => performanceLogBloc,
              child: BlocBuilder<PerformanceLogBloc, PerformanceLogState>(
                builder: (context, state) {
                  if (state is ActivityLogLoaded)
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.all(Gparam.widthPadding),
                            child: Row(
                              children: [
                                Gtheme.stext("Cal burnt today  ",
                                    size: GFontSize.S, weight: GFontWeight.N),
                                Gtheme.stext(
                                    state.totalCalBurntToday.toString(),
                                    size: GFontSize.L,
                                    weight: GFontWeight.B2),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey),
                          ...state.todayActivities
                              .asMap()
                              .entries
                              .map((e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gparam.widthPadding,
                                        vertical: 8),
                                    child: ActivityLogView(workout: e.value),
                                  ))
                        ],
                      ),
                    );
                  else if (state is PerformanceLogError) {
                    return MessageDisplay(message: state.message);
                  } else if (state is PerformanceLogInitial) {
                    return Center(
                      child: LoadingWidget(),
                    );
                  } else
                    return Container(
                      height: 0,
                    );
                },
              ),
            ),
            ActivitySearchBar(onActivitySelect: onActivitySelect)
          ]),
        ),
      ),
    );
  }

  onActivitySelect(ActivityModel p1) {
    print("print activity ${p1.exercise_name}");
    showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context, p1));
  }

  Widget _buildPopupDialog(BuildContext context, ActivityModel activity) {
    WorkoutModel workout = WorkoutModel(
        activity: activity,
        activityType: activity.is_yoga,
        sequence: [],
        restTime: []);

    return StatefulBuilder(builder: (context, setPopupState) {
      return new AlertDialog(
        insetPadding: EdgeInsets.all(24),
        contentPadding: EdgeInsets.all(20),
        title: Column(
          children: [
            Gtheme.stext('Activity Log'),
            Divider(
              color: Colors.grey,
            )
          ],
        ),
        content: Container(
          height: 300,
          width: double.maxFinite,
          child: Column(
            children: [
              ActivityTile(
                workout: workout,
                addSet: (w) {
                  print("shreyash");
                  setPopupState(() {
                    if (w.activityType == 0)
                      w.sequence.add(12);
                    else
                      w.sequence.add(5);
                    workout = w;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  ActivityLog newLog = ActivityLog(
                      id: DateTime.now().microsecondsSinceEpoch,
                      activityId: workout.activity.id,
                      time: DateTime.now(),
                      reps: (workout.activityType == 0)
                          ? (workout.sequence.length * 12).toString()
                          : (workout.sequence.length * 5).toString(),
                      caloriesBurnt: (workout.sequence.length *
                              workout.activity.calorie_burn)
                          .toInt());

                  performanceLogBloc
                      .add(AddActivityLog(newLog, workout.activity));

                  Navigator.of(context).pop();
                },
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Gtheme.stext("SAVE", color: GColors.W),
              )
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
        ],
      );
    });
  }
}
