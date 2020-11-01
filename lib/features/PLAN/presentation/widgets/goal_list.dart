import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/progress_goal.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';

class GoalListWidget extends StatelessWidget {
  const GoalListWidget({
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
                .goals
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
                  .goals[index - 1],
              context);
        },
      ),
    );
  }

  Widget _buildGoalCard(int i, GoalModel goal, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Router.navigator.pushNamed(Router.goalPage,
            arguments: GoalPageArguments(
                thisGoal: goal, planBloc: BlocProvider.of<PlanBloc>(context)));
      },
      child: Hero(
        tag: goal.id.toString(),
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
              if (goal.coverImageId != "0")
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          (Theme.of(context).brightness == Brightness.dark)
                              ? BlendMode.lighten
                              : BlendMode.multiply,
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                          imageUrl: goal.coverImageId,
                          fit: BoxFit.cover,
                          width: 170.0,
                          height: 125,
                        ))),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        text: (goal.goalImageId != "0")
                            ? goal.goalImageId + " "
                            : "",
                        style: TextStyle(
                            height: 1.3,
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textSmall,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        children: <TextSpan>[
                          TextSpan(
                              text: goal.title,
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
                  SizedBox(
                    height: Gparam.heightPadding / 2,
                  ),
                  CircleProgressBar(
                    radius: 85.0,
                    dotColor: Theme.of(context).scaffoldBackgroundColor,
                    dotEdgeColor: Theme.of(context).scaffoldBackgroundColor,
                    shadowColor: Colors.black,
                    ringColor: Colors.white24,
                    dotRadius: 0,
                    shadowWidth: 2.0,
                    progress: goal.progress,
                    progressChanged: (value) {},
                  ),
                  Row(
                    children: [
                      SizedBox(width: Gparam.widthPadding / 4),
                      Container(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          text: TextSpan(
                            text: (goal.progress * 100).floor().toString(),
                            style: TextStyle(
                                height: 1.1,
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "% tasks complete",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Gparam.textVerySmall,
                                  )),
                            ],
                          ),
                        ),
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
}
