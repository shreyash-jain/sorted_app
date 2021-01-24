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
                                  fontFamily: 'Montserrat',
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
                        if (widget.progress < 1)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              Text(
                                (widget.oldState)
                                    ? UserIntroStrings.oldActionDownloading
                                    : UserIntroStrings.newActionDownloading,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black45,
                                    fontFamily: 'Montserrat'),
                              ),
                              SizedBox(width: 10.0),
                              FadeAnimationTB(
                                  .8,
                                  TextTransition(
                                    text: currentItemInDownload,
                                    width: Gparam.width / 2,
                                    duration: Duration(milliseconds: 200),
                                    textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white60,
                                        fontFamily: 'Montserrat'),
                                  )),
                            ],
                          ),
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
                                              BorderRadius.circular(8),
                                          child: Container(
                                              height: 20,
                                              child: LinearProgressIndicator(
                                                backgroundColor: Colors.black45,
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                                value: widget.progress,
                                              ))),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        decoration: Gtheme.roundedWhite,
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            (widget.progress < 1)
                                                ? Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration:
                                                        new BoxDecoration(
                                                      image:
                                                          new DecorationImage(
                                                        image: new AssetImage(
                                                            UserIntroStrings
                                                                .downloadingPath),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.check,
                                                    color: Colors.black87,
                                                    size: 20,
                                                  ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              '${(widget.progress * 100).round()}%',
                                              style: Gtheme.blackShadowBold28,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Text("",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
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
