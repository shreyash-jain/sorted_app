import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/animations/three_progress.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/user_property.dart';

class BasicInfoWidget extends StatelessWidget {
  const BasicInfoWidget({
    Key key,
    @required this.state,
  }) : super(key: key);

  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Gparam.widthPadding / 2),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                        tag: "Profile_Pic",
                        transitionOnUserGestures: true,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, bottom: 0),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                child: Image(
                                  image: NetworkImage(
                                    state.details.imageUrl,
                                  ),
                                  height: 80,
                                  width: 80,
                                ),
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          MdiIcons.starCircle,
                          size: 16,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Level",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).highlightColor),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Text(
                            "3",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: Gparam.width - 80 - Gparam.widthPadding / 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          UserPropertyWidget(
                            prop_name: "Tracks",
                            prop_value: "5",
                          ),
                          UserPropertyWidget(
                            prop_name: "Score",
                            prop_value: "48",
                          ),
                          UserPropertyWidget(
                            prop_name: "Fit Buddies",
                            prop_value: "5",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CustomThreeLinearProgressBar(
                        radius: (Gparam.width - 100 - Gparam.widthPadding / 2) /
                            2.6,
                        dotRadius: 40,
                        shadowWidth: 4.0,
                        progress1: .2,
                        progress2: .4,
                        progress3: .4,
                        shadowColor: Color(0xFF0ec76a),
                        dotColor: Colors.blueAccent,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GrowthWidget(
                            percentage: state.profile?.fitness_growth??0.0,
                            type: "Fitness",
                            color: Color(0xFF307df0),
                          ),
                           GrowthWidget(
                            percentage: state.profile?.mindfulness_growth??0.0,
                            type: "Mindfulness",
                            color: Color(0xFF0ec76a),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ));
  }
}

class GrowthWidget extends StatelessWidget {
  final double percentage;
  final Color color;
  final String type;

  const GrowthWidget({
    Key key,
    this.percentage,
    this.color,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).highlightColor.withOpacity(.3),
                width: 1.5),
            color: Theme.of(context).highlightColor.withAlpha(20),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            "${percentage.toStringAsPrecision(2)} %",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: (percentage > 0) ? Colors.green : Colors.redAccent,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Row(
          children: <Widget>[
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: color,
                border:
                    Border.all(color: Colors.black.withOpacity(.03), width: 2),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.black.withAlpha(10),
                      blurRadius: 2)
                ],
                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              type,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).highlightColor),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ],
    );
  }
}
