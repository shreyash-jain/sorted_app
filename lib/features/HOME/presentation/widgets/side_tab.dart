import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/fade_animationLR.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/features/HOME/presentation/widgets/side_tab_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/user_avatar.dart';

class SideTab extends StatelessWidget {
  SideTab({
    Key key,
    @required this.currentSideTab,
    @required this.isNavEnabled,
    @required this.onTapAction,
  }) : super(key: key);

  final int currentSideTab;
  final bool isNavEnabled;
  final Function(int index) onTapAction;
  String user_image = 'assets/images/male1.png';

  @override
  Widget build(BuildContext context) {
    return FadeAnimationLR(
        0.8,
        Padding(
          padding: EdgeInsets.only(
              top: (Gparam.topPadding / 2),),
          child: Stack(
            children: [
              Container(
                width: Gparam.width / 2,
                height: Gparam.height,
                alignment: Alignment.center,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.topLeft,
                        child: UserAvatar(user_image: user_image)),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding / 2),
                        child: Text("Track",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmaller,
                                fontWeight: FontWeight.w800))),
                    Divider(
                      color: Theme.of(context).highlightColor.withAlpha(50),
                    ),
                    SideTabTile(
                        icon: Icons.autorenew,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Introspect",
                        description:
                            "The one where you choose and analyse what you want to keep track of",
                        index: 0,
                        onTapAction: onTapAction),
                    SideTabTile(
                        icon: Icons.date_range,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Plan",
                        description:
                            "The one where planning starts and your ToDos",
                        index: 1,
                        onTapAction: onTapAction),
                    SideTabTile(
                        icon: Icons.note_add,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Record",
                        description:
                            "The one where your organized notes are kept",
                        index: 2,
                        onTapAction: onTapAction),
                    SideTabTile(
                        icon: OMIcons.money,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Expenses",
                        description: "",
                        index: 3,
                        onTapAction: onTapAction),
                    SizedBox(
                      height: Gparam.heightPadding,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding / 2),
                        child: Text("Resolve",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmaller,
                                fontWeight: FontWeight.w800))),
                    Divider(
                      color: Theme.of(context).highlightColor.withAlpha(50),
                    ),
                    SideTabTile(
                        icon: Icons.fitness_center,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Fitness",
                        description:
                            "The one where you choose and analyse what you want to keep track of",
                        index: 0,
                        onTapAction: onTapAction),
                    SideTabTile(
                        icon: Icons.accessibility,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Yoga",
                        description:
                            "The one where planning starts and your ToDos",
                        index: 1,
                        onTapAction: onTapAction),
                    SideTabTile(
                        icon: Icons.adjust,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Meditation",
                        description:
                            "The one where your organized notes are kept",
                        index: 2,
                        onTapAction: onTapAction),
                    SideTabTile(
                        icon: Icons.restaurant,
                        currentSideTab: currentSideTab,
                        isNavEnabled: isNavEnabled,
                        tabName: "Nutrition",
                        description: "",
                        index: 3,
                        onTapAction: onTapAction),
                    
                  ],
                ),
              ),
           
              Container(
                alignment: Alignment.bottomLeft,
                height: Gparam.height,
                width: Gparam.width / 2,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                   width: Gparam.width / 2,
                  child: SideTabTile(
                      icon: Icons.settings,
                      currentSideTab: currentSideTab,
                      isNavEnabled: isNavEnabled,
                      tabName: "Settings",
                      description:
                          "The one where you choose and analyse what you want to keep track of",
                      index: 0,
                      onTapAction: (int) {
                         rt.Router.navigator.pushNamed( rt.Router.settingsPage);
                      }),
                ),
              )
            ],
          ),
        ));
  }
}
