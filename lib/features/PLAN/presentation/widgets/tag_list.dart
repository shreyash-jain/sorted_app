import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/progress_goal.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';

class TagListWidget extends StatelessWidget {
  const TagListWidget({
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
                .tags
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
                  .tags[index - 1],
              context);
        },
      ),
    );
  }

  Widget _buildGoalCard(int i, TagModel tag, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Router.navigator.pushNamed(Router.goalPage,
        //     arguments: GoalPageArguments(
        //         thisGoal: goal, planBloc: BlocProvider.of<PlanBloc>(context)));
      },
      child: Hero(
        tag: tag.id.toString(),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        text: "",
                        style: TextStyle(
                            height: 1.3,
                            fontFamily: 'Milliard',
                            fontSize: Gparam.textSmall,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        children: <TextSpan>[
                          TextSpan(
                              text: tag.tag,
                              style: TextStyle(
                                fontFamily: "Milliard",
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
                  Row(
                    children: [
                      SizedBox(width: Gparam.widthPadding / 4),
                      Container(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          text: TextSpan(
                            text: (tag.items).toString(),
                            style: TextStyle(
                                height: 1.1,
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: " tasks",
                                  style: TextStyle(
                                    fontFamily: "Milliard",
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
