import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/ONBOARDING/presentation/constants.dart';

class NotificationPV extends StatelessWidget {
  const NotificationPV({
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
           Padding(
            padding: EdgeInsets.only(top:Gparam.heightPadding*1.5,left:Gparam.widthPadding,right:Gparam.widthPadding*2),
            child: FadeAnimationTB(
                1.8,
                Container(
                    child: Text(
                  title,
                  style: OnboardTextStyle.titleTS,
                ))),
          ),
          Align(
            alignment:Alignment.topLeft,
              child: Padding(
              padding: EdgeInsets.only(top: Gparam.height/20,left:40),
              child: FadeAnimationTB(
                1.6,
                Container(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                                  Colors.white12,
                                  
                                   BlendMode.dst,
                                ),
                                      child: Image(
                      fit:BoxFit.cover,
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
          ),
         
          Padding(
            padding: EdgeInsets.only(top:Gparam.heightPadding,left:Gparam.widthPadding,right:Gparam.widthPadding*3),
            child: FadeAnimationTB(
                2.2,
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
