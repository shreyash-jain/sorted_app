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
          padding: EdgeInsets.only(top: Gparam.heightPadding*2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                height: Gparam.height / 1.15,
                width: isNavEnabled
                    ? Gparam.width / 2
                    :  Gparam.width / 10,
                curve: Curves.easeInOutCubic,
                decoration: BoxDecoration(
                  color: (Theme.of(context).brightness==Brightness.light)?Color.fromARGB(255, 240, 240, 240):Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                ),
                duration: Duration(milliseconds: 400),
              ),
            ],
          ),
        ));
  }
}