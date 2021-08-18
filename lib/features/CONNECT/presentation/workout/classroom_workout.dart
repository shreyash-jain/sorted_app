import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/CONNECT/presentation/workout/day_workout_tile.dart';
import 'package:sorted/features/CONNECT/presentation/workout_plan_bloc/workout_plan_bloc.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ClassroomWorkout extends StatefulWidget {
  final ClassModel classroom;

  ClassroomWorkout({Key key, this.classroom}) : super(key: key);

  @override
  _ClassroomWorkoutState createState() => _ClassroomWorkoutState();
}

class _ClassroomWorkoutState extends State<ClassroomWorkout>
    with AutomaticKeepAliveClientMixin<ClassroomWorkout> {
  WorkoutPlanBloc workoutPlanBloc;
  ClassModel _classroom;
  @override
  void initState() {
    workoutPlanBloc = new WorkoutPlanBloc(sl(), sl(), sl());
    _classroom = widget.classroom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => workoutPlanBloc
          ..add(LoadCurrentWorkoutPlan(0, classroom: widget.classroom)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<WorkoutPlanBloc, WorkoutPlanState>(
                builder: (context, state) {
                  if (state is WorkoutPlanListState) {
                    return Column(children: [
                      ...state.workoutPlans
                          .asMap()
                          .entries
                          .map((e) => Gtheme.stext(e.value.name))
                          .toList()
                    ]);
                  } else if (state is WorkoutPlanLoaded)
                    return Column(children: [
                      Padding(
                        padding: EdgeInsets.all(Gparam.widthPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Gtheme.stext("Workout Plan",
                                size: GFontSize.S, weight: GFontWeight.B2),
                            Spacer(),
                          ],
                        ),
                      ),
                      ...state.workoutEntity.dayWorkouts
                          .asMap()
                          .entries
                          .map((e) => DayActivityWidget(dayWorkout: e.value))
                          .toList(),
                    ]);
                  else if (state is WorkoutPlanInitial) {
                    return Center(child: LoadingWidget());
                  } else if (state is WorkoutPlanError) {
                    return MessageDisplay(message: state.message);
                  } else if (state is WorkoutPlanEmpty) {
                    return Container(
                        padding: EdgeInsets.all(Gparam.widthPadding),
                        child: Column(
                          children: [
                            Gtheme.stext(
                                "No Workout plan assigned to your class"),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ));
                  } else
                    return Container(
                      height: 0,
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
