import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/ONBOARDING/presentation/constants.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    Key key,
    @required this.imagepath,
    @required this.title,
    @required this.description,
  }) : super(key: key);

  final String imagepath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: ListView(
        
        
        children: <Widget>[
          Align(
            alignment:Alignment.topLeft,
              child: Padding(
              padding: EdgeInsets.only(top: Gparam.height/20,left:40),
              child: FadeAnimationTB(
                0.6,
                Container(
                  child: Image(
                    image: AssetImage(
                      imagepath,
                    ),
                    height: Gparam.height/6,
                    width: Gparam.height/6,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:Gparam.height/40,left:Gparam.width/10,right:Gparam.width/4),
            child: FadeAnimationTB(
                1.8,
                Container(
                    child: Text(
                  title,
                  style: OnboardTextStyle.titleTS,
                ))),
          ),
          Padding(
            padding: EdgeInsets.only(top: Gparam.height/45,left:Gparam.width/10,right:Gparam.width/4),
            child: FadeAnimationTB(
                2.8,
                Container(
                  child: Text(
                    description,
                    style: OnboardTextStyle.descriptionTS,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
