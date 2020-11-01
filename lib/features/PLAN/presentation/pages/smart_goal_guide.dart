import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';

class SmartGoalGuide extends StatefulWidget {
  const SmartGoalGuide({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SmartGoalGuideState();
}

class SmartGoalGuideState extends State<SmartGoalGuide> {
  var pageController = PageController(keepPage: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        color: Theme.of(context).primaryColor,
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          children: [
            Container(
              child: Center(
                  child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor.withOpacity(.5),
                  BlendMode.softLight
                ),
                child: Image(
                  image: AssetImage(
                    "assets/images/smartGoal1.png",
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
                  BlendMode.softLight
                ),
                child: Image(
                  image: AssetImage(
                    "assets/images/smartGoal2.png",
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
                  BlendMode.softLight
                ),
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
                  BlendMode.softLight
                ),
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
                                   BlendMode.softLight

                ),
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
                  BlendMode.softLight
                ),
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
                  BlendMode.softLight
                ),
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
