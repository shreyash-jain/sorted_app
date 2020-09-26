import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/widgets/bottom_tab_tile.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({
    Key key,
    @required this.currentBottomTab,
    @required this.onTapAction,
  }) : super(key: key);

  final int currentBottomTab;
  final Function(int index) onTapAction;

  @override
  Widget build(BuildContext context) {
    return FadeAnimationTB(
        1.8,
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                    height: Gparam.width / 8,
                    width: 7.6 * Gparam.width / 8,
                    curve: Curves.easeOutQuad,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black.withAlpha(40),
                            blurRadius: 30)
                      ],
                      borderRadius: new BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(0)),
                      gradient: new LinearGradient(
                          colors: [
                            Color.fromARGB(255, 240, 240, 240),
                            Color.fromARGB(255, 240, 240, 240),
                          ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          stops: [1.0, 0.0],
                          tileMode: TileMode.clamp),
                    ),
                    duration: Duration(milliseconds: 400),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BottomTabTile(
                          currentBottomTab: currentBottomTab,
                          index: 0,
                          tabName: "Home",
                          imagePath: "assets/images/homePage.png",
                          imagePath2: "assets/images/homeSelect.png",
                          onTapAction: (int index) {
                            onTapAction(index);
                          },
                        ),
                        BottomTabTile(
                            currentBottomTab: currentBottomTab,
                            index: 1,
                            tabName: "Profile",
                            imagePath: "assets/images/profile.png",
                             onTapAction: (int index) {
                            onTapAction(index);
                          },
                            imagePath2:
                                "assets/images/profileSelect.png"),
                        BottomTabTile(
                            currentBottomTab: currentBottomTab,
                            index: 2,
                            tabName: "Notifications",
                             onTapAction: (int index) {
                            onTapAction(index);
                          },
                            imagePath:
                                "assets/images/notificationTab.png",
                            imagePath2:
                                "assets/images/notificationTabSelect.png"),
                        BottomTabTile(
                                                            currentBottomTab: currentBottomTab,
                                                            index: 3,
                                                            tabName: "Milestones",
                                                             onTapAction: (int index) {
                                                            onTapAction(index);
                                                          },
                                                            imagePath: "assets/images/mission.png",
                                                            imagePath2:
                                                                "assets/images/missionSelect.png"),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ));
  }
}
                           