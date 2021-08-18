import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/HOME/presentation/fit_info_bloc/fit_info_bloc.dart';
import 'package:sorted/features/HOME/presentation/pep_talk_bloc/pep_talk_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/heading.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/home_classroom_tile.dart';

import 'package:auto_route/auto_route.dart';

class HomePlanner extends StatefulWidget {
  HomePlanner({Key key}) : super(key: key);

  @override
  _HomePlannerState createState() => _HomePlannerState();
}

class _HomePlannerState extends State<HomePlanner> {
  AffirmationBloc affirmationBloc;
  PeptalkBloc pepTalkBloc;
  FitInfoBloc fitInfoBloc;

  @override
  void initState() {
    affirmationBloc = sl<AffirmationBloc>()..add(LoadStories());
    pepTalkBloc = PeptalkBloc(sl())..add(GetPeptalk());
    fitInfoBloc = FitInfoBloc(sl(), sl())..add(GetTrackUrls());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeading(
          heading: "Today",
          subHeading: "Your personalized Fitness planner",
        ),
        Container(
          child: null,
        ),
        HomeDayActivityTile(
          assetPath: 'assets/images/challenges.png',
          title: "Challenge of the day",
          onClick: () {
            context.router.push(ChallengeRouteView());
          },
          subTitle: "Get a new one everyday",
        ),

        BlocProvider(
          create: (_) => affirmationBloc,
          child: BlocBuilder<AffirmationBloc, AffirmationState>(
            builder: (context, state) {
              if (state is LoadedState)
                return Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    HomeDayActivityTile(
                      assetPath: 'assets/images/affirmation.png',
                      title: "Morning affirmations",
                      onClick: () {
                        context.router.push(
                          AffirmationPV(
                              affirmations:
                                  (affirmationBloc.state as LoadedState)
                                      .affirmations,
                              startIndex: 0,
                              outerBloc: affirmationBloc),
                        );
                      },
                      subTitle: "5-10 mins",
                    ),
                  ],
                );
              else
                return Container(
                  height: 0,
                );
            },
          ),
        ),

        BlocProvider(
          create: (context) => pepTalkBloc,
          child: BlocBuilder<PeptalkBloc, PeptalkState>(
            builder: (context, state) {
              if (state is PeptalkLoaded)
                return Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    HomeDayActivityTile(
                      assetPath: 'assets/images/peptalk.png',
                      title: "Today's training Pep talk",
                      subTitle: "1-2 mins",
                      onClick: () {
                        context.router.push(PepTalkPlayer(talk: state.talk));
                      },
                    ),
                  ],
                );
              else
                return Container(
                  height: 0,
                );
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),
        HomeDayActivityTile(
          assetPath: 'assets/images/wplan.png',
          title: "My workout plan",
          subTitle: "All day",
          onClick: () {
            context.router.push(ActivityPlanView());
          },
        ),
        SizedBox(
          height: 12,
        ),
        HomeDayActivityTile(
          assetPath: 'assets/images/dplan.png',
          title: "My diet plan",
          subTitle: "All Day",
          onClick: () {
            context.router.push(DietPlanView());
          },
        ),

        BlocProvider(
          create: (context) => fitInfoBloc,
          child: BlocBuilder<FitInfoBloc, FitInfoState>(
            builder: (context, state) {
              if (state is FitInfoLoaded)
                return Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    HomeDayActivityTile(
                      assetPath: 'assets/images/info.png',
                      title: "Fitness Tip of the day",
                      subTitle: "2-5 mins",
                      onClick: () {
                        context.router.push(FitInfoPV(
                            trackModel: state.track, summary: state.summary));
                      },
                    ),
                  ],
                );
              else
                return Container(
                  height: 0,
                );
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),

        // Padding(
        //   padding: EdgeInsets.all(Gparam.widthPadding),
        //   child: HomeClassRoomTile(
        //     classroom: ClassModel(
        //       id: "hss",
        //       name: "Evening Yog Nindra",
        //       description: "",
        //       shareId: 84521,
        //       type: 1,
        //       hasTimeTable: 1,
        //       timeTableWeekdays: "Mon,Wed,Fri",
        //       topics: "Yog Nindra",
        //     ),
        //     time: "Today at 7 PM",
        //   ),
        // )
      ],
    );
  }
}

class HomeDayActivityTile extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subTitle;
  final Function() onClick;
  const HomeDayActivityTile({
    Key key,
    this.assetPath,
    this.title,
    this.subTitle,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClick != null) onClick();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: AssetImage(assetPath),
                width: Gparam.width / 6,
                height: Gparam.width / 6,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gtheme.stext(title, size: GFontSize.S, weight: GFontWeight.B),
                SizedBox(
                  height: 6,
                ),
                Gtheme.stext(subTitle,
                    size: GFontSize.XXXS, weight: GFontWeight.N),
              ],
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
