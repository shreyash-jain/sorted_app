import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/fade_animationLR.dart';
import 'package:sorted/core/global/constants/constants.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    Key key,
    @required this.isNavEnabled,
    @required this.currentSideTab,
  }) : super(key: key);

  final bool isNavEnabled;
  final int currentSideTab;

  @override
  Widget build(BuildContext context) {
    return FadeAnimationLR(
        1.8,
        Padding(
          padding: EdgeInsets.only(top: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                height: Gparam.height - 65,
                width: isNavEnabled ? Gparam.width / 2 : Gparam.width / 10,
                curve: Curves.easeInOutCubic,
                // decoration: BoxDecoration(
                //   color: Theme.of(context).scaffoldBackgroundColor,
                //   borderRadius: BorderRadius.only(
                //       topRight: Radius.circular(30.0),
                //       bottomRight: Radius.circular(30.0)),
                // ),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                    
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: [
                          0.1,
                          0.3,
                          0.8,
                          1
                        ])),
                duration: Duration(milliseconds: 400),
              ),
            ],
          ),
        ));
  }
}
