import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/fade_animationLR.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_tab_tile.dart';

class SideTab extends StatelessWidget {
  const SideTab({
    Key key,
    @required this.currentSideTab,
    @required this.isNavEnabled,
    @required this.onTapAction,
  }) : super(key: key);

  final int currentSideTab;
  final bool isNavEnabled;
  final Function(int index) onTapAction;

  @override
  Widget build(BuildContext context) {
    return FadeAnimationLR(
        1.8,
        Padding(
          padding: EdgeInsets.only(top: (66), bottom: (Gparam.height * 0.0833)),
          child: Container(
            width: Gparam.width / 8,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SideTabTile(
                    currentSideTab: currentSideTab,
                    isNavEnabled: isNavEnabled,
                    tabName: "Analyse",
                    description:
                        "The one where you choose and analyse what you want to keep track of",
                    index: 0,
                    onTapAction: onTapAction),
                SizedBox(
                  height: Gparam.heightPadding * 2,
                ),
                SideTabTile(
                    currentSideTab: currentSideTab,
                    isNavEnabled: isNavEnabled,
                    tabName: "Plan",
                    description: "The one where planning starts and your ToDos",
                    index: 1,
                    onTapAction: onTapAction),
                SizedBox(
                  height: Gparam.heightPadding * 2,
                ),
                SideTabTile(
                    currentSideTab: currentSideTab,
                    isNavEnabled: isNavEnabled,
                    tabName: "Notes",
                    description: "The one where your organized notes are kept",
                    index: 2,
                    onTapAction: onTapAction),
                SizedBox(
                  height: Gparam.heightPadding * 2,
                ),
                SideTabTile(
                    currentSideTab: currentSideTab,
                    isNavEnabled: isNavEnabled,
                    tabName: "Expenses",
                    description: "The one where you manage your expenses",
                    index: 3,
                    onTapAction: onTapAction),
                SizedBox(
                  height: Gparam.heightPadding * 2,
                ),
                SideTabTile(
                    currentSideTab: currentSideTab,
                    isNavEnabled: isNavEnabled,
                    tabName: "Journel",
                    description:
                        "The one where data is analysed and shown in best form",
                    index: 4,
                    onTapAction: onTapAction),
              ],
            ),
          ),
        ));
  }
}
