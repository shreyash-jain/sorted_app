import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/interactionPage.dart';

class StackConatinerBack extends StatelessWidget {
  const StackConatinerBack({
    Key key,
    @required this.imageAlignment,
    @required this.widget,
    @required this.scaleAnimation,
    @required this.greetingOpacity,
  }) : super(key: key);

  final Alignment imageAlignment;
  final InteractionPage widget;
  final Animation<double> scaleAnimation;

  final double greetingOpacity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        height: Gparam.height,
        duration: Duration(seconds: 2),
        padding:
            EdgeInsets.only(top: Gparam.topPadding, bottom: Gparam.topPadding),
        alignment: imageAlignment,
        curve: Curves.easeOutQuint,
        
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: Gparam.heightPadding * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.userDetail.imageUrl != null && Gparam.isHeightBig)
                  AnimatedBuilder(
                      animation: scaleAnimation,
                      builder: (context, child) => Transform.scale(
                          scale: scaleAnimation.value,
                          child: FadeAnimationTB(
                            .8,
                            Hero(
                                tag: UserIntroStrings.userImageTag,
                                child: Container(
                                  height: Gparam.height / 10,
                                  width: Gparam.height / 10,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Colors.black12,
                                          width: 3 / scaleAnimation.value),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(right: 0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              widget.userDetail.imageUrl,
                                            ),
                                            radius: Gparam.height / 25,
                                            backgroundColor: Colors.transparent,
                                          ))
                                    ],
                                  ),
                                )),
                          ))),
                if (widget.userDetail.imageUrl != null && Gparam.isHeightBig)
                  SizedBox(height: 10),
                AnimatedOpacity(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeOutQuint,
                  opacity: greetingOpacity,
                  child: FadeAnimationTB(
                      .9,
                      RichText(
                        text: TextSpan(
                          text: widget.oldState
                              ? UserIntroStrings.oldGreeting
                              : UserIntroStrings.newGreeting,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60),
                          children: <TextSpan>[
                            TextSpan(
                                text: '\n${widget.userDetail.name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
