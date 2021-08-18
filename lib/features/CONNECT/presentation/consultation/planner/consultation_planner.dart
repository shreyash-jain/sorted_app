import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/widgets/day_diet_tile.dart';
import 'package:sorted/features/CONNECT/presentation/diet_plan_bloc/diet_plan_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/workout/day_workout_tile.dart';
import 'package:sorted/features/CONNECT/presentation/workout_plan_bloc/workout_plan_bloc.dart';

class ConsultationPlanner extends StatefulWidget {
  final ClientConsultationModel consultation;
  ConsultationPlanner({Key key, this.consultation}) : super(key: key);

  @override
  _ConsultationPlannerState createState() => _ConsultationPlannerState();
}

class _ConsultationPlannerState extends State<ConsultationPlanner>
    with AutomaticKeepAliveClientMixin<ConsultationPlanner> {
  DietPlanBloc dietPlanBloc;
  WorkoutPlanBloc workoutPlanBloc;

  @override
  void initState() {
    print("hello");
    dietPlanBloc = new DietPlanBloc(sl(), sl(), sl());
    workoutPlanBloc = new WorkoutPlanBloc(sl(), sl(), sl());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<DietPlanBloc>(
            create: (BuildContext context) =>
                dietPlanBloc..add(LoadCurrentDietPlan(widget.consultation)),
          ),
          BlocProvider<WorkoutPlanBloc>(
            create: (BuildContext context) => workoutPlanBloc
              ..add(LoadCurrentConsultationWorkoutPlan(widget.consultation)),
          ),
        ],
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                BlocBuilder<DietPlanBloc, DietPlanState>(
                    builder: (context, state) {
                  if (state is DietPlanLoaded)
                    return Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding, vertical: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Gtheme.stext("Diet Plan",
                                size: GFontSize.S, weight: GFontWeight.B2),
                          ],
                        ),
                      ),
                      ...state.planEntitiy.dayDiets
                          .asMap()
                          .entries
                          .map((e) => DayDietWidget(dayDiet: e.value))
                          .toList(),
                    ]);
                  else if (state is DietPlanEmpty) {
                    return Container(
                        padding: EdgeInsets.all(Gparam.widthPadding),
                        child: Column(
                          children: [
                            Gtheme.stext("No Diet plan assigned to you"),
                          ],
                        ));
                  } else if (state is DietPlanInitial)
                    return Container(
                        height: 50, child: Center(child: LoadingWidget()));
                  else
                    return Container(
                      height: 0,
                    );
                }),
                Divider(
                  color: Colors.grey,
                ),
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
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
