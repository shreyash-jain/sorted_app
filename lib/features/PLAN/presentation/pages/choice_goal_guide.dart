import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/indicator_oval.dart';
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:auto_route/auto_route.dart';

class ChoiceGoalGuide extends StatefulWidget {
  const ChoiceGoalGuide({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChoiceGoalGuideState();
}

class ChoiceGoalGuideState extends State<ChoiceGoalGuide> {
  var pageController = PageController(keepPage: true);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 7; i++) {
      list.add(i == _currentPage
          ? IndicatorOval(isActive: true)
          : IndicatorOval(isActive: false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Center(
                child: Container(
              width: Gparam.width,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).primaryColor,
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  Container(
                    child: Center(
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).primaryColor.withOpacity(.5),
                                BlendMode.softLight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(12.0)),
                                    // border: Border.all(
                                    //     color: Theme.of(context)
                                    //         .scaffoldBackgroundColor.withOpacity(.1),
                                    //         width: 5),
                                  ),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      text: "Lets start",
                                      style: TextStyle(
                                          fontFamily: 'Lemonmilk',
                                          fontSize: Gparam.textMedium,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "\nPlanning !",
                                            style: TextStyle(
                                              fontFamily: "Lemonmilk",
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              fontWeight: FontWeight.normal,
                                              fontSize: Gparam.textVeryLarge,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(12.0)),
                                        // border: Border.all(
                                        //     color: Theme.of(context)
                                        //         .scaffoldBackgroundColor.withOpacity(.1),
                                        //         width: 5),
                                      ),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text: "Now add your first",
                                          style: TextStyle(
                                              fontFamily: 'Milliard',
                                              fontSize: Gparam.textSmall,
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "\nGoal",
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: Gparam.textMedium,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(60.0)),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor
                                                .withOpacity(.1),
                                            width: 5),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.forward,
                                          size: 28.0,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          pageController.animateToPage(1,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              curve: Curves.decelerate);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))),
                  ),
                  Container(
                    child: Center(
                        child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor.withOpacity(.5),
                          BlendMode.softLight),
                      child: Image(
                        image: AssetImage(
                          "assets/images/choiseGoal1.png",
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
                          "assets/images/choiseGoal2.png",
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
                          "assets/images/choiseGoal3.png",
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
                          "assets/images/choiseGoal4.png",
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
                          "assets/images/choiseGoal5.png",
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
                          "assets/images/choiseGoal6.png",
                        ),
                        width: Gparam.width,
                        height: Gparam.height,
                      ),
                    )),
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.only(top: 0, right: 0),
              child: Align(
                alignment: FractionalOffset.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildPageIndicator(),
                ),
              ),
            ),
            if (_currentPage == 6)
              InkWell(
                onTap: () {
                  Navigator.pop(context);

                  context.router.push(PlanHome());
                },
                child: Container(
                  margin: EdgeInsets.only(top: 2 * Gparam.height / 3),
                  width: Gparam.width,
                  height: Gparam.height / 3,
                ),
              )
          ],
        );
      }),
    ));
  }
}
