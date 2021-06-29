import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/person_display.dart';

class FitnessProfileWidget extends StatelessWidget {
  const FitnessProfileWidget({
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
                        fontFamily: 'Montserrat',
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
                                ? Gcolors.W
                                : Gcolors.B),
                        Image.asset(
                          "assets/images/clap.png",
                          height: 20,
                          width: 20,
                        )
                      ],
                    )),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: Container(
            //       margin: EdgeInsets.all(4),
            //       padding: EdgeInsets.all(4),
            //       decoration: BoxDecoration(
            //           color: Colors.grey.shade200,
            //           borderRadius: BorderRadius.circular(10)),
            //       child: Row(
            //         children: [
            //           Gtheme.stext(endorsed.toString() + "+ ",
            //               size: GFontSize.XXXS),
            //           Image.asset(
            //             "assets/images/clap.png",
            //             height: 20,
            //             width: 20,
            //           )
            //         ],
            //       )),
            // )
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
            MdiIcons.run,
            color: Color(0xFF307df0),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            width: 2,
            height: 116,
            color: Color(0xFF307df0),
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
                          "Fitness score",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF307df0)),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          " " +
                              (state.profile?.fitness_score ?? 0.0)
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
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.profile?.fitness_skills?.length ?? 1 + 1,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SizedBox(width: Gparam.widthPadding / 3);
                        }

                        if (state.profile != null &&
                            state.profile.fitness_skills != null)
                          return stringTile(
                              state.profile.fitness_skills[index - 1],
                              context,
                              state.profile.fitness_endorsed[index - 1],
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
                                  "Add your fitness skills",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
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
                      itemCount: 1 + 4,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return SizedBox(width: Gparam.widthPadding / 3);
                        } else if (index == 1)
                          return Row(
                            children: [
                              Gtheme.stext("Trainer",
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Gcolors.W
                                      : Gcolors.B,
                                  size: GFontSize.XS,
                                  weight: GFontWeight.N),
                              if (state.profile != null &&
                                  state.profile.trainer_name != null)
                                PersonDisplay(
                                  name: state.profile.trainer_name[index - 1],
                                  image_url: state
                                      .profile.trainer_image_url[index - 1],
                                ),
                              if (state.profile == null ||
                                  state.profile.trainer_name == null)
                                PersonDisplay(
                                  name: "None",
                                  image_url: null,
                                )
                            ],
                          );
                        else if (index == 2)
                          return Row(
                            children: [
                              Gtheme.stext("Nutritionist",
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Gcolors.W
                                      : Gcolors.B,
                                  size: GFontSize.XS,
                                  weight: GFontWeight.N),
                              if (state.profile != null &&
                                  state.profile.trainer_name != null)
                                PersonDisplay(
                                  name: state.profile.trainer_name[index - 1],
                                  image_url: state
                                      .profile.trainer_image_url[index - 1],
                                ),
                              if (state.profile == null ||
                                  state.profile.trainer_name == null)
                                PersonDisplay(
                                  name: "None",
                                  image_url: null,
                                )
                            ],
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
