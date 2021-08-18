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
  @override
  void initState() {
    super.initState();
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
                    Padding(
                      padding: EdgeInsets.all(Gparam.widthPadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Gtheme.stext("Workout Plan",
                              size: GFontSize.S, weight: GFontWeight.B2),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    ...state.workoutEntity.dayWorkouts
                        .asMap()
                        .entries
                        .map((e) => DayActivityWidget(dayWorkout: e.value))
                        .toList(),
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
