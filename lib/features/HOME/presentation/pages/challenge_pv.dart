import 'package:flutter/material.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/widgets/scratcher/widgets.dart';
import 'package:video_player/video_player.dart';

class ChallengePageView extends StatefulWidget {
  const ChallengePageView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChallengePageViewState();
}

class ChallengePageViewState extends State<ChallengePageView> {
  var pageController = PageController(keepPage: true);
  VideoPlayerController _controller;
  bool challengeAccepted = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/challenges%2FElectricEqualGoa-mobile.mp4?alt=media&token=3d391999-ae12-42bc-9d4f-4a1f982e0be2')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                    child: Scratcher(
                      brushSize: 50,
                      threshold: 20,
                      accuracy: ScratchAccuracy.low,
                      color: Colors.red,
                      onChange: (value) => print("Scratch progress: $value%"),
                      onThreshold: () {
                        setState(() {
                          challengeAccepted = true;
                        });
                      },
                      child: Container(
                        child: Container(
                          height: Gparam.height / 2,
                          width: Gparam.width,
                          alignment: Alignment.center,
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(.7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Post a 10 second video of you doing',
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
                                          color:
                                              Theme.of(context).highlightColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Gparam.textLarge,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (challengeAccepted)
                  MaterialButton(
                      child: Text("Accept the challenge"),
                      onPressed: () {
                        pageController.animateToPage(1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.decelerate);
                      })
              ],
            ),
            Container(
              child: Center(
                child: _controller.value.initialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
              ),
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
}
