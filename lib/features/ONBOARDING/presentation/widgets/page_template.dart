import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sorted/core/global/animations/fade_animation.dart';
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
              padding: EdgeInsets.only(top: Gstrings.height/20,left:40),
              child: FadeAnimation(
                1.6,
                Container(
                  child: Image(
                    image: AssetImage(
                      imagepath,
                    ),
                    height: Gstrings.height/6,
                    width: Gstrings.height/6,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:Gstrings.height/40,left:Gstrings.width/10,right:Gstrings.width/5),
            child: FadeAnimation(
                2.8,
                Container(
                    child: Text(
                  title,
                  style: OnboardTextStyle.titleTS,
                ))),
          ),
          Padding(
            padding: EdgeInsets.only(top: Gstrings.height/45,left:Gstrings.width/10,right:Gstrings.width/5),
            child: FadeAnimation(
                4.2,
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
