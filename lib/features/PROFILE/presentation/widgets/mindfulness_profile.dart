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
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black.withAlpha(2),
                          blurRadius: 2)
                    ],
                    borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                        fontFamily: 'Milliard',
                        fontSize: Gparam.textSmaller,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(context).highlightColor.withOpacity(.8)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(right: 4),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                      borderRadius: new BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Row(
                      children: [
                        Gtheme.stext(endorsed.toString() + "+ ",
                            size: GFontSize.XXXS,
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? GColors.W
                                : GColors.B),
                        Image.asset(
                          "assets/images/clap.png",
                          height: 20,
                          width: 20,
                        )
                      ],
                    )),
              ],
            ),
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
            height: 116,
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
                              fontFamily: 'Milliard',
                              fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0ec76a)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          " " +
                              (state.profile?.mindfulness_score ?? 0.0)
                                  .toStringAsPrecision(3),
                          style: TextStyle(
                              fontFamily: 'Milliard',
                              fontSize: Gparam.textVerySmall,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).highlightColor),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          state.profile?.mindfulness_skills?.length ?? 1 + 1,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SizedBox(width: Gparam.widthPadding / 3);
                        }
                        if (state.profile != null &&
                            state.profile.mindfulness_skills != null)
                          return stringTile(
                              state.profile.mindfulness_skills[index - 1],
                              context,
                              state.profile.mindfulness_endorsed[index - 1],
                              callback);
                        else
                          return Container(
                            margin: EdgeInsets.only(right: 0),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade100,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1, 1),
                                    color: Colors.black.withAlpha(2),
                                    blurRadius: 2)
                              ],
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Add your mindful skills",
                                  style: TextStyle(
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmaller,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .highlightColor
                                          .withOpacity(.8)),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(Icons.add)
                              ],
                            ),
                          );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1 + 2,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SizedBox(width: Gparam.widthPadding / 3 + 4);
                        } else if (index == 1) {
                          return Row(
                            children: [
                              Gtheme.stext("Councellor",
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? GColors.W
                                      : GColors.B,
                                  size: GFontSize.XS,
                                  weight: GFontWeight.N),
                            ],
                          );
                        }

                        if (state.profile != null &&
                            state.profile.councellor_name != null)
                          return PersonDisplay(
                            name: state.profile?.councellor_name[index - 1] ??
                                "None",
                            image_url:
                                state.profile.councellor_image_url[index - 1],
                          );
                        else {
                          return PersonDisplay(
                            name: "None",
                            image_url: null,
                          );
                        }
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
