import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/widgets/camera_video/cam_recorder.dart';
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
  VideoPlayerController _video_controller;
  bool challengeAccepted = false;
  AnimationController rocketController, steamController, scaleController;
  Animation<double> rocketAnimation, steamAnimation, scaleAnimation;
  Animation<double> onCompletionAnimation;

  @override
  void initState() {
    _video_controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/challenges%2FElectricEqualGoa-mobile.mp4?alt=media&token=3d391999-ae12-42bc-9d4f-4a1f982e0be2')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    // Rocket animation

    scaleController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              pageController.animateToPage(1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linearToEaseOut);
              setState(() {
                _video_controller.play();
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
    _video_controller.dispose();
    rocketController.dispose();
    steamController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
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
                          fontFamily: 'Montserrat',
                          fontSize: Gparam.textSmall,
                          fontWeight: FontWeight.w500,
                          color:
                              Theme.of(context).highlightColor.withOpacity(.8)),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'card',
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w500,
                              fontSize: Gparam.textMedium,
                            )),
                        TextSpan(
                            text: ' to know',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmall,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .highlightColor
                                    .withOpacity(.8))),
                        TextSpan(
                            text: '\nToday\'s challenge',
                            style: TextStyle(
                              fontFamily: "Montserrat",
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
                      color: Colors.lightBlue,
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
                                                    scaleAnimation.value.abs() *
                                                        -1),
                                            child: Transform.scale(
                                              scale: 1 +
                                                  (scaleAnimation.value) / 500,
                                              child: Container(
                                                  alignment:
                                                      Alignment(0.0, -1.0),
                                                  padding:
                                                      EdgeInsets.only(top: 0),
                                                  child: AnimatedSteam(
                                                    animation: steamAnimation,
                                                  )),
                                            ))),
                                AnimatedBuilder(
                                    animation: scaleAnimation,
                                    builder: (context, child) =>
                                        Transform.translate(
                                            offset: Offset(
                                                0.0,
                                                scaleAnimation.value.abs() *
                                                    -1),
                                            child: Transform.scale(
                                              scale: 1 +
                                                  (scaleAnimation.value) / 500,
                                              child: Container(
                                                alignment: Alignment(0.0, -1.0),
                                                padding: EdgeInsets.only(
                                                    top: Gparam.height / 5),
                                                child: AnimatedRocket(
                                                  animation: rocketAnimation,
                                                ),
                                              ),
                                            ))),
                                Container(
                                  height: Gparam.width,
                                  width: Gparam.width,
                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .highlightColor
                                            .withOpacity(.8),
                                      )),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text:
                                              'Post a 10 second video of you doing',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textSmall,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .highlightColor
                                                  .withOpacity(.8)),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '\nPlank',
                                                style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  color: Theme.of(context)
                                                      .highlightColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Gparam.textLarge,
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      MaterialButton(
                                          color:
                                              Theme.of(context).highlightColor,
                                          child: Text(
                                            "Accept the challenge ?",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 18.0,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              scaleController.forward();
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
                                color: Colors.grey,
                                onChange: (value) =>
                                    print("Scratch progress: $value%"),
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
                                            text:
                                                'Post a 10 second video of you doing',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: Gparam.textSmall,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .highlightColor
                                                    .withOpacity(.8)),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '\nPlank',
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    color: Theme.of(context)
                                                        .highlightColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Gparam.textLarge,
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
                                              "Accept the challenge ?",
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 18.0,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              textAlign: TextAlign.center,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: _video_controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _video_controller.value.aspectRatio,
                            child: VideoPlayer(_video_controller),
                          )
                        : Container(),
                  ),
                ),
                MaterialButton(
                    child: Text("Learn how to do plank"),
                    onPressed: () {
                      setState(() {
                        _video_controller.value.isPlaying
                            ? _video_controller.pause()
                            : _video_controller.play();
                      });
                    }),
                MaterialButton(
                    child: Text("Start Recording"),
                    onPressed: () {
                      context.router.pop();
                      context.router.push(
                        VideoRoute(),
                      );
                    })
              ],
            ),
            Container(
              child: Center(
                  child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withOpacity(.5),
                    BlendMode.softLight),
                child: Image(
                  image: AssetImage(
                    "assets/images/smartGoal3.png",
                  ),
                  width: Gparam.width,
                  height: Gparam.height,
                ),
              )),
            ),
            Container(
              child: Center(
                  child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withOpacity(.5),
                    BlendMode.softLight),
                child: Image(
                  image: AssetImage(
                    "assets/images/smartGoal4.png",
                  ),
                  width: Gparam.width,
                  height: Gparam.height,
                ),
              )),
            ),
            Container(
              child: Center(
                  child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withOpacity(.5),
                    BlendMode.softLight),
                child: Image(
                  image: AssetImage(
                    "assets/images/smartGoal5.png",
                  ),
                  width: Gparam.width,
                  height: Gparam.height,
                ),
              )),
            ),
            Container(
              child: Center(
                  child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withOpacity(.5),
                    BlendMode.softLight),
                child: Image(
                  image: AssetImage(
                    "assets/images/smartGoal6.png",
                  ),
                  width: Gparam.width,
                  height: Gparam.height,
                ),
              )),
            ),
            Container(
              child: Center(
                  child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withOpacity(.5),
                    BlendMode.softLight),
                child: Image(
                  image: AssetImage(
                    "assets/images/smartGoal7.png",
                  ),
                  width: Gparam.width,
                  height: Gparam.height,
                ),
              )),
            ),
          ],
        ),
      ));
    }));
  }

  onError() {}
}
