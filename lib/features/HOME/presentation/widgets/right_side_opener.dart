import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class RightSideOpener extends StatelessWidget {
  const RightSideOpener({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Gparam.width,
        height: Gparam.height,
        alignment: Alignment.centerRight,
        child: Container(
          width: Gparam.width / 2,
          alignment: Alignment.bottomLeft,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Gparam.heightPadding,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Gparam.widthPadding / 2),
                    child: Text("Chat with",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Gparam.widthPadding / 2),
                    child: Text("Experts",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textMedium,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: Gparam.heightPadding / 2,
                ),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("For Fitness",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w800))),
                Divider(
                  color: Theme.of(context).highlightColor.withAlpha(50),
                ),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Fitness consultant",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Gym trainer",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Yoga specialist",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("General physicist",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Physiotheripist",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("For Mental Health",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w800))),
                Divider(
                  color: Theme.of(context).highlightColor.withAlpha(50),
                ),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Stress counsellor",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Couple counsellor",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Life counsellor",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("For Nutrition",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w800))),
                Divider(
                  color: Theme.of(context).highlightColor.withAlpha(50),
                ),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Dietician",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Ayurveda specialist",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Pregnency food\nspecialist",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("For Productivity",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w800))),
                Divider(
                  color: Theme.of(context).highlightColor.withAlpha(50),
                ),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Work therapist",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Study therapist",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Engineering\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Medical\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Commerce\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Law\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Performing Arts\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Literature Arts\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Visual Arts\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
                Padding(
                    padding: EdgeInsets.all(Gparam.widthPadding / 2),
                    child: Text("Music Arts\nfield experts",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            fontWeight: FontWeight.w500))),
              ],
            ),
          ),
        ));
  }
}
