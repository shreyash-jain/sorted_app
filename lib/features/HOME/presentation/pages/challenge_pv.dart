import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/challenge_bloc/home_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/aim_reach_page.dart';
import 'package:sorted/features/HOME/presentation/widgets/rocket_animation/animated_rocket.dart';
import 'package:sorted/features/HOME/presentation/widgets/scratcher/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:auto_route/auto_route.dart';

class ChallengePageView extends StatefulWidget {
  const ChallengePageView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChallengePageViewState();
}

class ChallengePageViewState extends State<ChallengePageView>
    with TickerProviderStateMixin {
  var pageController = PageController(keepPage: true);

  bool challengeAccepted = false;
  AnimationController rocketController, steamController, scaleController;
  Animation<double> rocketAnimation, steamAnimation, scaleAnimation;
  Animation<double> onCompletionAnimation;
  String challengeStatus = "Mark as Done ?";
  ChallengeBloc challengeBloc;
  void openGoalCompletedPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: GoalCompletedPopup(
            text: "Yay!! Lets keep the streak ON!",
            title: "Challenge Completed",
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fconfetti.png?alt=media&token=78f77117-ff3b-4ff2-8f10-415d8c482587",
          ));
        });
  }

  @override
  void initState() {
    // Rocket animation
    challengeBloc = ChallengeBloc(sl());
    scaleController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              // context.router.pop();
              // context.router.push(
              //   VideoRoute(),
              // );
              openGoalCompletedPopup(context);
              setState(() {
                challengeStatus = "Challenge Completed";
              });
            }
          });
    scaleAnimation = Tween<double>(begin: 0.0, end: 1000.0).animate(
        CurvedAnimation(curve: Curves.easeInOutQuart, parent: scaleController));
    rocketController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    final CurvedAnimation curve =
        CurvedAnimation(parent: rocketController, curve: Curves.easeInOut);

    rocketAnimation = Tween(begin: 30.0, end: 0.0).animate(curve);

    rocketAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rocketController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        rocketController.forward();
      }
    });

    rocketController.forward();

    // Steam animation
    steamController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    final CurvedAnimation curveSteam =
        CurvedAnimation(parent: steamController, curve: Curves.linear);

    steamAnimation = Tween(begin: 55.0, end: 78.0).animate(curveSteam);
    steamController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    rocketController.dispose();
    steamController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return BlocProvider(
        create: (context) => challengeBloc..add(GetTodayChallenge()),
        child: BlocBuilder<ChallengeBloc, ChallengeState>(
          builder: (context, state) {
            if (state is ChallengeLoaded)
              return Center(
                  child: Container(
                width: Gparam.width,
                height: Gparam.height,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: Gparam.heightPadding,
                        ),
                        Container(
                          child: RichText(
                            text: TextSpan(
                              text: 'Scratch the ',
                              style: TextStyle(
                                  fontFamily: 'Milliard',
                                  fontSize: Gparam.textSmall,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .highlightColor
                                      .withOpacity(.8)),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'card',
                                    style: TextStyle(
                                      fontFamily: "Milliard",
                                      color: Theme.of(context).highlightColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Gparam.textMedium,
                                    )),
                                TextSpan(
                                    text: ' to know',
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .highlightColor
                                            .withOpacity(.8))),
                                TextSpan(
                                    text: '\nToday\'s challenge',
                                    style: TextStyle(
                                      fontFamily: "Milliard",
                                      color: Theme.of(context).highlightColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Gparam.textMedium,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Gparam.heightPadding,
                        ),
                        Container(
                          padding: const EdgeInsets.all(18.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  AnimatedOpacity(
                                    duration: Duration(seconds: 1),
                                    opacity: (challengeAccepted) ? 1 : 0,
                                    curve: Curves.decelerate,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedBuilder(
                                            animation: scaleAnimation,
                                            builder: (context, child) =>
                                                Transform.translate(
                                                    offset: Offset(
                                                        0.0,
                                                        120 +
                                                            scaleAnimation.value
                                                                    .abs() *
                                                                -1),
                                                    child: Transform.scale(
                                                      scale: 1 +
                                                          (scaleAnimation
                                                                  .value) /
                                                              500,
                                                      child: Container(
                                                          alignment: Alignment(
                                                              0.0, -1.0),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 0),
                                                          child: AnimatedSteam(
                                                            animation:
                                                                steamAnimation,
                                                          )),
                                                    ))),
                                        AnimatedBuilder(
                                            animation: scaleAnimation,
                                            builder: (context, child) =>
                                                Transform.translate(
                                                    offset: Offset(
                                                        0.0,
                                                        scaleAnimation.value
                                                                .abs() *
                                                            -1),
                                                    child: Transform.scale(
                                                      scale: 1 +
                                                          (scaleAnimation
                                                                  .value) /
                                                              500,
                                                      child: Container(
                                                        alignment: Alignment(
                                                            0.0, -1.0),
                                                        padding: EdgeInsets.only(
                                                            top: Gparam.height /
                                                                5),
                                                        child: AnimatedRocket(
                                                          animation:
                                                              rocketAnimation,
                                                        ),
                                                      ),
                                                    ))),
                                        Container(
                                          height: Gparam.width,
                                          width: Gparam.width,
                                          alignment: Alignment.center,
                                          decoration: new BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: state.challenge.name,
                                                  style: TextStyle(
                                                      fontFamily: 'Milliard',
                                                      fontSize:
                                                          Gparam.textSmall,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .highlightColor
                                                          .withOpacity(.8)),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: '\n\n' +
                                                            ("Fitness Challenge of the day \n"),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Milliard",
                                                          color: Theme.of(
                                                                  context)
                                                              .highlightColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              Gparam.textSmall,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              MaterialButton(
                                                  color: Theme.of(context)
                                                      .highlightColor,
                                                  child: Text(
                                                    challengeStatus,
                                                    style: TextStyle(
                                                      fontFamily: 'Milliard',
                                                      fontSize: 18.0,
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (challengeStatus !=
                                                          "Challenge Completed")
                                                        scaleController
                                                            .forward();
                                                    });
                                                  })
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!challengeAccepted)
                                    AnimatedOpacity(
                                      duration: Duration(milliseconds: 200),
                                      opacity: (challengeAccepted) ? 0 : 1,
                                      curve: Curves.linear,
                                      child: Scratcher(
                                        brushSize: 50,
                                        threshold: 50,
                                        image: Image.asset(
                                          "assets/images/scratch_card.png",
                                          fit: BoxFit.cover,
                                          width: Gparam.width,
                                          height: Gparam.width,
                                        ),
                                        accuracy: ScratchAccuracy.low,
                                        color: Colors.white,
                                        onChange: (value) =>
                                            print("Scratch progress: %"),
                                        onThreshold: () {
                                          setState(() {
                                            challengeAccepted = true;
                                          });
                                        },
                                        child: Container(
                                          child: Container(
                                            height: Gparam.width,
                                            width: Gparam.width,
                                            alignment: Alignment.center,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor
                                                .withOpacity(.7),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    text: state.challenge.name,
                                                    style: TextStyle(
                                                        fontFamily: 'Milliard',
                                                        fontSize:
                                                            Gparam.textSmall,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Theme.of(context)
                                                            .highlightColor
                                                            .withOpacity(.8)),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: '\n',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Milliard",
                                                            color: Theme.of(
                                                                    context)
                                                                .highlightColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: Gparam
                                                                .textLarge,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                MaterialButton(
                                                    color: Theme.of(context)
                                                        .highlightColor,
                                                    child: Text(
                                                      " ?",
                                                      style: TextStyle(
                                                        fontFamily: 'Milliard',
                                                        fontSize: 18.0,
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    onPressed: () {})
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
            else if (state is ChallengeInitial)
              return Center(
                child: LoadingWidget(),
              );
            else
              return Container(
                height: 0,
              );
          },
        ),
      );
    }));
  }

  onError() {}
}
