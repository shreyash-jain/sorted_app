import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/animations/three_progress.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/basic_info.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/fitness_profile.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/mindfulness_profile.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/person_display.dart';

class ProfileTop extends StatelessWidget {
  const ProfileTop({
    Key key,
    @required this.name,
    @required this.state,
  }) : super(key: key);

  final String name;
  final ProfileLoaded state;

  Widget stringPersonality(String s, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Text(
          s + "  •  ",
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: Gparam.textVerySmall,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).highlightColor.withOpacity(.6)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
      ),
      child: Column(
        children: <Widget>[
          BasicInfoWidget(state: state),
          Padding(
            padding: EdgeInsets.only(left: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Gparam.widthPadding / 2),
                  child: Text(
                    name,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Gparam.textVerySmall,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).highlightColor),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Gparam.widthPadding / 2),
                  child: Text(
                    state.profile.status,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Gparam.textVerySmall,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).highlightColor),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.grey,
                    ),
                    FitnessProfileWidget(state: state),
                    MindfulnessProfileWidhet(state: state),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
