import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/text_transition.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/interactionPage.dart';

class StackContainerFront extends StatelessWidget {
  const StackContainerFront({
    Key key,
    @required this.downloadingOpacity,
    @required this.widget,
    this.currentItemInDownload,
  }) : super(key: key);

  final double downloadingOpacity;
  final InteractionPage widget;
  final String currentItemInDownload;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: Gparam.height,
      duration: Duration(seconds: 2),
      padding: EdgeInsets.only(top: 40, bottom: 40),
      alignment: Alignment.center,
      curve: Curves.easeOutQuint,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                duration: Duration(seconds: 2),
                curve: Curves.easeOutQuint,
                opacity: downloadingOpacity,
                child: AnimatedContainer(
                  padding: EdgeInsets.all(30),
                  decoration: Gtheme.roundedWhite,
                  duration: Duration(seconds: 1),
                  child: FadeAnimationTB(
                      .9,
                      Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: widget.oldState
                                  ? UserIntroStrings.oldDownloadText
                                  : UserIntroStrings.newDownloadText,
                              style: TextStyle(
                                  fontFamily: 'Milliard',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: UserIntroStrings.waitingText,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Gparam.textSmaller)),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(height: 10),
              AnimatedOpacity(
                duration: Duration(seconds: 2),
                curve: Curves.easeOutQuint,
                opacity: downloadingOpacity,
                child: FadeAnimationTB(
                    .9,
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(left: 30.0, right: 30),
                            child: widget.progress > 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Container(
                                              height: 20,
                                              child: LinearProgressIndicator(
                                                backgroundColor:
                                                    Colors.black.withAlpha(20),
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.blueGrey
                                                            .withAlpha(60)),
                                                value: widget.progress,
                                              ))),
                                      SizedBox(height: 10),
                                      Text("loading",
                                          style: TextStyle(
                                              fontFamily: 'Milliard',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black45))
                                    ],
                                  )
                                : Text("",
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black45)),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
