import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/person_display.dart';

class MindfulnessProfileWidhet extends StatelessWidget {
  const MindfulnessProfileWidhet({
    Key key,
    @required this.state,
  }) : super(key: key);

  final ProfileLoaded state;
  Widget stringTile(
      String s, BuildContext context, int endorsed, VoidCallback fun) {
    return InkWell(
      onTap: () {
        print("1");
      },
      child: Container(
        height: 150,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(right: 4),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: Theme.of(context).highlightColor.withOpacity(.2),
                    width: 1),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.black.withAlpha(2),
                      blurRadius: 2)
                ],
                borderRadius: new BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Text(
                s,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: Gparam.textSmaller,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).highlightColor.withOpacity(.6)),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Gtheme.stext(endorsed.toString() + "+ ",
                          size: GFontSize.XXXS),
                      Image.asset(
                        "assets/images/clap.png",
                        height: 20,
                        width: 20,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Gparam.widthPadding / 2),
      child: Row(
        children: [
          Icon(
            MdiIcons.meditation,
            color: Color(0xFF0ec76a),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            width: 2,
            height: 110,
            color: Color(0xFF0ec76a),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Gparam.widthPadding / 3, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          "Mindfulness score",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                               fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0ec76a)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          " " +
                              state.profile.mindfulness_score
                                  .toStringAsPrecision(3),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textVerySmall,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).highlightColor),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.profile.mindfulness_skills.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SizedBox(width: Gparam.widthPadding / 3);
                        }

                        return stringTile(
                            state.profile.mindfulness_skills[index - 1],
                            context,
                            state.profile.mindfulness_endorsed[index - 1],
                            callback);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1 + 2,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SizedBox(width: Gparam.widthPadding / 3);
                        } else if (index == 1)
                          return Row(
                            children: [
                              Gtheme.stext("Councellor",
                                  color: GColors.B,
                                  size: GFontSize.XS,
                                  weight: GFontWeight.N),
                            ],
                          );

                        return PersonDisplay(
                          name: state.profile.councellor_name[index - 1],
                          image_url:
                              state.profile.councellor_image_url[index - 1],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void callback() {}
}
