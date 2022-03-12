import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/CONNECT/presentation/workout/day_workout_tile.dart';
import 'package:sorted/features/CONNECT/presentation/workout_plan_bloc/workout_plan_bloc.dart';
import 'package:sorted/features/PLANNER/data/models/workout_plan.dart';

class ActivityPlanView extends StatefulWidget {
  ActivityPlanView({Key key}) : super(key: key);

  @override
  _ActivityPlanViewState createState() => _ActivityPlanViewState();
}

class _ActivityPlanViewState extends State<ActivityPlanView> {
  WorkoutPlanBloc workoutPlanBloc;
  int selectedDay = 0;
  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now().weekday - 1;

    workoutPlanBloc = WorkoutPlanBloc(sl(), sl(), sl())
      ..add(GetRecommendedWorkoutPlan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => workoutPlanBloc,
            child: BlocBuilder<WorkoutPlanBloc, WorkoutPlanState>(
              builder: (context, state) {
                if (state is WorkoutPlanLoaded)
                  return Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding, vertical: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Gtheme.stext("My Workout Plan",
                              size: GFontSize.S, weight: GFontWeight.B2),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 30,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: Gparam.widthPadding,
                          ),
                          ...state.workoutEntity.dayWorkouts
                              .asMap()
                              .entries
                              .map((e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedDay = e.key;
                                      });
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(right: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 3.0,
                                                color: (selectedDay == e.key)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey.shade300),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Gtheme.stext(e.value.daySubTitle,
                                            size: GFontSize.M,
                                            weight: GFontWeight.B2)),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    if (state.workoutEntity.dayWorkouts[selectedDay] != null)
                      DayActivityWidget(
                          dayWorkout:
                              state.workoutEntity.dayWorkouts[selectedDay])
                  ]);
                else if (state is WorkoutPlanInitial)
                  return Center(child: LoadingWidget());
                else
                  return Container(
                    height: 0,
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
