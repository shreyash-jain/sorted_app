import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/progress_goal.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';

class UpcomingTasks extends StatelessWidget {
  const UpcomingTasks({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      alignment: Alignment.bottomLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
                .upComingTasks
                .length +
            1,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(width: Gparam.widthPadding / 2);
          }

          return _buildGoalCard(
              index - 1,
              (BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
                  .upComingTasks[index - 1],
              context);
        },
      ),
    );
  }

  Widget _buildGoalCard(int i, TaskModel task, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Router.navigator.pushNamed(Router.goalPage,
        //     arguments: GoalPageArguments(
        //         thisGoal: goal, planBloc: BlocProvider.of<PlanBloc>(context)));
      },
      child: Hero(
        tag: task.id.toString(),
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(8),
          width: 170.0,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(
              Radius.circular((12)),
            ),
            gradient: new LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(.8),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.00),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        text: TextSpan(
                          text: (task.taskImageId != "0")
                              ? task.taskImageId + " "
                              : "",
                          style: TextStyle(
                              height: 1.3,
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmall,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          children: <TextSpan>[
                            TextSpan(
                                text: task.title,
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: Gparam.textSmall,
                                  fontWeight: FontWeight.w800,
                                )),
                            TextSpan(
                                text: "\n",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: Gparam.textSmall,
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Gparam.heightPadding / 3,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        text: TextSpan(
                          text: pastDeadline(task.deadLine) + "\n",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textVerySmall,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          children: <TextSpan>[
                            TextSpan(
                                text: countdownDays(task.deadLine),
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  height: 1.2,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Gparam.textVerySmall,
                                )),
                            TextSpan(
                                text: countdownDaysUnit(task.deadLine),
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  height: 1.2,
                                  fontWeight: FontWeight.w300,
                                  fontSize: Gparam.textVerySmall,
                                )),
                          ],
                        ),
                      ),
                      Icon(
                        (task.priority > .6)
                            ? Icons.trending_up
                            : (task.priority > .3)
                                ? Icons.trending_flat
                                : Icons.trending_down,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 16,
                      ),
                      SizedBox(
                        width: Gparam.widthPadding / 4,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  countdownDays(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays > 0) {
      if (rDays > 365)
        return (rDays / 356).floor().toString();
      else
        return rDays.toString();
    } else if (rDays < 0) {
      if (rDays < -365)
        return (rDays / -356).floor().toString();
      else
        return rDays.abs().toString();
    } else {
      return deadLine.difference(DateTime.now()).inHours.abs().toString();
    }
  }

  bool isNearDeadline(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays.abs() < 2) {
      return true;
    }
    return false;
  }

  countdownDaysUnit(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays.abs();
    if (rDays > 0) {
      if (rDays > 365) {
        if (rDays / 365 > 1)
          return " years";
        else
          return " year";
      } else {
        if (rDays > 1)
          return " days";
        else
          return " day";
      }
    } else {
      return " hrs";
    }
  }

  pastDeadline(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays > 0) {
      return "Deadline in";
    } else if (rDays < 0) {
      return "Past deadline";
    } else {
      if (deadLine.isAfter(DateTime.now())) {
        return "Deadline in";
      } else
        return "Past deadline";
    }
  }
}
